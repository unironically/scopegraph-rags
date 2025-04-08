grammar statix_translate:to_silver;

--------------------------------------------------

fun topDotLHS  AG_LHS  ::= s::String = qualLHS(nameLHS("top"), s);
fun topDotExpr AG_Expr ::= s::String = qualExpr(nameExpr("top"), s);

synthesized attribute equations::[AG_Eq] occurs on Constraint;
synthesized attribute ag_expr::AG_Expr;
monoid attribute ag_decls::[AG_Decl] with [], ++;

--------------------------------------------------

attribute ag_decls occurs on Constraint;
propagate ag_decls on Constraint;

aspect production trueConstraint
top::Constraint ::=
{
  -- top.ok <- [true];
  top.equations = [
    contributionEq(
      topDotLHS("ok"), 
      trueExpr()
    )
  ];
}

aspect production falseConstraint
top::Constraint ::=
{
  -- top.ok <- [false];
  top.equations = [
    contributionEq(
      topDotLHS("ok"), 
      falseExpr()
    )
  ];
}

aspect production conjConstraint
top::Constraint ::= c1::Constraint c2::Constraint
{
  -- combination of equations from both
  top.equations = c1.equations ++ c2.equations;
}

aspect production existsConstraint
top::Constraint ::= names::NameList c::Constraint
{
  -- local n::ty; for all (n, ty) in names, then equations from body
  top.equations = names.localDeclEqs ++ c.equations;
}

aspect production eqConstraint
top::Constraint ::= t1::Term t2::Term
{
  -- top.ok <- t1 == t2; t1 and t2 must be ground
  top.equations = [
    contributionEq(
      topDotLHS("ok"), 
      eqExpr(t1.ag_expr, t2.ag_expr)
    )
  ];
}

aspect production neqConstraint
top::Constraint ::= t1::Term t2::Term
{
  -- top.ok <- t1 != t2; t1 and t2 must be ground
  top.equations = [
    contributionEq(
      topDotLHS("ok"), 
      neqExpr(t1.ag_expr, t2.ag_expr)
    )
  ];
}

aspect production newConstraintDatum
top::Constraint ::= name::String t::Term
{
  -- name = mkScope(t);
  top.equations = [
    defineEq (
      nameLHS(name),
      appExpr("mkScope", [t.ag_expr])
    )
  ];
}

aspect production newConstraint
top::Constraint ::= name::String
{
  -- name = mkScope();
  top.equations = [
    defineEq (
      nameLHS(name),
      appExpr("mkScope", [])
    )
  ];
}

aspect production dataConstraint
top::Constraint ::= name::String d::String
{
  -- t = name.datum;
  top.equations = [
    defineEq (
      topDotLHS(d),
      demandExpr(topDotLHS(name), "datum")
    )
  ];
}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{
  -- top.s_lab <- [tgt];
  top.equations = [
    contributionEq(
      topDotLHS(src ++ "_" ++ lab.termName),
      topDotExpr(tgt)
    )
  ];
}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{
  -- top.res = query(top.src, r);
  top.equations = [
    defineEq (
      topDotLHS(res),
      appExpr(
        "query",
        [topDotExpr(src), topDotExpr(r.dfa_name)]  -- todo, dfa defs need to flow up
      )
    )
  ];
}

aspect production oneConstraint
top::Constraint ::= name::String out::String
{
  -- top.out = one(top.name);
  top.equations = [
    defineEq (
      topDotLHS(out),
      appExpr(
        "one",
        [topDotExpr(name)]
      )
    )
  ];
}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{
  -- top.ok <- inhabited(top.name);
  top.equations = [
    contributionEq (
      topDotLHS("ok"),
      appExpr(
        "inhabited",
        [topDotExpr(name)]
      )
    )
  ];
}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{
  -- top.res = min(top.set, pc)
  top.equations = [
    defineEq (
      topDotLHS(res),
      appExpr (
        "min",
        [pc.ag_expr, topDotExpr(set)] -- todo, fun defs need to flow up, or pc is a lambda expr
      )
    )
  ];
}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{
  -- top.ok <- every(top.name, lam)
  top.equations = [
    contributionEq (
      topDotLHS("ok"),
      appExpr (
        "every",
        [lam.ag_expr, topDotExpr(name)]  -- todo, fun defs need to flow up
      )
    )
  ];
}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{
  -- top.res = filter(top.set, m)
  top.equations = [
    defineEq (
      topDotLHS(res),
      appExpr (
        "filter",
        [m.ag_expr, topDotExpr(set)]   -- todo, fun defs need to flow up
      )
    )
  ];
}

aspect production defConstraint
top::Constraint ::= name::String t::Term
{
  -- top.name = t
  top.equations = [
    defineEq (
      topDotLHS(name),
      t.ag_expr
    )
  ];
}

--------------------------------------------------

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{
  local defs::[String] = foldr(union, [], bs.defsAllBranches);  -- all external statix variables defined within the branches
  local defNamesTys::[(String, Type)] = filterMap(lookupVar(_, top.nameTyDecls), defs);
  local scopesExtended::[String] = top.requires;                -- all scopes for which we need to return a (possibly empty) edge tgt list
  local labs::[Label] = top.knownLabels;                        -- all known labels
  local labTys::[AG_Type] = map(\l::Label -> nameTypeAG("Label"), labs);

  local uniquePairName::String = "pair_" ++ toString(genInt());

  local pairType::AG_Type = 
    if null(scopesExtended ++ defs) 
          then nameTypeAG("Boolean")
          else tupleTypeAG (nameTypeAG("Boolean")::(
                            foldr(appendList, [],
                              map(\s::String -> labTys, scopesExtended)
                            ) ++
                            map((.ag_type), map(snd, defNamesTys))  -- var defs
                           ));

  local localDecl::AG_Eq = localDeclEq (uniquePairName, ^pairType);

  local define::AG_Eq = defineEq (
    topDotLHS(uniquePairName),
    caseExpr (
      t.ag_expr,
      bs.ag_cases
    )
  );

  -- todo: clean up!!!
  top.equations = [
    ^localDecl,
    ^define
  ] ++
  if null(scopesExtended ++ defs)
  then
    [contributionEq (topDotLHS("ok"), topDotExpr(uniquePairName))]
  else
    ([
      contributionEq (
        topDotLHS("ok"),
        tupleSectionExpr(topDotExpr(uniquePairName), 1)
      )
    ]++
    let labDefs::(Integer, [AG_Eq]) = -- labels tuple section
      foldr(
        (
          \scope::String acc::(Integer, [AG_Eq]) ->
            let forLabs::(Integer, [AG_Eq]) =
              foldr (
                (
                  \l::Label acc::(Integer, [AG_Eq]) ->
                    (acc.1 + 1, 
                    contributionEq (
                      topDotLHS(scope ++ "_" ++ l.name), 
                      tupleSectionExpr(topDotExpr(uniquePairName), acc.1)
                    )::acc.2)
                ),
                (acc.1, []),
                labs
              )
            in
              (acc.1 + forLabs.1, acc.2 ++ forLabs.2)
            end
        ),
        (2, []),
        scopesExtended
      )
    in
    let defDefs::(Integer, [AG_Eq]) = -- externals defined by tuple section
      foldr (
        (
          \def::(String, Type) acc::(Integer, [AG_Eq]) ->
            (acc.1 + 1, 
            defineEq (
              topDotLHS(def.1), 
              tupleSectionExpr(topDotExpr(uniquePairName), acc.1)
            )::acc.2)
        ),
        (labDefs.1, labDefs.2),
        defNamesTys
      )
    in
      defDefs.2
    end end);

}

--------------------------------------------------

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{
  -- args that are in syn position for syn preds, or in ret position for funs
  local defs::[(String, Type)] = top.freeVarsDefined;
  vs.idx = 0;

  local predInfo::PredInfo = lookupPred(name, top.predsInh).fromJust;

  top.equations = case predInfo of
                  | synPredInfo(_, _, _, _, _, _, _) -> 
                      appConstraintSyn(name, predInfo, vs, top.knownLabels).equations
                  | funPredInfo(_, _, _, _, _, _)    -> 
                      appConstraintFun(name, predInfo, vs, top.knownLabels).equations
                  end;
}

--------------------------------------------------

nonterminal StxApplication;

attribute equations occurs on StxApplication;

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

  top.equations =
    let argEqs::(Integer, [AG_Eq]) = 
      foldr(tupleSectionDef(uniquePairName, false, knownLabels, _, _), (2, []), argNamesTys)
    in
    let retEqs::(Integer, [AG_Eq]) =
      foldr(tupleSectionDef(uniquePairName, true, knownLabels, _, _), (argEqs.1, []), retNamesTys)
    in
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
        appExpr(name, map((topDotExpr(_)), argNamesOnly))
      ),
      contributionEq (
        topDotLHS("ok"),
        tupleSectionExpr(topDotExpr(uniquePairName), 1)
      )
    ] ++ argEqs.2 ++ retEqs.2
    end end;

}

abstract production appConstraintSyn
top::StxApplication ::=
  name::String
  predInfo::Decorated PredInfo
  allArgs::Decorated RefNameList with {idx}
  knownLabels::[Label]
{
  -- term
  local synTermName::String =
    case predInfo of
    | synPredInfo(_, (_, _, pos), _, _, _, _ ,_) -> allArgs.nth(pos)
    | _ -> error("appConstraintSyn")
    end;
  local termRef::AG_LHS   = nameLHS(synTermName);
  local termExpr::AG_Expr = nameExpr(synTermName);

  -- inherited attribute equations
  local argNamesTys::[(String, String, Type)] =
    matchArgsWithParams(predInfo.inhs, allArgs.names, 0);
  local inhEqs::[AG_Eq] =
    map(
      \arg::(String, String, Type) -> 
        defineEq(qualLHS(^termRef, arg.2), topDotExpr(arg.1)), argNamesTys);

  -- synthesized attribute equations
  local retNamesTys::[(String, String, Type)] =
    matchArgsWithParams(predInfo.syns, allArgs.names, 0);
  local synEqs::[AG_Eq] =
    map(
      \arg::(String, String, Type) -> 
        defineEq(topDotLHS(arg.1), qualExpr(^termExpr, arg.2)), retNamesTys);

  local okContrib::AG_Eq = 
    contributionEq(topDotLHS("ok"), qualExpr(^termExpr, "ok"));

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
                 qualExpr(nameExpr(synTermName), p.2 ++ "_" ++ l.name)),
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