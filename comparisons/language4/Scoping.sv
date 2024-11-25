grammar lm_semantics_4:nameanalysis;

--------------------------------------------------

inherited attribute s::Decorated SGScope;

synthesized attribute vars::[Decorated SGScope];
synthesized attribute mods::[Decorated SGScope];
synthesized attribute imps::[Decorated SGScope];

synthesized attribute path::[Path];

synthesized attribute ty::Type;

synthesized attribute ok::Boolean;

--------------------------------------------------

attribute ok occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local glob::SGScope = mkScope(location=top.location);
  glob.lex = [];
  glob.imp = ds.imps;
  glob.mod = ds.mods;
  glob.var = ds.vars;

  ds.s = glob;

  top.ok = ds.ok;
}

--------------------------------------------------

attribute s occurs on Decls;

attribute vars occurs on Decls;
attribute mods occurs on Decls;
attribute imps occurs on Decls;

attribute ok occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.s = top.s;
  ds.s = top.s;

  top.vars = d.vars ++ ds.vars;
  top.mods = d.mods ++ ds.mods;
  top.imps = d.imps ++ ds.imps;

  top.ok = d.ok && ds.ok;
}

aspect production declsNil
top::Decls ::=
{
  top.vars = [];
  top.mods = [];
  top.imps = [];

  top.ok = true;
}

--------------------------------------------------

attribute s occurs on Decl;

attribute vars occurs on Decl;
attribute mods occurs on Decl;
attribute imps occurs on Decl;

attribute ok occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local s_mod::SGScope = mkDeclMod(id, location=top.location);
  s_mod.lex = [top.s];
  s_mod.imp = ds.imps;
  s_mod.mod = ds.mods;
  s_mod.var = ds.vars;

  ds.s = s_mod;

  top.vars = [];
  top.mods = [s_mod];
  top.imps = [];

  top.ok = ds.ok;
}

aspect production declImport
top::Decl ::= r::ModRef
{
  r.s = top.s;

  top.vars = [];
  top.mods = [];
  top.imps = r.resolution;

  top.ok = r.ok;
}

aspect production declDef
top::Decl ::= b::ParBind
{
  top.vars = b.vars;
  top.mods = [];
  top.imps = [];

  b.s = top.s;

  top.ok = b.ok;
}

--------------------------------------------------

attribute s occurs on Expr;

attribute ty occurs on Expr;


aspect production exprInt
top::Expr ::= i::Integer
{
  top.ty = tInt();
}

aspect production exprTrue
top::Expr ::=
{
  top.ty = tBool();
}

aspect production exprFalse
top::Expr ::=
{
  top.ty = tBool();
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  r.s = top.s;

  local datumP::(String, Type) = 
    case datum(p) of
    | (x, t) -> just(x, t)
    | _ -> nothing()
    end;

  top.ok = datumP.isJust;
  
  local x::String = if top.ok 
                    then datumP.fromJust.1 
                    else "";
            
  local t::Type = if top.ok 
                  then datumP.fromJust.2 
                  else tErr();

  top.ty = t;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  top.ok = e1.ty == e2.ty;

  top.ty = if top.ok
           then tInt() 
           else tErr();
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  top.ty = if e1.ty == tInt() && e2.ty == tInt() then tInt() else tErr();
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  top.ty = if e1.ty == tInt() && e2.ty == tInt() then tInt() else tErr();
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  top.ty = if e1.ty == tInt() && e2.ty == tInt() then tInt() else tErr();
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  top.ty = if e1.ty == tBool() && e2.ty == tBool() then tBool() else tErr();
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  top.ty = if e1.ty == tBool() && e2.ty == tBool() then tBool() else tErr();
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  top.ty = if e1.ty == e2.ty then tBool() else tErr();
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  local e1ty::Maybe(Type, Type) =
    case e1.ty of
    | (t1, t2) -> just((t1, t2))
    | _ -> nothing()
    end;

  local t1::Type = if e1ty.isJust then e1ty.fromJust.1;
  local t2::Type = if e1ty.isJust then e1ty.fromJust.2;

  top.ok = e1ty.isJust &&
           e2.ty == t1;

  top.ty = if top.ok
           then t2
           else tErr();
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  e3.s = top.s;

  top.ty = if e1.ty == tBool() && e2.ty == e3.ty then e2.ty else tErr();
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

  top.ty = tFun(d.ty, e.ty);
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

  top.ty = e.ty;
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

  top.ty = e.ty;
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

  top.ty = e.ty;
}

--------------------------------------------------

attribute s occurs on SeqBinds;

synthesized attribute lastScope::Decorated SGScope occurs on SeqBinds;

attribute vars occurs on SeqBinds;

attribute ok occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.vars = [];
  top.lastScope = top.s;

  top.ok = true;
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  s.s = top.s;

  top.vars = s.vars;
  top.lastScope = top.s;

  top.ok = s.ok;
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

  top.ok = s.ok && ss.ok;
}

--------------------------------------------------

attribute s occurs on SeqBind;

attribute vars occurs on SeqBind;

attribute ok occurs on SeqBind;

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

  top.ok = e.ty != tErr();
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

  top.ok = ty == e.ty;
}

--------------------------------------------------

attribute s occurs on ParBinds;

attribute vars occurs on ParBinds;

attribute ok occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.vars = [];

  top.ok = true;
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.s = top.s;
  ss.s = top.s;

  top.vars = s.vars ++ ss.vars;

  top.ok = s.ok && ss.ok;
}

--------------------------------------------------

attribute s occurs on ParBind;

attribute vars occurs on ParBind;

attribute ok occurs on ParBind;

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

  top.ok = e.ty != tErr();
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

  top.ok = ty == e.ty;
}

--------------------------------------------------

attribute s occurs on ArgDecl;

attribute vars occurs on ArgDecl;

attribute ty occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  local s_var::SGScope = mkDeclVar(id, top.ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  tyann.s = top.s;

  top.vars = [s_var];

  top.ty = tyann.ty;
}

--------------------------------------------------

attribute s occurs on Type;

attribute ty occurs on Type;


aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  tyann1.s = top.s;
  tyann2.s = top.s;

  top.ty = tFun(tyann1.ty, tyann2.ty);
}

aspect production tInt
top::Type ::=
{
  top.ty = tInt();
}

aspect production tBool
top::Type ::=
{
  top.ty = tBool();
}

aspect production tErr
top::Type ::=
{
  top.ty = tErr();
}

--------------------------------------------------

attribute s occurs on ModRef;

attribute ok occurs on ModRef;

synthesized attribute resolution::[Decorated SGDecl] occurs on ModRef;
synthesized attribute ref::Decorated SGRef occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  local mods::[Path]   = query(top.s, regexMOD);
  local xmods::[Path]  = filter ((\x_::String -> x_ == x), mods);
  local xmods_::[Path] = minPaths(xmods);

  top.p  = if top.ok 
           then head(xmods_)
           else emptyPath();
           
  top.ok = length(xmods_) == 1;
}

--------------------------------------------------

attribute s occurs on VarRef;

attribute ok occurs on VarRef;

attribute resolution occurs on VarRef;
attribute ref occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local vars::[Path]   = query(top.s, regexVAR);
  local xvars::[Path]  = filter ((\x_::String -> x_ == x), vars);
  local xvars_::[Path] = minPaths(xvars);

  top.p  = if top.ok 
           then head(xvars_)
           else emptyPath();

  top.ok = length(xvars_) == 1;
}