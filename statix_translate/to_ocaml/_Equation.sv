grammar statix_translate:to_ocaml;

--------------------------------------------------

aspect production contributionEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{
}

aspect production defineEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{
}

aspect production demandEq
top::AG_Eq ::= lhs::AG_LHS attr::String
{
}

aspect production returnEq
top::AG_Eq ::= expr::AG_Expr
{
}

aspect production localDeclEq
top::AG_Eq ::= name::String ty::AG_Type
{
}