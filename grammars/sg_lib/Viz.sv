grammar sg_lib;

--------------------------------------------------

synthesized attribute graphvizString::String occurs on SGNode, SGRef;

aspect production mkNode
top::SGNode ::=
  datum::Maybe<SGDatum>
{
  local lexEdgesString::String = 
    concat(map(edgeStyle("LEX", "black", top, _), top.lex));
  local impEdgesString::String = --"";
    concat(map(edgeStyle("IMP", "green", top, _), top.imp));
  local modEdgesString::String = 
    concat(map(edgeStyle("MOD", "blue", top, _), top.mod));
  local varEdgesString::String = 
    concat(map(edgeStyle("VAR", "red", top, _), top.var));
  
  top.graphvizString = "{" ++ lexEdgesString ++ varEdgesString ++ modEdgesString ++ impEdgesString ++ "}\n";

}

aspect production mkRefVar
top::SGRef ::= name::String
{
  local lexEdgesString::String = 
    concat(map(refEdgeStyle("LEX", "gray", top, _), top.lex));

  top.graphvizString = "{" ++ lexEdgesString ++ "}\n";
}

aspect production mkRefMod
top::SGRef ::= name::String
{
  local lexEdgesString::String = 
    concat(map(refEdgeStyle("LEX", "gray", top, _), top.lex));

  top.graphvizString = "{" ++ lexEdgesString ++ "}\n";
}

--------------------------------------------------

function graphvizScopes
String ::= scopes::[Decorated SGNode] refs::[Decorated SGRef]
{
  return "digraph {layout=dot\n" ++ 
  
    implode("\n", map(nodeStyle, scopes)) ++ "\n" ++ 
    implode("\n", map(refStyle, refs)) ++ "\n" ++ 
    
    implode("\n", map((.graphvizString), scopes)) ++ "\n" ++
    implode("\n", map((.graphvizString), refs)) ++ "\n" ++
  
  "}\n";
}

function refStyle
String ::= r::Decorated SGRef
{
  local refStr::String = r.name ++ "_" ++ toString(r.location.line) ++ 
                                   "_" ++ toString(r.location.column);

  return "{ node [label=\"" ++ refStr ++ "\" shape=rect " ++ 
         "fontsize=12 margin=0 color=gray fillcolor=white] " ++ 
         toString(r.id) ++ "}";
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
String ::= lab::String col::String src::Decorated SGNode tgt::Decorated SGNode
{
  return "{edge [label=" ++ lab ++ " color=\"" ++ col ++ "\" " ++ 
    "fontcolor=\"" ++ col ++ "\"] " ++ 
    toString(src.id) ++ "->" ++ toString(tgt.id) ++ "}";
}

function refEdgeStyle
String ::= lab::String col::String src::Decorated SGRef tgt::Decorated SGNode
{
  return "{edge [label=" ++ lab ++ " color=\"" ++ col ++ "\" " ++ 
    "fontcolor=\"" ++ col ++ "\"] " ++ 
    toString(src.id) ++ "->" ++ toString(tgt.id) ++ "}";
}