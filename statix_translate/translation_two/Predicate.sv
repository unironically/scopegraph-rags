grammar statix_translate:translation_two;


--------------------------------------------------


attribute predicateCalls occurs on Predicate;

attribute predicateEnv occurs on Predicate;
propagate predicateEnv on Predicate;

attribute predicateDecls occurs on Predicate;

attribute prodTmpTrans occurs on Predicate;
propagate prodTmpTrans on Predicate;

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{
  top.predicateCalls :=
    ["For syntax predicate " ++ name ++ ":\n" ++
    implode("\n", map(\s::String -> "\t - " ++ s, bs.predicateCalls))];

  top.predicateDecls := [(name, left(syntaxPred(name, ^nameLst)))];


  -- all scope instances that are inherited
  bs.inhScopeInstances =
    map ((\id::String -> localScopeInstance(id, "INH")), nameLst.scopeDefNamesInh);

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

}


--------------------------------------------------


attribute predicateCalls occurs on Predicates;
propagate predicateCalls on Predicates;

attribute predicateEnv occurs on Predicates;
propagate predicateEnv on Predicates;

attribute predicateDecls occurs on Predicates;
propagate predicateDecls on Predicates;

attribute prodTmpTrans occurs on Predicates;
propagate prodTmpTrans on Predicates;

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{
}

aspect production predicatesNil
top::Predicates ::= 
{
}