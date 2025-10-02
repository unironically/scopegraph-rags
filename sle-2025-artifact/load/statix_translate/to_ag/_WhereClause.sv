grammar statix_translate:to_ag;

--------------------------------------------------

nonterminal AG_WhereClause;

attribute pp occurs on AG_WhereClause;

abstract production nilWhereClauseAG
top::AG_WhereClause ::=
{
  top.pp = "nilWhereClauseAG()";
}

abstract production withWhereClauseAG
top::AG_WhereClause ::= expr::AG_Expr
{
  top.pp = "withWhereClauseAG(" ++ expr.pp ++ ")";
}