grammar statix_translate:translation;

--------------------------------------------------

nonterminal AG_Expr;

abstract production trueExpr
top::AG_Expr ::=
{}

abstract production falseExpr
top::AG_Expr ::=
{}

abstract production eqExpr
top::AG_Expr ::= left::AG_Expr right::AG_Expr
{}

abstract production neqExpr
top::AG_Expr ::= left::AG_Expr right::AG_Expr
{}

abstract production appExpr
top::AG_Expr ::= name::String args::AG_Exprs
{}

abstract production nameExpr
top::AG_Expr ::= name::String
{}

abstract production qualExpr
top::AG_Expr ::= pre::AG_Expr name::String
{}

--------------------------------------------------

nonterminal AG_Exprs;

abstract production consExprs
top::AG_Exprs ::= hd::AG_Expr tl::AG_Exprs
{}

abstract production nilExprs
top::AG_Exprs ::=
{}