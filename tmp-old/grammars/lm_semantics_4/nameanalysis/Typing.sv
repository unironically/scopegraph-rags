grammar lm_semantics_4:nameanalysis;

--------------------------------------------------

--------------------------------------------------

aspect production program
top::Main ::= ds::Decls
{
}

--------------------------------------------------

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
}

aspect production declsNil
top::Decls ::=
{
}

--------------------------------------------------

aspect production declModule
top::Decl ::= id::String ds::Decls
{
}

aspect production declImport
top::Decl ::= r::ModRef
{
}

aspect production declDef
top::Decl ::= b::ParBind
{
}

--------------------------------------------------

aspect production exprInt
top::Expr ::= i::Integer
{
  
}

aspect production exprTrue
top::Expr ::=
{
  
}

aspect production exprFalse
top::Expr ::=
{
  
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  
}


aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
}

--------------------------------------------------



aspect production seqBindsNil
top::SeqBinds ::=
{
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
}

--------------------------------------------------

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
}

--------------------------------------------------



aspect production parBindsNil
top::ParBinds ::=
{
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
}

--------------------------------------------------


aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
}

--------------------------------------------------



aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
}

--------------------------------------------------


aspect production tInt
top::Type ::=
{
}

aspect production tBool
top::Type ::=
{
}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
}

aspect production tErr
top::Type ::=
{
}

--------------------------------------------------



aspect production modRef
top::ModRef ::= x::String
{
}

--------------------------------------------------

aspect production varRef
top::VarRef ::= x::String
{
}