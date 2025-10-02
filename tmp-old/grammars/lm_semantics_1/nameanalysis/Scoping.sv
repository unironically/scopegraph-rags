grammar lm_semantics_1:nameanalysis;

--------------------------------------------------

inherited attribute s::Decorated SGScope;

synthesized attribute vars::[Decorated SGDecl];

--------------------------------------------------

aspect production program
top::Main ::= ds::Decls
{
  local glob::SGScope = mkScope(location=top.location);
  glob.lex = [];
  glob.imp = [];
  glob.mod = [];
  glob.var = ds.vars;

  ds.s = glob;
}

--------------------------------------------------

attribute s occurs on Decls;
attribute vars occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.s = top.s;
  ds.s = top.s;

  top.vars = d.vars ++ ds.vars;
}

aspect production declsNil
top::Decls ::=
{
  top.vars = [];
}

--------------------------------------------------

attribute s occurs on Decl;
attribute vars occurs on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{
  b.s = top.s;

  top.vars = b.vars;
}

--------------------------------------------------

attribute s occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{}

aspect production exprTrue
top::Expr ::=
{}

aspect production exprFalse
top::Expr ::=
{}

aspect production exprVar
top::Expr ::= r::VarRef
{
  r.s = top.s;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  }

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  e3.s = top.s;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local funScope::SGScope = mkScope(location=top.location);
  funScope.lex = [top.s];
  funScope.imp = [];
  funScope.mod = [];
  funScope.var = d.vars;

  d.s = funScope;
  e.s = funScope;
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local letScope::SGScope = mkScope(location=top.location);
  letScope.lex = [bs.lastScope];
  letScope.imp = [];
  letScope.mod = [];
  letScope.var = bs.vars;

  bs.s = top.s;
  e.s = letScope;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::SGScope = mkScope(location=top.location);
  letScope.lex = [top.s];
  letScope.imp = [];
  letScope.mod = [];
  letScope.var = bs.vars;

  bs.s = letScope;
  e.s = letScope;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::SGScope = mkScope(location=top.location);
  letScope.lex = [top.s];
  letScope.imp = [];
  letScope.mod = [];
  letScope.var = bs.vars;

  bs.s = top.s;
  e.s = letScope;
}

--------------------------------------------------

attribute s occurs on SeqBinds;

synthesized attribute lastScope::Decorated SGScope occurs on SeqBinds;

attribute vars occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.vars = [];
  top.lastScope = top.s;
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  s.s = top.s;

  top.vars = s.vars;
  top.lastScope = top.s;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local letBindScope::SGScope = mkScope(location=top.location);
  letBindScope.lex = [top.s];
  letBindScope.imp = [];
  letBindScope.mod = [];
  letBindScope.var = s.vars;

  s.s = top.s;
  ss.s = letBindScope;

  top.vars = ss.vars;
  top.lastScope = ss.lastScope;
}

--------------------------------------------------

attribute s occurs on SeqBind;

attribute vars occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local s_var::SGDecl = mkDeclVar(id, e.ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  e.s = top.s;

  top.vars = [s_var];
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local s_var::SGDecl = mkDeclVar(id, ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  e.s = top.s;
  ty.s = top.s;

  top.vars = [s_var];
}

--------------------------------------------------

attribute s occurs on ParBinds;

attribute vars occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{ top.vars = []; }

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.s = top.s;
  ss.s = top.s;

  top.vars = s.vars ++ ss.vars;
}

--------------------------------------------------

attribute s occurs on ParBind;

attribute vars occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local s_var::SGDecl = mkDeclVar(id, e.ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  top.vars = [s_var];

  e.s = top.s;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local s_var::SGDecl = mkDeclVar(id, ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  top.vars = [s_var];

  e.s = top.s;
}

--------------------------------------------------

attribute s occurs on ArgDecl;

attribute vars occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local s_var::SGScope = mkDeclVar(id, ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  ty.s = top.s;

  top.vars = [s_var];
}

--------------------------------------------------

attribute s occurs on Type;

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  tyann1.s = top.s;
  tyann2.s = top.s;
}

aspect production tInt
top::Type ::=
{}

aspect production tBool
top::Type ::=
{}

aspect production tErr
top::Type ::=
{}

--------------------------------------------------

attribute s occurs on VarRef;

synthesized attribute resolution::[Decorated SGDecl] occurs on VarRef;
synthesized attribute ref::Decorated SGRef occurs on VarRef;

aspect production varRef
top::VarRef ::= name::String
{
  local r::SGRef = mkRefVar(name, location=top.location);
  r.lex = [top.s];

  top.ref = r;
  top.resolution = r.res;
}