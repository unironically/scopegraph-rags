grammar statix_translate:to_ocaml;

--------------------------------------------------

attribute ocaml_expr occurs on AG_WhereClause;

aspect production nilWhereClauseAG
top::AG_WhereClause ::=
{
  top.ocaml_expr = "Bool(true)";
}

aspect production withWhereClauseAG
top::AG_WhereClause ::= expr::AG_Expr
{
  top.ocaml_expr = expr.ocaml_expr;
}