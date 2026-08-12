grammar lmr1:lmr:nameanalysis_kastenswaite;

--------------------------------------------------

-- An abstract data type for name analysis
-- U. Kastens, W.M. Waite

--------------------------------------------------

-- keyInScope in the paper - lookup in only current scope
--synthesized attribute lookupScopeVar::(Maybe<Decorated Bind> ::= String);
--synthesized attribute lookupScopeMod::(Maybe<Decorated Module> ::= String);

-- keyInEnv in the paper - lookup in any parent scopes
synthesized attribute lookupEnvVar::(Maybe<Decorated Bind> ::= String);
synthesized attribute lookupEnvMod::(Maybe<Decorated Module> ::= String);

--------------------------------------------------

nonterminal Env with lookupEnvVar, lookupEnvMod;
                     -- lookupScopeVar, lookupScopeMod;
                     

--

production newEnv
top::Env ::=
{
  -- top.lookupScopeVar = \x::String -> nothing();
  top.lookupEnvVar   = \x::String -> nothing();

  -- top.lookupScopeMod = \x::String -> nothing();
  top.lookupEnvMod   = \x::String -> nothing();
}

production newScope
top::Env ::= e::Env
{
  -- top.lookupScopeVar = \x::String -> nothing();
  top.lookupEnvVar   = \x::String -> e.lookupEnvVar(x);

  -- top.lookupScopeMod = \x::String -> nothing();
  top.lookupEnvMod   = \x::String -> e.lookupEnvMod(x);
}

production addVar
top::Env ::= e::Env v::String ast::Decorated Bind
{
  -- top.lookupScopeVar = \x::String -> contSearch(x, v, ast, e.lookupScopeVar);
  top.lookupEnvVar = \x::String -> contSearch(x, v, ast, e.lookupEnvVar);

  -- top.lookupScopeMod = \x::String -> e.lookupScopeMod(x);
  top.lookupEnvMod = \x::String -> e.lookupEnvMod(x);
}

production addMod
top::Env ::= e::Env m::String ast::Decorated Module
{
  -- top.lookupScopeVar = \x::String -> e.lookupScopeVar(x);
  top.lookupEnvVar = \x::String -> e.lookupEnvVar(x);

  -- top.lookupScopeMod = \x::String -> contSearch(x, m, ast, e.lookupScopeMod);
  top.lookupEnvMod = \x::String -> contSearch(x, m, ast, e.lookupEnvMod);
}

--

fun contSearch Maybe<a> ::= x::String d::String ast::a cont::(Maybe<a> ::= String) =
  if x == d
  then unsafeTracePrint(just(ast), "good match of " ++ x ++ " with dcl " ++ d ++ "\n")
  else unsafeTracePrint(cont(x), "bad match " ++ x ++ " with dcl " ++ d ++ "\n");
