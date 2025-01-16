grammar statix_translate:translation_two;


{- Collecting uses of predicates within the bodies of others.
 - Aids in figuring out where variables go, so that we can generate the correct
 - inherited and synthesized attributes for syntax predicate uses.
 - Makes generating function calls for functional predicate uses cleaner.
 -}


--------------------------------------------------


{- First, we define a nonterminal for syntax predicate uses, and another for
 - functional predicate uses. Having these separated makes using attributes
 - cleaner.
 -}

-- give me a reference name and I will give a complete equation
synthesized attribute synEqs::String;
synthesized attribute inhEqs::String;
synthesized attribute okName::String;
synthesized attribute ref::String;

synthesized attribute inhArgs::[AttrUse];

nonterminal SyntaxPredUse with synEqs, inhEqs, okName, ref, inhArgs;

production syntaxPredicateUse
top::SyntaxPredUse ::= nt::SyntaxPred args::RefNameList
{
  local okName::String = "ok_" ++ toString(genInt());

  local ref::String = getNodeRef(nt.params, ^args); -- name of the node reference
  top.ref = ref;

  local synsInhs::InhSynPairs = getSynsInhsFromCall(nt.params, ^args, okName);
  local inhs::[AttrUse] = synsInhs.1; -- syn attr uses, (attr name, value) list
  local syns::[AttrUse] = synsInhs.2; -- inh attr uses, (attr name, value) list

  -- generate equations for giving syn attr values to local attr definitions
  top.synEqs = attrEqs (
    \use::AttrUse -> genSynEq(ref, use.1, use.2, use.3), syns);

  -- generate inherited attribute equations for a node
  top.inhEqs = attrEqs (
    \use::AttrUse -> genInhEq(ref, use.1, use.3), inhs);

  top.inhArgs = inhs;

  top.okName = okName;
}


--------------------------------------------------


{- Now for functional predicates
 -}

synthesized attribute translatedCall::String;

nonterminal FunctionPredUse with translatedCall, okName;

production functionPredUse
top::FunctionPredUse ::= used::FunctionPred args::RefNameList
{
  local okName::String = "ok_" ++ toString(genInt());
  local retName::String = used.name ++ "_" ++ toString(genInt());

  -- pair of lists of return position/type/var, and arg name/type/var
  local retArgs::RetArgPairs = getRetsArgsForCall(used.params, ^args, okName);
  
  local callRets::[RetUse]  = retArgs.1; -- (position, type, var)
  local callArgs::[AttrUse] = retArgs.2;  -- (param name, type, var)

  -- pair of return type and return to local equations
  local retTypeEqs::(String, String) = genPredReturn(retName, okName, callRets);

  local retTrans::String = retTypeEqs.1; -- return type translation
  local retEqs::String   = retTypeEqs.2; -- retrun type equations

  local callExpr::String = genCallExpr(used.name, callArgs);

  top.translatedCall = 
    "local " ++ retName ++ "::" ++ retTrans ++ " = " ++ 
      callExpr ++ ";" ++ 
    retEqs;

  top.okName = okName;
}


--------------------------------------------------


{- Utility functions -}


type AttrUse = (String, TypeAnn, String);
type InhSynPairs = ([AttrUse], [AttrUse]);
type RetUse = (Integer, TypeAnn, String);
type RetArgPairs = ([RetUse], [AttrUse]);

{- returns a pair (inhs, syns), where:
 -   inhs is a list of pairs of inherited attr names and attr arguments
 -   syns is the same for the synthesized attrs
 -} 
fun getSynsInhsFromCall
InhSynPairs ::= 
    decls::NameList 
    uses::RefNameList
    okName::String =
  getSynsInhsFromCallHelper(
    nameListCons(nameRet("ok", nameType("boolean")), decls),
    refNameListCons(okName, uses),
    ([], [])
  );

fun getSynsInhsFromCallHelper
InhSynPairs ::= ds::NameList rs::RefNameList acc::InhSynPairs =
  case ds, rs, acc of
  
  | nameListNil(), refNameListNil(), _ -> acc
  
  | nameListCons(nameSyn(sd, t), ds), refNameListCons(sr, rs), (inhs, syns) 
    -> getSynsInhsFromCallHelper(^ds, ^rs, (inhs, (sd, ^t, sr)::syns))
  
  | nameListCons(nameInh(sd, t), ds), refNameListCons(sr, rs), (inhs, syns) 
    -> getSynsInhsFromCallHelper(^ds, ^rs, ((sd, ^t, sr)::inhs, syns))
  
  | nameListCons(_, ds), refNameListCons(_, rs), _ 
    -> getSynsInhsFromCallHelper(^ds, ^rs, acc)
  
  | _, _, _ -> error("getSynsInhsFromCallHelper: different size decl/ref lists")
  end;


{- Generate the partial equation for an attribute use
 -}
fun attrEqs
String ::=
    f::(String ::= AttrUse) uses::[AttrUse] =
  concat (map (f, uses));


{- Generate a synthesized equation -}
fun genSynEq
String ::= ref::String aName::String ty::TypeAnn var::String =
  let 
    varTrans::String = case ty of scopeType() -> var ++ "_UNDEC" | _ -> var end
  in
  let
    aNameTrans::String = case ty of scopeType() -> aName ++ "_UNDEC" | _ -> aName end
  in
    "local " ++ varTrans ++ "::" ++ ty.typeTrans ++ " = " ++ ref ++ "." ++ aNameTrans ++ ";"
  end end;


{- Generate an inherited equation -}
fun genInhEq
String ::= ref::String aName::String var::String =
  ref ++ "." ++ aName ++ " = " ++ var ++ ";";


fun getNodeRef
String ::= ds::NameList rs::RefNameList =
  case ds, rs of
  | nameListNil(), refNameListNil() -> "ERRNAME"
  | nameListCons(nameUntagged(_, _), _), refNameListCons(sr, _) -> sr
  | nameListCons(_, ds), refNameListCons(_, rs) -> getNodeRef(^ds, ^rs)
  | _, _ -> error("getNodeRef: different size decl/ref lists")
  end;



{- analog of getSynsInhsFromCall, but for function predicate uses
 - returns a pair (rets, args), where:
 -   rets is the list of returns with type and position in the end return value
 -   args is the list of actual arguments we need in the translated call
 -} 
fun getRetsArgsForCall
RetArgPairs ::=   
    decls::NameList 
    uses::RefNameList
    okName::String =
  getRetsArgsForCallHelper(decls, uses, ([], []), 2);

fun getRetsArgsForCallHelper
RetArgPairs ::= ds::NameList rs::RefNameList acc::RetArgPairs pos::Integer =
  case ds, rs, acc of
  | nameListNil(), refNameListNil(), _ -> acc
  | nameListCons(nameUntagged(sd, t), ds), refNameListCons(sr, rs), (rets, args) 
    -> getRetsArgsForCallHelper(^ds, ^rs, (rets, (sd, ^t, sr)::args), pos)
  | nameListCons(nameRet(sd, t), ds), refNameListCons(sr, rs), (rets, args) 
    -> getRetsArgsForCallHelper(^ds, ^rs, ((pos, ^t, sr)::rets, args), pos + 1)
  | nameListCons(_, ds), refNameListCons(_, rs), _ 
    -> getRetsArgsForCallHelper(^ds, ^rs, acc, pos)
  | _, _, _ -> error("getRetsArgsForCallHelper: different size decl/ref lists")
  end;



{- Generate the correct return type and return eqs for a function predicate use -}
fun genPredReturn (String, String) ::= retValName::String okName::String rets::[RetUse] =
  if null(rets) 
  then ("Boolean", "local " ++ okName ++ "::Boolean = " ++ retValName ++ ";")
  else 
    let retsWithOk::[RetUse] =
      (1, nameType("boolean"), okName)::rets
    in
      (

        "(" ++ 
          implode (",",
            map ((\use::RetUse -> use.2.typeTrans), retsWithOk)) ++ 
        ")",

        implode ("",
          map (
            (\use::RetUse -> 
               "local " ++ use.3 ++ "::" ++ use.2.typeTrans ++ " = " ++ 
                 retValName ++ "." ++ toString(use.1) ++ ";"), 
            retsWithOk))

      )
    end;

fun genCallExpr String ::= funName::String args::[AttrUse] =
  funName ++ "(" ++ 
    implode (",", map ((\use::AttrUse -> use.3), args)) ++
  ")";