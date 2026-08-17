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
top::Scope<(i::InhSet)> ::= x::String node::Decorated Record
{ forwards to scopeDefault(datumRec(x, node)); }

---------------
-- Data

production datumRec
top::Datum ::= x::String node::Decorated Record {}

---------------
-- Labels

type LMLabsExt = {lex, var, mod, imp, rec};

inherited attribute rec<(i::InhSet)>::[DecScope<(i::InhSet)>] occurs on Scope<(i::InhSet)>;

------------------
-- Resolution Util

fun regexRecFun 
  LMLabsExt subset i => (ResPairList<(i::InhSet)> ::= ResPair<(i::InhSet)>) ::= =
  \p::ResPair<(i::InhSet)> ->
    map(\sf::DecScope<(i::InhSet)> -> (sf, "rec"::p.2), p.1.rec);
