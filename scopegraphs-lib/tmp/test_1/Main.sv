grammar test;

imports src;

--------------------------------------------------------------------------------
-- Testing ---------------------------------------------------------------------

fun main IO<Integer> ::= args::[String] = do {

  let sv::Decorated Scope = decorate scopeNoData() with
    { lex = []; var = []; mod = []; imp = []; };

  let s1::Decorated Scope = decorate scopeNoData() with 
    { lex = []; var = [sv]; mod = []; imp = []; };
  
  let s2::Decorated Scope = decorate scopeNoData() with 
    { lex = [s1]; var = []; mod = []; imp = []; };

  let resv::[Decorated Scope] = s2.resolve(isName("foo"), varRx(), lmOrder);

  print(toString(length(resv))++ "\n");

  return 0;
};

--------------------------------------------------------------------------------
-- Language specific -----------------------------------------------------------

inherited attribute lex::[Decorated Scope];
inherited attribute var::[Decorated Scope];
inherited attribute mod::[Decorated Scope];
inherited attribute imp::[Decorated Scope];

flowtype Scope = decorate {lex, var, mod, imp};

--type LMScope = Decorated Scope with {lex, var, mod, imp};

type LMLabel = Label<Decorated Scope>;

global lmOrder::Order = order (
  \l::LMLabel r::LMLabel ->
    case l, r of
    | labelLEX(), _ -> r | _, labelLEX() -> l -- LEX > *
    | labelIMP(), _ -> r | _, labelIMP() -> l -- IMP > MOD, VAR
    | _, _ -> error("reached default case of lmOrder")
    end
);

-- Scopes:

attribute lex, var, mod, imp occurs on Scope;

production scopeNoData
top::Scope ::=
{
  top.nextStep = \r::Regex ->
    let derivVAR::Regex = r.deriv(labelVAR().name) in
    let derivMOD::Regex = r.deriv(labelMOD().name) in
    let derivIMP::Regex = r.deriv(labelIMP().name) in
    let derivLEX::Regex = r.deriv(labelLEX().name) in
    case derivVAR of
    | regexEmpty() ->
      case derivMOD of
      | regexEmpty() ->
        case derivIMP of
        | regexEmpty() ->
          case derivIMP of
          | regexEmpty() -> ([], regexEmpty())
          | r -> (top.lex, r)
          end
        | r -> (top.imp, r)
        end
      | r -> (top.mod, r)
      end
    | r -> (top.var, r)
    end
    end end end end
  ;

  forwards to scope(datumNone());
}

production scopeVar
top::Scope ::= name::String
{ 
  top.nextStep = \r::Regex ->
    case r of
    | regexEmpty() -> ([], regexEmpty())
    | regexEpsilon() -> ([], regexEmpty())
    | _ -> error("scopeVar.nextStep")
    end
  ;

  forwards to scope(datumJust(name)); 
}

-- Labels:

production labelLEX
top::LMLabel ::=
{ top.name = "LEX";
  top.demand = \s::Decorated Scope -> s.lex; 
  forwards to label(); }

production labelVAR
top::LMLabel ::=
{ top.name = "VAR";
  top.demand = \s::Decorated Scope -> s.var; 
  forwards to label(); }

production labelMOD
top::LMLabel ::=
{ top.name = "MOD";
  top.demand = \s::Decorated Scope -> s.mod;
  forwards to label(); }

production labelIMP
top::LMLabel ::=
{ top.name = "IMP";
  top.demand = \s::Decorated Scope -> s.imp;
  forwards to label(); }

-- Not required, but convenient Regex productions:

production regexLEX
top::Regex ::=
{ forwards to regexLabel(labelLEX()); }

production regexVAR
top::Regex ::=
{ forwards to regexLabel(labelVAR()); }

production regexMOD
top::Regex ::=
{ forwards to regexLabel(labelMOD()); }

production regexIMP
top::Regex ::=
{ forwards to regexLabel(labelIMP()); }

-- Resolution regexes:

global varRx::Regex = 
  regexCat(
    regexStar(
      regexLEX()
    ),
    regexCat(
      regexMaybe(
        regexIMP()
      ),
      regexVAR()
    )
  );

global modRx::Regex = 
  regexCat(
    regexStar(
      regexLEX()
    ),
    regexCat(
      regexMaybe(
        regexIMP()
      ),
      regexMOD()
    )
  );

-- Predicates:

fun isName (Boolean ::= Datum) ::= name::String =
  \d::Datum ->
    case d of
    | datumJust(n) -> n == name
    | _ -> false
    end
; 