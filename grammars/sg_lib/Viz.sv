grammar sg_lib;

--------------------------------------------------

synthesized attribute graphvizString::String occurs on SGNode;

aspect production mkNode
top::SGNode ::=
  datum::Maybe<SGDatum>
{
  local lexEdgesString::String = 
    concat(map(edgeStyle("LEX", top, _), top.lex));
  local impEdgesString::String = "";
  --  concat(map(edgeStyle("IMP", top, _), top.imp));
  local modEdgesString::String = 
    concat(map(edgeStyle("MOD", top, _), top.mod));
  local varEdgesString::String = 
    concat(map(edgeStyle("VAR", top, _), top.var));
  
  top.graphvizString = "{" ++ lexEdgesString ++ varEdgesString ++ modEdgesString ++ impEdgesString ++ "}\n";

}

--------------------------------------------------

function graphvizScopes
String ::= scopes::[Decorated SGNode]
{
  return "digraph {layout=dot\n" ++ implode("\n", map(nodeStyle, scopes)) ++ "\n" ++ implode("\n", map((.graphvizString), scopes)) ++ "\n}\n";
}

function nodeStyle
String ::= s::Decorated SGNode
{

  local datumString::String =
    case s.datum of
    | just(d) -> d.name ++ "_" ++ 
        toString(d.location.line) ++ "_" ++ toString(d.location.column)
    | _ -> "()"
    end;
  
  return "{ node [label=\"" ++ toString(s.id) ++ " ↦ " ++ datumString ++ "\" style=rounded shape=rect fontsize=12 margin=0 fillcolor=white] " ++ toString(s.id) ++ "}";
}

function edgeStyle
String ::= lab::String src::Decorated SGNode tgt::Decorated SGNode
{
  return "{edge [label=" ++ lab ++ "] " ++ toString(src.id) ++ "->" ++ toString(tgt.id) ++ "}";
}