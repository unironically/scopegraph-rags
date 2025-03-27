grammar statix_translate:translation;


--------------------------------------------------


inherited attribute lookupName::String;
synthesized attribute nameFound<a>::Maybe<a>;

nonterminal Env<a> with lookupName, nameFound<a>;


abstract production addScope
top::Env<a> ::= bindings::[(String, a)] higherScope::Env<a>
{
  local foundHere::Maybe<a> = lookup(top.lookupName, bindings);
  higherScope.lookupName = top.lookupName;
  top.nameFound =
      case foundHere of
      | just(a) -> just(a)
      | nothing() -> higherScope.nameFound
      end;
}


abstract production baseScope
top::Env<a> ::=
{
  top.nameFound = nothing();
}


function lookupEnv
Maybe<a> ::= name::String env::Env<a>
{
  env.lookupName = name;
  return env.nameFound;
}


fun toEnv
attribute name {} occurs on a => Env<a> ::= l::[a] = 
  addScope(toBindings(l), baseScope());


fun toBindings
attribute name {} occurs on a => [(String, a)] ::= l::[a] =
  map(\ a::a -> (a.name, a), l);


--------------------------------------------------