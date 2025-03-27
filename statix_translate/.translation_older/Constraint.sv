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
propagate definedNonLocals on Constraint excluding existsConstraint, matchConstraint;

attribute knownFuncPreds occurs on Constraint;
propagate knownFuncPreds on Constraint;

attribute knownNonterminals occurs on Constraint;
propagate knownNonterminals on Constraint;

inherited attribute namesInScope::[(String, TypeAnn)] occurs on Constraint;
propagate namesInScope on Constraint excluding existsConstraint;

attribute isFunctionalPred occurs on Constraint;
propagate isFunctionalPred on Constraint excluding matchConstraint;

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
top::Constraint ::= names::NameList c::Constraint
{
  -- ignoring RefNameList here
  top.constraintTrans = c.constraintTrans;
  top.definedNonLocals :=
    filter ((\p::(String, TypeAnn) -> !contains(p.1, map(fst, names.nameListDefs))), 
            c.definedNonLocals);
  c.namesInScope = names.nameListDefs ++ top.namesInScope;
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

  local inpListElemsTy::TypeAnn = 
    let res::(String, TypeAnn) = head(filter((\p::(String, TypeAnn) -> p.1 == name), top.namesInScope)) in
      case res of
      | (s, listType(t)) -> ^t
      | _ -> error("Constraint.oneConstraint.inpListElemsTy expected a list type for " ++ name)
      end
    end;

  top.constraintTrans = 
    "local " ++ onlyName ++ "::(Boolean, " ++ inpListElemsTy.typeTrans ++ ") = " ++
      "if length(" ++ name ++ ") == 1 " ++
      "then (true, head(" ++ name ++ "))" ++
      "else (false, error(\"\"))" ++
    ";" ++
    "local " ++ okName ++ "::Boolean = " ++ onlyName ++ ".1;" ++
    "local " ++ out ++ "::" ++ inpListElemsTy.typeTrans ++ " = " ++ onlyName ++ ".2;";
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

  local funPredTrans::String = 
    "local " ++ name ++ "_" ++ toString(genInt()) ++ "::" ++ retTyStr ++ " = " ++
      name ++ "(" ++ implode (", ", funcActualArgNames) ++ ")" ++ ";";

  ----------------------------------------------------------------------------------

  -- nonterminal matching `name`
  local nont::Maybe<Decorated AGNont> =
    let matching::[Decorated AGNont] =
      filter(\nt::Decorated AGNont -> nt.name == upperFirstChar(name), top.knownNonterminals)
    in if null(matching) then nothing() else just(head(matching)) end;

  -- argument recognized as the syntactic term to the syntactic predicate
  local synTerm::String = head(drop(vs.size - nont.fromJust.termPos, vs.refNamesList));

  -- get arg list positions corresponding to inheriteds
  local inhAttrNums::[Integer] = map (compose(fst, snd), nont.fromJust.inhs);
  local inhAttrNames::[String] = map(fst, nont.fromJust.inhs);
  -- get all the args from the RefNameList that match those inh positions
  local inhArgs::[String] = vs.refNamesByPosition(inhAttrNums);
  -- match with attr names
  local inhAttrsArgs::[(String, String)] = zip(inhAttrNames, inhArgs);
  -- inh equations
  local inhEqs::[String] =
    map ((\p::(String, String) -> synTerm ++ "." ++ p.1 ++ " = " ++ p.2 ++ ";"),
         inhAttrsArgs);

  -- get arg list positions corresponding to inheriteds
  local synAttrNums::[Integer] = map (compose(fst, snd), nont.fromJust.syns);
  local synAttrTypes::[TypeAnn] = map (compose(snd, snd), nont.fromJust.syns);
  local synAttrNames::[String] = map(fst, nont.fromJust.syns);
  -- get all the args from the RefNameList that match those inh positions
  local synArgs::[String] = vs.refNamesByPosition(synAttrNums);
  -- match with attr names
  local synAttrsArgs::[(TypeAnn, (String, String))] = zip(synAttrTypes, zip(synAttrNames, synArgs));
  -- inh equations
  local synEqs::[String] =
    map ((\p::(TypeAnn, (String, String)) -> 
            "local " ++ snd(snd(p)) ++ "::" ++ p.1.typeTrans ++ " = " ++ synTerm ++ "." ++ fst(snd(p)) ++ ";"),
         synAttrsArgs);

  local syntaxPredTrans::String = concat(inhEqs) ++ concat(synEqs);

  ----------------------------------------------------------------------------------

  top.constraintTrans = if nont.isJust then syntaxPredTrans else funPredTrans;

  top.definedNonLocals <- if nont.isJust then [] else funcRetNamesTys; -- todo

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
  -- name of the match block
  local matchName::String = "match_" ++ toString(genInt());

  -- ok name
  local okName::String = okNameGen();
  top.okNames <- [okName];

  -- tell the branch list that it is a functional pred
  bs.isFunctionalPred = true;
  bs.expRetTys = retNamesTypes;
  bs.prodTy = nothing();

  -- types of the match results
  local retNamesTypes::[(String, TypeAnn)] = (okName, nameType("Boolean"))::bs.definedNonLocals;
  local retTypes::[TypeAnn] = map(snd, retNamesTypes);
  local retNames::[String]  = map(fst, retNamesTypes);
  local retTypeStr::String = "(" ++ implode(", ", retNames) ++ ")";

  -- translation
  top.constraintTrans = 
    "local " ++ matchName ++ "::" ++ retTypeStr ++ " = " ++
      "case " ++ t.termTrans ++ " of " ++
        implode("|", bs.branchListTrans) ++
      " end;" ++
    (foldl (
      (\acc::(String, Integer) p::(String, TypeAnn) ->
         (acc.1 ++ "local " ++ p.1 ++ "::" ++ p.2.typeTrans ++ " = " ++ 
           matchName ++ "." ++ toString(acc.2) ++ ";", acc.2 + 1)),
      ("", 1),
      retNamesTypes
    )).1;

  top.definedNonLocals := tail(retNamesTypes); -- don't want okName? (todo - verify)

}

aspect production defConstraint
top::Constraint ::= name::String ty::TypeAnn t::Term
{
  top.constraintTrans =
    "local " ++ name ++ "::" ++ ty.typeTrans ++ " = " ++ t.termTrans ++ ";";
  top.definedNonLocals <- [(name, ^ty)];
}

--------------------------------------------------