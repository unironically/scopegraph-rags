grammar statix_translate:to_ag;

--------------------------------------------------

synthesized attribute ag_case::AG_Case occurs on Branch;
synthesized attribute ag_case_with_ok::AG_Case occurs on Branch;

synthesized attribute hasAppConstraintBody::Boolean occurs on Branch;

attribute ag_funs occurs on Branch;
propagate ag_funs on Branch;

attribute nonAttrs occurs on Branch;

attribute matchExpr occurs on Branch;

attribute ag_prods occurs on Branch;
propagate ag_prods on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{
  c.nonAttrs = top.nonAttrs ++ m.nonAttrsSyn;
  m.nonAttrs = top.nonAttrs;

  local bodyRenamed::(AG_Expr ::= AG_Expr) = \cBody::AG_Expr ->
    case m.ag_pattern_and_where of
    | (_, _, just((lst, len))) -> 
        letExpr("d_lam_arg", datumTypeAG(), top.matchExpr,
          foldr (
            \arg::(String, String, Integer, AG_Type) acc::AG_Expr ->
              acc.renameDatumArg(arg.1, arg.2, arg.3, len),
            cBody,
            lst
          )
        )
    | _ -> cBody
    end;

  top.ag_case = agCase (
    m.ag_pattern_and_where.1,
    nilWhereClauseAG(),
    ifExpr(m.ag_pattern_and_where.2, bodyRenamed(c.ag_expr), abortExpr("branch case else TODO"))
  );

  top.ag_case_with_ok = agCase (
    m.ag_pattern_and_where.1,
    nilWhereClauseAG(),
    ifExpr(m.ag_pattern_and_where.2, bodyRenamed(c.ag_expr_with_ok), abortExpr("branch case else TODO"))
  );

  top.hasAppConstraintBody =
    case c of applyConstraint(_, _) -> true
            | _ -> false
    end;
}

--------------------------------------------------

attribute ag_cases occurs on BranchList;

synthesized attribute ag_cases_with_ok::AG_Cases occurs on BranchList;

attribute hasAppConstraintBody occurs on BranchList;

attribute ag_funs occurs on BranchList;
propagate ag_funs on BranchList;

attribute nonAttrs occurs on BranchList;
propagate nonAttrs on BranchList;

inherited attribute matchExpr::AG_Expr occurs on BranchList;
propagate matchExpr on BranchList;

attribute ag_prods occurs on BranchList;
propagate ag_prods on BranchList;


aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{
  top.ag_cases = agCasesCons(b.ag_case, bs.ag_cases);
  top.ag_cases_with_ok = agCasesCons(b.ag_case_with_ok, bs.ag_cases_with_ok);
  
  top.hasAppConstraintBody = b.hasAppConstraintBody || bs.hasAppConstraintBody;
}

aspect production branchListOne
top::BranchList ::= b::Branch
{
  top.ag_cases = 
    agCasesCons(
      b.ag_case,
      agCasesOne(agCase(
        agPatternUnderscore(),
        nilWhereClauseAG(),
        abortExpr("Match failure!")
      ))
    );

  top.ag_cases_with_ok =
    agCasesCons(
      b.ag_case_with_ok,
      agCasesOne(agCase(
        agPatternUnderscore(),
        nilWhereClauseAG(),
        abortExpr("Match failure!")
      ))
    );

  top.hasAppConstraintBody = b.hasAppConstraintBody;
}