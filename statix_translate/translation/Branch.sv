grammar statix_translate:translation;

--------------------------------------------------

attribute lambdas occurs on Branch;
propagate lambdas on Branch;

attribute definedNonLocals occurs on Branch;
propagate definedNonLocals on Branch;

attribute knownFuncPreds occurs on Branch;
propagate knownFuncPreds on Branch;

attribute knownNonterminals occurs on Branch;
propagate knownNonterminals on Branch;

synthesized attribute branchTrans::String occurs on Branch;

attribute namesInScope occurs on Branch;
propagate namesInScope on Branch;

-- name of the function for the branch
synthesized attribute branchFunName::String;

attribute isFunctionalPred occurs on Branch;
propagate isFunctionalPred on Branch;

attribute expRetTys occurs on Branch;

inherited attribute prodTy::Maybe<Decorated AGNont> occurs on Branch;

monoid attribute prods::[String] occurs on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{
  -- name for the production function for this branch
  local branchName::String = "branch_" ++ toString(genInt());
  
  top.branchTrans = 
    m.matcherTrans ++ " -> " ++
    if top.isFunctionalPred
    then branchName ++ "(" ++ implode(", ", map(fst, top.namesInScope ++ m.patternDefs)) ++ ")" -- call branch fun
    else c.constraintTrans;

  c.localScopes = c.localScopesSyn;

  local retTys::String =
    "(" ++
      implode(", ", map(\p::(String, TypeAnn) -> p.2.typeTrans, 
                        top.expRetTys)) ++
    ")";

  local retExprs::String = 
    "(" ++
      (if null(c.okNames) 
       then "true" 
       else implode("&&", c.okNames)) ++ -- "ok", 1st return val
      (if !null(tail(top.expRetTys))
       then ", " ++ implode(", ", map(fst, tail(top.expRetTys)))
       else "") ++
    ")";

  local args::String =
    implode (" ", map(\p::(String, TypeAnn) -> p.1 ++ "::" ++ p.2.typeTrans, 
                      top.namesInScope ++ m.patternDefs));

  local branchFun::String = 
    "function " ++ branchName ++ " " ++
      retTys ++ " ::= " ++ args ++
    "{" ++
      c.constraintTrans ++
      "return " ++ retExprs ++ ";" ++
    "}";

  top.lambdas <- if top.isFunctionalPred then [branchFun] else [];

  -- SYNTAX PRED BRANCH -----------------------
  
  local prod::(String, [(String, TypeAnn)]) = m.prod.fromJust;
  local prodName::String = prod.1;

  local prodChildren::[String] =
    map ((\ch::(String, TypeAnn) -> ch.1 ++ "::" ++ ch.2.typeTrans), prod.2);
  local prodChildrenStr::String = implode(" ", prodChildren);

  local nont::Decorated AGNont = top.prodTy.fromJust;
  local synEqs::[String] = 
    map ((\syn::(String, Integer, TypeAnn) -> "top." ++ syn.1 ++ " = " ++ syn.1 ++ ";"),
         nont.syns);

  top.prods := [
    "production " ++ prodName ++ "\n" ++
    "top::" ++ nont.name ++ " ::= " ++ prodChildrenStr ++ "\n" ++
    "{" ++
      c.constraintTrans ++ "\n" ++
      implode("\n", synEqs) ++
    "\n}"
  ];

}

--------------------------------------------------

attribute lambdas occurs on BranchList;
propagate lambdas on BranchList;

attribute definedNonLocals occurs on BranchList;

attribute knownFuncPreds occurs on BranchList;
propagate knownFuncPreds on BranchList;

attribute knownNonterminals occurs on BranchList;
propagate knownNonterminals on BranchList;

synthesized attribute branchListTrans::[String] occurs on BranchList;

attribute namesInScope occurs on BranchList;
propagate namesInScope on BranchList;

inherited attribute isFunctionalPred::Boolean occurs on BranchList;
propagate isFunctionalPred on BranchList;

inherited attribute expRetTys::[(String, TypeAnn)] occurs on BranchList;
propagate expRetTys on BranchList;

attribute prods occurs on BranchList;
propagate prods on BranchList;

attribute prodTy occurs on BranchList;
propagate prodTy on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{
  top.branchListTrans = b.branchTrans :: bs.branchListTrans;
  top.definedNonLocals := 
    unionBy((\p1::(String, TypeAnn) p2::(String, TypeAnn) -> p1.1 == p2.1), 
            b.definedNonLocals, bs.definedNonLocals);
}

aspect production branchListOne
top::BranchList ::= b::Branch
{
  top.branchListTrans = [b.branchTrans];
  top.definedNonLocals := b.definedNonLocals;
}