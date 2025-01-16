grammar lm_semantics_0:nameanalysis;

--------------------------------------------------

synthesized attribute ok::Boolean;
inherited attribute s::Decorated SGScope;
synthesized attribute VAR_s::[Decorated SGScope];
synthesized attribute ty::Type;

--------------------------------------------------

attribute ok occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local s::SGScope = mkScope(location=top.location);
  s.lex = []; s.imp = []; s.mod = [];
  s.var = ds.VAR_s;

  ds.s = s;

  top.ok = ds.ok;
}

--------------------------------------------------

attribute s occurs on Decls;
attribute VAR_s occurs on Decls;
attribute ok occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.s = top.s;
  ds.s = top.s;

  top.VAR_s = d.VAR_s ++ ds.VAR_s;

  top.ok = d.ok && ds.ok;
}

aspect production declsNil
top::Decls ::=
{
  top.VAR_s = [];

  top.ok = true;
}

--------------------------------------------------

attribute s occurs on Decl;
attribute VAR_s occurs on Decl;
attribute ok occurs on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{
  b.s = top.s;

  top.VAR_s = b.VAR_s;

  top.ok = b.ok;
}

--------------------------------------------------

attribute s occurs on Expr;
attribute ty occurs on Expr;
attribute ok occurs on Expr;
attribute VAR_s occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.VAR_s = [];
  top.ty = tInt();
  top.ok = true;
}

aspect production exprTrue
top::Expr ::=
{
  top.VAR_s = [];
  top.ty = tBool();
  top.ok = true;
}

aspect production exprFalse
top::Expr ::=
{
  top.VAR_s = [];
  top.ty = tBool();
  top.ok = true;
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  top.VAR_s = [];

  local pair::(Boolean, String, Type) = 
    case datumOf(r.p) of
    | (true, datumVar(x, ty)) -> (true, x, ^ty)
    | _                       -> (false, error("sadness"))
    end;
  local ok::Boolean = pair.1;
  local x::String = pair.2;
  local ty::Type = pair.3;

  top.ty = if ok then ^ty else tErr();

  r.s = top.s;

  top.ok = r.ok && ok;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  top.VAR_s = [];

  e1.s = top.s;
  e2.s = top.s;

  top.ty = tInt();

  top.ok = e1.ok && e2.ok &&
           e1.ty == tInt() && e2.ty == tInt();
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  top.VAR_s = [];

  e1.s = top.s;
  e2.s = top.s;

  top.ty = tInt();

  top.ok = e1.ok && e2.ok &&
           e1.ty == tInt() && e2.ty == tInt();
  }

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  top.VAR_s = [];

  e1.s = top.s;
  e2.s = top.s;

  top.ty = tInt();

  top.ok = e1.ok && e2.ok &&
           e1.ty == tInt() && e2.ty == tInt();
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  top.VAR_s = [];

  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  top.VAR_s = [];
  
  e1.s = top.s;
  e2.s = top.s;

  top.ty = tInt();

  top.ok = e1.ok && e2.ok &&
           e1.ty == tInt() && e2.ty == tInt();
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  top.VAR_s = [];
  
  e1.s = top.s;
  e2.s = top.s;

  top.ty = tBool();

  top.ok = e1.ok && e2.ok &&
           e1.ty == tBool() && e2.ty == tBool();
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  top.VAR_s = [];
  
  e1.s = top.s;
  e2.s = top.s;

  top.ty = tBool();

  top.ok = e1.ok && e2.ok && 
           e1.ty == e2.ty;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  top.VAR_s = [];
  
  e1.s = top.s;
  e2.s = top.s;

  local pair::(Boolean, Type) =
    case e1.ty, e2.ty of
    | tFun(t1, t2), t3 when ^t1 == t3 -> (true, t3)
    | _, _ -> (false, tErr())
    end;

  top.ty = pair.2;

  top.ok = e1.ok && e2.ok && 
           pair.1;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  top.VAR_s = [];
  
  e1.s = top.s;
  e2.s = top.s;
  e3.s = top.s;

  top.ty = e2.ty;

  top.ok = e1.ok && e2.ok && e3.ok && 
           e1.ty == tBool() && e2.ty == e3.ty;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  top.VAR_s = [];
  
  local s_fun::SGScope = mkScope(location=top.location);
  s_fun.lex = [top.s];
  s_fun.var = d.VAR_s ++ e.VAR_s;
  s_fun.imp = []; s_fun.mod = [];

  d.s = s_fun;
  local ty1::Type = d.ty;

  e.s = s_fun;
  local ty2::Type = e.ty;

  top.ty = tFun(d.ty, e.ty);

  top.ok = d.ok && e.ok;
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  top.VAR_s = [];
  
  local s_let::SGScope = mkScope(location=top.location);
  s_let.lex = [bs.lastScope];
  s_let.var = bs.VAR_s;
  s_let.imp = []; s_let.mod = [];

  bs.s = top.s;

  e.s = s_let;
  local ty::Type = e.ty;

  top.ty = ^ty;

  top.ok = bs.ok && e.ok;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  top.VAR_s = [];
  
  local s_let::SGScope = mkScope(location=top.location);
  s_let.lex = [top.s];
  s_let.var = bs.VAR_s;
  s_let.imp = []; s_let.mod = [];

  bs.s = s_let;

  e.s = s_let;
  local ty::Type = e.ty;

  top.ty = ^ty;

  top.ok = bs.ok && e.ok;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  top.VAR_s = [];
  
  local s_let::SGScope = mkScope(location=top.location);
  s_let.lex = [top.s];
  s_let.var = bs.VAR_s;
  s_let.imp = []; s_let.mod = [];

  bs.s = top.s;

  e.s = s_let;
  local ty::Type = e.ty;

  top.ty = ^ty;
  
  top.ok = bs.ok && e.ok;
}

--------------------------------------------------

attribute s occurs on SeqBinds;
attribute ok occurs on SeqBinds;

synthesized attribute lastScope::Decorated SGScope occurs on SeqBinds;

attribute VAR_s occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.VAR_s = [];
  top.lastScope = top.s;

  top.ok = true;
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  s.s = top.s;

  top.VAR_s = s.VAR_s;
  top.lastScope = top.s;

  top.ok = s.ok;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local s_def_::SGScope = mkScope(location=top.location);
  s_def_.lex = [top.s];
  s_def_.var = s.VAR_s;
  s_def_.imp = []; s_def_.mod = [];

  s.s = top.s;
  ss.s = s_def_;

  top.VAR_s = ss.VAR_s;
  top.lastScope = ss.lastScope;

  top.ok = s.ok && ss.ok;
}

--------------------------------------------------

attribute s occurs on SeqBind;
attribute ok occurs on SeqBind;

attribute VAR_s occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local s_var::SGScope = mkScopeDatum(datumVar(id, e.ty, location=top.location),
                                      location=top.location);
  s_var.lex = []; s_var.var = [];
  s_var.imp = []; s_var.mod = [];

  e.s = top.s;
  local ty::Type = e.ty;

  top.VAR_s = [s_var];

  top.ok = e.ok;
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local s_var::SGScope = mkScopeDatum(datumVar(id, ^ty, location=top.location),
                                      location=top.location);
  s_var.lex = []; s_var.var = [];
  s_var.imp = []; s_var.mod = [];

  e.s = top.s;
  local ty1::Type = e.ty;

  ty.s = top.s;
  local ty2::Type = ty.ty;

  top.VAR_s = [s_var];

  top.ok = e.ok && ^ty1 == ^ty2;
}

--------------------------------------------------

attribute s occurs on ParBinds;
attribute ok occurs on ParBinds;
attribute VAR_s occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{ top.VAR_s = []; top.ok = true;}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.s = top.s;
  ss.s = top.s;

  top.VAR_s = s.VAR_s ++ ss.VAR_s;

  top.ok = s.ok && ss.ok;
}

--------------------------------------------------

attribute s occurs on ParBind;
attribute ok occurs on ParBind;
attribute VAR_s occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local s_var::SGScope = mkScopeDatum(datumVar(id, e.ty, location=top.location),
                                      location=top.location);
  s_var.lex = []; s_var.var = [];
  s_var.imp = []; s_var.mod = [];

  e.s = top.s;
  local ty::Type = e.ty;

  top.VAR_s = [s_var];

  top.ok = e.ok;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local s_var::SGScope = mkScopeDatum(datumVar(id, ^ty, location=top.location),
                                      location=top.location);
  s_var.lex = []; s_var.var = [];
  s_var.imp = []; s_var.mod = [];

  e.s = top.s;
  local ty1::Type = e.ty;

  ty.s = top.s;
  local ty2::Type = ty.ty;

  top.VAR_s = [s_var];

  top.ok = e.ok && ^ty1 == ^ty2;
}

--------------------------------------------------

attribute s occurs on ArgDecl;
attribute ty occurs on ArgDecl;
attribute ok occurs on ArgDecl;

attribute VAR_s occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  local s_var::SGScope = mkScopeDatum(datumVar(id, ^ty, location=top.location),
                                      location=top.location);
  s_var.lex = []; s_var.var = [];
  s_var.imp = []; s_var.mod = [];
  
  tyann.s = top.s;
  local ty::Type = tyann.ty;

  top.VAR_s = [s_var];

  top.ty = ^ty;

  top.ok = true;
}

--------------------------------------------------

attribute s occurs on Type;
attribute ty occurs on Type;

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  tyann1.s = top.s;
  tyann2.s = top.s;

  top.ty = ^top;
}

aspect production tInt
top::Type ::=
{ top.ty = ^top; }

aspect production tBool
top::Type ::=
{ top.ty = ^top; }

aspect production tErr
top::Type ::=
{ top.ty = ^top; }

--------------------------------------------------

attribute s occurs on VarRef;
attribute ok occurs on VarRef;

synthesized attribute p::Path occurs on VarRef;

aspect production varRef
top::VarRef ::= name::String
{
  local pred::(Boolean ::= SGDatum) = 
    \d::SGDatum -> case d of | datumVar(x, _) -> x == name | _ -> false end;

  local xvars_::[Path] = query(top.s, varRefDFA(), pred);

  -- only(xvars_, p)
  local pair::(Boolean, Path) = onlyPath(xvars_);

  top.p = pair.2;

  top.ok = pair.1;
}
