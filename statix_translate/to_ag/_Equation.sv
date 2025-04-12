grammar statix_translate:to_ag;

--------------------------------------------------

nonterminal AG_Eq;

attribute pp occurs on AG_Eq;

abstract production contributionEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{
  top.pp = "contributionEq(" ++ lhs.pp ++ ", " ++ expr.pp ++ ")";
}

abstract production defineEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{
  top.pp = "defineEq(" ++ lhs.pp ++ ", " ++ expr.pp ++ ")";
}

abstract production ntaEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{
  top.pp = "ntaEq(" ++ lhs.pp ++ ", " ++ expr.pp ++ ")";
}

abstract production returnEq
top::AG_Eq ::= expr::AG_Expr
{
  top.pp = "returnEq(" ++ expr.pp ++ ")";
}

abstract production localDeclEq
top::AG_Eq ::= name::String ty::AG_Type
{
  top.pp = "localDeclEq(" ++ name ++ ", " ++ ty.pp ++ ")";
}