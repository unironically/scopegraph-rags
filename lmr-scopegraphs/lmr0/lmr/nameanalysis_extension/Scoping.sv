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
  b.s_def = top.s;
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
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  top.ok <- ty1 == tInt();
  top.ok <- ty2 == tInt();

  top.type = tInt();
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  top.ok <- ty1 == tInt();
  top.ok <- ty2 == tInt();

  top.type = tInt();
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  top.ok <- ty1 == tInt();
  top.ok <- ty2 == tInt();

  top.type = tInt();
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  top.ok <- ty1 == tInt();
  top.ok <- ty2 == tInt();

  top.type = tInt();
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  top.ok <- ty1 == tBool();
  top.ok <- ty2 == tBool();

  top.type = tBool();
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  top.ok <- ty1 == tBool();
  top.ok <- ty2 == tBool();

  top.type = tBool();
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  top.ok <- ty1 == ty2;

  top.type = tBool();
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  local ty3and4::(Boolean, Type, Type) = 
    case ty1 of
    | tFun(ty3, ty4) -> (true, ^ty3, ^ty4)
    | _ -> (false, tErr(), tErr())
    end;
  top.ok <- ty3and4.1;
  nondecorated local ty3::Type = ty3and4.2;
  nondecorated local ty4::Type = ty3and4.3;

  top.ok <- ty2 == ty3;

  top.type = ty4;
}


aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  e3.s = top.s;
  nondecorated local ty3::Type = e3.type;

  top.ok <- ty1 == tBool();
  top.ok <- ty2 == ty3;

  top.type = ty2;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  newScope s_fun::LMGraph -> datumLex();

  s_fun -[ lex ]-> top.s;

  d.s = s_fun;
  nondecorated local ty1::Type = d.type;

  e.s = s_fun;
  nondecorated local ty2::Type = e.type;

  top.type = tFun(ty1, ty2);
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  existsScope LMGraph:s_last;

  bs.s = top.s;
  bs.s_last = s_last;

  e.s = s_last;

  top.type = e.type;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  newScope s_let::LMGraph -> datumLex();

  s_let -[ lex ]-> top.s;

  bs.s = s_let;
  bs.s_def = s_let;

  e.s = s_let;

  top.type = e.type;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  newScope s_let::LMGraph -> datumLex();

  s_let -[ lex ]-> top.s;

  bs.s = top.s;
  bs.s_def = s_let;

  e.s = s_let;

  top.type = e.type;
}

--------------------------------------------------

aspect production seqBindsNil
top::SeqBinds ::=
{
  newScope top.s_last::LMGraph -> datumLex();

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
  newScope s_next::LMGraph -> datumLex();
  s_next -[ lex ]-> top.s;

  s.s = top.s;
  s.s_def = s_next;

  ss.s = s_next;
  ss.s_last = top.s_last;
}

--------------------------------------------------

aspect production seqBindUntyped
top::SeqBind ::= x::String e::Expr
{
  newScope s_dcl::LMGraph -> datumVar(x, ty);

  top.s_def -[ var ]-> s_dcl;

  nondecorated local ty::Type = e.type;
  e.s = top.s;
}

aspect production seqBindTyped
top::SeqBind ::= tyann::Type x::String e::Expr
{
  newScope s_dcl::LMGraph -> datumVar(x, ty1);

  top.s_def -[ var ]-> s_dcl;

  nondecorated local ty1::Type = ^tyann;

  nondecorated local ty2::Type = e.type;
  e.s = top.s;

  top.ok <- ty1 == ty2;
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
top::ParBind ::= x::String e::Expr
{
  newScope s_dcl::LMGraph -> datumVar(x, ty);

  top.s_def -[ var ]-> s_dcl;

  nondecorated local ty::Type = e.type;
  e.s = top.s;
}

aspect production parBindTyped
top::ParBind ::= tyann::Type x::String e::Expr
{
  newScope s_dcl::LMGraph -> datumVar(x, ty1);

  top.s_def -[ var ]-> s_dcl;

  nondecorated local ty1::Type = ^tyann;

  nondecorated local ty2::Type = e.type;
  e.s = top.s;

  top.ok <- ty1 == ty2;
}

--------------------------------------------------

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  newScope s_dcl::LMGraph -> datumVar(id, ty);

  nondecorated local ty::Type = ^tyann;

  top.type = ty;

  top.s -[ var ]-> s_dcl;
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
  -- does ministatix query, filter and min-refs constraints
  local vars::[Decorated Scope with LMGraph] =
    visible(
      \d::Datum -> case d of datumVar(x_, _) -> x_ == x | _ -> false end,
      `lex* . var`::LMGraph,
      `lex > var`::LMGraph,
      top.s
    );

  -- does ministatix only and tgt
  nondecorated local s_res::(Boolean, Decorated Scope with LMGraph) =
    case vars of
    | h::[] -> (true, h)
    | _ -> (false, deadScope)
    end;

  -- ministatix datum assertion `s_res -> DatumVar(x, ty')`
  nondecorated local res_ty::Type = case s_res.2.datum of 
                                    | datumVar(_, t) -> ^t 
                                    | _ -> tErr()
                                    end;
  
  top.type = res_ty;

  top.ok <- s_res.1;
}
