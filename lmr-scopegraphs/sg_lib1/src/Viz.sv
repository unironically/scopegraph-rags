grammar sg_lib1:src;

--------------------------------------------------

synthesized attribute graphvizString::String occurs on Scope;--, SGRef;

aspect production scope
top::Scope ::= datum::Datum
{
  local lexEdgesString::String = 
    concat(map(edgeStyle("LEX", "black", top, _), top.lex));
  local impEdgesString::String =
    concat(map(edgeStyle("IMP", "black", top, _), top.imp));
  local modEdgesString::String = 
    concat(map(edgeStyle("MOD", "black", top, _), top.mod));
  local varEdgesString::String = 
    concat(map(edgeStyle("VAR", "black", top, _), top.var));
  
  top.graphvizString = "{" ++ lexEdgesString ++ varEdgesString ++ 
                              modEdgesString ++ impEdgesString ++ "}\n";
}

--------------------------------------------------

function graphvizScopes
String ::= scopes::[Decorated Scope]
{
  return "digraph {layout=dot\n" ++ 
    implode("\n", map(nodeStyle, scopes)) ++ "\n" ++ 
    implode("\n", map((.graphvizString), scopes)) ++ "\n" ++
  "}\n";
}

function nodeStyle
String ::= s::Decorated Scope
{
  local datumString::String =
    case s.datum of
    | datumNone() -> "()"
    | d -> d.name
    end;
  
  return "{ node [label=\"" ++ toString(s.id) ++ " ↦ " ++ datumString ++ "\" style=rounded shape=rect fontsize=12 margin=0 fillcolor=white] " ++ toString(s.id) ++ "}";
}

function edgeStyle
String ::= lab::String col::String src::Decorated Scope tgt::Decorated Scope
{
  return "{edge [label=" ++ lab ++ " color=\"" ++ col ++ "\" " ++ 
    "fontcolor=\"" ++ col ++ "\"] " ++ 
    toString(src.id) ++ "->" ++ toString(tgt.id) ++ "}";
}