grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute constraintTrans::String;
monoid attribute okNames::[String] with  [], ++;

attribute constraintTrans occurs on Constraint;

attribute okNames occurs on Constraint;
propagate okNames on Constraint;

monoid attribute localScopesSyn::[String] with [], ++ occurs on Constraint;
propagate localScopesSyn on Constraint;

inherited attribute localScopes::[String] occurs on Constraint;

monoid attribute edgeContributions::[(String, String, String)] with [], ++ occurs on Constraint;
propagate edgeContributions on Constraint;

propagate localScopes on Constraint;

monoid attribute lambdas::[String] with [], ++ occurs on Constraint;
propagate lambdas on Constraint;

-- non-locals that are defined within the constraint
monoid attribute definedNonLocals::[(String, TypeAnn)] with [], ++ occurs on Constraint;
propagate definedNonLocals on Constraint excluding existsConstraint;

attribute knownFuncPreds occurs on Constraint;
propagate knownFuncPreds on Constraint;

--------------------------------------------------

aspect production trueConstraint
top::Constraint ::=
{
  local okName::String = okNameGen();
  top.okNames <- [okName];

  top.constraintTrans = 
    "local " ++ okName ++ "::Boolean = true;";
}

aspect production falseConstraint
top::Constraint ::=
{
  local okName::String = okNameGen();
  top.okNames <- [okName];

  top.constraintTrans = 
    "local " ++ okName ++ "::Boolean = false;";
}

aspect production conjConstraint
top::Constraint ::= c1::Constraint c2::Constraint
{
  top.constraintTrans = c1.constraintTrans ++ c2.constraintTrans;
}

aspect production existsConstraint
top::Constraint ::= names::RefNameList c::Constraint
{
  -- ignoring RefNameList here
  top.constraintTrans = c.constraintTrans;
  top.definedNonLocals :=
    filter ((\p::(String, TypeAnn) -> !contains(p.1, names.refNamesList)), 
            c.definedNonLocals);
}

aspect production eqConstraint
top::Constraint ::= t1::Term t2::Term
{
  local okName::String = okNameGen();
  top.okNames <- [okName];

  top.constraintTrans = 
    "local " ++ okName ++ "::Boolean = " ++
      t1.termTrans ++ " == " ++ t2.termTrans ++ ";";
}

aspect production neqConstraint
top::Constraint ::= t1::Term t2::Term
{
  local okName::String = okNameGen();
  top.okNames <- [okName];

  top.constraintTrans = 
    "local " ++ okName ++ "::Boolean = " ++
      t1.termTrans ++ " != " ++ t2.termTrans ++ ";";
}

aspect production newConstraintDatum
top::Constraint ::= name::String t::Term
{
  top.constraintTrans = 
    "local " ++ name ++ "::Scope = mkScope();" ++
    name ++ ".datum = " ++ t.termTrans ++ ";";
  top.localScopesSyn <- [name];
  top.definedNonLocals <- [(name, nameType("scopeType"))];
}

aspect production newConstraint
top::Constraint ::= name::String
{
  top.constraintTrans = 
    "local " ++ name ++ "::Scope = mkScope();";
  top.localScopesSyn <- [name];
  top.definedNonLocals <- [(name, nameType("scopeType"))];
}

aspect production dataConstraint
top::Constraint ::= scope::String t::Term
{
  local dataSrc::String = if contains(scope, top.localScopes)
                          then scope
                          else "top." ++ scope;

  local tStr::String = case t of
                       | nameTerm(s) -> s
                       | _ -> error("unimplemented case for dataConstraint.tStr")
                       end;

  top.constraintTrans = 
    "local " ++ tStr ++ "::Datum = " ++ dataSrc ++ ".datum;";
  top.definedNonLocals <- [(tStr, nameType("datumType"))];
}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{
  local edgeSrc::String = if contains(src, top.localScopes)
                          then src
                          else "top." ++ lab.termTrans ++ src;

  top.constraintTrans = "";
  top.edgeContributions <- [(edgeSrc, lab.termTrans, tgt)];
}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{
  local querySrc::String = if contains(src, top.localScopes)
                           then src
                           else "top." ++ src;

  top.constraintTrans = 
    "local " ++ res ++ "::[Path] = " ++
    "query(" ++ querySrc ++ ", " ++ r.regexTrans ++ ");";
  top.definedNonLocals <- [(res, listType(nameType("pathType")))];
}

aspect production oneConstraint
top::Constraint ::= name::String out::String
{
  local okName::String = okNameGen();
  top.okNames <- [okName];

  local onlyName::String = "onlyRes_" ++ toString(genInt());

  top.constraintTrans = 
    "local " ++ onlyName ++ "::(Boolean, TODO) = " ++
      "if length(" ++ name ++ ") == 1 " ++
      "then (true, head(" ++ name ++ "))" ++
      "else (false, error(\"\"))" ++
    ";" ++
    "local " ++ okName ++ "::Boolean = " ++ onlyName ++ ".1;" ++
    "local " ++ out ++ "::TODO = " ++ onlyName ++ ".2;";
  top.definedNonLocals <- [(out, nameType("pathType"))]; -- TODO, can be other than path?
}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{
  local okName::String = okNameGen();
  top.okNames <- [okName];

  top.constraintTrans = 
    "local " ++ okName ++ "::Boolean = null(" ++ name ++ ");";
}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{
  top.constraintTrans =
    "local " ++ res ++ "::[Path] = " ++
      "minPaths(" ++ set ++ ", " ++ pc.pathCompTrans ++ ");";
  top.definedNonLocals <- [(res, listType(nameType("pathType")))];
}

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{
  -- TODO: lookup predicate by name, get back all return and arg types
  --   if in syntax predicate: make corresponding inh equations
  --   if in functn predicate: make corresponding function call

  -- lookup functional pred
  local funcPred::Maybe<(String, [(String, Boolean, TypeAnn)])> =
    let matching::[(String, [(String, Boolean, TypeAnn)])] =
      filter(\p::(String, [(String, Boolean, TypeAnn)]) -> p.1 == name,
             top.knownFuncPreds)
    in if null(matching) then nothing() else just(head(matching)) end;
  
  local funcArgTys::[(String, Boolean, TypeAnn)] =
    case funcPred of
    | just((fName, fArgs)) -> fArgs
    | nothing() -> []
    end;

  local funcRets::[(String, Boolean, TypeAnn)] = 
    filter ((\p::(String, Boolean, TypeAnn) -> !p.2), funcArgTys);
  local funcRetNamesTys::[(String, TypeAnn)] =
    map (\p::(String, Boolean, TypeAnn) -> (p.1, p.3), funcRets);
  local funcRetTys::[TypeAnn]  = map(snd, funcRetNamesTys);

  local funcActualArgs::[(String, Boolean, TypeAnn)] = 
    filter ((\p::(String, Boolean, TypeAnn) -> p.2), funcArgTys);
  local funcActualArgNames::[String] = map(fst, funcActualArgs);

  local retTyStr::String =
    if null(funcRetTys) 
    then "Boolean"
    else "(Boolean, " ++ implode(", ", map((.typeTrans), funcRetTys)) ++ ")";

  top.constraintTrans = 
    "local " ++ name ++ "_" ++ toString(genInt()) ++ "::" ++ retTyStr ++ " = " ++
      name ++ "(" ++ implode (", ", funcActualArgNames) ++ ")" ++ ";";
  top.definedNonLocals <- funcRetNamesTys;
}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{
  local okName::String = okNameGen();
  top.okNames <- [okName];

  local onlyName::String = "onlyRes_" ++ toString(genInt());

  top.constraintTrans = 
    "local " ++ okName ++ "::Boolean = " ++
      "every(" ++ name ++ ", " ++ lam.lambdaName ++ ");";

  top.lambdas <- [lam.lambdaTrans];
}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{
  top.constraintTrans = 
    "local " ++ res ++ "::[Path] = " ++
      "filterPaths(" ++ set ++ ", " ++ m.matcherTrans ++ ");";
  top.definedNonLocals <- [(res, listType(nameType("pathType")))];
}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{
  {- `local (Boolean, T1, T2, ...) = case t of ... end`
   - where `Boolean` is the `ok` return.
   - `T1`, `T2`, ... are the types of the names given definitions inside
   - of the branches.
   -}

  top.constraintTrans = error("matchConstraint.constraintTrans TODO");
  top.definedNonLocals <- []; -- TODO
}

aspect production defConstraint
top::Constraint ::= name::String ty::TypeAnn t::Term
{
  top.constraintTrans =
    "local " ++ name ++ "::" ++ ty.typeTrans ++ " = " ++ t.termTrans ++ ";";
  top.definedNonLocals <- [(name, ^ty)];
}

--------------------------------------------------