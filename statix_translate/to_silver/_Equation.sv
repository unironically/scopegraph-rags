grammar statix_translate:to_silver;

--------------------------------------------------

nonterminal AG_Eq;

abstract production contributionEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{}

abstract production defineEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{}

abstract production demandEq
top::AG_Eq ::= lhs::AG_LHS attr::String
{}

abstract production returnEq
top::AG_Eq ::= expr::AG_Expr
{}

abstract production localDeclEq
top::AG_Eq ::= name::String ty::AG_Type
{}