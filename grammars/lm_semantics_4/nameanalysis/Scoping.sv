grammar lm_semantics_4:nameanalysis;

--------------------------------------------------

inherited attribute s::Decorated SGScope;
synthesized attribute lex_s::[Decorated SGScope];
synthesized attribute imp_s::[Decorated SGScope];
synthesized attribute var_s::[Decorated SGScope];
synthesized attribute mod_s::[Decorated SGScope];

inherited attribute s_def::Decorated SGScope;
synthesized attribute lex_s_def::[Decorated SGScope];
synthesized attribute imp_s_def::[Decorated SGScope];
synthesized attribute var_s_def::[Decorated SGScope];
synthesized attribute mod_s_def::[Decorated SGScope];

synthesized attribute ty::Type;
synthesized attribute p::Path;

monoid attribute ok::Boolean with true, && occurs on
  Main, Decls, Decl, Expr, SeqBinds, SeqBind, ParBinds, ParBind,
  ArgDecl, Type, ModRef, VarRef;
propagate ok on 
  Main, Decls, Decl, Expr, SeqBinds, SeqBind, ParBinds, ParBind,
  ArgDecl, Type, ModRef, VarRef;

--------------------------------------------------

aspect production program
top::Main ::= ds::Decls
{
  local glob::SGScope = mkScope(location=top.location);
  glob.datum = datumNone(location=top.location);
  glob.lex = ds.lex_s;
  glob.imp = ds.imp_s;
  glob.mod = ds.mod_s;
  glob.var = ds.var_s;

  ds.s = glob;
}

--------------------------------------------------

attribute 
  s, lex_s, imp_s, var_s, mod_s   -- scope `s`
occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.s = top.s;
  ds.s = top.s;

  top.lex_s = d.lex_s ++ ds.lex_s;
  top.imp_s = d.imp_s ++ ds.imp_s;
  top.var_s = d.var_s ++ ds.var_s;
  top.mod_s = d.mod_s ++ ds.mod_s;
}

aspect production declsNil
top::Decls ::=
{
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}

--------------------------------------------------

attribute 
  s, lex_s, imp_s, var_s, mod_s   -- scope `s`
occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local s_mod::SGScope = mkScope(location=top.location);
  s_mod.datum = datumMod(id, s_mod, location=top.location);
  s_mod.lex = top.s :: ds.lex_s;
  s_mod.imp = ds.imp_s;
  s_mod.var = ds.var_s;
  s_mod.mod = ds.mod_s;

  ds.s = s_mod;

  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [s_mod];
}

aspect production declImport
top::Decl ::= r::ModRef
{
  r.s = top.s;

  local pair1::(Boolean, SGDatum) = datumOf(r.p);
  local ok1::Boolean = pair1.1;
  local d1::SGDatum = pair1.2;

  top.ok <- ok1;

  local pair2::(Boolean, String, Decorated SGScope) =
    case d1 of
    | datumMod(x, s_mod) -> (true, x, s_mod)
    | _ -> (false, error("sadness"), error("sadness"))
    end;
  local ok2::Boolean = pair2.1;
  local x::String = pair2.2;
  local s_mod::Decorated SGScope = pair2.3;

  top.ok <- ok2;

  top.lex_s = r.lex_s;
  top.imp_s = s_mod:: r.imp_s;
  top.var_s = r.var_s;
  top.mod_s = r.mod_s;
}

aspect production declDef
top::Decl ::= b::ParBind
{
  b.s = top.s;

  top.lex_s = b.lex_s ++ b.lex_s_def;
  top.imp_s = b.imp_s ++ b.imp_s_def;
  top.var_s = b.var_s ++ b.var_s_def;
  top.mod_s = b.mod_s ++ b.mod_s_def;
}

--------------------------------------------------

attribute 
  s, lex_s, imp_s, var_s, mod_s,   -- scope `s`
  ty
occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.ty = tInt();
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}

aspect production exprTrue
top::Expr ::=
{
  top.ty = tBool();
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}

aspect production exprFalse
top::Expr ::=
{
  top.ty = tBool();
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  r.s = top.s;
  
  local pair1::(Boolean, SGDatum) = datumOf(r.p);
  local ok1::Boolean = pair1.1;
  local d1::SGDatum = pair1.2;

  top.ok <- ok1;

  local pair2::(Boolean, String, Type) =
    case d1 of
    | datumVar(x, ty) -> (true, x, ty)
    | _ -> (false, error("sadness"), error("sadness"))
    end;
  local ok2::Boolean = pair1.1;
  local x::String = pair2.2;
  local ty::Type = pair2.3;

  top.ok <- ok2;

  top.ty = ty;
  top.lex_s = r.lex_s;
  top.imp_s = r.imp_s;
  top.var_s = r.var_s;
  top.mod_s = r.mod_s;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  local ty1::Type = e1.ty;
  local ty2::Type = e2.ty;

  top.ok <- ty1 == tInt();
  top.ok <- ty2 == tInt();

  top.ty = tInt();
  top.lex_s = e1.lex_s ++ e2.lex_s;
  top.imp_s = e1.imp_s ++ e2.imp_s;
  top.var_s = e1.var_s ++ e2.var_s;
  top.mod_s = e1.mod_s ++ e2.mod_s;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  local ty1::Type = e1.ty;
  local ty2::Type = e2.ty;

  top.ok <- ty1 == tInt();
  top.ok <- ty2 == tInt();

  top.ty = tInt();
  top.lex_s = e1.lex_s ++ e2.lex_s;
  top.imp_s = e1.imp_s ++ e2.imp_s;
  top.var_s = e1.var_s ++ e2.var_s;
  top.mod_s = e1.mod_s ++ e2.mod_s;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  local ty1::Type = e1.ty;
  local ty2::Type = e2.ty;

  top.ok <- ty1 == tInt();
  top.ok <- ty2 == tInt();

  top.ty = tInt();
  top.lex_s = e1.lex_s ++ e2.lex_s;
  top.imp_s = e1.imp_s ++ e2.imp_s;
  top.var_s = e1.var_s ++ e2.var_s;
  top.mod_s = e1.mod_s ++ e2.mod_s;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  local ty1::Type = e1.ty;
  local ty2::Type = e2.ty;

  top.ok <- ty1 == tInt();
  top.ok <- ty2 == tInt();

  top.ty = tInt();
  top.lex_s = e1.lex_s ++ e2.lex_s;
  top.imp_s = e1.imp_s ++ e2.imp_s;
  top.var_s = e1.var_s ++ e2.var_s;
  top.mod_s = e1.mod_s ++ e2.mod_s;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  local ty1::Type = e1.ty;
  local ty2::Type = e2.ty;

  top.ok <- ty1 == tBool();
  top.ok <- ty2 == tBool();

  top.ty = tBool();
  top.lex_s = e1.lex_s ++ e2.lex_s;
  top.imp_s = e1.imp_s ++ e2.imp_s;
  top.var_s = e1.var_s ++ e2.var_s;
  top.mod_s = e1.mod_s ++ e2.mod_s;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  local ty1::Type = e1.ty;
  local ty2::Type = e2.ty;

  top.ok <- ty1 == tBool();
  top.ok <- ty2 == tBool();

  top.ty = tBool();
  top.lex_s = e1.lex_s ++ e2.lex_s;
  top.imp_s = e1.imp_s ++ e2.imp_s;
  top.var_s = e1.var_s ++ e2.var_s;
  top.mod_s = e1.mod_s ++ e2.mod_s;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  local ty1::Type = e1.ty;
  local ty2::Type = e2.ty;

  top.ok <- ty1 == ty2;

  top.ty = tBool();
  top.lex_s = e1.lex_s ++ e2.lex_s;
  top.imp_s = e1.imp_s ++ e2.imp_s;
  top.var_s = e1.var_s ++ e2.var_s;
  top.mod_s = e1.mod_s ++ e2.mod_s;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  local tyF::Type = e1.ty;
  local ty3::Type = e2.ty;

  local tup1::(Boolean, Type, Type) = 
    case tyF of
    | tFun(ty1, ty2) -> (true, ty1, ty2)
    | _ -> (false, error("sadness"), error("sadness"))
    end;
  local ok1::Boolean = tup1.1;
  local ty1::Type = tup1.2;
  local ty2::Type = tup1.3;

  top.ok <- tyF == tFun(ty1, ty2);
  top.ok <- ty1 == ty3;

  top.ty = ty2;
  top.lex_s = e1.lex_s ++ e2.lex_s;
  top.imp_s = e1.imp_s ++ e2.imp_s;
  top.var_s = e1.var_s ++ e2.var_s;
  top.mod_s = e1.mod_s ++ e2.mod_s;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  e3.s = top.s;

  local ty1::Type = e1.ty;
  local ty2::Type = e2.ty;
  local ty3::Type = e3.ty;

  top.ok <- ty1 == tBool();
  top.ok <- ty2 == ty3;

  top.ty = ty2;
  top.lex_s = e1.lex_s ++ e2.lex_s ++ e2.lex_s;
  top.imp_s = e1.imp_s ++ e2.imp_s ++ e3.imp_s;
  top.var_s = e1.var_s ++ e2.var_s ++ e3.var_s;
  top.mod_s = e1.mod_s ++ e2.mod_s ++ e3.mod_s;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local s_fun::SGScope = mkScope(location=top.location);
  s_fun.datum = datumNone(location=top.location);

  s_fun.lex = top.s::e.lex_s;
  s_fun.imp = e.imp_s;
  s_fun.var = e.var_s;
  s_fun.mod = e.mod_s;

  d.s = s_fun;
  e.s = s_fun;

  local ty1::Type = d.ty;
  local ty2::Type = e.ty;
  
  top.ty = tFun(ty1, ty2);
  top.lex_s = d.lex_s;
  top.imp_s = d.imp_s;
  top.var_s = d.var_s;
  top.mod_s = d.mod_s;
}


aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local s_let::SGScope = mkScope(location=top.location);
  s_let.datum = datumNone(location=top.location);
  s_let.lex = bs.lex_s_def ++ e.lex_s;
  s_let.imp = bs.imp_s_def ++ e.imp_s;
  s_let.var = bs.var_s_def ++ e.var_s;
  s_let.mod = bs.mod_s_def ++ e.mod_s;

  bs.s = top.s;
  bs.s_def = s_let;

  e.s = bs.s_def;

  top.ty = e.ty;
  top.lex_s = bs.lex_s;
  top.imp_s = bs.imp_s;
  top.var_s = bs.var_s;
  top.mod_s = bs.mod_s;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local s_let::SGScope = mkScope(location=top.location);
  s_let.datum = datumNone(location=top.location);
  s_let.lex = top.s :: (bs.lex_s ++ e.lex_s);
  s_let.imp = bs.imp_s ++ e.imp_s;
  s_let.var = bs.var_s ++ e.var_s;
  s_let.mod = bs.mod_s ++ e.mod_s;

  bs.s = s_let;
  e.s = s_let;

  top.ty = e.ty;
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local s_let::SGScope = mkScope(location=top.location);
  s_let.datum = datumNone(location=top.location);
  s_let.lex = top.s :: (bs.lex_s ++ e.lex_s);
  s_let.imp = bs.imp_s ++ e.imp_s;
  s_let.var = bs.var_s ++ e.var_s;
  s_let.mod = bs.mod_s ++ e.mod_s;

  bs.s = top.s;
  e.s = s_let;

  top.ty = e.ty;
  top.lex_s = bs.lex_s;
  top.imp_s = bs.imp_s;
  top.var_s = bs.var_s;
  top.mod_s = bs.mod_s;
}

--------------------------------------------------

attribute 
  s, 
    lex_s, imp_s, var_s, mod_s,
  s_def, 
    lex_s_def, imp_s_def, var_s_def, mod_s_def
occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];

  top.lex_s_def = [top.s];
  top.imp_s_def = [];
  top.var_s_def = [];
  top.mod_s_def = [];
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  s.s = top.s;
  s.s_def = top.s_def;

  top.lex_s = s.lex_s;
  top.imp_s = s.imp_s;
  top.var_s = s.var_s;
  top.mod_s = s.mod_s;

  top.lex_s_def = top.s :: s.lex_s_def;
  top.imp_s_def = s.imp_s_def;
  top.var_s_def = s.var_s_def;
  top.mod_s_def = s.mod_s_def;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  s.s = top.s;
  s.s_def = s_def2;

  ss.s = s_def2;
  ss.s_def = top.s_def;

  local s_def2::SGScope = mkScope(location=top.location);
  s_def2.datum = datumNone(location=top.location);
  s_def2.lex = top.s :: (s.lex_s_def ++ ss.lex_s);
  s_def2.imp = s.imp_s_def ++ ss.imp_s;
  s_def2.var = s.var_s_def ++ ss.var_s;
  s_def2.mod = s.mod_s_def ++ ss.mod_s;

  top.lex_s = s.lex_s;
  top.imp_s = s.imp_s;
  top.var_s = s.var_s;
  top.mod_s = s.mod_s;

  top.lex_s_def = ss.lex_s_def;
  top.imp_s_def = ss.imp_s_def;
  top.var_s_def = ss.var_s_def;
  top.mod_s_def = ss.mod_s_def;
}

--------------------------------------------------

attribute 
  s, 
    lex_s, imp_s, var_s, mod_s,
  s_def, 
    lex_s_def, imp_s_def, var_s_def, mod_s_def
occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local s_var::SGScope = mkScope(location=top.location);
  s_var.datum = datumVar(id, e.ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  e.s = top.s;

  top.lex_s = e.lex_s;
  top.imp_s = e.imp_s;
  top.var_s = e.var_s;
  top.mod_s = e.mod_s;

  top.lex_s_def = [];
  top.imp_s_def = [];
  top.var_s_def = [s_var];
  top.mod_s_def = [];
}

aspect production seqBindTyped
top::SeqBind ::= tyann::Type id::String e::Expr
{
  local s_var::SGScope = mkScope(location=top.location);
  s_var.datum = datumVar(id, ty1, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  tyann.s = top.s;
  e.s = top.s;

  local ty1::Type = tyann.ty;
  local ty2::Type = e.ty;

  top.ok <- ty1 == ty2;

  top.lex_s = e.lex_s;
  top.imp_s = e.imp_s;
  top.var_s = e.var_s;
  top.mod_s = e.mod_s;

  top.lex_s_def = [];
  top.imp_s_def = [];
  top.var_s_def = [s_var];
  top.mod_s_def = [];
}

--------------------------------------------------

attribute 
  s, 
    lex_s, imp_s, var_s, mod_s,
  s_def, 
    lex_s_def, imp_s_def, var_s_def, mod_s_def
occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];

  top.lex_s_def = [top.s];
  top.imp_s_def = [];
  top.var_s_def = [];
  top.mod_s_def = [];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.s = top.s;
  s.s_def = top.s_def;

  ss.s = top.s;
  ss.s_def = top.s_def;

  top.lex_s = s.lex_s ++ ss.lex_s;
  top.imp_s = s.imp_s ++ ss.imp_s;
  top.var_s = s.var_s ++ ss.var_s;
  top.mod_s = s.mod_s ++ ss.mod_s;

  top.lex_s_def = s.lex_s_def ++ ss.lex_s_def;
  top.imp_s_def = s.imp_s_def ++ ss.imp_s_def;
  top.var_s_def = s.var_s_def ++ ss.var_s_def;
  top.mod_s_def = s.mod_s_def ++ ss.mod_s_def;
}

--------------------------------------------------

attribute 
  s, 
    lex_s, imp_s, var_s, mod_s,
  s_def, 
    lex_s_def, imp_s_def, var_s_def, mod_s_def
occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local s_var::SGScope = mkScope(location=top.location);
  s_var.datum = datumVar(id, e.ty, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  e.s = top.s;

  top.lex_s = e.lex_s;
  top.imp_s = e.imp_s;
  top.var_s = e.var_s;
  top.mod_s = e.mod_s;

  top.lex_s_def = [];
  top.imp_s_def = [];
  top.var_s_def = [s_var];
  top.mod_s_def = [];
}

aspect production parBindTyped
top::ParBind ::= tyann::Type id::String e::Expr
{
  local s_var::SGScope = mkScope(location=top.location);
  s_var.datum = datumVar(id, ty1, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  tyann.s = top.s;
  e.s = top.s;

  local ty1::Type = tyann.ty;
  local ty2::Type = e.ty;

  top.ok <- ty1 == ty2;

  top.lex_s = e.lex_s;
  top.imp_s = e.imp_s;
  top.var_s = e.var_s;
  top.mod_s = e.mod_s;

  top.lex_s_def = [];
  top.imp_s_def = [];
  top.var_s_def = [s_var];
  top.mod_s_def = [];
}

--------------------------------------------------

attribute 
  s, 
    lex_s, imp_s, var_s, mod_s,
  ty
occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  local s_var::SGScope = mkScope(location=top.location);
  s_var.datum = datumVar(id, ty1, location=top.location);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  tyann.s = top.s;

  local ty1::Type = tyann.ty;

  top.ty = ty1;
  top.lex_s = tyann.lex_s;
  top.imp_s = tyann.imp_s;
  top.var_s = s_var :: tyann.var_s;
  top.mod_s = tyann.mod_s;
}

--------------------------------------------------

attribute 
  s, 
    lex_s, imp_s, var_s, mod_s,
  ty
occurs on Type;


aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  tyann1.s = top.s;
  tyann2.s = top.s;

  top.ty = tFun(tyann1.ty, tyann2.ty);
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}

aspect production tInt
top::Type ::=
{
  top.ty = tInt();
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}

aspect production tBool
top::Type ::=
{
  top.ty = tBool();
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}

aspect production tErr
top::Type ::=
{
  top.ty = tErr();
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}

--------------------------------------------------

attribute 
  s, 
    lex_s, imp_s, var_s, mod_s,
  p
occurs on ModRef;

aspect production modRef
top::ModRef ::= name::String
{
  local mods::[Path] = query(top.s, modRefDFA());  -- `LEX* IMP? MOD`
  local xmods::[Path] = pathFilter((\d::SGDatum -> case d of datumMod(x, _) -> x == name | _ -> false end), mods);
  local xmods_::[Path] = xmods; --minRefs(xmods);
  
  local pair1::(Boolean, Path) = 
    if length(xmods_) == 1
    then (true, head(xmods_))
    else (false, error("sadness"));

  local ok::Boolean = pair1.1;
  local p::Path = pair1.2;

  top.ok <- ok;
  top.p = p;
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}

--------------------------------------------------

attribute 
  s,
    lex_s, imp_s, var_s, mod_s,
  p
occurs on VarRef;

aspect production varRef
top::VarRef ::= name::String
{
  local vars::[Path] = query(top.s, varRefDFA());  -- `LEX* IMP? VAR`
  local xvars::[Path] = pathFilter((\d::SGDatum -> case d of datumVar(x, _) -> x == name | _ -> false end), vars);
  local xvars_::[Path] = xvars; --minRefs(xvars); 

  local pair1::(Boolean, Path) = 
    if length(xvars_) == 1
    then (true, head(xvars_))
    else (false, error("sadness"));

  local ok::Boolean = pair1.1;
  local p::Path = pair1.2;

  top.ok <- ok;
  top.p = p;
  top.lex_s = [];
  top.imp_s = [];
  top.var_s = [];
  top.mod_s = [];
}