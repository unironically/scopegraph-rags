grammar statix_translate:to_silver;

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

abstract production demandEq
top::AG_Eq ::= lhs::AG_LHS attr::String
{
  top.pp = "demandEq(" ++ lhs.pp ++ ", " ++ attr ++ ")";
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