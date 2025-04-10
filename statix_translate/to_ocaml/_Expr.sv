grammar statix_translate:to_ocaml;

--------------------------------------------------

aspect production trueExpr
top::AG_Expr ::=
{
}

aspect production falseExpr
top::AG_Expr ::=
{
}

aspect production intExpr
top::AG_Expr ::= i::Integer
{
}

aspect production stringExpr
top::AG_Expr ::= s::String
{
}

aspect production eqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
}

aspect production neqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
}

aspect production appExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{
}

aspect production nameExpr
top::AG_Expr ::= name::String
{
}

aspect production qualExpr
top::AG_Expr ::= pre::AG_Expr name::String
{
}

aspect production andExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
}

aspect production caseExpr
top::AG_Expr ::= e::AG_Expr cases::AG_Cases
{
}

aspect production demandExpr
top::AG_Expr ::= lhs::AG_Expr attr::String
{
}

aspect production lambdaExpr
top::AG_Expr ::= args::[(String, AG_Type)] body::AG_Expr
{
}

aspect production tupleExpr
top::AG_Expr ::= es::[AG_Expr]
{
}

aspect production consExpr
top::AG_Expr ::= h::AG_Expr  t::AG_Expr
{
}

aspect production nilExpr
top::AG_Expr ::=
{
}

aspect production tupleSectionExpr
top::AG_Expr ::= tup::AG_Expr i::Integer
{
}

aspect production termExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{
}

aspect production abortExpr
top::AG_Expr ::=
{
}

--------------------------------------------------

aspect production consExprs
top::AG_Exprs ::= hd::AG_Expr tl::AG_Exprs
{
}

aspect production nilExprs
top::AG_Exprs ::=
{
}