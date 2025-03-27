grammar statix_translate:translation;

--------------------------------------------------

nonterminal AG_Eq;

abstract production contributionEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{}

abstract production definsEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{}

abstract production demandEq
top::AG_Eq ::= lhs::AG_LHS attr::String
{}