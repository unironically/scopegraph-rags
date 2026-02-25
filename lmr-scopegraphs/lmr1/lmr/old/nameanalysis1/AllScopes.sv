grammar lmr1:lmr:nameanalysis1;

monoid attribute allScopes::[Decorated Scope] with [], ++;

attribute allScopes occurs on Main;

aspect production program
top::Main ::= ds::Decls
{ top.allScopes := globScope :: ds.allScopes; }

attribute allScopes occurs on Decls;
propagate allScopes on Decls excluding declsCons;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{ top.allScopes := seqScope :: (d.allScopes ++ ds.allScopes); }

attribute allScopes occurs on Decl;
propagate allScopes on Decl excluding declModule;

aspect production declModule
top::Decl ::= id::String ds::Decls
{ top.allScopes := modScope :: lookupScope :: ds.allScopes; }

attribute allScopes occurs on Expr;
propagate allScopes on Expr excluding exprFun, exprLet, exprLetRec, exprLetPar;

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
propagate allScopes on SeqBinds excluding seqBindsOne, seqBindsCons;

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{ top.allScopes := sbScope :: s.allScopes; }

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{ top.allScopes := sbScope :: (s.allScopes ++ ss.allScopes); }

attribute allScopes occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{ top.allScopes := varScope :: e.allScopes; }

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{ top.allScopes := varScope :: e.allScopes; }

attribute allScopes occurs on ParBinds;
propagate allScopes on ParBinds;

attribute allScopes occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{ top.allScopes := varScope :: e.allScopes; }

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{ top.allScopes := varScope :: e.allScopes; }

attribute allScopes occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{ top.allScopes := [ varScope ]; }