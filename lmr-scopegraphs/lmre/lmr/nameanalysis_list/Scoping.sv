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
{-aspect production declImp
top::Decl ::= x::String
{
  production attribute mods::[Decorated Scope] with ++;
  mods := top.scope.resolve(isName(x), impRx());

  local okLookup::Maybe<Decorated Scope> =
    case mods of
    | h::[] -> case h.datum of
               | datumMod(_) -> just(h)
               | _ -> nothing()
               end
    | _ -> nothing()
    end;

  top.ok := okLookup.isJust;
  top.synEdges := [ impEdge(okLookup.fromJust) ];
}-}

aspect production declImp
top::Decl ::= x::String
{
  production attribute mods::[Decorated Scope] with ++;
  mods := top.scope.resolve(isName(x), impRx());

  local okLookup::Maybe<Decorated Scope> =
    case mods of
    | h::[] -> case h.datum of
               | datumMod(_) -> just(h)
               | _ -> nothing()
               end
    | _ -> nothing()
    end;

  top.ok := okLookup.isJust;
  top.synEdges := [ impEdge(okLookup.fromJust) ];
}

--------------------------------------------------

aspect production varRef
top::VarRef ::= x::String
{
  vars <- top.scope.resolve(isName(x), newVarRx());
}