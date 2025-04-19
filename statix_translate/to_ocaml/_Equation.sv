grammar statix_translate:to_ocaml;

--------------------------------------------------

synthesized attribute ocaml_eq::Maybe<String> occurs on AG_Eq;

aspect production contributionEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{
  top.ocaml_eq = nothing();
}

aspect production localDeclEq
top::AG_Eq ::= name::String ty::AG_Type
{
  top.ocaml_eq = nothing();
}

--------------------------------------------------

aspect production defineEq
top::AG_Eq ::= lhs::AG_LHS expr::AG_Expr
{
  local eq::String = "AttrEq(" ++
    lhs.ocaml_lhs ++ ", " ++
    expr.ocaml_expr ++
  ")";

  top.ocaml_eq = just(eq);
}

aspect production ntaEq
top::AG_Eq ::= lhs::AG_LHS ty::AG_Type expr::AG_Expr
{
  local ntaName::String = case lhs of nameLHS(n) -> n | _ -> error("ntaEq.ntaName") end;
  local eq::String = "NtaEq(" ++
    str(ntaName) ++ ", " ++
    expr.ocaml_expr ++
  ")";

  top.ocaml_eq = just(eq);
}

aspect production returnEq
top::AG_Eq ::= expr::AG_Expr
{
  local eq::String = "AttrEq(" ++
    qualLHS(nameLHS("top"), "ret").ocaml_lhs ++ ", " ++
    expr.ocaml_expr ++
  ")";

  top.ocaml_eq = just(eq);
}