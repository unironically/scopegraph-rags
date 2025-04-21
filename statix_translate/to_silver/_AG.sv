grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_ag::String occurs on AG;

aspect production ag
top::AG ::= 
  nts::AG_Decls
  globs::AG_Decls
  prods::AG_Decls
  funs::AG_Decls
  inhs::[(String, AG_Type)]
  syns::[(String, AG_Type)]
  labs::[Label]
{
  local builtinPlusFoundNts::AG_Decls = agDeclsCons (
    nonterminalDecl("Datum", [("data", nameTypeAG("actualData"))], []),
    agDeclsCons(
      nonterminalDecl("actualData", [], []),
      ^nts
    )
  );

  local funsWithEqInstances::AG_Decls = 
    appendAG_Decls(^funs, eqInstanceForNTs(^nts, ^prods));

  top.silver_ag = implode("\n\n", [
    silverInhAttrs(inhs),
    silverSynAttrs(syns),
    nts.silver_decls,
    globs.silver_decls,
    prods.silver_decls,
    funsWithEqInstances.silver_decls,
    labProds, labEq, labAttrs, labGlobs, labDemand
  ]);

  prods.knownNts = ^builtinPlusFoundNts;
  funsWithEqInstances.knownNts  = ^builtinPlusFoundNts;
  globs.knownNts = ^builtinPlusFoundNts;
  nts.knownNts   = ^builtinPlusFoundNts;

  local builtinPlusFoundProds::AG_Decls = agDeclsCons (
    productionDecl("End", pathTypeAG(), [("s", scopeTypeAG())], []),
    agDeclsCons(
      productionDecl("Edge", pathTypeAG(), [("s", scopeTypeAG()), ("l", labelTypeAG()), ("ps", pathTypeAG())], []),
      ^prods
    )
  );

  nts.knownProds = ^builtinPlusFoundProds;
  globs.knownProds = ^builtinPlusFoundProds;
  prods.knownProds = ^builtinPlusFoundProds;
  funsWithEqInstances.knownProds = ^builtinPlusFoundProds;

  
  -- global label information:
  local labelsStr::[String] = map(\l::Label -> case l of label(n) -> n end, labs);
  local labProds::String = genLabelProds(labelsStr);
  local labEq::String = genEqLabels(labelsStr);
  local labAttrs::String = genAttrLabels(labelsStr);
  local labGlobs::String = genGlobalLabelList(labelsStr);
  local labDemand::String = genDemandEdgesLabels(labelsStr);

}

--------------------------------------------------
-- generate label info

function labelsToString
[String] ::= labSet::[Label]
{ return map(\l::Label -> case l of label(n) -> n end, labSet); }

function genLabelProds
String ::= labSet::[String]
{
  return implode("\n", map(
    \l::String -> "abstract production pf_label" ++ l ++ " top::Label ::= {}",
    labSet
  ));
}

function genEqLabels
String ::= labSet::[String]
{
  return "function eqLabel Boolean ::= l1::Label l2::Label {" ++
    "return case (l1, l2) of " ++
    implode(" | ", 
      map(\l::String -> "(pf_label" ++ l ++ "(), pf_label" ++ l ++ "()) -> true",
          labSet) ++ ["(_, _) -> false"]  
    ) ++
    " end;" ++
  "}";
}

function genAttrLabels
String ::= labSet::[String]
{
  return implode("\n", 
    map(\l::String -> "inherited attribute " ++ l ++ "::[Decorated Scope] occurs on Scope;",
        labSet)
  );
}

function genGlobalLabelList
String ::= labSet::[String]
{
  return "global globalLabelList::[Label] = [" ++
    implode(", ", map(\l::String -> "pf_label" ++ l ++ "()", labSet)) ++
  "];";
}

function genDemandEdgesLabels
String ::= labSet::[String]
{
  return "function demandEdgesForLabel [Decorated Scope] ::= s::Decorated Scope l::Label {" ++
    "return case l of " ++
      implode(" | ", map(\l::String -> "pf_label" ++ l ++ "() -> s." ++ l, labSet)) ++
    " end;" ++
  "}";
}

--------------------------------------------------
-- generate eq instances

function eqInstanceForNTs
AG_Decls ::= nts::AG_Decls allProds::AG_Decls
{
  return
    case nts of
    | agDeclsNil()  -> agDeclsNil()
    | agDeclsOne(nonterminalDecl(n, _, _)) -> 
        let prods::AG_Decls = prodsForNt(nameTypeAG(n), ^allProds) in
          eqInstanceNt(nameTypeAG(n), prods)
        end
    | agDeclsCons(nonterminalDecl(n, _, _), t) ->
        let prods::AG_Decls = prodsForNt(nameTypeAG(n), ^allProds) in
          appendAG_Decls(eqInstanceNt(nameTypeAG(n), prods),
                         eqInstanceForNTs(^t, ^allProds))
        end
    | _ -> error("eqInstanceForNTs")
    end;
}

function appendAG_Decls
AG_Decls ::= l::AG_Decls r::AG_Decls
{
  return
    case l of
    | agDeclsNil()       -> ^r
    | agDeclsOne(d)      -> agDeclsCons(^d, ^r)
    | agDeclsCons(d, ds) -> agDeclsCons(^d, appendAG_Decls(^ds, ^r))
    end;
}

function prodsForNt
AG_Decls ::= nt::AG_Type prods::AG_Decls
{
  return
    case prods of
    | agDeclsNil()  -> agDeclsNil()
    | agDeclsOne(d) -> if matchingProd(^nt, ^d) then agDeclsOne(^d) else agDeclsNil()
    | agDeclsCons(h, t) -> if matchingProd(^nt, ^h) then agDeclsCons(^h, prodsForNt(^nt, ^t)) else prodsForNt(^nt, ^t)
    end;
}

function matchingProd
Boolean ::= nt::AG_Type prod::AG_Decl
{
  return case (nt, prod) of
         | (nameTypeAG(n), productionDecl(_, nameTypeAG(n_), _, _)) when n == n_ -> 
              unsafeTracePrint(true, "tyname: " ++ n ++ ", prodname: " ++ n_ ++ "\n")
         | (_, _) -> false
         end;
}

-- eq case for multiple productions
function eqTrueCases
AG_Cases ::= prods::AG_Decls funName::String
{
  return
    let defaultCase::AG_Case = 
      agCase (
        agPatternTuple([agPatternUnderscore(), agPatternUnderscore()]),
        nilWhereClauseAG(),
        falseExpr()
      )
    in
      case prods of
      | agDeclsNil()  -> agCasesOne(defaultCase)
      | agDeclsOne(d) -> agCasesCons(eqTrueCase(^d, funName), agCasesOne(defaultCase))
      | agDeclsCons(h, t) -> agCasesCons(eqTrueCase(^h, funName), eqTrueCases(^t, funName))
      end
    end;
}

-- eq instance for one nt
function eqInstanceNt
AG_Decls ::= nt::AG_Type prods::AG_Decls
{
  local funName::String = "eq_" ++ nt.silver_type;
  return agDeclsCons(
    functionDecl(
      funName, boolTypeAG(),
      [("l", ^nt), ("r", ^nt)], [
        returnEq(
          caseExpr(
            tupleExpr([nameExprUndec("l"), nameExprUndec("r")]),
            eqTrueCases(^prods, funName)
          )
        )
      ]
    ),
    agDeclsOne(
      eqInstanceDecl(
        ^nt,
        lambdaExpr([("l", ^nt), ("r", ^nt)],
          appExpr(funName, [nameExprUndec("l"), nameExprUndec("r")])
        )
      )
    )
  );
}

-- eq case for one production
function eqTrueCase
AG_Case ::= prod::AG_Decl funName::String
{
  return
    case prod of
    | productionDecl(n, t, args, _) ->
        let argsFirst::(Integer, [AG_Pattern]) = foldl(argOne, (0, []), args) in
        let argsSnd::(Integer, [AG_Pattern]) = foldl(argOne, (argsFirst.1, []), args) in
        let patsFst::[AG_Pattern] = argsFirst.2 in
        let patsSnd::[AG_Pattern] = argsSnd.2 in
        let appFst::AG_Pattern = agPatternApp(n, patsFst) in
        let appSnd::AG_Pattern = agPatternApp(n, patsSnd) in
          agCase (
            agPatternTuple([appFst, appSnd]),
            nilWhereClauseAG(),
            eqPairwiseArgs(patsFst, patsSnd, funName)
          )
        end end end end end end
    | _ -> error("eqTrueCase")
    end;

}

function argOne
(Integer, [AG_Pattern]) ::= acc::(Integer, [AG_Pattern]) pair::(String, AG_Type)
{
  return (acc.1 + 1, agPatternName(("arg_" ++ toString(acc.1))) :: acc.2);
}

function eqPairwiseArgs
AG_Expr ::= patsFst::[AG_Pattern] patsSnd::[AG_Pattern] funName::String
{
  return
    case (patsFst, patsSnd) of
    | ([], []) -> trueExpr()
    | (h1::t1, h2::t2) -> andExpr(
                            eqExpr(
                              nameExpr(h1.silver_pattern), 
                              nameExpr(h2.silver_pattern)
                            ), 
                            eqPairwiseArgs(t1, t2, funName)
                          )
    | (_, _) -> error("Unequal pattern list lengths in eqPairwiseArgs")
    end;
}

--------------------------------------------------

function lookupProd
AG_Decl ::= name::String prods::AG_Decls
{
  return
    case prods of
    | agDeclsNil() -> error("Could not find prod " ++ name ++ "!")
    | agDeclsCons(h, t) ->
        case h of
        | productionDecl(n, ty, args, body) when n == name -> ^h
        | _ -> lookupProd(name, ^t)
        end 
    end;
}

function silverInhAttrs
String ::= attrs::[(String, AG_Type)]
{
  return implode("\n", map((silverInhAttr(_)), attrs));
}

function silverInhAttr
String ::= attr::(String, AG_Type)
{
  return "inherited attribute " ++ attr.1 ++ "::" ++ attr.2.silver_type ++ ";";
}

function silverSynAttrs
String ::= attrs::[(String, AG_Type)]
{
  return implode("\n", map((silverSynAttr(_)), attrs));
}

function silverSynAttr
String ::= attr::(String, AG_Type)
{
  return "synthesized attribute " ++ attr.1 ++ "::" ++ attr.2.silver_type ++ ";";
}

function lookupNt
Maybe<AG_Decl> ::= name::String lst::AG_Decls
{
  return
    case lst of
    | agDeclsCons(h, t) -> 
        case h of
        | nonterminalDecl(n, _, _) -> if preNt ++ n == name || n == name
                                      then just(^h) 
                                      else lookupNt(name, ^t)
        | _ -> error("lookupNt")
        end
    | agDeclsNil() -> nothing()
    end;
}