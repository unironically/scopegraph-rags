grammar statix_translate:translation;

--------------------------------------------------

attribute lambdas occurs on Branch;
propagate lambdas on Branch;

attribute definedNonLocals occurs on Branch;
propagate definedNonLocals on Branch;

attribute knownFuncPreds occurs on Branch;
propagate knownFuncPreds on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{
  c.localScopes = c.localScopesSyn;
}

--------------------------------------------------

attribute lambdas occurs on BranchList;
propagate lambdas on BranchList;

attribute definedNonLocals occurs on BranchList;
propagate definedNonLocals on BranchList;

attribute knownFuncPreds occurs on BranchList;
propagate knownFuncPreds on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{

}

aspect production branchListOne
top::BranchList ::= b::Branch
{

}