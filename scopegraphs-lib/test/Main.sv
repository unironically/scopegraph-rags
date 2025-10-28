grammar test;

imports src;

--------------------------------------------------------------------------------
-- Testing ---------------------------------------------------------------------

fun main IO<Integer> ::= args::[String] = do {

  let sv0::LMScope = decorate scopeVar("baz") with
    { lex = []; var = []; mod = []; imp = []; };

  let sv1::LMScope = decorate scopeVar("foo") with
    { lex = []; var = []; mod = []; imp = []; };

  let sv2::LMScope = decorate scopeVar("foo") with
    { lex = []; var = []; mod = []; imp = []; };


  let s1::LMScope = decorate scopeNoData() with
    { lex = []; var = [sv2]; mod = []; imp = []; };
  
  let s2::LMScope = decorate scopeNoData() with
    { lex = [s1]; var = [sv0, sv1]; mod = []; imp = []; };


  let resFooV::[LMScope] = visible(isName("foo"), varRx(), labelOrd, s2);
  let resAnyV::[LMScope] = visible(anyVar(), varRx(), labelOrd, s2);

  let resFooR::[LMScope] = reachable(isName("foo"), varRx(), s2);
  let resAnyR::[LMScope] = reachable(anyVar(), varRx(), s2);

  print("resFooV: [" ++ implode(", ", map((.name), map((.datum), resFooV))) ++ "]\n");
  print("resAnyV: [" ++ implode(", ", map((.name), map((.datum), resAnyV))) ++ "]\n");

  print("resFooR: [" ++ implode(", ", map((.name), map((.datum), resFooR))) ++ "]\n");
  print("resAnyR: [" ++ implode(", ", map((.name), map((.datum), resAnyR))) ++ "]\n");

  return 0;

};

--------------------------------------------------------------------------------
-- Language specific -----------------------------------------------------------

type LMScope = Decorated Scope with ScopeInhs;
type ScopeInhs = {lex, var, mod, imp};

-- Edge attributes:

inherited attribute lex::[LMScope] occurs on Scope;
inherited attribute var::[LMScope] occurs on Scope;
inherited attribute mod::[LMScope] occurs on Scope;
inherited attribute imp::[LMScope] occurs on Scope;

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
top::Label<ScopeInhs> ::=
{ top.name = "LEX";
  top.demand = \s::LMScope -> s.lex;
  forwards to label(); }

production labelVAR
top::Label<ScopeInhs> ::=
{ top.name = "VAR";
  top.demand = \s::LMScope -> s.var;
  forwards to label(); }
  
production labelMOD
top::Label<ScopeInhs> ::=
{ top.name = "MOD";
  top.demand = \s::LMScope -> s.mod;
  forwards to label(); }

production labelIMP
top::Label<ScopeInhs> ::=
{ top.name = "IMP";
  top.demand = \s::LMScope -> s.imp;
  forwards to label(); }

-- Label order (todo: non-strict ordering):

fun labelOrd Integer ::= left::Label<i> right::Label<i> =
  case left, right of

  | labelVAR(), labelLEX() -> -1 | labelLEX(), labelVAR() -> 1 -- VAR < LEX
  | labelVAR(), labelIMP() -> -1 | labelIMP(), labelVAR() -> 1 -- VAR < IMP

  | labelMOD(), labelLEX() -> -1 | labelLEX(), labelMOD() -> 1 -- MOD < LEX
  | labelMOD(), labelIMP() -> -1 | labelIMP(), labelMOD() -> 1 -- MOD < IMP

  | labelIMP(), labelLEX() -> -1 | labelLEX(), labelIMP() -> 1 -- IMP < LEX
  
  | _, _ -> 0 -- VAR = VAR, LEX = LEX, MOD = MOD, IMP = IMP
  
  end
;

-- Regex productions:

production regexLEX
top::Regex<ScopeInhs> ::=
{ forwards to regexLabel(labelLEX()); }

production regexVAR
top::Regex<ScopeInhs> ::=
{ forwards to regexLabel(labelVAR()); }

production regexMOD
top::Regex<ScopeInhs> ::=
{ forwards to regexLabel(labelMOD()); }

production regexIMP
top::Regex<ScopeInhs> ::=
{ forwards to regexLabel(labelIMP()); }


-- Resolution regexes:

global varRx::Regex<ScopeInhs> = 
  regexCat(
    regexStar(
      regexLEX()),
    regexCat(
      regexMaybe(
        regexIMP()),
      regexVAR()));

global modRx::Regex<ScopeInhs> = 
  regexCat(
    regexStar(
      regexLEX()),
    regexCat(
      regexMaybe(
        regexIMP()),
      regexMOD()));

-- Resolution predicates:

fun isName Predicate ::= name::String =
  \d::Decorated Datum ->
    case d of
    | datumVar(n)  -> n == name
    | datumMod(n)  -> n == name
    | datumJust(n) -> n == name
    | _ -> false
    end
;

fun anyVar Predicate ::= =
  \d::Decorated Datum ->
    case d of
    | datumVar(_) -> true
    | _ -> false
    end
;

fun anyMod Predicate ::= =
  \d::Decorated Datum ->
    case d of
    | datumVar(_) -> true
    | _ -> false
    end
;