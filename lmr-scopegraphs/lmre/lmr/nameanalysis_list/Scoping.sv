grammar lmre:lmr:nameanalysis_list;

exports lmrh:lmr:nameanalysis_list;

imports lmre:lmr:syntax;
imports sg_lib2:src;

--------------------------------------------------

--inherited attribute scope::Decorated Scope;
--monoid attribute synEdges::[Edge] with [], ++;

--synthesized attribute type::Type;
--monoid attribute ok::Boolean with true, &&;

--------------------------------------------------

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{}

aspect production declsNil
top::Decls ::=
{}

--------------------------------------------------

-- orphaned production, mwda turned off
aspect production declMod
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = scopeMod(id);
  modScope.edges = lexEdge(top.scope) :: ds.synEdges;

  ds.scope = modScope;

  top.synEdges := [ modEdge(modScope) ];

  top.ok := ds.ok;
}

-- orphaned production, mwda turned off
aspect production declImp
top::Decl ::= x::String
{
  local mods::[Decorated Scope] = top.scope.resolve(isName(x), impRx());

  local okAndModscope::(Boolean, Decorated Scope) =
    if length(mods) != 1
    then (false, error("Oh crap!"))
    else case head(mods).datum of
         | datumMod(_) -> (true, head(mods))
         | _ -> (false, error("Oh crap!"))
         end;

  top.ok := okAndModscope.1;

  top.synEdges := [ impEdge(okAndModscope.2) ];
}

--------------------------------------------------

aspect production varRef
top::VarRef ::= x::String
{
  vars <- top.scope.resolve(isName(x), newVarRx());
}