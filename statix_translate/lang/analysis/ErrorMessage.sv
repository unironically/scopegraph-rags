grammar statix_translate:lang:analysis;

--------------------------------------------------

synthesized attribute msg::String occurs on Error;

nonterminal Error;

abstract production permissionError
top::Error ::=
  name::String
  loc::Location
{
  top.msg = produceError("No permission to extend " ++ name, loc);
}

abstract production noSuchPredicateError
top::Error ::=
  name::String
  loc::Location
{
  top.msg = produceError("No known predicate " ++ name, loc);
}

abstract production noSuchNameError
top::Error ::=
  name::String
  loc::Location
{
  top.msg = produceError("No known variable " ++ name, loc);
}

abstract production noSuchTypeError
top::Error ::=
  name::String
  loc::Location
{
  top.msg = produceError("No known type " ++ name, loc);
}

--------------------------------------------------

fun produceError String ::= msg::String loc::Location =
  "ERROR " ++ 
  toString(loc.line) ++ ":" ++ 
  toString(loc.column) ++ " - " ++ 
  msg;