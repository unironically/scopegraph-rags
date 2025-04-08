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

abstract production noSuchConstructorError
top::Error ::=
  name::String
  loc::Location
{
  top.msg = produceError("No known constructor " ++ name, loc);
}

abstract production duplicateConstructorError
top::Error ::=
  name::String
  loc::Location
{
  top.msg = produceError("Conflicting term types for " ++ name, loc);
}

abstract production badConstructorArgsError
top::Error ::=
  name::String
  loc::Location
{
  top.msg = produceError("Bad term arguments for " ++ name, loc);
}

abstract production typeError
top::Error ::=
  msg::String
  loc::Location
{
  top.msg = produceError("Type error " ++ msg, loc);
}

abstract production branchDefsError
top::Error ::=
  loc::Location
{
  top.msg = produceError("For each match constraint, all branches need to define the same names", loc);
}

abstract production undefinedSynError
top::Error ::=
  name::String
  predName::String
  loc::Location
{
  top.msg = produceError("Variable " ++ name ++ " not defined within predicate " ++ predName, loc);
}

abstract production multiDefError
top::Error ::=
  name::String
  loc::Location
{
  top.msg = produceError("Variable " ++ name ++ " is defined multiple times", loc);
}

--------------------------------------------------

fun produceError String ::= msg::String loc::Location =
  "ERROR " ++ 
  toString(loc.line) ++ ":" ++ 
  toString(loc.column) ++ " - " ++ 
  msg;