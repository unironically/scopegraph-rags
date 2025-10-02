grammar statix_translate:to_silver;

--------------------------------------------------

attribute silver_expr occurs on AG_WhereClause;

aspect production nilWhereClauseAG
top::AG_WhereClause ::=
{
  top.silver_expr = "";
}

aspect production withWhereClauseAG
top::AG_WhereClause ::= expr::AG_Expr
{
  top.silver_expr = "";
}