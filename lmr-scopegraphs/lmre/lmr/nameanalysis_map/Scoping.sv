grammar lmre:lmr:nameanalysis_map;

exports lmrh:lmr:nameanalysis_map;

imports lmre:lmr:syntax;

--------------------------------------------------

--inherited attribute scope::Decorated Scope;

-- monoid attribute synVar::[Decorated Scope] with [], ++;

--synthesized attribute type::Type;
--monoid attribute ok::Boolean with true, &&;

monoid attribute synMod::[Decorated Scope] with [], ++;
monoid attribute synImp::[Decorated Scope] with [], ++;

--------------------------------------------------

aspect production program
top::Main ::= ds::Decls
{
  globScope.edges <- 
    mapCons("MOD", ds.synMod,
    mapLast("IMP", ds.synImp));
}

--------------------------------------------------

attribute synMod, synImp occurs on Decls;
propagate synMod, synImp on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{}

aspect production declsNil
top::Decls ::=
{}

--------------------------------------------------

attribute synMod, synImp occurs on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{
  top.synMod := [];
  top.synImp := [];
}

-- orphaned production, but mwda turned off
aspect production declMod
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = scopeMod(id);
  modScope.edges := 
    mapCons("LEX", [top.scope], 
    mapCons("VAR", ds.synVar, 
    mapCons("MOD", ds.synMod, 
    mapLast("IMP", ds.synImp))));

  ds.scope = modScope;

  top.synVar := [];
  top.synMod := [ modScope ];
  top.synImp := [];

  top.ok := ds.ok;
}

-- orphaned production, mwda turned off
aspect production declImp
top::Decl ::= x::String
{
  local mods::[Decorated Scope] = resolve(isName(x), impRx(), top.scope);

  local modScope::Maybe<Decorated Scope> =
    case mods of
    | h::[] -> just(h)
    | _ -> nothing()
    end;

  top.synVar := [];
  top.synMod := [];
  top.synImp := if modScope.isJust then [modScope.fromJust] else [];

  top.ok := modScope.isJust;
}

--------------------------------------------------

aspect production varRef
top::VarRef ::= x::String
{
  vars <- resolve(isName(x), newVarRx(), top.scope);
}