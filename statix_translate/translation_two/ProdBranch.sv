grammar statix_translate:translation_two;

inherited attribute inhScopeInstances::[LocalScopeInstance];

monoid attribute prodBranchListTrans::[String] with [], ++;

inherited attribute prodType::SyntaxPred;

--------------------------------------------------

attribute predicateCalls occurs on ProdBranch;
propagate predicateCalls on ProdBranch;

attribute predicateEnv occurs on ProdBranch;
propagate predicateEnv on ProdBranch;

-- information about the predicate being used
attribute prodType occurs on ProdBranch;

-- list of localScopeInstance(name::String, source::String), yet to be decorated with `flowsToNodes` and `localContribs`
attribute inhScopeInstances occurs on ProdBranch;

attribute prodBranchListTrans occurs on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{
  
  local allLocalScopeInstances::[LocalScopeInstance]
    = unionBy((\l1::LocalScopeInstance l2::LocalScopeInstance -> l1.name == l2.name), 
              c.localScopeInstances, top.inhScopeInstances); -- inhScopeInstances on the left, so that these are kept in case of collision (dy def of silver union)

  -- decorated scopes instances. i.e., we know their local contributions and flow information
  local decoratedLocalScopeInstances::[Decorated LocalScopeInstance] = 
    map (
      (
        \l::LocalScopeInstance ->
          decorate l with {
            flowsToNodes  = filterMap((\p::(String, String, String) -> if p.1 == l.name then just(snd(p)) else nothing()), c.localScopeFlows);
            localContribs = filterMap((\p::(String, Label, String) -> if p.1 == l.name then just((p.2, p.3)) else nothing()), c.localScopeContribs);
          }
      ),
      allLocalScopeInstances
    );


  local labelSet::[Label] = [label("LEX"), label("IMP"), label("MOD"), label("VAR")]; -- todo, passed down after prog analysis
  local bodyScopeEqs::String = genScopeEquations(decoratedLocalScopeInstances, labelSet);

  top.prodBranchListTrans := [
    genProduction (
      name,
      nameType(top.prodType.name),
      params.prodChildParams,
      bodyScopeEqs ++ "\n" ++ c.constraintTrans
    )
  ];

}

--------------------------------------------------

attribute predicateCalls occurs on ProdBranchList;
propagate predicateCalls on ProdBranchList;

attribute predicateEnv occurs on ProdBranchList;
propagate predicateEnv on ProdBranchList;

-- list of localScopeInstance(name::String, source::String), yet to be decorated with `flowsToNodes` and `localContribs`
attribute inhScopeInstances occurs on ProdBranchList;
propagate inhScopeInstances on ProdBranchList;

attribute prodBranchListTrans occurs on ProdBranchList;
propagate prodBranchListTrans on ProdBranchList;

attribute prodType occurs on ProdBranchList;
propagate prodType on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{

}

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{

}