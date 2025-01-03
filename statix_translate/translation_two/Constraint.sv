grammar statix_translate:translation_two;

monoid attribute localScopeInstances::[LocalScopeInstance] with [], ++;
monoid attribute localScopeFlows::[(String, String)] with [], ++;
monoid attribute localScopeContribs::[(String, Label, String)] with [], ++;

--------------------------------------------------


attribute predicateEnv occurs on Constraint;
propagate predicateEnv on Constraint;

attribute predicateCalls occurs on Constraint;
propagate predicateCalls on Constraint;

-- all scope instances that are either defined locally or obtained from a child syn attr
-- lift these all to the predicate definition level
attribute localScopeInstances occurs on Constraint;
propagate localScopeInstances on Constraint;

-- to what children does each scope go in the enclosing prod
attribute localScopeFlows occurs on Constraint;
propagate localScopeFlows on Constraint;

-- contributions made to scopes within the enclosing prod
attribute localScopeContribs occurs on Constraint;
propagate localScopeContribs on Constraint;

--------------------------------------------------

aspect production trueConstraint
top::Constraint ::=
{}

aspect production falseConstraint
top::Constraint ::=
{}

aspect production conjConstraint
top::Constraint ::= c1::Constraint c2::Constraint
{}

aspect production existsConstraint
top::Constraint ::= names::NameList c::Constraint
{}

aspect production eqConstraint
top::Constraint ::= t1::Term t2::Term
{}

aspect production neqConstraint
top::Constraint ::= t1::Term t2::Term
{}

aspect production newConstraintDatum
top::Constraint ::= name::String t::Term
{
  -- locally defined scope instance
  -- todo: something with data term
  top.localScopeInstances <- [localScopeInstance(name, "LOCAL")];
}

aspect production newConstraint
top::Constraint ::= name::String
{
  -- locally defined scope instance
  top.localScopeInstances <- [localScopeInstance(name, "LOCAL")];
}

aspect production dataConstraint
top::Constraint ::= name::String t::Term
{}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{

  top.localScopeContribs <- 
    case lab of 
    | labelTerm(l) -> [(src, ^l, tgt)]
    | _ -> [] -- todo, allow parameterized label
    end;
}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{}

{- In mstx syntax, the `out` arg can be any term, but only a variable
 - name is used in examples. We make the restriction that it can only
 - be a variable name.
 -}
aspect production oneConstraint
top::Constraint ::= name::String out::String
{}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{}

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
    then filterMap((\at::AttrUse -> case at.2 of scopeType() -> just((at.3, ntUse.ref)) | _ -> nothing() end), ntUse.inhArgs)
    else [];
    
}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{}

aspect production defConstraint
top::Constraint ::= name::String ty::TypeAnn t::Term
{}

--------------------------------------------------