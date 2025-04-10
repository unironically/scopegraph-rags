grammar statix_translate:to_ocaml;

--------------------------------------------------

aspect production nilWhereClauseAG
top::AG_WhereClause ::=
{
}

aspect production withWhereClauseAG
top::AG_WhereClause ::= expr::AG_Expr
{
}