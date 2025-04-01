grammar statix_translate:to_silver;

--------------------------------------------------

fun topDotLHS  AG_LHS  ::= s::String = qualLHS(nameLHS("top"), s);
fun topDotExpr AG_Expr ::= s::String = qualExpr(nameExpr("top"), s);

synthesized attribute equations::[AG_Eq] occurs on Constraint;
synthesized attribute ag_expr::AG_Expr;
monoid attribute ag_decls::[AG_Decl] with [], ++;

--------------------------------------------------

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
      topDotLHS(src ++ "_" ++ lab.name),
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
  -- todo
  top.equations = [];
}

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{
  -- args that are in syn position for syn preds, or in ret position for funs
  local defs::[(String, TypeAnn)] = top.freeVarsDefined;

  local predInfo::PredInfo = lookupPred(name, top.predsInh).fromJust;

  top.equations = case predInfo of
                  | synPredInfo(_, _, _, _) -> 
                      appConstraintSyn(name, predInfo, vs).equations
                  | funPredInfo(_, _, _)    -> 
                      appConstraintFun(name, predInfo, vs).equations
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
{

  local uniquePairName::String = "pair_" ++ toString(genInt());

  -- [(argument variable given, argument position type)]
  local retNamesTys::[(String, TypeAnn)] = 
    matchArgsWithParams(predInfo.syns, allArgs.names, 0);

  local argNamesTys::[(String, TypeAnn)] =
    matchArgsWithParams(predInfo.inhs, allArgs.names, 0);
  local argNamesOnly::[String] = map(fst, argNamesTys);

  top.equations = [
    localDeclEq (
      uniquePairName,
      if null(retNamesTys) 
        then nameTypeAG("Boolean")
        else tupleTypeAG (nameTypeAG("Boolean")::
                          map((.ag_type), map(snd, retNamesTys)))
    ),
    defineEq (
      topDotLHS(uniquePairName),
      appExpr(name, map((topDotExpr(_)), argNamesOnly))
    ),
    contributionEq (
      topDotLHS("ok"),
      tupleSectionExpr(topDotExpr(uniquePairName), 1)
    )
  ] ++ foldr(tupleSectionDef(uniquePairName, false, _, _), (2, []), argNamesTys).2
    ++ foldr(tupleSectionDef(uniquePairName, true, _, _), (2, []), retNamesTys).2;

}

abstract production appConstraintSyn
top::StxApplication ::=
  name::String
  predInfo::Decorated PredInfo
  allArgs::Decorated RefNameList
{

  top.equations = []; -- todo

}

--------------------------------------------------

-- returns list of pairs of (argument variable given, argument position type)
function matchArgsWithParams
[(String, TypeAnn)] ::= 
  params::[(String, TypeAnn, Integer)] 
  args::[String]
  argIndex::Integer
{
  return
    case args of
      h::t when !null(params)-> 
        if argIndex == head(params).3
        then (h, head(params).2) :: matchArgsWithParams(tail(params), t, argIndex + 1)
        else matchArgsWithParams(params, t, argIndex + 1)
    | _ -> []
    end;
}

function tupleSectionDef
(Integer, [AG_Eq]) ::= 
  pairName::String
  isRet::Boolean
  item::(String, TypeAnn)
  acc::(Integer, [AG_Eq])
{
  local offset::Integer = 
    if isRet then 1
    else case item.2 of nameType("scope") -> length(tmpLabelSet) | _ -> 0 end;

  local nextIdx::Integer = acc.1 + offset;

  local tmpLabelSet::[Label] = [
    label("LEX"), label("VAR"), label("IMP"), label("MOD")
  ];

  local labelEqs::[AG_Eq] = 
    case item.2 of
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