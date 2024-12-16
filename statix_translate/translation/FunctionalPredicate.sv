grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute predicateTrans::String occurs on Predicate;

attribute lambdas occurs on Predicate;
propagate lambdas on Predicate;

monoid attribute functionalPreds::[(String, [(String, Boolean, TypeAnn)])] with [], ++ occurs on Predicate;

attribute knownFuncPreds occurs on Predicate;
propagate knownFuncPreds on Predicate;

--

aspect production functionalPredicate 
top::Predicate ::= 
    name::String        -- predicate name
    nameLst::NameList   -- predicate args
    const::Constraint   -- body
{
  const.localScopes = const.localScopesSyn;

  local argDecls::[String] = map (\p::(String, TypeAnn) -> p.1 ++ "::" ++ p.2.typeTrans, 
                                  nameLst.nameListUntg);

  local retTys::[String] = map ((.typeTrans), map (snd, nameLst.nameListRets));
  local retIds::[String] = map (fst, nameLst.nameListRets);

  local retTy::String = 
    if null(nameLst.nameListRets)
    then "Boolean"
    else "(Boolean, " ++ implode (", ", retTys) ++ ")";

  local retVal::String = 
    let oks::String = implode ("&&", const.okNames) in
    let rets::String = implode (", ", retIds) in
      case const.okNames, retIds of
      | [], []  -> "()"
      | [], rs  -> "(" ++ rets ++ ")"
      | okl, [] -> "(" ++ oks ++ ")"
      | okl, rs -> "(" ++ oks ++ ", " ++ rets ++ ")"
      end
    end end;

  top.predicateTrans = 
    "function " ++ name ++ " " ++
      retTy ++ " ::= " ++ implode (" ", argDecls) ++
    "{" ++
      const.constraintTrans ++
      "return " ++ retVal ++ ";" ++
    "}";

  top.functionalPreds := [(name, nameLst.allFuncArgDecls)];

  const.namesInScope = nameLst.nameListDefs;
}

--------------------------------------------------

-- NameList only used in syntaxPredicate or functionalPredicate

monoid attribute nameListSyns::[(String, TypeAnn)] with [], ++ occurs on NameList, Name;
monoid attribute nameListInhs::[(String, TypeAnn)] with [], ++ occurs on NameList, Name;
monoid attribute nameListRets::[(String, TypeAnn)] with [], ++ occurs on NameList, Name;
monoid attribute nameListUntg::[(String, TypeAnn)] with [], ++ occurs on NameList, Name;
propagate nameListSyns, nameListInhs, nameListRets, nameListUntg on NameList, Name;

synthesized attribute numberUntagged::Integer occurs on NameList;

synthesized attribute allFuncArgDecls::[(String, Boolean, TypeAnn)] occurs on NameList;

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{
  top.numberUntagged = case name of | nameUntagged(_, _) -> 1 | _ -> 0 end
                       + names.numberUntagged;
  top.allFuncArgDecls = 
    map (\p::(String, TypeAnn) -> (p.1, false, p.2), name.nameListRets) ++
    map (\p::(String, TypeAnn) -> (p.1, true, p.2), name.nameListUntg) ++
    names.allFuncArgDecls;
}

aspect production nameListOne
top::NameList ::= name::Name
{
  top.numberUntagged = case name of | nameUntagged(_, _) -> 1 | _ -> 0 end;
  top.allFuncArgDecls = 
    map (\p::(String, TypeAnn) -> (p.1, false, p.2), name.nameListRets) ++
    map (\p::(String, TypeAnn) -> (p.1, true, p.2), name.nameListUntg);
}

--------------------------------------------------

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{
  top.nameListSyns <- [(name, ^ty)];
}

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{
  top.nameListInhs <- [(name, ^ty)];
}

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{
  top.nameListRets <- [(name, ^ty)];
}

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{
  top.nameListUntg <- [(name, ^ty)];
}

--------------------------------------------------