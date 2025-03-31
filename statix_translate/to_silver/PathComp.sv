grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_expr occurs on PathComp;

aspect production lexicoPathComp
top::PathComp ::= lts::LabelLTs
{
  top.ag_expr = falseExpr(); -- TODO
}

aspect production revLexicoPathComp
top::PathComp ::= lts::LabelLTs
{
  top.ag_expr = falseExpr(); -- TODO
}

aspect production scalaPathComp
top::PathComp ::=
{
  top.ag_expr = falseExpr(); -- TODO
}

aspect production namedPathComp
top::PathComp ::= name::String
{
  top.ag_expr = falseExpr(); -- TODO
}