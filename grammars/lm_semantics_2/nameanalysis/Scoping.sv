grammar lm_semantics_2:nameanalysis;

--------------------------------------------------

inherited attribute s::Decorated SGScope;
inherited attribute sLookup::Decorated SGScope;

synthesized attribute vars::[Decorated SGScope];
synthesized attribute mods::[Decorated SGScope];
synthesized attribute imps::[Decorated SGScope];

monoid attribute allScopes::[Decorated SGScope] with [], ++;

--------------------------------------------------

attribute allScopes occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local glob::SGScope = mkScope(location=top.location);
  glob.lex = [];
  glob.imp = [];
  glob.mod = ds.mods;
  glob.var = ds.vars;

  ds.s = glob;

  top.allScopes := glob :: ds.allScopes;
}

--------------------------------------------------

attribute s occurs on Decls;
attribute vars occurs on Decls;
attribute mods occurs on Decls;

attribute allScopes occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local lookup::SGScope = mkScope(location=top.location);
  lookup.lex = [top.s];
  lookup.imp = d.imps;
  lookup.mod = d.mods;
  lookup.var = d.vars;

  d.s = top.s;
  d.sLookup = lookup;

  ds.s = lookup;

  top.vars = d.vars ++ ds.vars;
  top.mods = d.mods ++ ds.mods;

  top.allScopes := lookup::(d.allScopes ++ ds.allScopes);
}

aspect production declsNil
top::Decls ::=
{
  top.vars = [];
  top.mods = [];

  top.allScopes := [];
}

--------------------------------------------------

attribute s occurs on Decl;
attribute sLookup occurs on Decl;

attribute vars occurs on Decl;
attribute mods occurs on Decl;
attribute imps occurs on Decl;

attribute allScopes occurs on Decl;

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

  top.allScopes := modScope::ds.allScopes;
}

aspect production declImport
top::Decl ::= r::ModRef
{
  top.vars = [];
  top.mods = [];
  top.imps = r.resolution;

  r.s = top.s;

  top.allScopes := [];
}

aspect production declDef
top::Decl ::= b::ParBind
{
  top.vars = b.vars;
  top.mods = [];
  top.imps = [];

  b.s = top.sLookup;

  top.allScopes := b.allScopes;
}

--------------------------------------------------

attribute s occurs on Expr;

attribute allScopes occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.allScopes := [];
}

aspect production exprTrue
top::Expr ::=
{
  top.allScopes := [];
}

aspect production exprFalse
top::Expr ::=
{
  top.allScopes := [];
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  r.s = top.s;
  top.allScopes := [];
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  e3.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes ++ e3.allScopes;
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

  top.allScopes := s_fun :: (d.allScopes ++ e.allScopes);
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

  top.allScopes := s_let :: (bs.allScopes ++ e.allScopes);
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

  top.allScopes := s_let :: (bs.allScopes ++ e.allScopes);
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

  top.allScopes := s_let :: (bs.allScopes ++ e.allScopes);
}

--------------------------------------------------

attribute s occurs on SeqBinds;

synthesized attribute lastScope::Decorated SGScope occurs on SeqBinds;

attribute vars occurs on SeqBinds;
attribute allScopes occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.vars = [];
  top.lastScope = top.s;

  top.allScopes := [];
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  s.s = top.s;

  top.vars = s.vars;
  top.lastScope = top.s;

  top.allScopes := s.allScopes;
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

  top.allScopes := s_def_prime :: (s.allScopes ++ ss.allScopes);
}

--------------------------------------------------

attribute s occurs on SeqBind;

attribute vars occurs on SeqBind;
attribute allScopes occurs on SeqBind;

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
  top.allScopes := [s_var];
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
  top.allScopes := [s_var];
}

--------------------------------------------------

attribute s occurs on ParBinds;

attribute vars occurs on ParBinds;

attribute allScopes occurs on ParBinds;
propagate allScopes on ParBinds;

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

attribute allScopes occurs on ParBind;

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
  top.allScopes := [s_var];
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
  top.allScopes := [s_var];
}

--------------------------------------------------

attribute s occurs on ArgDecl;

attribute vars occurs on ArgDecl;
attribute allScopes occurs on ArgDecl;

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
  top.allScopes := [s_var];
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

aspect production modRef
top::ModRef ::= name::String
{
  local r::SGRef = mkRefMod(name, location=top.location);
  r.lex = [top.s];

  top.resolution = r.res;
}

--------------------------------------------------

attribute s occurs on VarRef;

attribute resolution occurs on VarRef;

aspect production varRef
top::VarRef ::= name::String
{
  local r::SGRef = mkRefVar(name, location=top.location);
  r.lex = [top.s];

  top.resolution = r.res;
}