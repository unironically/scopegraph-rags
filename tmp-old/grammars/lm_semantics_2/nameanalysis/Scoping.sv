grammar lm_semantics_2:nameanalysis;

--------------------------------------------------

inherited attribute s::Decorated SGScope;
inherited attribute sLookup::Decorated SGScope;

synthesized attribute vars::[Decorated SGScope];
synthesized attribute mods::[Decorated SGScope];
synthesized attribute imps::[Decorated SGScope];

--------------------------------------------------

aspect production program
top::Main ::= ds::Decls
{
  local glob::SGScope = mkScope(location=top.location);
  glob.lex = [];
  glob.imp = [];
  glob.mod = ds.mods;
  glob.var = ds.vars;

  ds.s = glob;
}

--------------------------------------------------

attribute s occurs on Decls;
attribute vars occurs on Decls;
attribute mods occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local s_next::SGScope = mkScope(location=top.location);
  s_next.lex = [top.s];
  s_next.imp = d.imps;
  s_next.mod = d.mods;
  s_next.var = d.vars;

  d.s = s_next;
  d.sLookup = s;

  ds.s = s_next;

  top.vars = d.vars ++ ds.vars;
  top.mods = d.mods ++ ds.mods;
}

aspect production declsNil
top::Decls ::=
{
  top.vars = [];
  top.mods = [];
}

--------------------------------------------------

attribute s occurs on Decl;
attribute sLookup occurs on Decl;
attribute vars occurs on Decl;
attribute mods occurs on Decl;
attribute imps occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local modScope::SGScope = mkDeclMod(id, location=top.location);
  modScope.lex = [top.s];
  modScope.imp = [];
  modScope.mod = ds.mods;
  modScope.var = ds.vars;

  top.vars = [];
  top.mods = [modScope];
  top.imps = [];

  ds.s = top.s;
}

aspect production declImport
top::Decl ::= r::ModRef
{
  top.vars = [];
  top.mods = [];
  top.imps = r.resolution;

  r.s = top.sLookup;
}

aspect production declDef
top::Decl ::= b::ParBind
{
  top.vars = b.vars;
  top.mods = [];
  top.imps = [];

  b.s = top.sLookup;
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
  local s_fun::SGScope = mkScope(location=top.location);
  s_fun.lex = [top.s];
  s_fun.imp = [];
  s_fun.mod = [];
  s_fun.var = d.vars;

  d.s = s_fun;
  e.s = s_fun;
}


aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local s_let::SGScope = mkScope(location=top.location);
  s_let.lex = [bs.lastScope];
  s_let.imp = [];
  s_let.mod = [];
  s_let.var = bs.vars;

  bs.s = top.s;
  e.s = s_let;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local s_let::SGScope = mkScope(location=top.location);
  s_let.lex = [top.s];
  s_let.imp = [];
  s_let.mod = [];
  s_let.var = bs.vars;

  bs.s = s_let;
  e.s = s_let;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local s_let::SGScope = mkScope(location=top.location);
  s_let.lex = [top.s];
  s_let.imp = [];
  s_let.mod = [];
  s_let.var = bs.vars;

  bs.s = top.s;
  e.s = s_let;
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
  local s_def_prime::SGScope = mkScope(location=top.location);
  s_def_prime.lex = [top.s];
  s_def_prime.imp = [];
  s_def_prime.mod = [];
  s_def_prime.var = s.vars;

  s.s = top.s;
  ss.s = s_def_prime;

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
{
  top.vars = [];
}

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

  e.s = top.s;

  top.vars = [s_var];
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
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

attribute s occurs on ModRef;

synthesized attribute resolution::[Decorated SGDecl] occurs on ModRef;
synthesized attribute ref::Decorated SGRef occurs on ModRef;

aspect production modRef
top::ModRef ::= name::String
{
  local r::SGRef = mkRefMod(name, location=top.location);
  r.lex = [top.s];

  top.ref = r;
  top.resolution = r.res;
}

--------------------------------------------------

attribute s occurs on VarRef;

attribute resolution occurs on VarRef;
attribute ref occurs on VarRef;

aspect production varRef
top::VarRef ::= name::String
{
  local r::SGRef = mkRefVar(name, location=top.location);
  r.lex = [top.s];

  top.ref = r;
  top.resolution = r.res;
}