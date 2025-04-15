grammar statix_translate:to_ag;

--------------------------------------------------

synthesized attribute ag_case::AG_Case occurs on Branch;

attribute ag_funs occurs on Branch;
propagate ag_funs on Branch;

attribute nonAttrs occurs on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{
  top.ag_case = agCase(
    m.ag_pattern, 
    m.ag_whereClause,
    c.ag_expr
  );
  c.nonAttrs = top.nonAttrs ++ m.nonAttrsSyn;
  m.nonAttrs = top.nonAttrs;
}

--------------------------------------------------

attribute ag_cases occurs on BranchList;

attribute ag_funs occurs on BranchList;
propagate ag_funs on BranchList;

attribute nonAttrs occurs on BranchList;
propagate nonAttrs on BranchList;

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