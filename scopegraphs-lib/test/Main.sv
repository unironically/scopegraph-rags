grammar test;

imports src;

--------------------------------------------------------------------------------
-- Testing ---------------------------------------------------------------------

fun main IO<Integer> ::= args::[String] = do {

  let sv1::Decorated Scope = decorate scopeVar("foo") with
    { lex = []; var = []; mod = []; imp = []; };

  let sv2::Decorated Scope = decorate scopeVar("bar") with
    { lex = []; var = []; mod = []; imp = []; };

  let s1::Decorated Scope = decorate scopeNoData() with 
    { lex = []; var = [sv1, sv2]; mod = []; imp = []; };
  
  let s2::Decorated Scope = decorate scopeNoData() with 
    { lex = [s1]; var = []; mod = []; imp = []; };

  let resFoo::[Decorated Scope] = s2.resolve(isName("foo"), varRx(), labelOrd);
  let resAny::[Decorated Scope] = s2.resolve(anyVar(), varRx(), labelOrd);

  -- todo: why does resFoo have foo_0, and resAny has foo_1 instead of foo_0 ?
  print("resFoo: [" ++ implode(", ", map((.name), map((.datum), resFoo))) ++ "]\n");
  print("resAny: [" ++ implode(", ", map((.name), map((.datum), resAny))) ++ "]\n");

  return 0;

};

--------------------------------------------------------------------------------
-- Language specific -----------------------------------------------------------

flowtype Scope = decorate {lex, var, mod, imp};

-- Edge attributes:

inherited attribute lex::[Decorated Scope] occurs on Scope;
inherited attribute var::[Decorated Scope] occurs on Scope;
inherited attribute mod::[Decorated Scope] occurs on Scope;
inherited attribute imp::[Decorated Scope] occurs on Scope;

-- Scopes:

production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

production scopeVar
top::Scope ::= name::String
{ forwards to scope(datumVar(name)); }

production scopeMod
top::Scope ::= name::String
{ forwards to scope(datumMod(name)); }

-- Data:

production datumVar
top::Datum ::= name::String
{ forwards to datumJust(name); }

production datumMod
top::Datum ::= name::String
{ forwards to datumJust(name); }

-- Labels:

production labelLEX
top::Label ::=
{ top.name = "LEX";
  top.demand = \s::Decorated Scope -> s.lex;
  forwards to label(); }

production labelVAR
top::Label ::=
{ top.name = "VAR";
  top.demand = \s::Decorated Scope -> s.var;
  forwards to label(); }

production labelMOD
top::Label ::=
{ top.name = "MOD";
  top.demand = \s::Decorated Scope -> s.mod;
  forwards to label(); }

production labelIMP
top::Label ::=
{ top.name = "IMP";
  top.demand = \s::Decorated Scope -> s.imp;
  forwards to label(); }

-- Label order (todo: non-strict ordering):

global labelOrd::[Label] = [
  labelVAR(), labelIMP(), labelLEX() -- VAR < IMP < LEX
];

-- Regex productions:

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

-- Resolution predicates:

fun isName Predicate ::= name::String =
  \d::Datum ->
    case d of
    | datumVar(n) -> n == name
    | datumJust(n) -> n == name
    | _ -> false
    end
;

fun anyVar Predicate ::= =
  \d::Datum ->
    case d of
    | datumVar(_) -> true
    | _ -> false
    end
;