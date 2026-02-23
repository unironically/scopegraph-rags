grammar lmr0:lmr:nameanalysis6;

imports syntax:lmr0:lmr:abstractsyntax;

import silver:langutil; -- for location.unparse

--------------------------------------------------

scope attribute s occurs on Decls, Decl, Expr, SeqBinds, SeqBind, ParBinds, 
                            ParBind, ArgDecl, VarRef;
scope attribute s_last occurs on SeqBinds;
scope attribute s_def occurs on SeqBind, ParBinds, ParBind;

monoid attribute ok::Boolean with true, && occurs on 
  Main, Decls, Decl, Expr, SeqBinds, SeqBind, ParBinds, ParBind, ArgDecl,VarRef;
propagate ok on Main, Decls, Decl, Expr, SeqBinds, SeqBind, ParBinds, ParBind,
                ArgDecl, VarRef;

synthesized attribute type::Type occurs on Expr, VarRef, ArgDecl;

--------------------------------------------------

-- causes a cycle if this is used instead of the attr occurrence decls above:
-- attribute ok occurs on Main;
-- propagate ok on Main;

aspect production program
top::Main ::= ds::Decls
{
  mkscope globScope;

  ds.s = globScope;
}

--------------------------------------------------

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.s = top.s;
  ds.s = top.s;
}

aspect production declsNil
top::Decls ::=
{
}

--------------------------------------------------

aspect production declDef
top::Decl ::= b::ParBind
{
  b.s = top.s;
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
  r.s = top.s;

  top.type = r.type;
}

aspect production exprAdd
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
}

--------------------------------------------------

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  mkscope varScope -> id |-> e.type;

  top.s_def -[ var ]-> varScope;

  e.s = top.s;

  top.ok <- e.type != tErr();
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  mkscope varScope -> id |-> ^ty;

  top.s_def -[ var ]-> varScope;

  e.s = top.s;

  top.ok <- e.type == ^ty;
}


--------------------------------------------------

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  mkscope varScope -> id |-> ^ty;

  top.s -[ var ]-> varScope;

  top.type = ^ty;
}

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

aspect production varRef
top::VarRef ::= x::String
{
  local xvars_::[MyScope] = visible(
    isName(x), 
    `lex* . var`, 
    `lex > var`,
    top.s
  );

  local okAndRes::(Boolean, Type) = 
    if length(xvars_) < 1
    then unsafeTracePrint((false, tErr()), "[✗] " ++ top.location.unparse ++ 
                          ": error: unresolvable variable reference '" ++ x ++ "'\n")
    else if length(xvars_) > 1
    then unsafeTracePrint((false, tErr()), "[✗] " ++ top.location.unparse ++ 
                          ": error: ambiguous variable reference '" ++ x ++ "'\n")
    else unsafeTracePrint((true, tInt()), "[✓] successfully resolved '" ++ x ++ "'\n"); -- temporary

  top.ok := okAndRes.1;
  top.type = okAndRes.2;
}