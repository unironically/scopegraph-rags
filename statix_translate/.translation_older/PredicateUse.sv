grammar statix_translate:translation;


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
synthesized attribute synEqsPartial::(String ::= String);
synthesized attribute inhEqsPartial::(String ::= String);

nonterminal SyntaxPredUse with termName, synEqsPartial, inhEqsPartial;

production syntaxPredicateUse
top::SyntaxPredUse ::= name::String nt::SyntaxPred args::RefNameList
{
  local synsInhs::InhSynPairs = getSynsInhsFromCall(nt.attrs, args);
  local syns::[AttrUse] = synsInhs.1; -- syn attr uses, (attr name, value) list
  local inhs::[AttrUse] = synsInhs.2; -- inh attr uses, (attr name, value) list

  -- generate equations for giving syn attr values to local attr definitions
  top.synEqsPartial = attrEqs (
    \use::AttrUse -> genSynEq(name, use.1, use.2, use.3), syns);

  -- generate inherited attribute equations for a node
  top.inhEqsPartial = attrEqs (
    \use::AttrUse -> genInhEq(name, use.1, use.3), inhs);
}


--------------------------------------------------


{- Now for functional predicates
 -}

synthesized attribute translatedCall::String;
synthesized attribute okName::String;

nonterminal FunctionPredUse with translatedCall, okName;

production functionPredUse
top::FunctionPredUse ::= used::FunctionPred args::RefNameList
{
  local retName::String = used.name ++ "_" ++ toString(genInt());
  local okName::String = "ok_" ++ toString(genInt());

  local retsArgs::RetArgPairs = getRetsArgsForCall(used.params, args);
  local rets::[RetUse]  = retsArgs.1; -- (position, type, var)
  local args::[AttrUse] = retArgs.2;  -- (param name, type, var)

  local retTypeEqs::(String, String) = genPredReturn(retName, okName, rets);
  local retTrans::String = retTypeEqs.1; -- return type translation
  local retEqs::String   = retTypeEqs.2; -- retrun type equations

  local callExpr::String = genCallExpr(used.name, args);

  top.translatedCall = 
    "local " ++ retName ++ "::" ++ retTrans ++ " = " ++ callExpr ++ ";" ++ retEqs;

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
    uses::RefNameList =
  let helper::(InhSynPairs ::= NameList RefNameList InhSynPairs) =
    \decls::NameList uses::RefNameList acc::InhSynPairs ->
      case decls, uses, acc of
      
      | nameListNil(), nameListNil(), _ -> acc
      
      | nameListCons(nameSyn(sd, t), ds), refNameListCons(sr, rs), (inhs, syns) 
        -> getSynsInhsFromCall(ds, rs, (inhs, (sd, t, sr)::syns))
      
      | nameListCons(nameInh(sd, t), ds), refNameListCons(sr, rs), (inhs, syns) 
        -> getSynsInhsFromCall(ds, rs, ((sd, t, sr)::inhs, syns))
      
      | d::ds, r::rs, _ -> getSynsInhsFromCall(ds, rs, acc)
      
      | _, _, _ -> error("getSynsInhsFromCall: different size decl/ref lists")

      end
  in
    helper(decls, uses, ([], []))
  end;


{- Generate the partial equation for an attribute use
 -}
fun attrEqs
String ::=
    f::(String ::= AttrUse) uses::[AttrUse] =
  concat (map (f, uses));


{- Generate a synthesized equation -}
fun genSynEq
String ::= ref::String aName::String ty::Decorated TypeAnn var::String =
  "local " ++ var ++ "::" ++ ty.typeTrans ++ " = " ++ ref ++ "." ++ aName ++ ";";


{- Generate an inherited equation -}
fun genInhEq
String ::= ref::String aName::String var::String =
  ref ++ "." ++ aName ++ " = " ++ var ++ ";";


{- analog of getSynsInhsFromCall, but for function predicate uses
 - returns a pair (rets, args), where:
 -   rets is the list of returns with type and position in the end return value
 -   args is the list of actual arguments we need in the translated call
 -} 
fun getRetsArgsForCall
RetArgPairs ::=   
    decls::NameList 
    uses::RefNameList =
  let helper::(RetArgPairs ::= NameList RefNameList RetArgPairs) =
    \ds::NameList rs::RefNameList acc::RetArgPairs ->
      case ds, rs, acc of
      
      | nameListNil(), nameListNil(), _ -> acc
      
      | nameListCons(nameUntagged(sd, t), ds), refNameListCons(sr, rs), (rets, args) 
        -> getRetsArgsForCall(ds, rs, (rets, (sd, t, sr)::args))
      
      | nameListCons(nameRet(sd, t), ds), refNameListCons(sr, rs), (rets, args) 
        -> getRetsArgsForCall(ds, rs, ((sd, t, sr)::rets, args))
      
      | d::ds, r::rs, _ -> getRetsArgsForCall(ds, rs, acc)
      
      | _, _, _ -> error("getRetsArgsForCall: different size decl/ref lists")

      end
  in
    helper(decls, uses, ([], []))
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