grammar sg_lib3:src;

--

synthesized attribute col::String occurs on Label<(i::InhSet)>;

aspect production label
top::Label<(i::InhSet)> ::=
{ top.col = "black"; }

--

fun vizStr String ::= labs::[Label<i>] scopes::[Decorated Scope with i] =
  "digraph {layout=dot\n" ++ 
    implode("\n", map(vizStrScope, scopes)) ++ "\n" ++
    implode("\n", concat(map(vizStrEdges(labs, _), scopes))) ++ "\n" ++
  "}\n"
;

--

fun vizStrScope String ::= scope::Decorated Scope with i =
  "{ node [label=\"" ++ vizStrScopeLabel(scope) ++ "\" " ++ 
    "style=rounded shape=rect fontsize=12 margin=0 fillcolor=white] " ++ 
    toString(scope.id) ++ 
  "}"
;

fun vizStrScopeLabel String ::= scope::Decorated Scope with i =
  case scope.datum of
  | datumNone()  -> toString(scope.id)
  | d -> toString(scope.id) ++ " ↦ " ++ d.name
  end
;

--

fun vizStrEdges [String] ::= labs::[Label<i>] scope::Decorated Scope with i =
  concat(map(
    \l::Label<i> ->
      map (vizStrEdge(l, scope, _), l.demand(scope)),
    labs
  ))
;

fun vizStrEdge String ::= lab::Label<i> src::Decorated Scope with i 
                                        tgt::Decorated Scope with i =
  "{edge [label=\"" ++ lab.name ++ "\" color=" ++ lab.col ++ 
                                     " fontcolor=" ++ lab.col ++ "] " ++ 
  toString(src.id) ++ " -> " ++ toString(tgt.id) ++ "}"
;