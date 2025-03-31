grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_expr {- ::AG_Expr -} occurs on Lambda;

attribute ag_decls {- ::[AG_Decl] -} occurs on Lambda;
propagate ag_decls on Lambda;

aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{
  local arg_name::String = arg;
  local lam_name::String = "lambda_" ++ toString(genInt());

  local ag_ty::AG_Type = ty.ag_type;

  top.ag_expr = nameExpr(lam_name);

  top.ag_decls <- [
    -- todo, ag_decl
    functionDecl (lam_name, nameTypeAG("Boolean"), [(arg_name,  ^ag_ty)], body)
  ];

  local body::[AG_Eq] = c.equations ++ [ -- body with top.ok contributions
    returnEq(topDotExpr("ok"))          -- return top.ok;
  ];

}

--------------------------------------------------

synthesized attribute ag_whereClause::AG_WhereClause occurs on WhereClause;

aspect production nilWhereClause
top::WhereClause ::=
{
  top.ag_whereClause = nilWhereClauseAG();
}

aspect production withWhereClause
top::WhereClause ::= gl::GuardList
{
  top.ag_whereClause = withWhereClauseAG(gl.ag_expr);
}

--------------------------------------------------

attribute ag_expr {- ::AG_Expr -} occurs on Guard;

aspect production eqGuard
top::Guard ::= t1::Term t2::Term
{
  top.ag_expr = eqExpr(t1.ag_expr, t2.ag_expr);
}

aspect production neqGuard
top::Guard ::= t1::Term t2::Term
{
  top.ag_expr = neqExpr(t1.ag_expr, t2.ag_expr);
}

--------------------------------------------------

attribute ag_expr {- ::AG_Expr -} occurs on GuardList;

aspect production guardListCons
top::GuardList ::= g::Guard gl::GuardList
{
  top.ag_expr = andExpr(g.ag_expr, gl.ag_expr);
}

aspect production guardListOne
top::GuardList ::= g::Guard
{
  top.ag_expr = g.ag_expr;
}