grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_decls occurs on Module;
propagate ag_decls on Module;

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{ preds.globalNames = ords.orderNames; }
 
--------------------------------------------------

-- todo: order expressions as globals?

monoid attribute orderNames::[String] with [], ++ occurs on Orders;
propagate orderNames on Orders;

aspect production ordersCons
top::Orders ::= ord::Order ords::Orders
{}

aspect production ordersNil
top::Orders ::= 
{}

--------------------------------------------------

attribute orderNames occurs on Order;

aspect production order
top::Order ::= name::String pathComp::PathComp
{ top.orderNames := [name]; }

--------------------------------------------------

aspect production importsCons
top::Imports ::= imp::Import imps::Imports
{}

aspect production importsNil
top::Imports ::=
{}

--------------------------------------------------

aspect production imp
top::Import ::= qual::QualName
{}

--------------------------------------------------

attribute ag_decls occurs on Predicates;
propagate ag_decls on Predicates;

inherited attribute globalNames::[String] occurs on Predicates;
propagate globalNames on Predicates;

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{}

aspect production predicatesNil
top::Predicates ::= 
{}

--------------------------------------------------

attribute ag_decls occurs on Predicate;
propagate ag_decls on Predicate;

attribute globalNames occurs on Predicate;
propagate globalNames on Predicate;

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{
  top.ag_decls <- 
    let toAGNameType::((String, AG_Type) ::= (String, Type, Integer)) =
      \p::(String, Type, Integer) -> (p.1, p.2.ag_type)
    in
      [nonterminalDecl (
         name,
         map(toAGNameType, nameLst.inhs),
         map(toAGNameType, nameLst.syns))]
    end;

    bs.nonAttrs = top.globalNames;
}

aspect production functionalPredicate
top::Predicate ::= name::String params::NameList c::Constraint
{
  local pred::PredInfo = head(top.predsSyn);

  local retInfo::(AG_Type, AG_Expr, [AG_Eq]) =
    let args::[(String, Type, Integer)] = params.unlabelled in
    let rets::[(String, Type, Integer)] = params.syns in
    let retTys::[Type] = map(\p::(String, Type, Integer) -> fst(snd(p)), rets) in
    
    let labAGTysTemplate::[AG_Type] = map(\l::Label -> nameTypeAG("Scope"), top.knownLabels) in
    let labAGTys::[AG_Type] = labTysForScopeArgs(args, labAGTysTemplate) in
    let retAGTys::[AG_Type] = map((.ag_type), retTys) in

    if null(labAGTys ++ retAGTys)
    then (
      nameTypeAG("Boolean"),
      topDotExpr("ok"),
      [localDeclEq("ok", nameTypeAG("Boolean"))]
    )
    else (
      tupleTypeAG (nameTypeAG("Boolean") :: (labAGTys ++ retAGTys)),
      tupleExpr(
        topDotExpr("ok") :: (
          labRetsForScopeArgs(args, top.knownLabels) ++
          map(topDotExpr(_), map(fst, params.syns))
        )
      ),
      localDeclEq("ok", nameTypeAG("Boolean"))::(
        localDeclsForScopeArgs(args, top.knownLabels) ++
        map(\p::(String, Type, Integer) -> localDeclEq(p.1, p.2.ag_type), params.syns)
      )
    )
    end end end end end end;

  local retTy::AG_Type = retInfo.1;
  local retEq::[AG_Eq] = [returnEq(retInfo.2)];
  local retsAsLocals::[AG_Eq] = retInfo.3;

  top.ag_decls <- [
    functionDecl (
      name,
      ^retTy,
      map((\p::(String, Type, Integer) -> (p.1, p.2.ag_type)), params.unlabelled),
      retsAsLocals ++ c.equations ++ retEq
    )
  ];

  c.nonAttrs = top.globalNames;

}

function labTysForScopeArgs
[AG_Type] ::= args::[(String, Type, Integer)] labTys::[AG_Type]
{
  return
    case args of
    | [] -> []
    | (_, nameType("scope"), _)::t ->
        map(listTypeAG(_), labTys) ++
        labTysForScopeArgs(t, labTys)
    | _::t -> labTysForScopeArgs(t, labTys)
    end;
}

function labRetsForScopeArgs
[AG_Expr] ::= args::[(String, Type, Integer)] labTys::[Label]
{
  return
    case args of
    | [] -> []
    | (s, nameType("scope"), _)::t ->
        map(\l::Label -> nameExpr(s ++ "_" ++ l.name), labTys) ++
        labRetsForScopeArgs(t, labTys)
    | _::t -> labRetsForScopeArgs(t, labTys)
    end;
}

function localDeclsForScopeArgs
[AG_Eq] ::= args::[(String, Type, Integer)] labTys::[Label]
{
  return
    case args of
    | [] -> []
    | (s, nameType("scope"), _)::t ->
        map(\l::Label -> localDeclEq(s ++ "_" ++ l.name, listTypeAG(nameTypeAG("Scope"))), labTys) ++
        localDeclsForScopeArgs(t, labTys)
    | _::t -> localDeclsForScopeArgs(t, labTys)
    end;
}

--------------------------------------------------

attribute ag_decls occurs on ProdBranch;
propagate ag_decls on ProdBranch;

attribute globalNames occurs on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{
  top.ag_decls <- [
    productionDecl (
      name,
      top.prodTyAnn.ag_type,
      params.nameAGTys,
      c.equations
    )
  ];
  c.nonAttrs = top.globalNames;
}

--------------------------------------------------

attribute ag_decls occurs on ProdBranchList;
propagate ag_decls on ProdBranchList;

attribute nonAttrs occurs on ProdBranchList;
propagate nonAttrs on ProdBranchList;

attribute globalNames occurs on ProdBranchList;
propagate globalNames on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{}

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{}