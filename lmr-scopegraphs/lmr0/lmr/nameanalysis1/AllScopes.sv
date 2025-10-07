grammar lmr0:lmr:nameanalysis1;

monoid attribute allScopes::[Decorated Scope] with [], ++;
monoid attribute allRefs::[(String, Decorated Scope)] with [], ++;

attribute allScopes occurs on Main;

attribute allRefs occurs on Main;
propagate allRefs on Main;

aspect production program
top::Main ::= ds::Decls
{ top.allScopes := globScope :: ds.allScopes; }

attribute allScopes occurs on Decls;
propagate allScopes on Decls;
attribute allRefs occurs on Decls;
propagate allRefs on Decls;

attribute allScopes occurs on Decl;
propagate allScopes on Decl;
attribute allRefs occurs on Decl;
propagate allRefs on Decl;

attribute allScopes occurs on Expr;
propagate allScopes on Expr excluding exprFun, exprLet, exprLetRec, exprLetPar;
attribute allRefs occurs on Expr;
propagate allRefs on Expr;

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{ top.allScopes := bodyScope :: (d.allScopes ++ e.allScopes); }

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{ top.allScopes := letScope :: (bs.allScopes ++ e.allScopes); }

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{ top.allScopes := letScope :: (bs.allScopes ++ e.allScopes); }

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{ top.allScopes := letScope :: (bs.allScopes ++ e.allScopes); }

attribute allScopes occurs on SeqBinds;
propagate allScopes on SeqBinds excluding seqBindsCons, seqBindsOne;
attribute allRefs occurs on SeqBinds;
propagate allRefs on SeqBinds;

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{ top.allScopes := sbScope :: s.allScopes; }

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{ top.allScopes := sbScope :: (s.allScopes ++ ss.allScopes); }

attribute allScopes occurs on SeqBind;
attribute allRefs occurs on SeqBind;
propagate allRefs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{ top.allScopes := varScope :: e.allScopes; }

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{ top.allScopes := varScope :: e.allScopes; }

attribute allScopes occurs on ParBinds;
propagate allScopes on ParBinds;
attribute allRefs occurs on ParBinds;
propagate allRefs on ParBinds;

attribute allScopes occurs on ParBind;
attribute allRefs occurs on ParBind;
propagate allRefs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{ top.allScopes := varScope :: e.allScopes; }

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{ top.allScopes := varScope :: e.allScopes; }

attribute allScopes occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{ top.allScopes := [varScope]; }

attribute allRefs occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{ top.allRefs := [(x, top.scope)]; }