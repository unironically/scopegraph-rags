grammar statix_translate:to_ag;

--------------------------------------------------

monoid attribute ag_nts::AG_Decls with agDeclsNil(), agDeclsCat occurs on Module;
monoid attribute ag_globals::AG_Decls with agDeclsNil(), agDeclsCat occurs on Module;
monoid attribute ag_prods::AG_Decls with agDeclsNil(), agDeclsCat occurs on Module;
monoid attribute ag_funs::AG_Decls with agDeclsNil(), agDeclsCat occurs on Module;
monoid attribute ag_inh_attrs::[(String, AG_Type)] with [], agAttrsUnion occurs on Module;
monoid attribute ag_syn_attrs::[(String, AG_Type)] with [], agAttrsUnion occurs on Module;

propagate ag_nts, ag_globals, ag_prods, ag_funs, ag_inh_attrs, ag_syn_attrs on Module;

synthesized attribute ag::AG occurs on Module;

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{ 
  preds.globalNames = ords.orderNames;
  top.ag = ag(top.ag_nts, top.ag_globals, top.ag_prods, top.ag_funs, 
              top.ag_inh_attrs, top.ag_syn_attrs, top.labelsSyn);
}
 
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

attribute ag_nts occurs on Predicates;
propagate ag_nts on Predicates;

attribute ag_prods occurs on Predicates;
propagate ag_prods on Predicates;

attribute ag_funs occurs on Predicates;
propagate ag_funs on Predicates;

attribute ag_inh_attrs occurs on Predicates;
propagate ag_inh_attrs on Predicates;

attribute ag_syn_attrs occurs on Predicates;
propagate ag_syn_attrs on Predicates;

inherited attribute globalNames::[String] occurs on Predicates;
propagate globalNames on Predicates;

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{}

aspect production predicatesNil
top::Predicates ::= 
{}

--------------------------------------------------

attribute ag_nts occurs on Predicate;
propagate ag_nts on Predicate;

attribute ag_prods occurs on Predicate;
propagate ag_prods on Predicate;

attribute ag_funs occurs on Predicate;
propagate ag_funs on Predicate;

attribute globalNames occurs on Predicate;
propagate globalNames on Predicate;

attribute ag_inh_attrs occurs on Predicate;
propagate ag_inh_attrs on Predicate;

attribute ag_syn_attrs occurs on Predicate;
propagate ag_syn_attrs on Predicate;

synthesized attribute ag_decl::AG_Decl occurs on Predicate;

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{
  -- inherited attributes
  local inhs::[(String, AG_Type)] = map (
    \p::(String, Type, Integer) -> (p.1, p.2.ag_type),
    nameLst.inhs
  );

  -- synthesized attributes
  local syns::[(String, AG_Type)] = ("ok", boolTypeAG()) :: 
    (map(\p::(String, Type, Integer) -> (p.1, p.2.ag_type), nameLst.syns) ++ 
    edgeAttrsForInhScopes(inhs, top.knownLabels));

  top.ag_decl = nonterminalDecl (name, inhs, syns);

  top.ag_nts <- agDeclsOne(top.ag_decl);

  top.ag_inh_attrs <- inhs;

  top.ag_syn_attrs <- syns;

  bs.nonAttrs = top.globalNames;
}


function edgeAttrsForInhScopes
[(String, AG_Type)] ::= inhs::[(String, AG_Type)] labs::[Label]
{
  return
    case inhs of
    | (s, scopeTypeAG())::t -> 
        map((\l::Label -> (s ++ "_" ++ l.name, listTypeAG(scopeTypeAG()))), labs) ++ 
        edgeAttrsForInhScopes(t, labs)
    | _::t -> edgeAttrsForInhScopes(t, labs)
    | [] -> []
    end;
}

aspect production functionalPredicate
top::Predicate ::= name::String params::NameList c::Constraint
{
  local pred::PredInfo = head(top.predsSyn);

  local retInfo::(AG_Type, AG_Expr, [AG_Eq]) =
    let args::[(String, Type, Integer)] = params.unlabelled in
    let rets::[(String, Type, Integer)] = params.syns in
    let retTys::[Type] = map(\p::(String, Type, Integer) -> fst(snd(p)), rets) in
    
    let labAGTysTemplate::[AG_Type] = map(\l::Label -> scopeTypeAG(), top.knownLabels) in
    let labAGTys::[AG_Type] = labTysForScopeArgs(args, labAGTysTemplate) in
    let retAGTys::[AG_Type] = map((.ag_type), retTys) in

    if null(labAGTys ++ retAGTys)
    then (
      boolTypeAG(),
      topDotExpr("ok"),
      [localDeclEq("ok", boolTypeAG())]
    )
    else (
      tupleTypeAG (boolTypeAG() :: (labAGTys ++ retAGTys)),
      tupleExpr(
        topDotExpr("ok") :: (
          labRetsForScopeArgs(args, top.knownLabels) ++
          map(topDotExpr(_), map(fst, params.syns))
        )
      ),
      localDeclEq("ok", boolTypeAG())::(
        localDeclsForScopeArgs(args, top.knownLabels) ++
        map(\p::(String, Type, Integer) -> localDeclEq(p.1, p.2.ag_type), params.syns)
      )
    )
    end end end end end end;

  local retTy::AG_Type = retInfo.1;
  local retEq::[AG_Eq] = [returnEq(retInfo.2)];
  local retsAsLocals::[AG_Eq] = retInfo.3;

  top.ag_decl =
    functionDecl (
      name,
      ^retTy,
      map((\p::(String, Type, Integer) -> (p.1, p.2.ag_type)), params.unlabelled),
      retsAsLocals ++ c.equations ++ retEq
    );

  top.ag_funs <- agDeclsOne(top.ag_decl);

  c.nonAttrs = top.globalNames;

}

function labTysForScopeArgs
[AG_Type] ::= args::[(String, Type, Integer)] labTys::[AG_Type]
{
  return
    case args of
    | [] -> []
    | (_, scopeType(), _)::t ->
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
    | (s, scopeType(), _)::t ->
        map(\l::Label -> topDotExpr(s ++ "_" ++ l.name), labTys) ++
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
    | (s, scopeType(), _)::t ->
        map(\l::Label -> localDeclEq(s ++ "_" ++ l.name, listTypeAG(scopeTypeAG())), labTys) ++
        localDeclsForScopeArgs(t, labTys)
    | _::t -> localDeclsForScopeArgs(t, labTys)
    end;
}

--------------------------------------------------

attribute ag_prods occurs on ProdBranch;
propagate ag_prods on ProdBranch;

attribute ag_funs occurs on ProdBranch;
propagate ag_funs on ProdBranch;

attribute globalNames occurs on ProdBranch;

attribute ag_decl occurs on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{
  top.ag_decl =
    productionDecl (
      name,
      top.prodTyAnn.ag_type,
      params.nameAGTys,
      c.equations
    );
  top.ag_prods <- agDeclsOne(top.ag_decl);
  c.nonAttrs = top.globalNames;
}

--------------------------------------------------

attribute ag_prods occurs on ProdBranchList;
propagate ag_prods on ProdBranchList;

attribute ag_funs occurs on ProdBranchList;
propagate ag_funs on ProdBranchList;

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