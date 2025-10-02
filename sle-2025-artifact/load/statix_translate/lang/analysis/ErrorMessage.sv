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

abstract production varTypeError
top::Error ::=
  name::String
  decl::Type
  given::Type
  loc::Location
{
  top.msg = produceError(name ++ " declared with type " ++ typeStr(^decl) ++ " but defined with type " ++ typeStr(^given), loc);
}

abstract production consTypeError
top::Error ::=
  hTy::Type
  tTy::Type
  loc::Location
{
  top.msg = produceError("Ill-typed cons (::) head type given as " ++ typeStr(^hTy) ++ " but tail type given as " ++ typeStr(^tTy), loc);
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