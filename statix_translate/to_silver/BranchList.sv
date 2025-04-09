grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute ag_case::AG_Case occurs on Branch;

attribute ag_decls occurs on Branch;
propagate ag_decls on Branch;

--top::AG_Case ::= pat::AG_Pattern wc::Maybe<AG_WhereClause> body::AG_Expr

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{
  local fun_name::String = "fun_" ++ toString(genInt()) ++ "_" ++ toString(top.location.line);
  
  -- args stuff

  local namesInBranchScopeAux::[(String, Type)] = m.nameTyDeclsSyn ++ top.nameTyDecls;
  local namesInBranchScope::[(String, Type)] = 
    filter((\p::(String, Type) -> !contains(p.1, c.defs)), namesInBranchScopeAux);

  local namesOfNamesInScope::[String] = map(fst, namesInBranchScope);
  local tysOfNamesInScope::[Type] = map(snd, namesInBranchScope);
  local agTysOfNamesInScope::[AG_Type] = map((.ag_type), tysOfNamesInScope);
  local branchFunArgs::[(String, AG_Type)] = zip(namesOfNamesInScope, agTysOfNamesInScope);
  local appArgs::[AG_Expr] = map(nameExpr(_), namesOfNamesInScope);
  local app::AG_Expr = appExpr(fun_name, appArgs);

  -- return stuff

  local defNamesTys::[(String, Type)] = filterMap(lookupVar(_, top.nameTyDecls), c.defs);
  local scopesExtended::[String] = top.requires;
  local labs::[Label] = top.knownLabels;
  local labTys::[AG_Type] = map(\l::Label -> nameTypeAG("Label"), labs);
  local pairType::AG_Type = 
    if null(scopesExtended ++ c.defs)
          then nameTypeAG("Boolean")
          else tupleTypeAG (nameTypeAG("Boolean")::(
                            foldr(appendList, [],
                              map(\s::String -> labTys, scopesExtended)
                            ) ++
                            map((.ag_type), map(snd, defNamesTys))  -- var defs
                           ));

  local perScopeLabRets::[AG_Expr] =
    concat (map (
      (\s::String ->
         map(\l::Label -> nameExpr(s ++ "_" ++ l.name), labs)),
      scopesExtended
    ));
  local defRets::[AG_Expr] = map(topDotExpr(_), map(fst, defNamesTys));

  top.ag_case = agCase(m.ag_pattern, m.ag_whereClause, ^app);

  local retsAsLocals::[AG_Eq] = 
    localDeclEq("ok", nameTypeAG("Boolean")) ::
    map (\p::(String, Type, Integer) -> localDeclEq(p.1, p.2.ag_type),
         params.syns);

  top.ag_decls <- [
    functionDecl (
      fun_name,
      ^pairType,
      branchFunArgs,
      retsAsLocals ++
      c.equations ++
      [
        returnEq(tupleExpr(
          nameExpr("ok") :: -- we always have an ok result
          (perScopeLabRets ++     -- scope labs for scopes we extend in the case
          defRets)               -- defs in the case
        ))
      ]
      )
  ];
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