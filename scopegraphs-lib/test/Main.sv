grammar test;

imports src;

--------------------------------------------------------------------------------
-- Testing ---------------------------------------------------------------------

fun main IO<Integer> ::= args::[String] = do {

  let sv0::LMScope = decorate scopeVar("baz") with
    { lex = []; var = []; };

  let sv1::LMScope = decorate scopeVar("foo") with
    { lex = []; var = []; };

  let sv2::LMScope = decorate scopeVar("bar") with
    { lex = []; var = []; };

  let s1::LMScope = decorate scopeNoData() with 
    { lex = []; var = [sv1, sv2]; };
  
  let s2::LMScope = decorate scopeNoData() with 
    { lex = [s1]; var = [sv0]; };

  let resFoo::[LMScope] = resolve(isName("foo"), varRx(), labelOrd, s2);
  let resAny::[LMScope] = resolve(anyVar(), varRx(), labelOrd, s2);

  -- todo: why does resFoo have foo_0, and resAny has foo_1 instead of foo_0 ?
  print("resFoo: [" ++ implode(", ", map((.name), map((.datum), resFoo))) ++ "]\n");
  print("resAny: [" ++ implode(", ", map((.name), map((.datum), resAny))) ++ "]\n");

  return 0;

};

--------------------------------------------------------------------------------
-- Language specific -----------------------------------------------------------

type LMScope = Decorated Scope with ScopeInhs;
type ScopeInhs = {lex, var};

-- Edge attributes:

inherited attribute lex::[LMScope] occurs on Scope;
inherited attribute var::[LMScope] occurs on Scope;

-- Scopes:

production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

production scopeVar
top::Scope ::= name::String
{ forwards to scope(datumVar(name)); }

-- Data:

production datumVar
top::Datum ::= name::String
{ forwards to datumJust(name); }

-- Labels:

production labelLEX
top::Label<ScopeInhs> ::=
{ top.name = "LEX";
  top.demand = \s::LMScope -> s.lex;
  forwards to label(); }

production labelVAR
top::Label<ScopeInhs> ::=
{ top.name = "VAR";
  top.demand = \s::LMScope -> s.var;
  forwards to label(); }

-- Label order (todo: non-strict ordering):

global labelOrd::[Label<ScopeInhs>] = [
  labelVAR(), labelLEX() -- VAR < IMP < LEX
];

-- Regex productions:

production regexLEX
top::Regex<ScopeInhs> ::=
{ forwards to regexLabel(labelLEX()); }

production regexVAR
top::Regex<ScopeInhs> ::=
{ forwards to regexLabel(labelVAR()); }


-- Resolution regexes:

global varRx::Regex<ScopeInhs> = 
  regexCat(
    regexStar(
      regexLEX()
    ),
    regexVAR()
  );

-- Resolution predicates:

fun isName Predicate ::= name::String =
  \d::Datum ->
    case d of
    | datumVar(n)  -> n == name
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