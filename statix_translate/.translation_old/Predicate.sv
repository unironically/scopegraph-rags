grammar statix_translate:translation;

monoid attribute predicatesTrans::[String] with [], ++;

--------------------------------------------------


attribute predicateCalls occurs on Predicate;

attribute predicateEnv occurs on Predicate;
propagate predicateEnv on Predicate;

attribute predicateDecls occurs on Predicate;

attribute predicatesTrans occurs on Predicate;

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{
  local pred::SyntaxPred = syntaxPred(name, ^nameLst);

  top.predicateCalls :=
    ["For syntax predicate " ++ name ++ ":\n" ++
    implode("\n", map(\s::String -> "\t - " ++ s, bs.predicateCalls))];

  top.predicateDecls := [(name, left(^pred))];


  -- all scope instances that are inherited
  bs.inhScopeInstances =
    map ((\id::String -> localScopeInstance(id, "INH")), nameLst.scopeDefNamesInh);

  bs.prodType = ^pred;

  top.predicatesTrans := 
    let 
      prodsTrans::[String] = bs.prodBranchListTrans
    in
      ["nonterminal " ++ name ++ ";\n" ++ implode("\n", prodsTrans)]
    end;

}


-----------------------------------------


aspect production functionalPredicate 
top::Predicate ::= 
    name::String        -- predicate name
    nameLst::NameList   -- predicate args
    const::Constraint   -- body
{
  top.predicateCalls :=
    ["For functional predicate " ++ name ++ ":\n" ++
    implode("\n", map(\s::String -> "\t - " ++ s, const.predicateCalls))];

  top.predicateDecls := [(name, right(functionPred(name, ^nameLst)))];

  top.predicatesTrans := []; -- todo

}


--------------------------------------------------


attribute predicateCalls occurs on Predicates;
propagate predicateCalls on Predicates;

attribute predicateEnv occurs on Predicates;
propagate predicateEnv on Predicates;

attribute predicateDecls occurs on Predicates;
propagate predicateDecls on Predicates;

attribute predicatesTrans occurs on Predicates;
propagate predicatesTrans on Predicates;

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{
}

aspect production predicatesNil
top::Predicates ::= 
{
}