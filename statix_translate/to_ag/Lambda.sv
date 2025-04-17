grammar statix_translate:to_ag;

--------------------------------------------------

attribute ag_expr {- ::AG_Expr -} occurs on Lambda;

attribute ag_funs occurs on Lambda;
propagate ag_funs on Lambda;

attribute nonAttrs occurs on Lambda;

-- todo: allow pattern as lambda arg? steps to false if no match
aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{
  local body::AG_Expr = 
    case wc of 
      nilWhereClause() -> c.ag_expr
    | _ ->
        caseExpr(
          nameExpr(arg),
          agCasesCons(
            agCase (agPatternUnderscore(), nilWhereClauseAG(), andExpr(wc.ag_expr, c.ag_expr)),     -- match
            agCasesCons(
              agCase(agPatternUnderscore(), nilWhereClauseAG(), falseExpr()), -- no match
              agCasesNil()
            )
          )
        )
    end;

  top.ag_expr = lambdaExpr (
    [(arg, ty.ag_type)],
    ^body
  );

  wc.nonAttrs = arg::top.nonAttrs;
  c.nonAttrs  = arg::top.nonAttrs; -- todo
}

--------------------------------------------------

attribute ag_expr occurs on WhereClause;

attribute nonAttrs occurs on WhereClause;
propagate nonAttrs on WhereClause;


aspect production nilWhereClause
top::WhereClause ::=
{
  top.ag_expr = trueExpr();
}

aspect production withWhereClause
top::WhereClause ::= gl::GuardList
{
  top.ag_expr = gl.ag_expr;
}

--------------------------------------------------

attribute ag_expr {- ::AG_Expr -} occurs on Guard;

attribute nonAttrs occurs on Guard;
propagate nonAttrs on Guard;

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

attribute nonAttrs occurs on GuardList;
propagate nonAttrs on GuardList;

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