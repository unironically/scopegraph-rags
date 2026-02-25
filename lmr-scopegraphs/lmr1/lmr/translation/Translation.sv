grammar lmr1:lmr:translation;

imports syntax:lmr1:lmr:abstractsyntax;
imports lmr1:lmr:nameanalysis_extension;

--------------------------------------------------

synthesized attribute translation::String occurs on
  Main,
  Decls,
  Decl,
  Expr,
  SeqBinds,
  ParBinds,
  Bind,
  ArgDecl,
  Type,
  ModRef,
  VarRef;

inherited attribute tab::String occurs on Decls, Decl;

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
top::Decl ::= name::String ds::Decls
{
  top.translation =
    top.tab ++ "module Mod_" ++ name ++ " = struct\n" ++
    ds.translation ++
    top.tab ++ "end";

  ds.tab = top.tab ++ "\t";
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
    case e1.type, e2.type of
    | tFloat(), tFloat() ->
        e1.translation ++ " +. " ++ e2.translation
    | tFloat(), tInt() ->
        e1.translation ++ " +. (float_of_int " ++ e2.translation ++ ")"
    | tInt(), tFloat() ->
        "(float_of_int " ++ e1.translation ++ ") +. " ++ e2.translation
    | _, _ ->
        e1.translation ++ " + " ++ e2.translation
    end;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  top.translation = e1.translation ++ " && " ++ e2.translation;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  top.translation = e1.translation ++ " = " ++ e2.translation;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  top.translation = "(" ++ d.translation ++ " -> " ++ e.translation ++ ")"; 
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  top.translation = e1.translation ++ " " ++ e2.translation;
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
  local pre::String = if null(bs.liftedExprs) then "" else foldr(
    \pair::(String, Decorated Expr) acc::String ->
      "let " ++ pair.1 ++ "_unpar = " ++ pair.2.translation ++ " in " ++ acc,
    "",
    bs.liftedExprs
  );

  top.translation = pre ++ bs.translation ++ e.translation;

  bs.isFirst = true;
}

aspect default production top::Expr ::=
{
  top.translation = error("unimplemented Expr translation");
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
synthesized attribute liftedExprs::[(String, Decorated Expr)] occurs on ParBinds;

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
  ss.seqRecPar = top.seqRecPar;
}

--------------------------------------------------

synthesized attribute liftedExpr::(String, Decorated Expr) occurs on Bind;

aspect production bindUntyped
top::Bind ::= x::String e::Expr
{
  top.translation = 
    "var_" ++ x ++ " = " ++ 
    if top.seqRecPar == 1
    then "lazy (" ++ e.translation ++ ")"
    else if top.seqRecPar == 2
    then "lazy (" ++ x ++ "_unpar)"
    else e.translation;

  top.liftedExpr = (x, e);
}

aspect production bindTyped
top::Bind ::= tyann::Type x::String e::Expr
{
  top.translation = 
    "var_" ++ x ++ ": " ++ tyann.translation ++ " = " ++ 
    if top.seqRecPar == 1
    then "lazy (" ++ e.translation ++ ")"
    else if top.seqRecPar == 2
    then "lazy (" ++ x ++ "_unpar)"
    else e.translation;

  top.liftedExpr = (x, e);
}

--------------------------------------------------

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  top.translation = "fun var_" ++ id ++ ":" ++ tyann.translation;
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
    if seqRecPar == 1 || seqRecPar == 2
    then "(Lazy.force var_" ++ x ++ ")"
    else "var_" ++ x;
}
