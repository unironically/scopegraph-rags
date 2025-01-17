grammar lm_semantics_0:nameanalysis;

--------------------------------------------------

synthesized attribute ok::Boolean;
inherited attribute s::Decorated SGScope;

synthesized attribute VAR_s::[Decorated SGScope];
synthesized attribute LEX_s::[Decorated SGScope];

synthesized attribute VAR_s_def::[Decorated SGScope];
synthesized attribute LEX_s_def::[Decorated SGScope];

synthesized attribute p::Path;

synthesized attribute ty::Type;

--------------------------------------------------

attribute ok occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  -- new s
  local s::SGScope = mkScope(location=top.location);

  -- decls(s, ds)
  ds.s = s;
  s.lex = ds.LEX_s;
  s.var = ds.VAR_s;

  -- ok-ness
  top.ok = ds.ok;

  -- ignore
  s.imp = []; s.mod = [];
}

--------------------------------------------------

attribute s occurs on Decls;
attribute VAR_s occurs on Decls;
attribute LEX_s occurs on Decls;

attribute ok occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  -- decl(s, d)
  d.s = top.s;

  -- decls(s, ds)
  ds.s = top.s;

  -- s is passed to decl as s and decls as s
  top.VAR_s = d.VAR_s ++ ds.VAR_s;
  top.LEX_s = d.LEX_s ++ ds.LEX_s;

  -- ok-ness
  top.ok = d.ok && ds.ok;
}

aspect production declsNil
top::Decls ::=
{
  -- no assertions for s, nor is it passed
  top.VAR_s = [];
  top.LEX_s = [];

  -- ok-ness
  top.ok = true;
}

--------------------------------------------------

attribute s occurs on Decl;
attribute VAR_s occurs on Decl;
attribute LEX_s occurs on Decl;

attribute ok occurs on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{
  -- par-bind(s, b, s)
  b.s = top.s;
  top.VAR_s = b.VAR_s ++ b.VAR_s_def;
  top.LEX_s = b.LEX_s ++ b.LEX_s_def;

  -- ok-ness
  top.ok = b.ok;
}

--------------------------------------------------

attribute s occurs on Expr;
attribute VAR_s occurs on Expr;
attribute LEX_s occurs on Expr;

attribute ty occurs on Expr;

attribute ok occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  -- ty == INT()
  top.ty = tInt();

  -- no assertions for s, nor is it passed
  top.VAR_s = [];
  top.LEX_s = [];

  -- ok-ness
  top.ok = true;
}

aspect production exprTrue
top::Expr ::=
{
  -- ty == BOOL()
  top.ty = tBool();

  -- no assertions for s, nor is it passed
  top.VAR_s = [];
  top.LEX_s = [];

  -- ok-ness
  top.ok = true;
}

aspect production exprFalse
top::Expr ::=
{
  -- ty == BOOL()
  top.ty = tBool();

  -- no assertions for s, nor is it passed
  top.VAR_s = [];
  top.LEX_s = [];

  -- ok-ness
  top.ok = true;
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  -- tgt(s', p)
  local tgtPair::(Boolean, Decorated SGScope) = tgt(^p);
  local okTgt::Boolean = tgtPair.1;
  local s_::Decorated SGScope = tgtPair.2;

  -- s' -> d
  local d::SGDatum = s_.datum;

  -- d == DatumVar(x, ty')
  local pair::(Boolean, String, Type) = 
    case d of
      datumVar(x, ty) -> (true, x, ^ty)
    | _               -> (false, error("sadness"))
    end;
  local eqOk::Boolean = pair.1;
  local x::String = pair.2;
  local ty_::Type = pair.3;

  -- ty == ty'
  top.ty = ^ty_;

  -- var-ref(s, r, p)
  r.s = top.s;
  top.VAR_s = r.VAR_s;
  local p::Path = r.p;
  
  -- ok-ness
  top.ok = okTgt && r.ok && eqOk;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  -- expr(s, e1, ty1)
  e1.s = top.s;
  local ty1::Type = e1.ty;
  
  -- expr(s, e2, ty2)
  e2.s = top.s;
  local ty2::Type = e2.ty;

  -- ty == INT()
  top.ty = tInt();

  -- s is passed down to e1 and e2
  top.VAR_s = e1.VAR_s ++ e2.VAR_s;
  top.LEX_s = e1.LEX_s ++ e2.LEX_s;

  -- ok-ness
  top.ok = e1.ok && e2.ok &&
           ^ty1 == tInt() && ^ty2 == tInt();
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  -- expr(s, e1, ty1)
  e1.s = top.s;
  local ty1::Type = e1.ty;
  
  -- expr(s, e2, ty2)
  e2.s = top.s;
  local ty2::Type = e2.ty;

  -- ty == INT()
  top.ty = tInt();

  -- s is passed down to e1 and e2
  top.VAR_s = e1.VAR_s ++ e2.VAR_s;
  top.LEX_s = e1.LEX_s ++ e2.LEX_s;

  -- ok-ness
  top.ok = e1.ok && e2.ok &&
           ^ty1 == tInt() && ^ty2 == tInt();
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  -- expr(s, e1, ty1)
  e1.s = top.s;
  local ty1::Type = e1.ty;
  
  -- expr(s, e2, ty2)
  e2.s = top.s;
  local ty2::Type = e2.ty;

  -- ty == INT()
  top.ty = tInt();

  -- s is passed down to e1 and e2
  top.VAR_s = e1.VAR_s ++ e2.VAR_s;
  top.LEX_s = e1.LEX_s ++ e2.LEX_s;

  -- ok-ness
  top.ok = e1.ok && e2.ok &&
           ^ty1 == tInt() && ^ty2 == tInt();
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  -- expr(s, e1, ty1)
  e1.s = top.s;
  local ty1::Type = e1.ty;
  
  -- expr(s, e2, ty2)
  e2.s = top.s;
  local ty2::Type = e2.ty;

  -- ty == INT()
  top.ty = tInt();

  -- s is passed down to e1 and e2
  top.VAR_s = e1.VAR_s ++ e2.VAR_s;
  top.LEX_s = e1.LEX_s ++ e2.LEX_s;

  -- ok-ness
  top.ok = e1.ok && e2.ok &&
           ^ty1 == tInt() && ^ty2 == tInt();
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  -- expr(s, e1, ty1)
  e1.s = top.s;
  local ty1::Type = e1.ty;
  
  -- expr(s, e2, ty2)
  e2.s = top.s;
  local ty2::Type = e2.ty;

  -- ty == BOOL()
  top.ty = tBool();

  -- s is passed down to e1 and e2
  top.VAR_s = e1.VAR_s ++ e2.VAR_s;
  top.LEX_s = e1.LEX_s ++ e2.LEX_s;

  -- ok-ness
  top.ok = e1.ok && e2.ok &&
           ^ty1 == tBool() && ^ty2 == tBool();
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  -- expr(s, e1, ty1)
  e1.s = top.s;
  local ty1::Type = e1.ty;
  
  -- expr(s, e2, ty2)
  e2.s = top.s;
  local ty2::Type = e2.ty;

  -- ty == BOOL()
  top.ty = tBool();

  -- s is passed down to e1 and e2
  top.VAR_s = e1.VAR_s ++ e2.VAR_s;
  top.LEX_s = e1.LEX_s ++ e2.LEX_s;

  -- ok-ness
  top.ok = e1.ok && e2.ok &&
           ^ty1 == tBool() && ^ty2 == tBool();
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  -- expr(s, e1, ty1)
  e1.s = top.s;
  local ty1::Type = e1.ty;
  
  -- expr(s, e2, ty2)
  e2.s = top.s;
  local ty2::Type = e2.ty;

  -- ty == BOOL()
  top.ty = tBool();

  -- s is passed down to e1 and e2
  top.VAR_s = e1.VAR_s ++ e2.VAR_s;
  top.LEX_s = e1.LEX_s ++ e2.LEX_s;

  -- ok-ness, ty1 == ty2
  top.ok = e1.ok && e2.ok &&
           ^ty1 == ^ty2;
}

-- associations todo
aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  top.VAR_s = [];
  top.LEX_s = [];
  
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

-- associations todo
aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  top.VAR_s = [];
  top.LEX_s = [];
  
  e1.s = top.s;
  e2.s = top.s;
  e3.s = top.s;

  top.ty = e2.ty;

  top.ok = e1.ok && e2.ok && e3.ok && 
           e1.ty == tBool() && e2.ty == e3.ty;
}

-- associations todo
aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  top.VAR_s = [];
  top.LEX_s = [];
  
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
  -- new s_let
  local s_let::SGScope = mkScope(location=top.location);

  -- seq-binds(s, bs, s_let), expr(s_let, e, ty)
  bs.s = top.s;
  s_let.lex = bs.LEX_s_def ++ e.LEX_s;
  s_let.var = bs.VAR_s_def ++ e.VAR_s;

  -- expr(s_let, e, ty)
  e.s = s_let;
  top.ty = e.ty;

  -- s is passed to seq-binds(s, bs, s_let)
  top.VAR_s = bs.VAR_s;
  top.LEX_s = bs.LEX_s;

  -- ok-ness
  top.ok = bs.ok && e.ok;

  -- ignore
  s_let.imp = []; s_let.mod = [];
}

-- associations todo
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

-- associations todo
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
attribute VAR_s occurs on SeqBinds;
attribute LEX_s occurs on SeqBinds;

attribute VAR_s_def occurs on SeqBinds;
attribute LEX_s_def occurs on SeqBinds;

attribute ok occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  -- s not passed nor asserted on
  top.VAR_s = [];
  top.LEX_s = [];

  -- s_def -[ `LEX ]-> s
  -- no LEX assertions, and s_def not passed
  top.VAR_s_def = [];
  top.LEX_s_def = [top.s];
  
  -- ok-ness
  top.ok = true;
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  -- seq-bind(s, b, s_def)
  s.s = top.s;
  top.VAR_s = s.VAR_s;
  top.LEX_s = s.LEX_s;
  top.VAR_s_def = s.VAR_s_def;
  top.LEX_s_def = s.LEX_s_def;

  -- ok-ness
  top.ok = s.ok;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  -- new def'
  local s_def_::SGScope = mkScope(location=top.location);

  -- s_def' -[ `LEX ]-> s, and s_def' is passed to seq-bind as s_def and seq-binds as s
  s_def_.lex = top.s :: (s.LEX_s_def ++ ss.LEX_s);
  s_def_.var = s.VAR_s_def ++ ss.VAR_s;

  -- seq-bind(s, b, s_def')
  s.s = top.s;

  -- seq-binds(s_def', bs, s_def)
  ss.s = s_def_;

  -- s is passed to seq-bind as s
  top.VAR_s = s.VAR_s;
  top.LEX_s = s.LEX_s;

  -- s_def is passed to seq-binds as s_def
  top.VAR_s_def = ss.VAR_s_def;
  top.LEX_s_def = ss.LEX_s_def;

  -- ok-ness
  top.ok = s.ok && ss.ok;

  -- ignore
  s_def_.imp = []; s_def_.mod = [];
}

--------------------------------------------------

attribute s occurs on SeqBind;
attribute VAR_s occurs on SeqBind;
attribute LEX_s occurs on SeqBind;

attribute VAR_s_def occurs on SeqBind;
attribute LEX_s_def occurs on SeqBind;

attribute ok occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  -- new s_var -> DatumVar(x, ty)
  local s_var::SGScope = mkScopeDatum(datumVar(id, e.ty, location=top.location),
                                      location=top.location);

  -- no assertions for s_var, nor is it passed
  s_var.lex = [];
  s_var.var = [];

  -- expr(s, e, ty)
  e.s = top.s;

  -- s is passed to expr as s
  top.VAR_s = e.VAR_s;
  top.LEX_s = e.LEX_s;

  -- s_def -[ `VAR ]-> s_var, not passed
  top.VAR_s_def = [s_var];
  top.LEX_s_def = [];

  -- ok-ness
  top.ok = e.ok;

  -- ignore
  s_var.imp = []; s_var.mod = [];
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  -- new s_var -> DatumVar(x, ty1)
  local s_var::SGScope = mkScopeDatum(datumVar(id, ^ty, location=top.location),
                                      location=top.location);

  -- no assertions from s_var, nor is it passed
  s_var.lex = []; 
  s_var.var = []; 

  -- s is passed to expr as s
  top.VAR_s = e.VAR_s;
  top.LEX_s = e.LEX_s;

  -- s_def -[ `VAR ]-> s_var, not passed
  top.VAR_s_def = [s_var];
  top.LEX_s_def = [];

  -- type(s, tyann, ty1)
  ty.s = top.s;
  local ty1::Type = ty.ty;
  
  -- expr(s, e, ty2)
  e.s = top.s;
  local ty2::Type = e.ty; 

  -- ok-ness, ty1 == ty2
  top.ok = e.ok && ^ty1 == ^ty2;

  -- ignore
  s_var.imp = []; s_var.mod = [];
}

--------------------------------------------------

attribute s occurs on ParBinds;
attribute VAR_s occurs on ParBinds;
attribute LEX_s occurs on ParBinds;

attribute VAR_s_def occurs on ParBinds;
attribute LEX_s_def occurs on ParBinds;

attribute ok occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{ 
  -- no assertions from s, nor is it passed
  top.VAR_s = []; 
  top.LEX_s = []; 

  -- ok-ness
  top.ok = true;
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  -- par-bind(s, b, s_def)
  s.s = top.s;

  -- par-binds(s, b, s_def)
  ss.s = top.s;

  -- s is passed to par-bind and par-binds as s
  top.VAR_s = s.VAR_s ++ ss.VAR_s;
  top.LEX_s = s.LEX_s ++ ss.LEX_s;

  -- s_def is passed to par-bind and par-binds as s_def
  top.VAR_s_def = s.VAR_s_def ++ ss.VAR_s_def;
  top.LEX_s_def = s.LEX_s_def ++ ss.LEX_s_def;

  -- ok-ness
  top.ok = s.ok && ss.ok;
}

--------------------------------------------------

attribute s occurs on ParBind;
attribute VAR_s occurs on ParBind;
attribute LEX_s occurs on ParBind;

attribute VAR_s_def occurs on ParBind;
attribute LEX_s_def occurs on ParBind;

attribute ok occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  -- new s_var -> DatumVar(x, ty)
  local s_var::SGScope = mkScopeDatum(datumVar(id, e.ty, location=top.location),
                                      location=top.location);

  -- no assertions for s_var, nor is it passed
  s_var.lex = [];
  s_var.var = [];

  -- expr(s, e, ty)
  e.s = top.s;

  -- s is passed to expr as s
  top.VAR_s = e.VAR_s;
  top.LEX_s = e.LEX_s;

  -- s_def -[ `VAR ]-> s_var, not passed
  top.VAR_s_def = [s_var];
  top.LEX_s_def = [];

  -- ok-ness
  top.ok = e.ok;

  -- ignore
  s_var.imp = []; s_var.mod = [];
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  -- new s_var -> DatumVar(x, ty1)
  local s_var::SGScope = mkScopeDatum(datumVar(id, ^ty, location=top.location),
                                      location=top.location);

  -- no assertions from s_var, nor is it passed
  s_var.lex = []; 
  s_var.var = []; 

  -- s is passed to expr as s
  top.VAR_s = e.VAR_s;
  top.LEX_s = e.LEX_s;

  -- s_def -[ `VAR ]-> s_var, not passed
  top.VAR_s_def = [s_var];
  top.LEX_s_def = [];

  -- type(s, tyann, ty1)
  ty.s = top.s;
  local ty1::Type = ty.ty;
  
  -- expr(s, e, ty2)
  e.s = top.s;
  local ty2::Type = e.ty; 

  -- ok-ness, ty1 == ty2
  top.ok = e.ok && ^ty1 == ^ty2;

  -- ignore
  s_var.imp = []; s_var.mod = [];
}

--------------------------------------------------

attribute s occurs on ArgDecl;
attribute VAR_s occurs on ArgDecl;
attribute LEX_s occurs on ArgDecl;

attribute ty occurs on ArgDecl;

attribute ok occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  -- new s_var -> DatumVar(x, ty)
  local s_var::SGScope = mkScopeDatum(datumVar(id, tyann.ty, location=top.location),
                                      location=top.location);

  -- no assertions, not passed
  s_var.lex = []; s_var.var = [];
  
  -- type(s, tyann, ty)
  tyann.s = top.s;
  top.ty = tyann.ty;

  -- s -[ `VAR ]-> s_var, s is passed to type as s
  top.VAR_s = s_var :: tyann.VAR_s;
  top.LEX_s = tyann.LEX_s;

  -- ok-ness
  top.ok = true;

  -- ignore
  s_var.imp = []; s_var.mod = [];
}

--------------------------------------------------

attribute s occurs on Type;
attribute VAR_s occurs on Type;
attribute LEX_s occurs on Type;

attribute ty occurs on Type;

attribute ok occurs on Type;

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  -- type(s, tyann1, ty1)
  tyann1.s = top.s;
  local ty1::Type = tyann1.ty;

  -- type(s, tyann2, ty2)
  tyann2.s = top.s;
  local ty2::Type = tyann2.ty;

  -- ty == FUN(ty1, ty2)
  top.ty = tFun(^ty1, ^ty2);

  -- no assertions on s, passed to type and type as s
  top.VAR_s = tyann1.VAR_s ++ tyann2.VAR_s;
  top.LEX_s = tyann1.LEX_s ++ tyann2.LEX_s;

  -- ok-ness
  top.ok = true;
}

aspect production tInt
top::Type ::=
{ 
  -- ty == INT()
  top.ty = tInt();

  -- no assertions on s, not passed
  top.VAR_s = [];
  top.LEX_s = [];

  -- ok-ness
  top.ok = true; 
}

aspect production tBool
top::Type ::=
{ 
  -- ty == INT()
  top.ty = tBool();

  -- no assertions on s, not passed
  top.VAR_s = [];
  top.LEX_s = [];

  -- ok-ness
  top.ok = true; 
}

aspect production tErr
top::Type ::=
{ 
  -- ty == ERR()
  top.ty = ^top;

  -- no assertions on s, not passed
  top.VAR_s = [];
  top.LEX_s = [];

  -- ok-ness
  top.ok = false;
}

--------------------------------------------------

attribute s occurs on VarRef;
attribute VAR_s occurs on VarRef;
attribute LEX_s occurs on VarRef;

attribute p occurs on VarRef;

attribute ok occurs on VarRef;

aspect production varRef
top::VarRef ::= name::String
{
  -- query s `LEX* `VAR as vars
  -- filter vars (DatumVar(x', _) where x' == x) xvars
  -- min-refs(xvars, xvars')
  local xvars_::[Path] = query(
    top.s, 
    varRefDFA(), 
    \d::SGDatum -> case d of 
                   | datumVar(x, _) -> x == name 
                   | _ -> false 
                   end
  );

  -- only(xvars_, p)
  local onlyResult::(Boolean, Path) = onlyPath(xvars_);
  top.p = onlyResult.2;

  -- no assertions, not passed
  top.VAR_s = [];
  top.LEX_s = [];

  -- ok-ness
  top.ok = onlyResult.1;
}
