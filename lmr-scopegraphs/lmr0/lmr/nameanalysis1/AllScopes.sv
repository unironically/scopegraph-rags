grammar lmr0:lmr:nameanalysis1;

monoid attribute allScopes::[Decorated Scope] with [], ++;

attribute allScopes occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  top.allScopes := ds.scope :: ds.allScopes;
}

attribute allScopes occurs on Decls;
propagate allScopes on Decls;

attribute allScopes occurs on Decl;
propagate allScopes on Decl;

attribute allScopes occurs on Expr;
propagate allScopes on Expr excluding exprFun, exprLet, exprLetRec, exprLetPar;

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{ top.allScopes := e.scope :: (d.allScopes ++ e.allScopes); }

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{ top.allScopes := e.scope :: (bs.allScopes ++ e.allScopes); }

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{ top.allScopes := e.scope :: (bs.allScopes ++ e.allScopes); }

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{ top.allScopes := e.scope :: (bs.allScopes ++ e.allScopes); }

attribute allScopes occurs on SeqBinds;
propagate allScopes on SeqBinds excluding seqBindsCons;

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{ top.allScopes := ss.scope :: (s.allScopes ++ ss.allScopes); }

attribute allScopes occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{ top.allScopes := top.VAR_s ++ e.allScopes; }

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{ top.allScopes := top.VAR_s ++ e.allScopes; }

attribute allScopes occurs on ParBinds;
propagate allScopes on ParBinds;

attribute allScopes occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{ top.allScopes := top.VAR_s ++ e.allScopes; }

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{ top.allScopes := top.VAR_s ++ e.allScopes; }

attribute allScopes occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{ top.allScopes := top.VAR_s; }