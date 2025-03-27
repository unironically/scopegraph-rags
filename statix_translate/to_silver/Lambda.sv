grammar statix_translate:translation;

--------------------------------------------------

--------------------------------------------------

attribute ag_expr {- ::AG_Expr -} occurs on Lambda;

attribute ag_decls {- ::[AG_Decl] -} occurs on Lambda;
propagate ag_decls on Lambda;

aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{
  local lam_name::String = "lambda_" ++ toString(genInt());

  top.ag_expr = nameExpr(lam_name);

  top.ag_decls <- [
    functionDecl (lam_name, [boolType()], body)
  ];

  local body::[AG_Eq] = 
    case wc of 
      nilWhereClause()    -> c.equations
    | withWhereClause(gl) -> error("lambda.body - withWhereClause TODO")
    end;
}

--------------------------------------------------

aspect production nilWhereClause
top::WhereClause ::=
{}

aspect production withWhereClause
top::WhereClause ::= gl::GuardList
{}

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

attribute ag_exprs {- ::[AG_Expr] -} occurs on GuardList;

aspect production guardListCons
top::GuardList ::= g::Guard gl::GuardList
{
  top.ag_exprs = g.ag_expr :: gl.ag_Exprs;
}

aspect production guardListOne
top::GuardList ::= g::Guard
{
  top.ag_exps = [g.ag_expr];
}