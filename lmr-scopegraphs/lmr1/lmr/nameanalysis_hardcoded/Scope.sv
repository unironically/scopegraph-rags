grammar lmr1:lmr:nameanalysis_hardcoded;

---------------
-- Scope

nonterminal Scope with id, datum;

synthesized attribute id::Integer;

production scopeDefault
top::Scope ::= d::Datum
{ top.id = genInt();
  top.datum = d; }

production scope
top::Scope ::=
{ forwards to scopeDefault(datumDefault()); }

production scopeVar
top::Scope ::= x::String node::Decorated Bind
{ forwards to scopeDefault(datumVar(x, node)); }

production scopeMod
top::Scope ::= x::String node::Decorated Module
{ forwards to scopeDefault(datumMod(x, node)); }

-------------
-- Edges attr

inherited attribute edges::Map<String Decorated Scope> with combineMap
  occurs on Scope;

-------
-- Data

data nonterminal Datum with name;

synthesized attribute datum::Datum;

synthesized attribute name::String;

production datumDefault
top::Datum ::= 
{ top.name = ""; }

production datumVar
top::Datum ::= x::String node::Decorated Bind
{ top.name = x; }

production datumMod
top::Datum ::= x::String node::Decorated Module
{ top.name= x; }

-------------
-- Resolution

type ResPath = [String];
type ResPair = (Decorated Scope, ResPath);
type ResPairList = [ResPair];

type Predicate = (Boolean ::= Datum);

-- Generic regex functions

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
      if null(go)
      then [p]
      else p::concat(map(regexStarFun(r), go)) 
    end;

fun regexPlusFun (ResPairList ::= ResPair) ::= r::(ResPairList ::= ResPair) =
  regexCatFun(r, regexStarFun(r));

fun regexMaybeFun (ResPairList ::= ResPair) ::= r::(ResPairList ::= ResPair) =
  regexOrFun(regexEpsilonFun(), r);

-- Language-specific regex functions

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

-------------
-- Query Funs

type RegexF = (ResPairList ::= ResPair);

fun queryReachable [Decorated Scope] ::= rx::RegexF pred::Predicate start::Decorated Scope =
  filterMap(\r::ResPair -> if pred(r.1.datum)
                           then just(r.1)
                           else nothing(),
            rx((start, [])));

fun queryVisible [Decorated Scope] ::= rx::RegexF pred::Predicate ord::(Integer ::= String String) start::Decorated Scope =
  map(\p::ResPair -> p.1,
        min(ord,
            filter(\r::ResPair -> pred(r.1.datum),
                   rx((start, [])))));

--

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
              0  -> (s, p)::acc
            | -1 -> [(s, p)]
            | _  -> acc
            end
          end
      end end,
    [],
    ps
  );

fun labelsComp Integer ::= c::(Integer ::= String String) l::[String] r::[String] =
  case l, r of
    [], [] -> 0
  | [], _ -> 0 | _, [] -> 0
  | hl::tl, hr::tr ->
      let compOne::Integer = c(hl, hr) in
        if compOne == 0
        then labelsComp(c, tl, tr)
        else compOne
      end
  end;

--------------
-- Util for LM

fun lmOrd Integer ::= l::String r::String =
  case l, r of
    "lex", "lex" -> 0
  | "lex", _ -> 1 | _, "lex" -> -1 -- lex least preferred
  | "imp", "imp" -> 0
  | "imp", _ -> 1 | _, "imp" -> -1 -- imp less preferred than var, mod
  | _, _ -> 0
  end;

global deadScope::Decorated Scope = decorate scope() with { edges = mapNone(); };
