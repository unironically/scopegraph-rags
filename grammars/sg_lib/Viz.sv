grammar sg_lib;

--------------------------------------------------

synthesized attribute graphvizString::String occurs on Scope;

aspect production mkScope
top::Scope ::=
  lex::Maybe<Decorated Scope>
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
  datum::Maybe<Datum>
{

  local lexEdgeString::String =
    case lex of
    | just(s) -> edgeStyle("LEX", top, s)
    | _ -> ""
    end;

  local varEdgesString::String = concat(map(edgeStyle("VAR", top, _), top.varEdges));
  local modEdgesString::String = concat(map(edgeStyle("MOD", top, _), top.modEdges));
  local impEdgesString::String = concat(map(edgeStyle("IMP", top, _), top.impEdges));

  top.graphvizString = "{" ++ lexEdgeString ++ varEdgesString ++ modEdgesString ++ impEdgesString ++ "}\n";

}

--------------------------------------------------

function graphvizScopes
String ::= scopes::[Decorated Scope]
{
  return "digraph {\n" ++ implode ("\n", map (nodeStyle, scopes)) ++ "\n" ++ implode ("\n", map ((.graphvizString), scopes)) ++ "\n}\n";
}

function nodeStyle
String ::= s::Decorated Scope
{

  local datumString::String = 
    case s.datum of
    | just(d) -> d.str
    | _ -> "()"
    end;
  
  return "{ node [label=\"" ++ toString(s.id) ++ " ↦ " ++ datumString ++ "\" style=rounded shape=rect fontsize=12 margin=0 fillcolor=white] " ++ toString(s.id) ++ "}";
}

function edgeStyle
String ::= lab::String src::Decorated Scope tgt::Decorated Scope
{
  return "{edge [label=" ++ lab ++ "] " ++ toString(src.id) ++ "->" ++ toString(tgt.id) ++ "}";
}