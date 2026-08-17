grammar lmr1:lmr:extension_records_sg;

--------------------------------------------------

{-
synthesized attribute lookupEnvRec::(Maybe<Decorated Record> ::= String);

--------------------------------------------------

attribute lookupEnvRec occurs on Env;

--

aspect production newEnv
top::Env ::=
{
  top.lookupEnvRec = \x::String -> nothing();
}

aspect production newScope
top::Env ::= e::Env
{
  top.lookupEnvRec = \x::String -> e.lookupEnvRec(x);
}

aspect production addVar
top::Env ::= e::Env v::String ast::Decorated Bind
{
  top.lookupEnvRec = \x::String -> e.lookupEnvRec(x);
}

aspect production addMod
top::Env ::= e::Env m::String ast::Decorated Module
{
  top.lookupEnvRec = \x::String -> e.lookupEnvRec(x);
}

production addRec
top::Env ::= e::Env r::String ast::Decorated Record
{
  -- top.lookupScopeVar = \x::String -> contSearch(x, v, ast, e.lookupScopeVar);
  top.lookupEnvRec = \x::String -> contSearch(x, r, ast, e.lookupEnvRec);

  -- top.lookupScopeMod = \x::String -> e.lookupScopeMod(x);
  top.lookupEnvMod = \x::String -> e.lookupEnvMod(x);

  top.lookupEnvVar = \x::String -> e.lookupEnvVar(x);
}
-}

---------------
-- Scope

production scopeRec
top::Scope ::= x::String node::Decorated Record
{ top.datum = datumRec(x, node); }

---------------
-- Data

production datumRec
top::Datum ::= x::String node::Decorated Record {}

---------------
-- Labels

type LMLabsExt = {lex, var, mod, imp, rec};

inherited attribute rec::[DecScope<LMLabsExt>] occurs on Scope;

production label_rec
top::Label<LMLabsExt> ::=
{ top.name = "rec";
  top.demand = \s::DecScope<LMLabsExt> -> s.rec; }

------------------
-- Resolution Util

fun regexRecFun (ResPairList<LMLabsExt> ::= ResPair<LMLabsExt>) ::= =
  \p::ResPair<LMLabsExt> ->
    map(\sf::DecScope<LMLabsExt> -> (sf, "rec"::p.2), p.1.rec);

fun regexRecFun_Test
  LMLabsExt subset i => (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= =
    \p::ResPair<(i::InhSet)> ->
      map(\sf::DecScope<(i::InhSet)> -> (sf, "rec"::p.2), p.1.rec);

{-

ISSUE:

regexRecFun_Test is what we might like to write as regexRecFun, with the subset
constraint allowing extensions to use this function after they extend the
label set with new labels.

problem is that we use p.1.rec as the argument to map, which has type 
Decorated Scope with {lex, var, imp, mod, rec}, which does not take into
account all of what the set `i` might be.

-}