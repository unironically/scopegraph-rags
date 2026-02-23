grammar lmr0:lmr:nameanalysis9;

imports syntax:lmr0:lmr:abstractsyntax;

import silver:langutil; -- for location.unparse

--------------------------------------------------

inherited attribute s::LMScope occurs on
  Decls, Decl, ParBind, Expr, VarRef;
propagate s on Decls, Decl, Expr;

monoid attribute s_var::[LMScope] occurs on
  Decls, Decl, ParBind;
propagate s_var on Decls, Decl, ParBind;

--------------------------------------------------

monoid attribute ok::Boolean with true, && occurs on Main, Decls, Decl, ParBind, Expr, VarRef;
propagate ok on Main, Decls, Decl, ParBind, Expr, VarRef;

synthesized attribute type::Type occurs on Expr, VarRef;

--------------------------------------------------

-- causes a cycle if this is used instead of the attr occurrence decls above:
-- attribute ok occurs on Main;
-- propagate ok on Main;

aspect production program
top::Main ::= ds::Decls
{
  -- mkscope globScope;
  local globScope::LMScopeUndec = mkScope(noDatum());
  globScope.lex = [];
  globScope.var = ds.s_var;

  ds.s = globScope;
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

aspect production declDef
top::Decl ::= b::ParBind
{
}

--------------------------------------------------

aspect production exprInt
top::Expr ::= i::Integer
{
  top.type = tInt();
}

aspect production exprTrue
top::Expr ::=
{
  top.type = tBool();
}

aspect production exprFalse
top::Expr ::=
{
  top.type = tBool();
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  top.type = r.type;
}

{-aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

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
  e1.s = top.s;
  e2.s = top.s;

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
  e1.s = top.s;
  e2.s = top.s;

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
  e1.s = top.s;
  e2.s = top.s;

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
  e1.s = top.s;
  e2.s = top.s;

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
  e1.s = top.s;
  e2.s = top.s;

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
  e1.s = top.s;
  e2.s = top.s;

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
  e1.s = top.s;
  e2.s = top.s;

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
  e1.s = top.s;
  e2.s = top.s;

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
  mkscope bodyScope;
  bodyScope -[ lex ]-> top.s;

  d.s = top.s;
  e.s = bodyScope;

  top.type = tFun(d.type, e.type);
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  mkscope letScope;

  bs.s = top.s;
  bs.s_last = letScope;

  e.s = letScope;

  top.type = e.type;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  mkscope letScope;
  letScope -[ lex ]-> top.s;

  bs.s = letScope;
  bs.s_def = letScope;

  e.s = letScope;

  top.type = e.type;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  mkscope letScope;

  bs.s = top.s;
  bs.s_def = letScope;

  e.s = letScope;

  top.type = e.type;
}

--------------------------------------------------

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.s_last -[ lex ]-> top.s;
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  top.s_last -[ lex ]-> top.s;

  s.s = top.s;
  s.s_def = top.s_last;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  mkscope sbScope;
  sbScope -[ lex ]-> top.s;

  s.s = top.s;
  s.s_def = sbScope;

  ss.s = sbScope;
  ss.s_last = top.s_last;
}

--------------------------------------------------

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  mkscope varScope -> id |-> e.type;

  top.s_def -[ var ]-> varScope;

  e.s = top.s;

  top.ok <- e.type != tErr();
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  mkscope varScope -> id |-> ^ty;

  top.s_def -[ var ]-> varScope;

  e.s = top.s;

  top.ok <- e.type == ^ty;
}

--------------------------------------------------

aspect production parBindsNil
top::ParBinds ::=
{
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.s = top.s;
  s.s_def = top.s_def;

  ss.s = top.s;
  ss.s_def = top.s_def;
}-}

--------------------------------------------------

{- Extension syntax:

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{

  mkscope var dcl -> (id, e.type);

  top.s -[ var ]-> dcl;

  e.s = top.s;
}

-}

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  -- mkscope var dcl -> (id, e.type);
  local dcl::LMScopeUndec = mkScope(var((id, e.type)));
  dcl.lex = [];
  dcl.var = [];

  -- top.s -[ var ]-> dcl;
  top.s_var <- [dcl];

  e.s = top.s;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  -- mkscope var dcl -> (id, ^ty);
  local dcl::LMScopeUndec = mkScope(var((id, ^ty)));
  dcl.lex = [];
  dcl.var = [];

  -- top.s -[ var ]-> dcl;
  top.s_var <- [dcl];

  e.s = top.s;

  top.ok <- ^ty == e.type;
}


--------------------------------------------------

{-aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  mkscope varScope -> id |-> ^ty;

  top.s -[ var ]-> varScope;

  top.type = ^ty;
}-}

--------------------------------------------------

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
}

aspect production tInt
top::Type ::=
{
}

aspect production tBool
top::Type ::=
{
}

aspect production tErr
top::Type ::=
{
}

--------------------------------------------------

{- Extension syntax:

aspect production varRef
top::VarRef ::= x::String
{
  -- statix: `query ...`
  local vars::[LMScope] =
    resolve(isName(x), `lex* . var`, top.s);

  -- statix: `only(onlyDcl, vars)`
  local onlyDcl::LMScope =
    if top.ok
    then head(vars)
    else blankScope;

  -- statix: `onlyDcl -> (_, type)` (no notion of default). what about lex here?
  local datum::(String, Type) <- onlyDcl | ("", tErr()) as var;
  top.type = datum.2;

  top.ok <- length(vars) == 1;
}

-}

aspect production varRef
top::VarRef ::= x::String
{
  -- statix: `query ...`
  local vars::[LMScope] =
    resolve(
      isName(x),
      regexCat(regexStar(regexLabel(label_lex())),
               regexLabel(label_var())),
      top.s
    );
  
  -- statix: `only(onlyDcl, vars)`
  local onlyDcl::LMScope =
    if top.ok
    then head(vars)
    else blankScope; -- blankScope is a generated global, scope with no data

  -- statix: `onlyDcl -> (_, type)` (no notion of default)
  local datum::(String, Type) = collectVarData(onlyDcl, ("", tErr()));
  top.type = datum.2;

  top.ok <- length(vars) == 1;
}
