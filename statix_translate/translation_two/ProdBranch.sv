grammar statix_translate:translation_two;

inherited attribute inhScopeInstances::[LocalScopeInstance];

monoid attribute prodTmpTrans::[String] with [], ++;

--------------------------------------------------

attribute predicateCalls occurs on ProdBranch;
propagate predicateCalls on ProdBranch;

attribute predicateEnv occurs on ProdBranch;
propagate predicateEnv on ProdBranch;

-- list of localScopeInstance(name::String, source::String), yet to be decorated with `flowsToNodes` and `localContribs`
attribute inhScopeInstances occurs on ProdBranch;

attribute prodTmpTrans occurs on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{
  
  local allLocalScopeInstances::[LocalScopeInstance]
    = unionBy((\l1::LocalScopeInstance l2::LocalScopeInstance -> l1.name == l2.name), 
              c.localScopeInstances, top.inhScopeInstances); -- inhScopeInstances on the left, so that these are kept in case of collision (dy def of silver union)

  local decoratedLocalScopeInstances::[Decorated LocalScopeInstance] = 
    map (
      (
        \l::LocalScopeInstance ->
          decorate l with {
            flowsToNodes  = filterMap((\p::(String, String) -> if p.1 == l.name then just(p.2) else nothing()), c.localScopeFlows);
            localContribs = filterMap((\p::(String, Label, String) -> if p.1 == l.name then just((p.2, p.3)) else nothing()), c.localScopeContribs);
          }
      ),
      allLocalScopeInstances
    );

  top.prodTmpTrans := [
    name ++ " ->\n\t" ++
      implode (
        "\n\t", 
        map (
          (
           \s::Decorated LocalScopeInstance ->
              s.name ++ " | " ++ s.scopeSource ++ 
                        " | " ++ implode (", ", s.flowsToNodes) ++ 
                        " | " ++ implode (", ", map ((\p::(Label, String) -> "(" ++ p.1.labelTrans ++ ", " ++ p.2 ++ ")"), s.localContribs)) ++ 
                        " |"
          ),
          decoratedLocalScopeInstances
        )
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

attribute prodTmpTrans occurs on ProdBranchList;
propagate prodTmpTrans on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{

}

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{

}