grammar statix_translate:to_silver;

--------------------------------------------------

nonterminal AG_Expr;

abstract production trueExpr
top::AG_Expr ::=
{}

abstract production falseExpr
top::AG_Expr ::=
{}

abstract production eqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{}

abstract production neqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{}

abstract production appExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{}

abstract production nameExpr
top::AG_Expr ::= name::String
{}

abstract production qualExpr
top::AG_Expr ::= pre::AG_Expr name::String
{}

abstract production andExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{}

abstract production caseExpr
top::AG_Expr ::= e::AG_Expr cases::AG_Cases
{}

abstract production demandExpr
top::AG_Expr ::= lhs::AG_LHS attr::String
{}

--------------------------------------------------

nonterminal AG_Exprs;

abstract production consExprs
top::AG_Exprs ::= hd::AG_Expr tl::AG_Exprs
{}

abstract production nilExprs
top::AG_Exprs ::=
{}