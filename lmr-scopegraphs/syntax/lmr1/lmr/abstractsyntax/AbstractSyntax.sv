grammar syntax:lmr1:lmr:abstractsyntax;

--------------------------------------------------

synthesized attribute statix::String;

--------------------------------------------------

nonterminal Main with statix, location;

abstract production program
top::Main ::= ds::Decls
{
  top.statix = "Program(" ++ ds.statix ++ ")";
}

--------------------------------------------------

nonterminal Decls with statix, location;

abstract production declsCons
top::Decls ::= d::Decl ds::Decls
{
  top.statix = "DeclsCons(" ++ d.statix ++ ", " ++ ds.statix ++ ")";
}

abstract production declsNil
top::Decls ::=
{
  top.statix = "DeclsNil()";
}

--------------------------------------------------

nonterminal Decl with statix, location;

abstract production declModule
top::Decl ::= id::String ds::Decls
{
  top.statix = "DeclModule(\"" ++ id ++ "\", " ++ ds.statix ++ ")";
}

abstract production declImport
top::Decl ::= r::ModRef
{
  top.statix = "DeclImport(" ++ r.statix ++ ")";
}

abstract production declDef
top::Decl ::= b::ParBind
{
  top.statix = "DeclDef(" ++ b.statix ++ ")";
}

--------------------------------------------------

nonterminal Expr with statix, location;

abstract production exprInt
top::Expr ::= i::Integer
{
  top.statix = "ExprInt(\"" ++ toString(i) ++ "\")";
}

abstract production exprTrue
top::Expr ::=
{
  top.statix = "ExprTrue()";
}

abstract production exprFalse
top::Expr ::=
{
  top.statix = "ExprFalse()";
}

abstract production exprVar
top::Expr ::= r::VarRef
{
  top.statix = "ExprVar(" ++ r.statix ++ ")";
}

abstract production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  top.statix = "ExprAdd(" ++ e1.statix ++ ", " ++ e2.statix ++ ")";
}

abstract production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  top.statix = "ExprSub(" ++ e1.statix ++ ", " ++ e2.statix ++ ")";
}

abstract production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  top.statix = "ExprMul(" ++ e1.statix ++ ", " ++ e2.statix ++ ")";
}

abstract production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  top.statix = "ExprDiv(" ++ e1.statix ++ ", " ++ e2.statix ++ ")";
}

abstract production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  top.statix = "ExprAnd(" ++ e1.statix ++ ", " ++ e2.statix ++ ")";
}

abstract production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  top.statix = "ExprOr(" ++ e1.statix ++ ", " ++ e2.statix ++ ")";
}

abstract production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  top.statix = "ExprEq(" ++ e1.statix ++ ", " ++ e2.statix ++ ")";
}

abstract production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  top.statix = "ExprApp(" ++ e1.statix ++ ", " ++ e2.statix ++ ")";
}

abstract production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  top.statix = "ExprIf(" ++ e1.statix ++ ", " ++ e2.statix ++ ", " ++ e3.statix ++ ")";
}

abstract production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  top.statix = "ExprFun(" ++ d.statix ++ ", " ++ e.statix ++ ")";
}

abstract production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  top.statix = "ExprLet(" ++ bs.statix ++ ", " ++ e.statix ++ ")";
}

abstract production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  top.statix = "ExprLetRec(" ++ bs.statix ++ ", " ++ e.statix ++ ")";
}

abstract production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  top.statix = "ExprLetPar(" ++ bs.statix ++ ", " ++ e.statix ++ ")";
}

--------------------------------------------------

nonterminal SeqBinds with statix, location;

abstract production seqBindsNil
top::SeqBinds ::=
{
  top.statix = "SeqBindsNil()";
}

abstract production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  top.statix = "SeqBindsOne(" ++ s.statix ++ ")";
}

abstract production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  top.statix = "SeqBindsCons(" ++ s.statix ++ ", " ++ ss.statix ++ ")";
}

--------------------------------------------------

nonterminal SeqBind with statix, location;

abstract production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  top.statix = "DefBind(\"" ++ id ++ "\", " ++ e.statix ++ ")";
}

abstract production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  top.statix = "DefBindTyped(\"" ++ id ++ "\", " ++ ty.statix ++ ", " ++ e.statix ++ ")";
}

--------------------------------------------------

nonterminal ParBinds with statix, location;

abstract production parBindsNil
top::ParBinds ::=
{
  top.statix = "ParBindsNil()";
}

abstract production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  top.statix = "ParBindsCons(" ++ s.statix ++ ", " ++ ss.statix ++ ")";
}

--------------------------------------------------

nonterminal ParBind with statix, location;

abstract production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  top.statix = "DefBind(\"" ++ id ++ "\", " ++ e.statix ++ ")";
}

abstract production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  top.statix = "DefBindTyped(\"" ++ id ++ "\", " ++ ty.statix ++ ", " ++ e.statix ++ ")";
}

--------------------------------------------------

nonterminal ArgDecl with statix, location;

abstract production argDecl
top::ArgDecl ::= id::String ty::Type
{
  top.statix = "ArgDecl(\"" ++ id ++ "\", " ++ ty.statix ++ ")";
}

--------------------------------------------------

nonterminal Type with statix;

abstract production tInt
top::Type ::=
{
  top.statix = "TInt()";
}

abstract production tBool
top::Type ::=
{
  top.statix = "TBool()";
}

abstract production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  top.statix = "tFun(" ++ tyann1.statix ++ ", " ++ tyann2.statix ++ ")";
}

abstract production tErr
top::Type ::=
{
  top.statix = "TErr()";
}

fun eqType Boolean ::= t1::Type t2::Type =
  case t1, t2 of
  | tInt(), tInt() -> true
  | tBool(), tBool() -> true              -- QUESTION: why need to use ^ here?
  | tFun(t1_1, t1_2), tFun(t2_1, t2_2) -> eqType(^t1_1, ^t2_1) && eqType(^t1_2, ^t2_2)
  | tErr(), tErr() -> true
  | _, _ -> false
  end;

instance Eq Type {
  eq = eqType;
}

--------------------------------------------------

nonterminal ModRef with statix, location;

abstract production modRef
top::ModRef ::= x::String
{
  top.statix = "ModRef(\"" ++ x ++ "\")";
}

--------------------------------------------------

nonterminal VarRef with statix, location;

abstract production varRef
top::VarRef ::= x::String
{
  top.statix = "VarRef(\"" ++ x ++ "\")";
}