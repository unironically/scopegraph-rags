grammar lmr3:lmr:nameanalysis1;

imports syntax:lmr1:lmr:abstractsyntax;
imports sg_lib1:src;

import silver:langutil; -- for location.unparse

--------------------------------------------------

monoid attribute ok::Boolean with true, &&;

inherited attribute scope::Decorated Scope;

synthesized attribute VAR_s::[Decorated Scope];
synthesized attribute LEX_s::[Decorated Scope];
synthesized attribute MOD_s::[Decorated Scope];
synthesized attribute IMP_s::[Decorated Scope];

synthesized attribute type::Type;

synthesized attribute mod::Maybe<Decorated Scope>;

--------------------------------------------------

attribute ok occurs on Main;

propagate ok on Main;

aspect production program
top::Main ::= ds::Decls
{
  production attribute globScope::Scope = scopeNoData();
  globScope.lex = [];
  globScope.var = ds.VAR_s;
  globScope.mod = ds.MOD_s;
  globScope.imp = ds.IMP_s;

  ds.scope = globScope;
}

--------------------------------------------------

attribute ok, scope, VAR_s, MOD_s, IMP_s occurs on Decls;

propagate ok on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.scope = top.scope;
  ds.scope = top.scope;

  top.VAR_s = d.VAR_s ++ ds.VAR_s;
  top.MOD_s = d.MOD_s ++ ds.MOD_s;
  top.IMP_s = d.IMP_s ++ ds.IMP_s;
}

aspect production declsNil
top::Decls ::=
{
  top.VAR_s = [];
  top.MOD_s = [];
  top.IMP_s = [];
}

--------------------------------------------------

attribute scope occurs on Decl;

attribute VAR_s occurs on Decl;
attribute MOD_s occurs on Decl;
attribute IMP_s occurs on Decl;

attribute ok occurs on Decl;
propagate ok on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  production attribute modScope::Scope = scopeMod(id);
  modScope.lex = [top.scope];
  modScope.var = ds.VAR_s;
  modScope.mod = ds.MOD_s;
  modScope.imp = ds.IMP_s;

  ds.scope = modScope;

  top.VAR_s = [];
  top.MOD_s = [modScope];
  top.IMP_s = [];
}

aspect production declImport
top::Decl ::= r::ModRef
{
  r.scope = top.scope;

  top.VAR_s = [];
  top.MOD_s = [];
  top.IMP_s = case r.mod of
              | just(s) -> [s]
              | _ -> []
              end;
}

aspect production declDef
top::Decl ::= b::ParBind
{
  b.scope = top.scope;

  top.VAR_s = b.VAR_s;
  top.MOD_s = [];
  top.IMP_s = [];
}

--------------------------------------------------

attribute scope occurs on Expr;

attribute type occurs on Expr;

attribute ok occurs on Expr;
propagate ok on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.type = tInt();
}

aspect production exprTrue
top::Expr ::=
{
  top.type= tBool();
}

aspect production exprFalse
top::Expr ::=
{
  top.type= tBool();
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  propagate scope;

  top.type = r.type;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, tInt())
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, tInt())
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, tInt())
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, tInt())
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tBool(), tBool() -> (true, tBool())
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tBool(), tBool() -> (true, tBool())
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | t1, t2 when t1 == t2 -> (true, tBool())
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tFun(t1, t2), t3 when ^t1 == t3 -> (true, ^t2)
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  propagate scope;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type, e3.type of
                                   | tBool(), t2, t3 when t2 == t3 -> (true, t2)
                                   | _, _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  production attribute bodyScope::Scope = scopeNoData();
  bodyScope.lex = [top.scope];
  bodyScope.var = d.VAR_s;
  bodyScope.mod = [];
  bodyScope.imp = [];

  d.scope = top.scope;
  e.scope = bodyScope;

  top.type = tFun(d.type, e.type);
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  production attribute letScope::Decorated Scope = bs.lastScope;

  bs.scope = top.scope;
  e.scope = letScope;

  top.type = e.type;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  production attribute letScope::Scope = scopeNoData();
  letScope.lex = [top.scope];
  letScope.var = bs.VAR_s;
  letScope.mod = [];
  letScope.imp = [];


  bs.scope = letScope;
  e.scope = letScope;

  top.type = e.type;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  production attribute letScope::Scope = scopeNoData();
  letScope.lex = [top.scope];
  letScope.var = bs.VAR_s;
  letScope.mod = [];
  letScope.imp = [];

  bs.scope = top.scope;
  e.scope = letScope;

  top.type = e.type;
}

--------------------------------------------------

attribute ok, scope, lastScope occurs on SeqBinds;

propagate ok on SeqBinds;

synthesized attribute lastScope::Decorated Scope;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.lastScope = top.scope;
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  production attribute sbScope::Scope = scopeNoData();
  sbScope.lex = [top.scope];
  sbScope.var = s.VAR_s;
  sbScope.mod = [];
  sbScope.imp = [];

  s.scope = top.scope;

  top.lastScope = sbScope;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  production attribute sbScope::Scope = scopeNoData();
  sbScope.lex = [top.scope];
  sbScope.var = s.VAR_s;
  sbScope.mod = [];
  sbScope.imp = [];

  s.scope = top.scope;
  ss.scope = sbScope;

  top.lastScope = ss.lastScope;
}

--------------------------------------------------

attribute ok, scope, VAR_s occurs on SeqBind;

propagate ok on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  production attribute varScope::Scope = scopeVar(id, e.type);
  varScope.lex = [];
  varScope.var = [];
  varScope.mod = [];
  varScope.imp = [];

  e.scope = top.scope;

  top.VAR_s = [varScope];
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  production attribute varScope::Scope = scopeVar(id, ^ty);
  varScope.lex = [];
  varScope.var = [];
  varScope.mod = [];
  varScope.imp = [];

  e.scope = top.scope;

  top.ok <- e.type == ^ty;
  top.VAR_s = [varScope];
}

--------------------------------------------------

attribute ok, scope, VAR_s occurs on ParBinds;

propagate ok, scope on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.VAR_s = [];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  top.VAR_s = s.VAR_s ++ ss.VAR_s;
}

--------------------------------------------------

attribute ok, scope, VAR_s occurs on ParBind;

propagate ok on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  production attribute varScope::Scope = scopeVar(id, e.type);
  varScope.lex = [];
  varScope.var = [];
  varScope.mod = [];
  varScope.imp = [];

  e.scope = top.scope;

  top.VAR_s = [varScope];
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  production attribute varScope::Scope = scopeVar(id, ^ty);
  varScope.lex = [];
  varScope.var = [];
  varScope.mod = [];
  varScope.imp = [];

  e.scope = top.scope;

  top.ok <- e.type == ^ty;
  top.VAR_s = [varScope];
}

--------------------------------------------------

attribute ok, scope, type, VAR_s occurs on ArgDecl;

propagate ok on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  production attribute varScope::Scope = scopeVar(id, ^tyann);
  varScope.lex = [];
  varScope.var = [];
  varScope.mod = [];
  varScope.imp = [];

  top.type = ^tyann;
  top.VAR_s = [varScope];
}

--------------------------------------------------

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{}

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

attribute ok, scope, type occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local xvars_::[Decorated Scope] =
    query(top.scope, varRefDFA(),
          \d::Datum -> case d of 
                       | datumVar(name, _) -> x == name 
                       | _ -> false 
                       end);

  local okAndRes::(Boolean, Type) = 
    if length(xvars_) < 1
    then unsafeTracePrint((false, tErr()), "[✗] " ++ top.location.unparse ++ 
                          ": error: unresolvable variable reference '" ++ x ++ "'\n")
    else if length(xvars_) > 1
    then unsafeTracePrint((false, tErr()), "[✗] " ++ top.location.unparse ++ 
                          ": error: ambiguous variable reference '" ++ x ++ "'\n")
    else case head(xvars_).datum of
         | datumVar(_, ty) -> (true, ^ty)
         | _ -> (false, tErr())
         end;

  top.ok := okAndRes.1;
  top.type = okAndRes.2;
}

--------------------------------------------------

attribute scope, ok, mod occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  local xmods_::[Decorated Scope] =
    query(top.scope, modRefDFA(), 
          \d::Datum -> case d of 
                       | datumMod(name) -> x == name 
                       | _ -> false 
                       end);

  local okAndRes::(Boolean, Maybe<Decorated Scope>) = 
    if length(xmods_) < 1
    then unsafeTracePrint((false, nothing()), "[✗] " ++ top.location.unparse ++ 
                          ": error: unresolvable module reference '" ++ x ++ "'\n")
    else if length(xmods_) > 1
    then unsafeTracePrint((false, nothing()), "[✗] " ++ top.location.unparse ++ 
                          ": error: ambiguous module reference '" ++ x ++ "'\n")
    else case head(xmods_).datum of
         | datumMod(_) -> (true, just(head(xmods_)))
         | _ -> (false, nothing())
         end;

  top.ok := okAndRes.1;
  top.mod = okAndRes.2;
}