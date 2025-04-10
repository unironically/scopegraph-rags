grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute ag_case::AG_Case occurs on Branch;

attribute ag_decls occurs on Branch;
propagate ag_decls on Branch;

--top::AG_Case ::= pat::AG_Pattern wc::Maybe<AG_WhereClause> body::AG_Expr

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{
  top.ag_case = agCase(
    m.ag_pattern, 
    m.ag_whereClause,
    c.ag_expr
  );
}

--------------------------------------------------

attribute ag_cases occurs on BranchList;

attribute ag_decls occurs on BranchList;
propagate ag_decls on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{
  top.ag_cases = agCasesCons(b.ag_case, bs.ag_cases);
}

aspect production branchListOne
top::BranchList ::= b::Branch
{
  top.ag_cases = agCasesOne(b.ag_case);
}