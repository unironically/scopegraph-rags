grammar lm_syntax_0:lang:abstractsyntax;

--------------------------------------------------

synthesized attribute flattened::[String];

inherited attribute s::String;
inherited attribute s_def::String;

inherited attribute p::String;

inherited attribute ty::String;

--------------------------------------------------

attribute flattened occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local s::String = "s_" ++ toString(genInt());

  ds.s = s;

  top.flattened = [
    "-- from program",
    "new " ++ s
  ] ++ ds.flattened;
}

--------------------------------------------------

attribute s, flattened occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.s = top.s;
  ds.s = top.s;

  top.flattened = [
    "-- from declsCons"
  ] ++ d.flattened ++ ds.flattened;
}

aspect production declsNil
top::Decls ::=
{
  top.flattened = ["-- from declsNil", "true"];
}

--------------------------------------------------

attribute s, flattened occurs on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{
  top.flattened = [
    "-- from declDef"
  ] ++ b.flattened;

  b.s = top.s;
  b.s_def = top.s;
}

--------------------------------------------------

attribute s, flattened, ty occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.flattened = [
    "-- from exprInt",
    top.ty ++ " == INT()"
  ];
}

aspect production exprTrue
top::Expr ::=
{
  top.flattened = [
    "-- from exprTrue",
    top.ty ++ " == BOOL()"
  ];
}

aspect production exprFalse
top::Expr ::=
{
  top.flattened = [
    "-- from exprFalse",
    top.ty ++ " == BOOL()"
  ];
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  local p::String = "p_" ++ toString(genInt());
  local d::String = "d_" ++ toString(genInt());
  local ty_::String = "ty'_" ++ toString(genInt());
  local s_::String = "s'_" ++ toString(genInt());

  r.s = top.s;
  r.p = p;

  top.flattened = [
    "-- from exprVar"
  ] ++ r.flattened ++ [
    "tgt(" ++ r.p ++ ", " ++ s_ ++ ")",
    s_ ++ " -> " ++ d,
    d ++ " == DatumVar(x, " ++ ty_ ++ ")",
    top.ty ++ " == " ++ ty_
  ];
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());

  e1.s = top.s;
  e1.ty = ty1;

  e2.s = top.s;
  e2.ty = ty2;

  top.flattened = [
    "-- from exprAdd"
  ] ++ e1.flattened ++ e2.flattened ++ [
    ty1 ++ " == INT()",
    ty2 ++ " == INT()",
    top.ty ++ " == INT()"
  ];
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());

  e1.s = top.s;
  e1.ty = ty1;

  e2.s = top.s;
  e2.ty = ty2;

  top.flattened = [
    "-- from exprSub"
  ] ++ e1.flattened ++ e2.flattened ++ [
    ty1 ++ " == INT()",
    ty2 ++ " == INT()",
    top.ty ++ " == INT()"
  ];
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());

  e1.s = top.s;
  e1.ty = ty1;

  e2.s = top.s;
  e2.ty = ty2;

  top.flattened = [
    "-- from exprMul"
  ] ++ e1.flattened ++ e2.flattened ++ [
    ty1 ++ " == INT()",
    ty2 ++ " == INT()",
    top.ty ++ " == INT()"
  ];
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());

  e1.s = top.s;
  e1.ty = ty1;

  e2.s = top.s;
  e2.ty = ty2;

  top.flattened = [
    "-- from exprDiv"
  ] ++ e1.flattened ++ e2.flattened ++ [
    ty1 ++ " == INT()",
    ty2 ++ " == INT()",
    top.ty ++ " == INT()"
  ];
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());

  e1.s = top.s;
  e1.ty = ty1;

  e2.s = top.s;
  e2.ty = ty2;

  top.flattened = [
    "-- from exprAnd"
  ] ++ e1.flattened ++ e2.flattened ++ [
    ty1 ++ " == BOOL()",
    ty2 ++ " == BOOL()",
    top.ty ++ " == BOOL()"
  ];
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());

  e1.s = top.s;
  e1.ty = ty1;

  e2.s = top.s;
  e2.ty = ty2;

  top.flattened = [
    "-- from exprOr"
  ] ++ e1.flattened ++ e2.flattened ++ [
    ty1 ++ " == BOOL()",
    ty2 ++ " == BOOL()",
    top.ty ++ " == BOOL()"
  ];
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());

  e1.s = top.s;
  e1.ty = ty1;

  e2.s = top.s;
  e2.ty = ty2;

  top.flattened = [
    "-- from exprEq"
  ] ++ e1.flattened ++ e2.flattened ++ [
    ty1 ++ " == " ++ ty2,
    top.ty ++ " == BOOL()"
  ];
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());
  local ty3::String = "ty_" ++ toString(genInt());
  local ty4::String = "ty_" ++ toString(genInt());

  e1.s = top.s;
  e1.ty = ty1;

  e2.s = top.s;
  e2.ty = ty2;

  top.flattened = [
    "-- from exprApp"
  ] ++ e1.flattened ++ e2.flattened ++ [
    ty1 ++ " == FUN(" ++ ty3 ++ ", " ++ ty4 ++ ")",
    ty2 ++ " == " ++ ty3,
    top.ty ++ " == " ++ ty4
  ];
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  local ty1::String = toString(genInt());
  local ty2::String = toString(genInt());
  local ty3::String = toString(genInt());

  e1.s = top.s;
  e1.ty = ty1;

  e2.s = top.s;
  e2.ty = ty2;

  e3.s = top.s;
  e3.ty = ty3;

  top.flattened = [
    "-- from exprIf"
  ] ++ e1.flattened ++ e2.flattened ++ e3.flattened ++ [
    ty1 ++ " == BOOL()",
    ty2 ++ " == " ++ ty3
  ];
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local s_fun::String = "s_fun_" ++ toString(genInt());

  local ty1::String = toString(genInt());
  local ty2::String = toString(genInt());

  d.s = s_fun;
  d.ty = ty1;

  e.s = s_fun;
  e.ty = ty2;

  top.flattened = [
    "-- from exprFun",
    "new " ++ s_fun,
    s_fun ++ " -[ `LEX ]-> " ++ top.s
  ] ++ d.flattened ++ e.flattened ++ [
    top.ty ++ " == FUN(" ++ ty1 ++ ", " ++ ty2 ++ ")"
  ];
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local s_let::String = "s_let_" ++ toString(genInt());
  
  bs.s = top.s;
  bs.s_def = s_let;

  e.s = s_let;
  e.ty = top.ty;

  top.flattened = [
    "-- from exprLet",
    "new " ++ s_let
  ] ++ bs.flattened ++ e.flattened;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local s_let::String = "s_let_" ++ toString(genInt());
  
  bs.s = s_let;
  bs.s_def = s_let;

  e.s = s_let;
  e.ty = top.ty;

  top.flattened = [
    "-- from exprLetRec",
    "new " ++ s_let
  ] ++ bs.flattened ++ e.flattened;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local s_let::String = "s_let_" ++ toString(genInt());
  
  bs.s = top.s;
  bs.s_def = s_let;

  e.s = s_let;
  e.ty = top.ty;

  top.flattened = [
    "-- from exprLetPar",
    "new " ++ s_let
  ] ++ bs.flattened ++ e.flattened;
}

--------------------------------------------------

attribute s, flattened, s_def occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.flattened = [
    "-- from seqBindsNil",
    top.s_def ++ " -[ `LEX ]-> " ++ top.s
  ];
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  s.s = top.s;
  s.s_def = top.s_def;
  
  top.flattened = [
    "-- from seqBindsOne",
    top.s_def ++ " -[ `LEX ]-> " ++ top.s
  ] ++ s.flattened;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local s_def_::String = "s_def'_" ++ toString(genInt());

  s.s = top.s;
  s.s_def = s_def_;

  ss.s = s_def_;
  ss.s_def = top.s_def;

  top.flattened = [
    "-- from seqBindsCons",
    "new " ++ s_def_,
    s_def_ ++ " -[ `LEX ]-> " ++ top.s
  ] ++ s.flattened ++ ss.flattened;
}

--------------------------------------------------

attribute s, flattened, s_def occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local s_var::String = "s_var_" ++ toString(genInt());
  local ty::String = "ty_" ++ toString(genInt());

  e.s = top.s;
  e.ty = ty;

  top.flattened = [
    "-- from seqBindUntyped",
    "new " ++ s_var ++ " -> DatumVar(" ++ id ++ ", " ++ ty ++ ")",
    top.s_def ++ " -[ `VAR ]-> " ++ s_var
  ] ++ e.flattened;
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local s_var::String = "s_var_" ++ toString(genInt());
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());

  ty.s = top.s;
  ty.ty = ty1;

  e.s = top.s;
  e.ty = ty2;

  top.flattened = [
    "-- from seqBindTyped",
    "new " ++ s_var ++ " -> DatumVar(" ++ id ++ ", " ++ ty1 ++ ")",
    top.s_def ++ " -[ `VAR ]-> " ++ s_var
  ] ++ ty.flattened ++ e.flattened ++ [
    ty1 ++ " == " ++ ty2
  ];
}

--------------------------------------------------

attribute s, flattened, s_def occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.flattened = [
    "-- from parBindsNil",
    "true"
  ];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.s = top.s;
  s.s_def = top.s_def;

  ss.s = top.s;
  ss.s_def = top.s_def;

  top.flattened = ["-- from parBindsCons"] ++ s.flattened ++ ss.flattened;
}

--------------------------------------------------

attribute s, flattened, s_def occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local s_var::String = "s_var_" ++ toString(genInt());
  local ty::String = "ty_" ++ toString(genInt());

  e.s = top.s;
  e.ty = ty;

  top.flattened = [
    "-- from parBindUntyped",
    "new " ++ s_var ++ " -> DatumVar(" ++ id ++ ", " ++ ty ++ ")",
    top.s_def ++ " -[ `VAR ]-> " ++ s_var
  ] ++ e.flattened;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local s_var::String = "s_var_" ++ toString(genInt());
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());

  ty.s = top.s;
  ty.ty = ty1;

  e.s = top.s;
  e.ty = ty2;

  top.flattened = [
    "-- from parBindTyped",
    "new " ++ s_var ++ " -> DatumVar(" ++ id ++ ", " ++ ty1 ++ ")",
    top.s_def ++ " -[ `VAR ]-> " ++ s_var
  ] ++ ty.flattened ++ e.flattened ++ [
    ty1 ++ " == " ++ ty2
  ];
}

--------------------------------------------------

attribute s, flattened, ty occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local s_var::String = "s_var_" ++ toString(genInt());

  ty.s = top.s;
  ty.ty = top.ty;

  top.flattened = [
    "-- from argDecl"
  ] ++ ty.flattened ++ [
    "new " ++ s_var ++ " -> DatumVar(" ++ id ++ ", " ++ top.ty ++ ")",
    top.s ++ " -[ `VAR ]-> " ++ s_var
  ];
}

--------------------------------------------------

attribute s, flattened, ty occurs on Type;

aspect production tInt
top::Type ::=
{
  top.flattened = [
    "-- from tInt",
    top.ty ++ " == INT()"
  ];
}

aspect production tBool
top::Type ::=
{
  top.flattened = [
    "-- from tBool",
    top.ty ++ " == BOOL()"
  ];
}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  local ty1::String = "ty_" ++ toString(genInt());
  local ty2::String = "ty_" ++ toString(genInt());

  tyann1.s = top.s;
  tyann1.ty = ty1;

  tyann2.s = top.s;
  tyann2.ty = ty2;

  top.flattened = [
    "-- from tFun"
  ] ++ tyann1.flattened ++ tyann2.flattened ++ [
    top.ty ++ " == FUN(" ++ ty1 ++ ", " ++ ty2 ++ ")"
  ];
}

aspect production tErr
top::Type ::=
{
  top.flattened = [
    "-- from tErr",
    top.ty ++ " == ERR()"
  ];
}

--------------------------------------------------

attribute s, flattened, p occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local vars::String = "vars_" ++ toString(genInt());
  local xvars::String = "xvars_" ++ toString(genInt());
  local xvars_::String = "xvas'_" ++ toString(genInt());

  top.flattened = [
    "-- from varRef",
    "query " ++ top.s ++ " `LEX* `VAR as " ++ vars,
    "filter " ++ vars ++ " (DatumVar(x', _) where x' == " ++ x ++ ") " ++ xvars,
    "min-refs(" ++ xvars ++ ", " ++ xvars_ ++ ")",
    "only(" ++ xvars_ ++ ", " ++ top.p ++ ")"
  ];
}