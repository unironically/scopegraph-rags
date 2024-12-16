grammar statix_translate:translation;

--------------------------------------------------

attribute lambdas occurs on Branch;
propagate lambdas on Branch;

attribute definedNonLocals occurs on Branch;
propagate definedNonLocals on Branch;

attribute knownFuncPreds occurs on Branch;
propagate knownFuncPreds on Branch;

synthesized attribute branchTrans::String occurs on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{
  
  top.branchTrans = m.matcherTrans ++ " -> " ++ c.constraintTrans;

  c.localScopes = c.localScopesSyn;

}

--------------------------------------------------

attribute lambdas occurs on BranchList;
propagate lambdas on BranchList;

attribute definedNonLocals occurs on BranchList;
propagate definedNonLocals on BranchList;

attribute knownFuncPreds occurs on BranchList;
propagate knownFuncPreds on BranchList;

synthesized attribute branchListTrans::[String] occurs on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{
  top.branchListTrans = b.branchTrans :: bs.branchListTrans;
}

aspect production branchListOne
top::BranchList ::= b::Branch
{
  top.branchListTrans = [b.branchTrans];
}