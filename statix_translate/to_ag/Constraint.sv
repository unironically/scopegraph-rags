grammar statix_translate:to_ag;

--------------------------------------------------

fun topDotLHS  AG_LHS  ::= s::String = qualLHS(nameLHS("top"), s);
fun topDotExpr AG_Expr ::= s::String = demandExpr(nameExpr("top"), s);

synthesized attribute equations::[AG_Eq] occurs on Constraint;
synthesized attribute ag_expr::AG_Expr;

attribute ag_expr occurs on Constraint;

inherited attribute nonAttrs::[String] occurs on Constraint;
propagate nonAttrs on Constraint;

--------------------------------------------------

attribute ag_funs occurs on Constraint;
propagate ag_funs on Constraint;

aspect production trueConstraint
top::Constraint ::=
{
  top.equations = [ contributionEq(topDotLHS("ok"), trueExpr()) ];
  top.ag_expr = trueExpr();
}

aspect production falseConstraint
top::Constraint ::=
{
  top.equations = [ contributionEq(topDotLHS("ok"), falseExpr()) ];
  top.ag_expr = falseExpr();
}

aspect production conjConstraint
top::Constraint ::= c1::Constraint c2::Constraint
{
  top.equations = c1.equations ++ c2.equations;
  top.ag_expr = error("conjConstraint.ag_expr");
}

aspect production existsConstraint
top::Constraint ::= names::NameList c::Constraint
{
  top.equations = names.localDeclEqs ++ c.equations;
  top.ag_expr = error("existsConstraint.ag_expr");
}

aspect production eqConstraint
top::Constraint ::= t1::Term t2::Term
{
  local eq::AG_Expr = eqExpr(t1.ag_expr, t2.ag_expr);
  top.equations = [ contributionEq(topDotLHS("ok"), ^eq) ];
  top.ag_expr = ^eq;
}

aspect production neqConstraint
top::Constraint ::= t1::Term t2::Term
{
  local neq::AG_Expr = neqExpr(t1.ag_expr, t2.ag_expr);
  top.equations = [ contributionEq(topDotLHS("ok"), ^neq) ];
  top.ag_expr = ^neq;
}

aspect production newConstraintDatum
top::Constraint ::= name::String t::Term
{
  local ref::AG_LHS = nameLHS(name);
  local mkScopeApp::AG_Expr = termExpr("mkScope", []);

  local labelLocals::[AG_Eq] = map (
    \l::Label -> localDeclEq(name ++ "_" ++ l.name, listTypeAG(nameTypeAG("scope"))),
    top.knownLabels
  );

  local edgeInhs::[AG_Eq] = map (
    \l::Label -> 
      defineEq(qualLHS(nameLHS(name), l.name), topDotExpr(name ++ "_" ++ l.name)),
    top.knownLabels
  );

  local datumRef::AG_Expr = nameExpr(name ++ "_datum");
  local datumDef::AG_Eq = ntaEq (nameLHS(name ++ "_datum"), datumAndDataApp.1);
  local dataDef::AG_Eq = datumAndDataApp.2;
  local datumAndDataApp::(AG_Expr, AG_Eq) =
    case t of
    | constructorTerm(dname, termListCons(idt, t)) ->
        (
          termExpr(dname, [idt.ag_expr]),
          defineEq(qualLHS(nameLHS(name ++ "_datum"), "data"), 
            termExpr("ActualData" ++ dname, t.ag_exprs))
        )
    | _ -> error("newConstraintDatum.datumAndDataApp")
    end; 

  -- creating the scope and edge eqs
  local localDef::AG_Eq = defineEq (topDotLHS(name), nameExpr(name));
  local scopeEq::AG_Eq = ntaEq (^ref, ^mkScopeApp);
  local inhEq::AG_Eq = defineEq(qualLHS(^ref, "datum"), ^datumRef);

  top.equations = labelLocals ++ edgeInhs ++ 
                  [ ^datumDef, ^dataDef,        -- data
                    ^localDef, ^scopeEq, ^inhEq -- scope
                  ];

  top.ag_expr = ^mkScopeApp;
}

aspect production newConstraint
top::Constraint ::= name::String
{
  local ref::AG_LHS = nameLHS(name);
  local mkScopeApp::AG_Expr = termExpr("mkScope", []);
  
  local labelLocals::[AG_Eq] = map (
    \l::Label -> 
      localDeclEq(name ++ "_" ++ l.name, listTypeAG(nameTypeAG("scope"))),
    top.knownLabels
  );

  local edgeInhs::[AG_Eq] = map (
    \l::Label -> 
      defineEq(qualLHS(nameLHS(name), l.name), topDotExpr(name ++ "_" ++ l.name)),
    top.knownLabels
  );

  local localDef::AG_Eq = defineEq (topDotLHS(name), nameExpr(name));

  top.equations = labelLocals ++ edgeInhs ++ 
                  [ ^localDef, ntaEq (^ref, ^mkScopeApp) ];
  top.ag_expr = ^mkScopeApp;
}

aspect production dataConstraint
top::Constraint ::= name::String d::String
{
  local ref::AG_Expr = if contains(name, top.nonAttrs) then nameExpr(name)
                                                       else topDotExpr(name);
  local lhs::AG_LHS = if contains(d, top.nonAttrs) then nameLHS(d)
                                                   else topDotLHS(d);
  local dmdExpr::AG_Expr = demandExpr(^ref, "datum");
  top.equations = [ defineEq (^lhs, ^dmdExpr) ];
  top.ag_expr = ^dmdExpr;
}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{
  local ref::AG_Expr = if contains(tgt, top.nonAttrs) then nameExpr(tgt)
                                                      else topDotExpr(tgt);
  top.equations = [
    contributionEq(topDotLHS(src ++ "_" ++ lab.labelName.fromJust),
                   consExpr(^ref, nilExpr()))
  ];
  top.ag_expr = error("edgeConstraint.ag_expr");
}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{
  local ref::AG_Expr = if contains(src, top.nonAttrs) then nameExpr(src)
                                                      else topDotExpr(src);
  local lhs::AG_LHS = if contains(res, top.nonAttrs) then nameLHS(res)
                                                     else topDotLHS(res);
  local queryApp::AG_Expr = appExpr("query", [^ref, r.ag_expr]);
  top.equations = [ defineEq (^lhs, ^queryApp) ];
  top.ag_expr = ^queryApp;
}

aspect production oneConstraint
top::Constraint ::= name::String out::String
{
  local nameRef::AG_Expr = if contains(name, top.nonAttrs) then nameExpr(name)
                                                           else topDotExpr(name);
  local outLHS::AG_LHS = if contains(out, top.nonAttrs) then nameLHS(out)
                                                        else topDotLHS(out);
  local oneApp::AG_Expr = appExpr("one", [^nameRef]);
  top.equations = [ defineEq (^outLHS, ^oneApp) ];
  top.ag_expr = ^oneApp;
}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{
  local nameRef::AG_Expr = if contains(name, top.nonAttrs) then nameExpr(name)
                                                           else topDotExpr(name);
  local inhabitedExpr::AG_Expr = appExpr("inhabited", [^nameRef]);
  top.equations = [ contributionEq (topDotLHS("ok"), ^inhabitedExpr) ];
  top.ag_expr = ^inhabitedExpr;
}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{
  local setExpr::AG_Expr = if contains(set, top.nonAttrs) then nameExpr(set)
                                                          else topDotExpr(set);
  local resLHS::AG_LHS = if contains(res, top.nonAttrs) then nameLHS(res)
                                                        else topDotLHS(res);

  local minApp::AG_Expr = appExpr ("path_min", [pc.ag_expr, ^setExpr]);
  top.equations = [ defineEq (^resLHS, ^minApp) ];
  top.ag_expr = ^minApp;
}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{
  local nameRef::AG_Expr = if contains(name, top.nonAttrs) then nameExpr(name)
                                                           else topDotExpr(name);
  local everyApp::AG_Expr = appExpr ("every", [lam.ag_expr, ^nameRef]);
  top.equations = [ contributionEq (topDotLHS("ok"), ^everyApp) ];
  top.ag_expr = ^everyApp;
}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{
  local setExpr::AG_Expr = if contains(set, top.nonAttrs) then nameExpr(set)
                                                          else topDotExpr(set);
  local resLHS::AG_LHS = if contains(res, top.nonAttrs) then nameLHS(res)
                                                        else topDotLHS(res);

  top.equations = [ defineEq (^resLHS, ^filterApp) ];
  top.ag_expr = ^filterApp;

  local filterApp::AG_Expr = appExpr ("path_filter", [^filterfun, ^setExpr]);

  local filterfun::AG_Expr = 
    lambdaExpr([("d_lam_arg", nameTypeAG("datum"))],
      caseExpr(
        nameExpr("d_lam_arg"),
        agCasesCons(
          agCase(m.ag_pattern_and_where.1, nilWhereClauseAG(), m.ag_pattern_and_where.2),
          agCasesOne (
            agCase(agPatternUnderscore(), nilWhereClauseAG(), falseExpr())
          )
        )
      )
    );

}

aspect production defConstraint
top::Constraint ::= name::String t::Term
{
  local lhs::AG_LHS = if contains(name, top.nonAttrs) then nameLHS(name)
                                                      else topDotLHS(name);
  top.equations = [ defineEq (^lhs, t.ag_expr) ];
  top.ag_expr = t.ag_expr;
}

--------------------------------------------------

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{
  -- should be empty if an ok contribution, singleton otherwise
  local bsDefNames::[String] = foldr(union, [], bs.defsAllBranches);

  -- the name and type of the ag case return
  local nameTyRet::(String, AG_Type) = 
    case bsDefNames of
    | [n] -> let nameFromEnv::Maybe<(String, Type)> =
               lookupVar(n, top.nameTyDecls)
             in
               (n, nameFromEnv.fromJust.2.ag_type)
             end
    | []  -> ("ok", nameTypeAG("Boolean"))
    | _   -> error("matchConstraint.nameTyRet")
    end;
  
  local ag_match::AG_Expr = caseExpr (t.ag_expr, bs.ag_cases);

  top.equations = [
    if nameTyRet.1 == "ok"
    then contributionEq (topDotLHS(nameTyRet.1), ^ag_match)
    else defineEq (topDotLHS(nameTyRet.1), ^ag_match)
  ];

  top.ag_expr = ^ag_match;

  bs.matchExpr = t.ag_expr;
}

--------------------------------------------------

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{
  local predInfo::PredInfo = lookupPred(name, top.predsInh).fromJust;
  vs.idx = 0;

  local apply::Decorated StxApplication with {nonAttrs} = 
    case predInfo of
    | synPredInfo(_, _, _, _, _, _, _) -> 
        decorate appConstraintSyn(name, predInfo, vs, top.knownLabels) 
        with {nonAttrs = top.nonAttrs;}
    | funPredInfo(_, _, _, _, _, _)    -> 
        decorate appConstraintFun(name, predInfo, vs, top.knownLabels) 
        with {nonAttrs = top.nonAttrs;}
    end;

  top.equations = apply.equations;

  top.ag_expr = apply.ag_expr;
}

--------------------------------------------------

nonterminal StxApplication;

attribute equations occurs on StxApplication;
attribute ag_expr occurs on StxApplication;

attribute nonAttrs occurs on StxApplication;
propagate nonAttrs on StxApplication;

function argRefExpr
AG_Expr ::= nonAttrs::[String] name::String
{
  return if contains(name, nonAttrs) then nameExpr(name) 
                                     else topDotExpr(name);
}

abstract production appConstraintFun
top::StxApplication ::=
  name::String
  predInfo::Decorated PredInfo
  allArgs::Decorated RefNameList
  knownLabels::[Label]
{

  local uniquePairName::String = "pair_" ++ toString(genInt());

  -- [(argument variable given, argument position type)]
  local retNamesTys::[(String, String, Type)] =
    matchArgsWithParams(predInfo.syns, allArgs.names, 0);

  local argNamesTys::[(String, String, Type)] =
    matchArgsWithParams(predInfo.inhs, allArgs.names, 0);
  local argNamesOnly::[String] = map(fst, argNamesTys);

  local eqsAndExpr::([AG_Eq], AG_Expr) =
    let argEqs::(Integer, [AG_Eq]) = 
      foldr(tupleSectionDef(uniquePairName, false, knownLabels, _, _), (2, []), argNamesTys)
    in
    let retEqs::(Integer, [AG_Eq]) =
      foldr(tupleSectionDef(uniquePairName, true, knownLabels, _, _), (argEqs.1, []), retNamesTys)
    in
    let apply::AG_Expr = appExpr(name, map(argRefExpr(top.nonAttrs, _), argNamesOnly)) in
    (
      [
        localDeclEq (
          uniquePairName,
          if null(retNamesTys) 
            then nameTypeAG("Boolean")
            else tupleTypeAG (nameTypeAG("Boolean")::
                              map((.ag_type), map(\p::(String, String, Type) -> p.3, retNamesTys)))
        ),
        defineEq (
          topDotLHS(uniquePairName),
          apply
        ),
        contributionEq (
          topDotLHS("ok"),
          tupleSectionExpr(topDotExpr(uniquePairName), 1)
        )
      ] ++ argEqs.2 ++ retEqs.2,
      apply
    )
    end end end;

  top.equations = eqsAndExpr.1; 
  top.ag_expr   = eqsAndExpr.2;

}

abstract production appConstraintSyn
top::StxApplication ::=
  name::String
  predInfo::Decorated PredInfo
  allArgs::Decorated RefNameList with {idx}
  knownLabels::[Label]
{
  top.ag_expr = error("appConstraintSyn.ag_expr");

  -- term
  local synTermName::String =
    case predInfo of
    | synPredInfo(_, (_, _, pos), _, _, _, _ ,_) -> allArgs.nth(pos)
    | _ -> error("appConstraintSyn.synTermName")
    end;
  local termRef::AG_LHS   = nameLHS(synTermName);
  local termExpr::AG_Expr = nameExpr(synTermName);

  -- inherited attribute equations
  local argNamesTys::[(String, String, Type)] =
    matchArgsWithParams(predInfo.inhs, allArgs.names, 0);
  local inhEqs::[AG_Eq] =
    map(
      \arg::(String, String, Type) -> 
        defineEq(qualLHS(^termRef, arg.2), argRefExpr(top.nonAttrs, arg.1)), argNamesTys);

  -- synthesized attribute equations
  local retNamesTys::[(String, String, Type)] =
    matchArgsWithParams(predInfo.syns, allArgs.names, 0);
  local synEqs::[AG_Eq] =
    map(
      \arg::(String, String, Type) -> 
        defineEq(topDotLHS(arg.1), demandExpr(^termExpr, arg.2)), retNamesTys);

  local okContrib::AG_Eq = 
    contributionEq(topDotLHS("ok"), demandExpr(^termExpr, "ok"));

  -- edge contributions for scopes passed to the predicate
  local edgeContribEqs::[AG_Eq] =
    let scopeArgs::[(String, String, Type)] = -- info for all args that are scopes
      filter (
        \p::(String, String, Type) -> 
          case p.3 of | nameType("scope") -> true | _ -> false end,
        argNamesTys)
    in
      concat (map (
        (\p::(String, String, Type) ->
           map (
             \l::Label ->
               contributionEq(
                 topDotLHS(p.1 ++ "_" ++ l.name),
                 demandExpr(nameExpr(synTermName), p.2 ++ "_" ++ l.name)),
             knownLabels)),
        scopeArgs
      ))
    end;

  top.equations = ^okContrib :: (inhEqs ++ synEqs ++ edgeContribEqs);
}

--------------------------------------------------

-- returns list of pairs of (argument variable given, param name, argument position type)
function matchArgsWithParams
[(String, String, Type)] ::= 
  params::[(String, Type, Integer)] 
  args::[String]
  argIndex::Integer
{
  return
    case args of
      h::t when !null(params)-> 
        if argIndex == head(params).3
        then (h, head(params).1, head(params).2) :: matchArgsWithParams(tail(params), t, argIndex + 1)
        else matchArgsWithParams(params, t, argIndex + 1)
    | _ -> []
    end;
}

function tupleSectionDef
(Integer, [AG_Eq]) ::= 
  pairName::String
  isRet::Boolean
  knownLabels::[Label]
  item::(String, String, Type)
  acc::(Integer, [AG_Eq])
{
  local offset::Integer = 
    if isRet then 1
    else case item.3 of nameType("scope") -> length(tmpLabelSet) | _ -> 0 end;

  local nextIdx::Integer = acc.1 + offset;

  local tmpLabelSet::[Label] = knownLabels;

  local labelEqs::[AG_Eq] = 
    case item.3 of
      nameType("scope") when !isRet -> 
        foldr (
          (\lab::Label acc::(Integer, [AG_Eq]) ->
              (acc.1 - 1,
               contributionEq (
                 topDotLHS(item.1 ++ "_" ++ lab.name),
                 tupleSectionExpr(topDotExpr(pairName), acc.1)
               ) :: acc.2)
          ),
          (nextIdx - 1, []), tmpLabelSet
        ).2
    | _ -> []
    end;

  local retEq::[AG_Eq] = 
    if isRet
    then [
      defineEq(
        topDotLHS(item.1),
        tupleSectionExpr(topDotExpr(pairName), acc.1)
      )
    ]
    else [];

  return ( 
    nextIdx,
    (retEq ++ labelEqs) ++ acc.2
  );
}