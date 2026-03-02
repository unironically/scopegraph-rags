grammar lmr1:lmr:translation;

imports syntax:lmr1:lmr:abstractsyntax;
imports lmr1:lmr:nameanalysis_extension;

--------------------------------------------------

synthesized attribute translation::String occurs on
  Main, Decls, Decl, Module, Expr, SeqBinds, ParBinds, Bind, Type, ModRef, VarRef;

inherited attribute tab::String occurs on Decls, Decl, Module;

--------------------------------------------------

aspect production program
top::Main ::= ds::Decls
{
  top.translation = ds.translation;

  ds.tab = "";
}

--------------------------------------------------

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  top.translation = 
    d.translation ++ "\n" ++
    ds.translation;

  d.tab = top.tab;
  ds.tab = top.tab;
}

aspect production declsNil
top::Decls ::=
{
  top.translation = "";
}

--------------------------------------------------

aspect production declModule
top::Decl ::= m::Module
{
  m.tab = top.tab;
  top.translation = m.translation;
}

aspect production declImport
top::Decl ::= mr::ModRef
{
  top.translation = top.tab ++ mr.translation;
}

aspect production declDef
top::Decl ::= b::Bind
{
  top.translation = top.tab ++ "let " ++ b.translation;
}

--------------------------------------------------

aspect production module
top::Module ::= x::String ds::Decls
{
  top.translation =
    top.tab ++ "module Mod_" ++ x ++ " = struct\n" ++
    ds.translation ++
    top.tab ++ "end";

  ds.tab = top.tab ++ "\t";
}

--------------------------------------------------

aspect production exprFloat
top::Expr ::= f::Float
{
  top.translation = toString(f);
}

aspect production exprInt
top::Expr ::= i::Integer
{
  top.translation = toString(i);
}

aspect production exprTrue
top::Expr ::=
{
  top.translation = "true";
}

aspect production exprFalse
top::Expr ::=
{
  top.translation = "false";
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  top.translation = r.translation;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  top.translation =
    "(" ++
      case e1.type, e2.type of
      | tFloat(), tFloat() ->
          e1.translation ++ " +. " ++ e2.translation
      | tFloat(), tInt() ->
          e1.translation ++ " +. (float_of_int " ++ e2.translation ++ ")"
      | tInt(), tFloat() ->
          "(float_of_int " ++ e1.translation ++ ") +. " ++ e2.translation
      | _, _ ->
          e1.translation ++ " + " ++ e2.translation
      end ++
    ")";
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  top.translation = "(" ++ e1.translation ++ " && " ++ e2.translation ++ ")";
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  top.translation = "(" ++ e1.translation ++ " = " ++ e2.translation ++ ")";
}

aspect production exprFun
top::Expr ::= b::Bind e::Expr
{
  top.translation = "(" ++ b.translation ++ " -> " ++ e.translation ++ ")"; 
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  top.translation = "(" ++ e1.translation ++ " " ++ e2.translation ++ ")";
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  top.translation = "if " ++ e1.translation ++ 
                    " then " ++ e2.translation ++
                    " else " ++ e3.translation;
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  top.translation = bs.translation ++ e.translation;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  top.translation = bs.translation ++ e.translation;

  bs.isFirst = true;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  top.translation = error("exprLetPar.translation TODO");

  bs.isFirst = true;
}

--------------------------------------------------

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.translation = "";
}

aspect production seqBindsOne
top::SeqBinds ::= s::Bind
{
  top.translation = "let " ++ s.translation ++ " in ";
}

aspect production seqBindsCons
top::SeqBinds ::= s::Bind ss::SeqBinds
{
  top.translation = "let " ++ s.translation ++ " in " ++ ss.translation;
}

--------------------------------------------------

inherited attribute isFirst::Boolean occurs on ParBinds;
synthesized attribute liftedExprs::[(String, Decorated Expr with {s})] occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.translation = "";

  top.liftedExprs = [];
}

aspect production parBindsOne
top::ParBinds ::= s::Bind
{
  top.translation =
    (if top.isFirst then "let " else " and ") ++
    s.translation ++ " in ";

  top.liftedExprs = [s.liftedExpr];
}

aspect production parBindsCons
top::ParBinds ::= s::Bind ss::ParBinds
{
  top.translation = 
    (if top.isFirst then "let rec " else " and ") ++
    s.translation ++ ss.translation;

  top.liftedExprs = s.liftedExpr :: ss.liftedExprs;

  ss.isFirst = false;
}

--------------------------------------------------

synthesized attribute liftedExpr::(String, Decorated Expr with {s}) occurs on Bind;

aspect production bindUntyped
top::Bind ::= x::String e::Expr
{
  top.translation = 
    x ++ " = " ++
    if top.isRec
    then "lazy (" ++ e.translation ++ ")"
    else e.translation;

  top.liftedExpr = (x, e);
}

aspect production bindTyped
top::Bind ::= tyann::Type x::String e::Expr
{
  top.translation = 
    x ++ ": " ++ tyann.translation ++ " = " ++ 
    if top.isRec
    then "lazy (" ++ e.translation ++ ")"
    else e.translation;

  top.liftedExpr = (x, e);
}

aspect production bindArgDcl
top::Bind ::= x::String tyann::Type
{
  top.translation = "fun " ++ x ++ ":" ++ tyann.translation;

  top.liftedExpr = error("Impossible! bindArgDcl.liftedExpr");
}

--------------------------------------------------

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  top.translation =
    case tyann1 of
    | tFun(_, _) -> "(" ++ tyann1.translation ++ ") -> " ++ tyann2.translation
    | _ -> tyann1.translation ++ " -> " ++ tyann2.translation
    end;
}

aspect production tFloat
top::Type ::=
{
  top.translation = "float";
}

aspect production tInt
top::Type ::=
{
  top.translation = "int";
}

aspect production tBool
top::Type ::=
{
  top.translation = "bool";
}

aspect production tErr
top::Type ::=
{
  top.translation = error("tErr.translation demanded");
}

--------------------------------------------------

aspect production modRef
top::ModRef ::= x::String
{
  top.translation = "open Mod_" ++ x;
}

--------------------------------------------------

aspect production varRef
top::VarRef ::= x::String
{
  top.translation = 
    if bindNode.isRec
    then "(Lazy.force " ++ x ++ ")"
    else x;
}
