grammar statix_translate:translation;


--------------------------------------------------

attribute predicateCalls occurs on Branch;
propagate predicateCalls on Branch;

attribute predicateEnv occurs on Branch;
propagate predicateEnv on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{
  
}

--------------------------------------------------

attribute predicateCalls occurs on BranchList;
propagate predicateCalls on BranchList;

attribute predicateEnv occurs on BranchList;
propagate predicateEnv on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{

}

aspect production branchListOne
top::BranchList ::= b::Branch
{

}