grammar statix_translate:translation;


--------------------------------------------------

fun genProduction
String ::=
    name::String
    ty::TypeAnn
    children::[(String, TypeAnn)]
    body::String =
  "abstract production " ++ name ++ 
  "\ntop::" ++ ty.typeTrans ++ " ::= " ++
    implode (" ", map ((\ch::(String, TypeAnn) -> ch.1 ++ "::" ++ ch.2.typeTrans), 
                       children)) ++
  "\n{\n" ++
    body ++
  "\n}\n";

---

function genScopeEquations
String ::=
  scopeInstances::[Decorated LocalScopeInstance]
  labelSet::[Label]
{
  return
    implode(
      " ", 
      map ((\si::Decorated LocalScopeInstance -> 
        genEdgeEquationsOneScope(si, labelSet)),
      filter ((\si::Decorated LocalScopeInstance -> si.scopeSource != "SYN" && si.scopeSource != "LOCAL-UNDEC"), 
              scopeInstances))); -- ignore SYN for now
}

function genEdgeEquationsOneScope
String ::=
  scopeInstance::Decorated LocalScopeInstance
  labelSet::[Label]
{
  local allLabelsTrans::[String] = 
    map ((\l::Label -> genEdgeEquationsOneScopeOneLabel(l, scopeInstance)), labelSet);

  return implode(" ", allLabelsTrans);
}

function genEdgeEquationsOneScopeOneLabel
String ::=
  label::Label
  scopeInstance::Decorated LocalScopeInstance
{
  local contribsForLabel::[String] = map (snd, filter((\con::(Label, String) -> 
    con.1.labelTrans == label.labelTrans), scopeInstance.localContribs)); -- equality of labels currently based on equal translation, but could be better
  
  return genEdgeEquationsOneScopeOneLabelString(contribsForLabel, ^label, scopeInstance);
}

function genEdgeEquationsOneScopeOneLabelString
String ::=
  localContribs::[String]
  label::Label
  scopeInstance::Decorated LocalScopeInstance
{

  local childContribs::String = 
    implode (" ++ ",
      map (   -- child id, attr id
        (\child::(String, String) -> 
          child.1 ++ "." ++ child.2 ++ "_" ++ label.labelTrans),
        scopeInstance.flowsToNodes
      ));

  local allContribs::String = 
    case localContribs, scopeInstance.flowsToNodes of
    | [], [] -> "[]"
    | [], _  -> childContribs
    | _, []  -> "[" ++ implode (", ", localContribs) ++ "]"
    | _, _   -> "[" ++ implode (", ", localContribs) ++ "] ++ " ++ childContribs
    end;

  return
    case scopeInstance.scopeSource of
    | "INH"   -> "top." ++ scopeInstance.name ++ "_" ++ label.labelTrans ++ " = " ++
                 allContribs ++ ";"
    | "LOCAL" -> scopeInstance.name ++ "." ++ label.labelTrans ++ " = " ++
                 allContribs ++ ";"
    | _       -> error("shouldn't have SYN in genEdgeEquationsOneScopeOneLabel")
    end;

}