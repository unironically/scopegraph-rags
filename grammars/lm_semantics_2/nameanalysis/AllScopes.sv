grammar lm_semantics_2:nameanalysis;

monoid attribute allScopes::[Decorated SGScope] with [], ++;

attribute allScopes occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  top.allScopes := ds.s :: ds.allScopes;
}


attribute allScopes occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{ top.allScopes := d.sLookup::(d.allScopes ++ ds.allScopes); }

aspect production declsNil
top::Decls ::=
{ top.allScopes := []; }


attribute allScopes occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{ top.allScopes := head(top.mods)::ds.allScopes; }

aspect production declImport
top::Decl ::= r::ModRef
{ top.allScopes := []; }

aspect production declDef
top::Decl ::= b::ParBind
{ top.allScopes := b.allScopes; }


attribute allScopes occurs on Expr;
propagate allScopes on Expr excluding exprFun, exprLet, exprLetRec, exprLetPar;

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{ top.allScopes := e.s :: (d.allScopes ++ e.allScopes); }

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{ top.allScopes := e.s :: (bs.allScopes ++ e.allScopes); }

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{ top.allScopes := e.s :: (bs.allScopes ++ e.allScopes); }

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{ top.allScopes := e.s :: (bs.allScopes ++ e.allScopes); }

attribute allScopes occurs on SeqBinds;
propagate allScopes on SeqBinds excluding seqBindsCons;

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{ top.allScopes := ss.s :: (s.allScopes ++ ss.allScopes); }


attribute allScopes occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{ top.allScopes := top.vars ++ e.allScopes; }

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{ top.allScopes := top.vars ++ e.allScopes; }


attribute allScopes occurs on ParBinds;
propagate allScopes on ParBinds;

attribute allScopes occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{ top.allScopes := top.vars ++ e.allScopes; }

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{ top.allScopes := top.vars ++ e.allScopes; }


attribute allScopes occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{ top.allScopes := top.vars; }

--------------------------------------------------

monoid attribute allRefs::[Decorated SGRef] with [], ++;

attribute allRefs occurs on Main, Decls, Decl, SeqBinds, SeqBind, ParBinds,
                         ParBind, Expr, ArgDecl, VarRef, ModRef;

propagate allRefs on Main, Decls, Decl, SeqBinds, SeqBind, ParBinds, ParBind,
                  Expr, ArgDecl;

aspect production modRef
top::ModRef ::= name::String
{
  top.allRefs := [top.ref];
}

aspect production varRef
top::VarRef ::= name::String
{
  top.allRefs := [top.ref];
}