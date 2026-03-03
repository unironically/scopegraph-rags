grammar lmr1:lmr:nameanalysis_extension;

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
top::Decl ::= m::Module
{
  
}

aspect production declImport
top::Decl ::= mr::ModRef
{
  
}

aspect production declDef
top::Decl ::= b::Bind
{
  
}

--------------------------------------------------

aspect production module
top::Module ::= x::String ds::Decls
{
  
}

--------------------------------------------------

aspect production exprFloat
top::Expr ::= f::Float
{
  
}

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

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  
}

aspect production exprFun
top::Expr ::= b::Bind e::Expr
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
