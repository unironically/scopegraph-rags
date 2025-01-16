grammar statix_translate:translation_two;

monoid attribute localScopeInstances::[LocalScopeInstance] with [], ++;
monoid attribute localScopeFlows::[(String, (String, String))] with [], ++;
monoid attribute localScopeContribs::[(String, Label, String)] with [], ++;

synthesized attribute constraintTrans::String;

--------------------------------------------------


attribute predicateEnv occurs on Constraint;
propagate predicateEnv on Constraint;

attribute predicateCalls occurs on Constraint;
propagate predicateCalls on Constraint;

-- all scope instances that are either defined locally or obtained from a child syn attr
-- lift these all to the predicate definition level
attribute localScopeInstances occurs on Constraint;
propagate localScopeInstances on Constraint excluding existsConstraint;

-- to what children does each scope go in the enclosing prod
attribute localScopeFlows occurs on Constraint;
propagate localScopeFlows on Constraint;

-- contributions made to scopes within the enclosing prod
attribute localScopeContribs occurs on Constraint;
propagate localScopeContribs on Constraint;

attribute constraintTrans occurs on Constraint;

--------------------------------------------------

aspect production trueConstraint
top::Constraint ::=
{
  top.constraintTrans = "top.ok <- true;";
}

aspect production falseConstraint
top::Constraint ::=
{
  top.constraintTrans = "top.ok <- false;";
}

aspect production conjConstraint
top::Constraint ::= c1::Constraint c2::Constraint
{
  top.constraintTrans = c1.constraintTrans ++ c2.constraintTrans;
}

aspect production existsConstraint
top::Constraint ::= names::NameList c::Constraint
{
  local scopesInExists::[String] = names.scopeDefNames;

  top.localScopeInstances :=
    map ((\id::String -> localScopeInstance(id, "LOCAL")), scopesInExists) ++
    filter (
      (\ls::LocalScopeInstance -> contains(ls.name, scopesInExists)),
      c.localScopeInstances);

  top.constraintTrans = 
    concat (map (
      (\id::String -> "local " ++ id ++ "::Decorated Scope = " ++ id ++ "_UNDEC;"),  -- id_UNDEC must exist
      scopesInExists)) ++
    c.constraintTrans;
}

aspect production eqConstraint
top::Constraint ::= t1::Term t2::Term
{
  local eqName::String = "eq_" ++ toString(genInt());
  top.constraintTrans = 
    let 
      eqRes::EqUnifyResult = getTermFreeVars(^t1, ^t2, top.predicateEnv)
    in
    let
      eqResTyStrs::[String] = "Boolean"::map((\p::(String, TypeAnn) -> p.2.typeTrans), eqRes.eqVars)
    in
      "local " ++ eqName ++ "::(" ++ implode (", ", eqResTyStrs) ++ ") = " ++
        eqRes.eqTrans ++ ";" ++
      "top.ok <- " ++ (if null(eqRes.eqVars) then eqName else eqName ++ ".1") ++ ";" ++
      foldl (
        (
          \p::(Integer, String) var::(String, TypeAnn) ->
            (
              p.1 + 1,
              p.2 ++ 
              "local " ++ var.1 ++ "::" ++ var.2.typeTrans ++ " = " ++ eqName ++ "." ++ toString(p.1) ++ ";"
            )
        ),
        (2, ""),
        eqRes.eqVars
      ).2
    end end;
}

aspect production neqConstraint
top::Constraint ::= t1::Term t2::Term
{
  top.constraintTrans = ""; -- todo
}

aspect production newConstraintDatum
top::Constraint ::= name::String t::Term
{
  -- locally defined scope instance
  -- todo: something with data term
  top.localScopeInstances <- [localScopeInstance(name, "LOCAL-UNDEC")];
  top.constraintTrans = "local " ++ name ++ "_UNDEC::Scope = mkScope();"; -- todo: datum
}

aspect production newConstraint
top::Constraint ::= name::String
{
  -- locally defined scope instance
  top.localScopeInstances <- [localScopeInstance(name, "LOCAL-UNDEC")];
  top.constraintTrans = "local " ++ name ++ "_UNDEC::Scope = mkScope();";
}

aspect production dataConstraint
top::Constraint ::= name::String t::Term
{
  top.constraintTrans = ""; -- todo
}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{
  top.localScopeContribs <- 
    case lab of 
    | labelTerm(l) -> [(src, ^l, tgt)]
    | _ -> [] -- todo, allow parameterized label
    end;

  top.constraintTrans = "";
}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{
  top.constraintTrans = "local " ++ res ++ "::[Path] = query (" ++ src ++ ", REGEX TODO);"; -- todo: regex
}

{- In mstx syntax, the `out` arg can be any term, but only a variable
 - name is used in examples. We make the restriction that it can only
 - be a variable name.
 -}
aspect production oneConstraint
top::Constraint ::= name::String out::String
{
  top.constraintTrans = "local " ++ out ++ "::Path = only(" ++ name ++ ");";
}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{
  top.constraintTrans = "top.ok <- !null(" ++ name ++ ");";
}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{
  top.constraintTrans = "local " ++ res ++ "::[Path] = min (PATHCOMP TODO, " ++ set ++ ");"; 
}

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{

  -- lookup predicate
  local lookupRes::Maybe<PredicateEnvItem> = lookupEnv(name, top.predicateEnv);
  -- predicate referenced is either a syntax or functional predicate (or err)
  local isSyntaxPred::Boolean =
    case lookupRes of
    | just(either) -> either.isLeft
    | _ -> error("applyConstraint: lookupRes not found for '" ++ name ++ "' (todo)")
    end;
  -- if it is a syntax predicate
  local ntUse::SyntaxPredUse = syntaxPredicateUse(lookupRes.fromJust.fromLeft, ^vs);
  -- if is is a functional predicate
  local fnUse::FunctionPredUse = functionPredUse(lookupRes.fromJust.fromRight, ^vs);

  top.predicateCalls <- [
    if isSyntaxPred
    then name ++ " ::: " ++ ntUse.inhEqs ++ " ::: " ++ ntUse.synEqs
    else name ++ " ::: " ++ fnUse.translatedCall
  ];

  -- scope instances synthesized from pred
  -- todo: at the predicate level, if collision between name of INH and SYN localScope, keep the INH.
  top.localScopeInstances <- 
    if isSyntaxPred
    then map((\id::String -> localScopeInstance(id, "SYN")), lookupRes.fromJust.fromLeft.scopesSyn)
    else [];

  -- all (localScope, nodeRef) pairs where localScope is some name for a scope that is local to this pred, and nodeRef is the name of the child it flows to
  top.localScopeFlows <-
    if isSyntaxPred
    then filterMap(
          (\at::AttrUse -> case at.2 of 
                             scopeType() -> just((at.3, (ntUse.ref, at.1))) 
                           | _ -> nothing() 
                           end), 
          ntUse.inhArgs)
    else [];
    
  top.constraintTrans =
    if isSyntaxPred
    then ntUse.inhEqs ++ ntUse.synEqs
    else fnUse.translatedCall
  ;

}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{
  top.constraintTrans = ""; -- todo
}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{
  top.constraintTrans = ""; -- todo
}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{
  top.constraintTrans = ""; -- todo
}

aspect production defConstraint
top::Constraint ::= name::String ty::TypeAnn t::Term
{
  top.constraintTrans = "local " ++ name ++ "::" ++ ty.typeTrans ++ " = " ++ "TERM TRANS TODO;"; -- todo
}

--------------------------------------------------