grammar statix_translate:to_ag;

--------------------------------------------------

synthesized attribute ag_case::AG_Case occurs on Branch;

attribute ag_funs occurs on Branch;
propagate ag_funs on Branch;

attribute nonAttrs occurs on Branch;

attribute matchExpr occurs on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{
  {-top.ag_case = agCase(
    m.ag_pattern, 
    m.ag_whereClause,
    c.ag_expr
  );-}
  c.nonAttrs = top.nonAttrs ++ m.nonAttrsSyn;
  m.nonAttrs = top.nonAttrs;

  local bodyRenamed::AG_Expr = 
    case m.ag_pattern_and_where of
    | (_, _, just((lst, len))) -> 
        letExpr("d_lam_arg", datumTypeAG(), top.matchExpr,
          foldr (
            \arg::(String, String, Integer, AG_Type) acc::AG_Expr ->
              acc.renameDatumArg(arg.1, arg.2, arg.3, len),
            c.ag_expr,
            lst
          )
        )
    | _ -> c.ag_expr
    end;

  top.ag_case = agCase (
    m.ag_pattern_and_where.1,
    nilWhereClauseAG(),
    ifExpr(m.ag_pattern_and_where.2, ^bodyRenamed, abortExpr("branch case else TODO"))
  );
}

--------------------------------------------------

attribute ag_cases occurs on BranchList;

attribute ag_funs occurs on BranchList;
propagate ag_funs on BranchList;

attribute nonAttrs occurs on BranchList;
propagate nonAttrs on BranchList;

inherited attribute matchExpr::AG_Expr occurs on BranchList;
propagate matchExpr on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{
  top.ag_cases = agCasesCons(b.ag_case, bs.ag_cases);
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
}