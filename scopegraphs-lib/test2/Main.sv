grammar test2;

imports src2;

--------------------------------------------------------------------------------
-- Testing ---------------------------------------------------------------------

fun main IO<Integer> ::= args::[String] = do {

  let sv1::LMScope = decorate scopeVar("foo") with
    { lex = []; var = []; };

  let sv2::LMScope = decorate scopeVar("bar") with
    { lex = []; var = []; };

  let s2::LMScope = decorate scopeNoData() with 
    { lex = []; var = [sv1, sv2]; };

  let s1::LMScope = decorate scopeNoData() with 
    { lex = [s2]; var = []; };

  let resFoo::[LMScope] = lmResolve(s1, isName("foo"), varRx());
  let resAny::[LMScope] = lmResolve(s1, anyVar(), varRx());

  -- todo: why does resFoo have foo_0, and resAny has foo_1 instead of foo_0 ?
  print("resFoo: [" ++ implode(", ", map((.name), map((.datum), resFoo))) ++ "]\n");
  print("resAny: [" ++ implode(", ", map((.name), map((.datum), resAny))) ++ "]\n");

  return 0;

};

--------------------------------------------------------------------------------
-- Language specific -----------------------------------------------------------

type LMScope = Decorated Scope<ScopeWrapper> with {lex, var};

synthesized attribute lexWrap::[ScopeWrapper] occurs on Scope<a>;
synthesized attribute varWrap::[ScopeWrapper] occurs on Scope<a>;

inherited attribute lex::[LMScope] occurs on Scope<a>;
inherited attribute var::[LMScope] occurs on Scope<a>;

-- resolve:

function lmResolve
[LMScope] ::= start::LMScope p::Predicate r::Regex<ScopeWrapper>
{
  return
    let
      res::[ScopeWrapper] = resolve(wrap(start), p, ^r)
    in
      map (\r::ScopeWrapper -> case r of wrap(s) -> s end, res)
    end;
}

-- Scopes:

aspect production scope
top::Scope<a> ::= datum::Datum
{ top.lexWrap = error("scope.lexWrap");
  top.varWrap = error("scope.varWrap"); }

production scopeNoData
top::Scope<a> ::=
{ top.lexWrap = map((wrap(_)), top.lex);
  top.varWrap = map((wrap(_)), top.var);
  forwards to scope(datumNone()); }

production scopeVar
top::Scope<a> ::= name::String
{ forwards to scope(datumVar(name)); }

-- Data:

production datumVar
top::Datum ::= name::String
{ forwards to datumJust(name); }

-- Labels:

production labelLEX
top::Label<ScopeWrapper> ::=
{ top.name = "LEX";
  top.demand = \s::ScopeWrapper -> case s of wrap(s) -> s.lexWrap end;
  forwards to label(); }

production labelVAR
top::Label<ScopeWrapper> ::=
{ top.name = "VAR";
  top.demand = \s::ScopeWrapper -> case s of wrap(s) -> s.varWrap end;
  forwards to label(); }

-- Label order:

global labelOrd::[Label<ScopeWrapper>] = [labelVAR(), labelLEX()];

-- Not required, but convenient Regex productions:

production regexLEX
top::Regex<ScopeWrapper> ::=
{ forwards to regexLabel(labelLEX()); }

production regexVAR
top::Regex<ScopeWrapper> ::=
{ forwards to regexLabel(labelVAR()); }

-- Resolution regexes:

global varRx::Regex<ScopeWrapper> = 
  regexCat(
    regexStar(
      regexLEX()
    ),
    regexVAR()
  );

-- Predicates:

fun isName (Boolean ::= Datum) ::= name::String =
  \d::Datum ->
    case d of
    | datumVar(n) -> n == name
    | datumJust(n) -> n == name
    | datumNone() -> false
    end
;

fun anyVar Predicate ::= =
  \d::Datum ->
    case d of
    | datumVar(_) -> true
    | _ -> false
    end
;

-- ScopeWrapper:

nonterminal ScopeWrapper;

attribute datum occurs on ScopeWrapper;

production wrap
top::ScopeWrapper ::= res::LMScope
{
  top.datum = res.datum;
}