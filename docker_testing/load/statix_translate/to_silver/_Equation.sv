grammar statix_translate:to_silver;

--------------------------------------------------

inherited attribute knownLocals::[(String, AG_Type)] occurs on AG_Eq;
propagate knownLocals on AG_Eq;

synthesized attribute silver_eq::Maybe<String> occurs on AG_Eq;

inherited attribute knownProds::AG_Decls occurs on AG_Eq;
propagate knownProds on AG_Eq;

aspect production contributionEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{
  top.silver_eq = nothing();
}

aspect production localDeclEq
top::AG_Eq ::= name::String ty::AG_Type
{
  top.silver_eq = just("local attribute " ++ name ++ "::" ++ ty.silver_type ++ ";");
}

aspect production localDefineEq
top::AG_Eq ::= name::String ty::AG_Type expr::AG_Expr
{
  top.silver_eq = just("local " ++ name ++ "::" ++ ty.nta_type ++ 
                       " = " ++ expr.silver_expr ++ ";");
}

aspect production defineEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{
  top.silver_eq = just(lhs.silver_lhs ++ " = " ++ expr.silver_expr ++ ";");
}

aspect production ntaEq
top::AG_Eq ::= lhs::AG_LHS ty::AG_Type expr::AG_Expr
{
  top.silver_eq = just("local " ++ lhs.silver_lhs ++ "::" ++ ty.nta_type ++ 
                       " = " ++ expr.silver_expr ++ ";");
}

aspect production returnEq
top::AG_Eq ::= expr::AG_Expr
{
  top.silver_eq = just("return " ++ expr.silver_expr ++ ";");
}

--------------------------------------------------