grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_decls occurs on Module;
propagate ag_decls on Module;

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{}
 
--------------------------------------------------

aspect production ordersCons
top::Orders ::= ord::Order ords::Orders
{}

aspect production ordersNil
top::Orders ::= 
{}

--------------------------------------------------

aspect production order
top::Order ::= name::String pathComp::PathComp
{}

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

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{}

aspect production predicatesNil
top::Predicates ::= 
{}

--------------------------------------------------

attribute ag_decls occurs on Predicate;
propagate ag_decls on Predicate;

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
}

aspect production functionalPredicate
top::Predicate ::= name::String params::NameList c::Constraint
{
  local pred::PredInfo = head(top.predsSyn);

  local retTy::AG_Type =
    let args::[(String, Type, Integer)] = params.unlabelled in
    let rets::[(String, Type, Integer)] = params.syns in
    let retTys::[Type] = map(\p::(String, Type, Integer) -> fst(snd(p)), rets) in
    
    let labAGTysTemplate::[AG_Type] = map(\l::Label -> nameTypeAG("Label"), top.knownLabels) in
    let labAGTys::[AG_Type] = labTysForScopeArgs(args, labAGTysTemplate) in
    let retAGTys::[AG_Type] = map((.ag_type), retTys) in

    if null(labAGTys ++ retAGTys)
    then nameTypeAG("Boolean")
    else tupleTypeAG (
      nameTypeAG("Boolean") :: (labAGTys ++ retAGTys)
    )
      
    end end end end end end;

  top.ag_decls <- [
    functionDecl (
      name,
      ^retTy,
      params.nameAGTys,
      c.equations
    )
  ];
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

--------------------------------------------------

attribute ag_decls occurs on ProdBranch;
propagate ag_decls on ProdBranch;

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
}

--------------------------------------------------

attribute ag_decls occurs on ProdBranchList;
propagate ag_decls on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{}

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{}