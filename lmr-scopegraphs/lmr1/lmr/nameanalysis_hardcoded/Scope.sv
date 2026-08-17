grammar lmr1:lmr:nameanalysis_hardcoded;

---------------
-- Scope

nonterminal Scope<(i::InhSet)> with datum;
type DecScope<(i::InhSet)> = Decorated Scope<i> with i;

type LMScope = DecScope<LMLabs>;

production scopeDefault
top::Scope<(i::InhSet)> ::= d::Datum
{ top.datum = d; }

production scope
top::Scope<(i::InhSet)> ::=
{ forwards to scopeDefault(datumDefault()); }

production scopeVar
top::Scope<(i::InhSet)> ::= x::String node::Decorated Bind
{ forwards to scopeDefault(datumVar(x, node)); }

production scopeMod
top::Scope<(i::InhSet)> ::= x::String node::Decorated Module
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

nonterminal Label<(i::InhSet)> with name, demand<i>;

synthesized attribute name::String;
synthesized attribute demand<(i::InhSet)>::([DecScope<i>] ::= DecScope<i>);

instance Eq Label<(i::InhSet)> {
  eq = \left::Label<(i::InhSet)> right::Label<(i::InhSet)> -> 
    left.name == right.name;
}

inherited attribute lex<(i::InhSet)>::[DecScope<(i::InhSet)>] occurs on Scope<(i::InhSet)>;
inherited attribute var<(i::InhSet)>::[DecScope<(i::InhSet)>] occurs on Scope<(i::InhSet)>;
inherited attribute mod<(i::InhSet)>::[DecScope<(i::InhSet)>] occurs on Scope<(i::InhSet)>;
inherited attribute imp<(i::InhSet)>::[DecScope<(i::InhSet)>] occurs on Scope<(i::InhSet)>;

type LMLabs = {lex, var, mod, imp};

------------------
-- Resolution Util

type ResPath = [String];
type ResPair<(i::InhSet)> = (Decorated Scope<i> with i, ResPath);
type ResPairList<(i::InhSet)> = [ResPair<i>];

type Predicate = (Boolean ::= Datum);

--

fun regexEpsilonFun (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= =
  \p::ResPair<i> -> [(p.1, "$"::p.2)];

fun regexEmptyFun (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= =
  \p::ResPair<i> -> [];

fun regexCatFun (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= l::(ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) r::(ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) =
  \p::ResPair<i> -> concat(map(r, l(p)));

fun regexOrFun (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= l::(ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) r::(ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) =
  \p::ResPair<i> -> l(p) ++ r(p);

fun regexStarFun (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= r::(ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) =
  \p::ResPair<i> ->
    let go::ResPairList<i> = r(p) in
      if null(go) then [p] else p::concat(map(regexStarFun(r), go)) 
    end;

fun regexPlusFun (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= r::(ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) =
  regexCatFun(r, regexStarFun(r));

fun regexMaybeFun (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= r::(ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) =
  regexOrFun(regexEpsilonFun(), r);

--

fun regexLexFun 
  LMLabs subset i => (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= =
  \p::ResPair<(i::InhSet)> ->
    map(\sf::DecScope<(i::InhSet)> -> (sf, "lex"::p.2), p.1.lex);

fun regexVarFun 
  LMLabs subset i => (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= =
  \p::ResPair<(i::InhSet)> ->
    map(\sf::DecScope<(i::InhSet)> -> (sf, "var"::p.2), p.1.var);

fun regexModFun 
  LMLabs subset i => (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= =
  \p::ResPair<(i::InhSet)> ->
    map(\sf::DecScope<(i::InhSet)> -> (sf, "mod"::p.2), p.1.mod);

fun regexImpFun 
  LMLabs subset i => (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= =
  \p::ResPair<(i::InhSet)> ->
    map(\sf::DecScope<(i::InhSet)> -> (sf, "imp"::p.2), p.1.imp);

-- Path minimum

fun min ResPairList<(i::InhSet)> ::= c::(Integer ::= String String) ps::ResPairList<(i::InhSet)> =
  foldr(
    \rp::ResPair<i> acc::ResPairList<i> ->
      let s::Decorated Scope<i> with i = rp.1 in
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

type RegexType<(i::InhSet)> = (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>);

fun queryReachable [DecScope<(i::InhSet)>] ::= rx::RegexType<(i::InhSet)> p::Predicate start::DecScope<(i::InhSet)> =
  filterMap(applyScopePredR(p, _), rx((start, [])));

fun queryVisible [DecScope<(i::InhSet)>] ::= rx::RegexType<(i::InhSet)> p::Predicate ord::(Integer ::= String String) start::DecScope<(i::InhSet)> =
  map(
    \p::ResPair<i> -> p.1,
    min(
      ord,
      filter(applyScopePredV(p, _), rx((start, [])))));

-- used in reachability
fun applyScopePredR Maybe<Decorated Scope<(i::InhSet)> with i> ::= dp::Predicate p::ResPair<(i::InhSet)> =
  if dp(p.1.datum) then just(p.1) else nothing();

-- used in visibility
fun applyScopePredV Boolean ::= dp::Predicate p::ResPair<(i::InhSet)> =
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
