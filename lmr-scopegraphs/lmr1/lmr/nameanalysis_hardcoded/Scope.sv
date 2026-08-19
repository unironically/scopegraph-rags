grammar lmr1:lmr:nameanalysis_hardcoded;

---------------
-- Scope

nonterminal Scope with datum, edges;

inherited attribute edges::Map<String Decorated Scope> with combineMap;

production scopeDefault
top::Scope ::= d::Datum
{ top.datum = d; }

production scope
top::Scope ::=
{ forwards to scopeDefault(datumDefault()); }

production scopeVar
top::Scope ::= x::String node::Decorated Bind
{ forwards to scopeDefault(datumVar(x, node)); }

production scopeMod
top::Scope ::= x::String node::Decorated Module
{ forwards to scopeDefault(datumMod(x, node)); }

---------------
-- Data

data nonterminal Datum;

synthesized attribute datum::Datum;

production datumDefault
top::Datum ::= {}

production datumVar
top::Datum ::= x::String node::Decorated Bind {}

production datumMod
top::Datum ::= x::String node::Decorated Module {}

---------------
-- Labels

--inherited attribute lex::[Decorated Scope] occurs on Scope;
--inherited attribute var::[Decorated Scope] occurs on Scope;
--inherited attribute mod::[Decorated Scope] occurs on Scope;
--inherited attribute imp::[Decorated Scope] occurs on Scope;
--type LMLabs = {lex, var, mod, imp};

------------------
-- Resolution Util

type ResPath = [String];
type ResPair = (Decorated Scope, ResPath);
type ResPairList = [ResPair];

type Predicate = (Boolean ::= Datum);

--

fun regexEpsilonFun (ResPairList ::= ResPair) ::= =
  \p::ResPair -> [(p.1, "$"::p.2)];

fun regexEmptyFun (ResPairList ::= ResPair) ::= =
  \p::ResPair -> [];

fun regexCatFun (ResPairList ::= ResPair) ::= l::(ResPairList ::= ResPair) r::(ResPairList ::= ResPair) =
  \p::ResPair -> concat(map(r, l(p)));

fun regexOrFun (ResPairList ::= ResPair) ::= l::(ResPairList ::= ResPair) r::(ResPairList ::= ResPair) =
  \p::ResPair -> l(p) ++ r(p);

fun regexStarFun (ResPairList ::= ResPair) ::= r::(ResPairList ::= ResPair) =
  \p::ResPair ->
    let go::ResPairList = r(p) in
      if null(go) then [p] else p::concat(map(regexStarFun(r), go)) 
    end;

fun regexPlusFun (ResPairList ::= ResPair) ::= r::(ResPairList ::= ResPair) =
  regexCatFun(r, regexStarFun(r));

fun regexMaybeFun (ResPairList ::= ResPair) ::= r::(ResPairList ::= ResPair) =
  regexOrFun(regexEpsilonFun(), r);

--

fun regexLexFun (ResPairList ::= ResPair) ::= =
  \p::ResPair ->
    map(\sf::Decorated Scope -> (sf, "lex"::p.2), p.1.edges.lookup("lex"));

fun regexVarFun (ResPairList ::= ResPair) ::= =
  \p::ResPair ->
    map(\sf::Decorated Scope -> (sf, "var"::p.2), p.1.edges.lookup("var"));

fun regexModFun (ResPairList ::= ResPair) ::= =
  \p::ResPair ->
    map(\sf::Decorated Scope -> (sf, "mod"::p.2), p.1.edges.lookup("mod"));

fun regexImpFun (ResPairList ::= ResPair) ::= =
  \p::ResPair ->
    map(\sf::Decorated Scope -> (sf, "imp"::p.2), p.1.edges.lookup("imp"));

-- Path minimum

fun min ResPairList ::= c::(Integer ::= String String) ps::ResPairList =
  foldr(
    \rp::ResPair acc::ResPairList ->
      let s::Decorated Scope = rp.1 in
      let p::[String] = reverse(rp.2) in
        if null(acc)
        then [(s, p)]
        else
          let hp::[String] = head(acc).2 in
            case labelsComp(c, p, hp) of
            | 0  -> (s, p)::acc
            | -1 -> [(s, p)]
            | _  -> acc
            end
          end
      end end,
    [],
    ps
  )
;

fun labelsComp Integer ::= c::(Integer ::= String String) l::[String] r::[String] =
  case l, r of
  | [], [] -> 0
  | [], _ -> 0 | _, [] -> 0
  | hl::tl, hr::tr ->
    let compOne::Integer = c(hl, hr) in
      if compOne == 0
      then labelsComp(c, tl, tr)
      else compOne
    end
  end
;

---------------
-- Queries

type RegexType = (ResPairList ::= ResPair);

fun queryReachable [Decorated Scope] ::= rx::RegexType p::Predicate start::Decorated Scope =
  filterMap(applyScopePredR(p, _), rx((start, [])));

fun queryVisible [Decorated Scope] ::= rx::RegexType p::Predicate ord::(Integer ::= String String) start::Decorated Scope =
  map(\p::ResPair -> p.1,
        min(ord, filter(applyScopePredV(p, _), rx((start, [])))));

-- used in reachability
fun applyScopePredR Maybe<Decorated Scope> ::= dp::Predicate p::ResPair =
  if dp(p.1.datum) then just(p.1) else nothing();

-- used in visibility
fun applyScopePredV Boolean ::= dp::Predicate p::ResPair =
  dp(p.1.datum);

---------------
-- Util for LM

fun lmOrd Integer ::= l::String r::String =
  case l, r of
    "lex", "lex" -> 0
  | "lex", _ -> 1 | _, "lex" -> -1
  | "imp", "imp" -> 0
  | "imp", _ -> 1 | _, "imp" -> -1
  | _, _ -> 0
  end
;

global deadScope::Decorated Scope = decorate scope() with { edges = mapNone(); };