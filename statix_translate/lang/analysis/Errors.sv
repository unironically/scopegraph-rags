grammar statix_translate:lang:analysis;

--------------------------------------------------

synthesized attribute msg::String occurs on Error;

nonterminal Error;

abstract production permissionError
top::Error ::=
  name::String
  loc::Location
{
  top.msg = produceError("No permission to extend '" ++ name ++ "'", loc);
}

--------------------------------------------------

fun produceError String ::= msg::String loc::Location =
  "ERROR at " ++ toString(loc.line) ++ "," ++ toString(loc.column) ++ " " ++ msg;