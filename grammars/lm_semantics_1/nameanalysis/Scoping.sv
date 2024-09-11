grammar lm_semantics_1:nameanalysis;

--------------------------------------------------

inherited attribute lexScope::Decorated SGScope;

synthesized attribute varDecls::[Decorated SGDecl];

monoid attribute binds::[(String, String)] with [], ++;

--------------------------------------------------

attribute binds occurs on Main;
propagate binds on Main;

aspect production program
top::Main ::= ds::Decls
{
  local glob::SGScope = mkScope(location=top.location);
  glob.lex = [];
  glob.imp = [];
  glob.mod = [];
  glob.var = ds.varDecls;

  ds.lexScope = glob;
}

--------------------------------------------------

attribute lexScope occurs on Decls;
attribute varDecls occurs on Decls;

attribute binds occurs on Decls;
propagate binds on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.lexScope = top.lexScope;
  ds.lexScope = top.lexScope;

  top.varDecls = d.varDecls ++ ds.varDecls;
}

aspect production declsNil
top::Decls ::=
{
  top.varDecls = [];
}

--------------------------------------------------

attribute lexScope occurs on Decl;
attribute varDecls occurs on Decl;

attribute binds occurs on Decl;
propagate binds on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{
  top.varDecls = b.varDecls;

  b.lexScope = top.lexScope;
}

--------------------------------------------------

attribute lexScope occurs on Expr;

attribute binds occurs on Expr;
propagate binds on Expr;

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
  r.lexScope = top.lexScope;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
  }

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
  e3.lexScope = top.lexScope;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local funScope::SGScope = mkScope(location=top.location);
  funScope.lex = [top.lexScope];
  funScope.imp = [];
  funScope.mod = [];
  funScope.var = d.varDecls;

  d.lexScope = funScope;
  e.lexScope = funScope;
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local letScope::SGScope = mkScope(location=top.location);
  letScope.lex = [bs.lastScope];
  letScope.imp = [];
  letScope.mod = [];
  letScope.var = bs.varDecls;

  bs.lexScope = top.lexScope;
  e.lexScope = letScope;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::SGScope = mkScope(location=top.location);
  letScope.lex = [top.lexScope];
  letScope.imp = [];
  letScope.mod = [];
  letScope.var = bs.varDecls;

  bs.lexScope = letScope;
  e.lexScope = letScope;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::SGScope = mkScope(location=top.location);
  letScope.lex = [top.lexScope];
  letScope.imp = [];
  letScope.mod = [];
  letScope.var = bs.varDecls;

  bs.lexScope = top.lexScope;
  e.lexScope = letScope;
}

--------------------------------------------------

attribute lexScope occurs on SeqBinds;

synthesized attribute lastScope::Decorated SGScope occurs on SeqBinds;

attribute varDecls occurs on SeqBinds;

attribute binds occurs on SeqBinds;
propagate binds on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.varDecls = [];
  top.lastScope = top.lexScope;
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  s.lexScope = top.lexScope;

  top.varDecls = s.varDecls;
  top.lastScope = top.lexScope;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local letBindScope::SGScope = mkScope(location=top.location);
  letBindScope.lex = [top.lexScope];
  letBindScope.imp = [];
  letBindScope.mod = [];
  letBindScope.var = s.varDecls;

  s.lexScope = top.lexScope;
  ss.lexScope = letBindScope;

  top.varDecls = ss.varDecls;
  top.lastScope = ss.lastScope;
}

--------------------------------------------------

attribute lexScope occurs on SeqBind;

attribute varDecls occurs on SeqBind;

attribute binds occurs on SeqBind;
propagate binds on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local s_var::SGScope = mkDeclVar(id, e.ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  e.lexScope = top.lexScope;

  top.varDecls = [s_var];
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local s_var::SGScope = mkDeclVar(id, ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  e.lexScope = top.lexScope;
  ty.lexScope = top.lexScope;

  top.varDecls = [s_var];
}

--------------------------------------------------

attribute lexScope occurs on ParBinds;

attribute varDecls occurs on ParBinds;

attribute binds occurs on ParBinds;
propagate binds on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.varDecls = [];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.lexScope = top.lexScope;
  ss.lexScope = top.lexScope;

  top.varDecls = s.varDecls ++ ss.varDecls;
}

--------------------------------------------------

attribute lexScope occurs on ParBind;

attribute varDecls occurs on ParBind;

attribute binds occurs on ParBind;
propagate binds on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local s_var::SGScope = mkDeclVar(id, e.ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  top.varDecls = [s_var];

  e.lexScope = top.lexScope;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local s_var::SGScope = mkDeclVar(id, ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  top.varDecls = [s_var];

  e.lexScope = top.lexScope;
}

--------------------------------------------------

attribute lexScope occurs on ArgDecl;

attribute varDecls occurs on ArgDecl;

attribute binds occurs on ArgDecl;
propagate binds on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local s_var::SGScope = mkDeclVar(id, ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  ty.lexScope = top.lexScope;

  top.varDecls = [s_var];
}

--------------------------------------------------

attribute lexScope occurs on Type;

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
  tyann1.lexScope = top.lexScope;
  tyann2.lexScope = top.lexScope;
}

aspect production tErr
top::Type ::=
{

}

--------------------------------------------------

attribute lexScope occurs on VarRef;

attribute binds occurs on VarRef;

synthesized attribute resolution::[Decorated SGDecl] occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local r::SGRef = mkRefVar(x, location=top.location);
  r.lex = [top.lexScope];

  top.resolution = r.res;

  top.binds := 
    map ((\d::Decorated SGDecl -> (printRef(r), printDecl(d))), r.res);
}