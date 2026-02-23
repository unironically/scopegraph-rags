grammar lmr0:lmr:nameanalysis_extension;

imports syntax:lmr0:lmr:abstractsyntax;

import silver:langutil; -- for location.unparse

--------------------------------------------------

scopegraph LMGraph labels lex, var;

scope attribute LMGraph:s;
attribute s occurs on Decls, Decl, SeqBinds, SeqBind, ParBinds, ParBind, Expr,
  ArgDecl, VarRef;

scope attribute LMGraph:s_def;
attribute s_def occurs on SeqBind, ParBinds, ParBind;

scope attribute LMGraph:s_last;
attribute s_last occurs on SeqBinds;

--------------------------------------------------

monoid attribute ok::Boolean with true, && occurs on Main, Decls, Decl, ParBind, 
  Expr, VarRef, ArgDecl, SeqBind, SeqBinds, ParBinds;

propagate ok on Main, Decls, Decl, ParBind, Expr, VarRef, ArgDecl, SeqBind,
  SeqBinds, ParBinds;

synthesized attribute type::Type occurs on Expr, ArgDecl, VarRef;

--------------------------------------------------

aspect production program
top::Main ::= ds::Decls
{
  newScope glob::LMGraph -> datumLex();

  ds.s = glob;
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
  e3.s = top.s;

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
  newScope bodyScope::LMGraph -> datumLex();

  bodyScope -[ lex ]-> top.s;

  d.s = top.s;
  e.s = bodyScope;

  top.type = tFun(d.type, e.type);
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  exists scope LMGraph:s_last;

  bs.s = top.s;
  bs.s_last = s_last;

  e.s = s_last;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  newScope s_let::LMGraph -> datumLex();

  s_let -[ lex ]-> top.s;

  bs.s = s_let;
  bs.s_def = s_let;

  e.s = s_let;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  newScope s_let::LMGraph -> datumLex();

  s_let -[ lex ]-> top.s;

  bs.s = top.s;
  bs.s_def = s_let;

  e.s = s_let;
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
  newScope top.s_last::LMGraph -> datumLex();

  top.s_last -[ lex ]-> top.s;

  s.s = top.s;
  s.s_def = top.s_last;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  newScope next::LMGraph -> datumLex();
  next -[ lex ]-> top.s;

  s.s = top.s;
  s.s_def = next;

  ss.s = next;
  ss.s_last = top.s_last;
}

--------------------------------------------------

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  newScope dcl::LMGraph -> datumVar(id, e.type);

  top.s_def -[ var ]-> dcl;

  e.s = top.s;
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  newScope dcl::LMGraph -> datumVar(id, ^ty);

  top.s_def -[ var ]-> dcl;

  e.s = top.s;

  top.ok <- ^ty == e.type;
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
  newScope dcl::LMGraph -> datumVar(id, e.type);

  top.s -[ var ]-> dcl;

  e.s = top.s;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  newScope dcl::LMGraph -> datumVar(id, ^ty);

  top.s -[ var ]-> dcl;

  e.s = top.s;

  top.ok <- ^ty == e.type;
}


--------------------------------------------------

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  newScope varScope::LMGraph -> datumVar(id, ^ty);

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
  local vars::[Decorated Scope with LMGraph] =
    visible(
      \d::Datum -> case d of datumVar(x_, _) -> x_ == x | _ -> false end,
      `lex* . var`::LMGraph,
      `lex > var`::LMGraph,
      top.s
    );

  nondecorated local headTy::Type = case head(vars).datum of 
                                    | datumVar(_, t) -> ^t 
                                    | _ -> error("Oh no! (varRef)")
                                    end;
  
  top.type = if top.ok then headTy else tErr();

  top.ok <- length(vars) == 1;
}
