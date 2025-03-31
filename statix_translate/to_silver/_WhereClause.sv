grammar statix_translate:to_silver;

--------------------------------------------------

nonterminal AG_WhereClause;

abstract production nilWhereClauseAG
top::AG_WhereClause ::=
{}

abstract production withWhereClauseAG
top::AG_WhereClause ::= exprs::AG_Expr
{}