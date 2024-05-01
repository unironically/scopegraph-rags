grammar lm_semantics_2:nameanalysis;

--------------------------------------------------

synthesized attribute statixConstraints::[String];
inherited attribute sName::String;
inherited attribute s_impName::String;
inherited attribute tyName::String;
inherited attribute s_defName::String;
inherited attribute pName::String;
inherited attribute s_letName::String;
inherited attribute s_lookupName::String;

--------------------------------------------------

attribute statixConstraints occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local sName::String = "s_" ++ toString(genInt());
  top.statixConstraints = [
    "new " ++ sName
  ] ++ ds.statixConstraints;
  ds.sName = sName;
  ds.s_lookupName = sName;
}

--------------------------------------------------

attribute statixConstraints occurs on Decls;
attribute sName occurs on Decls;
attribute s_lookupName occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local dName::String = "d_" ++ toString (genInt());
  local dsName::String = "ds_" ++ toString (genInt());
  local s_impName::String = "s_imp_" ++ toString (genInt());
  top.statixConstraints = [
    "new " ++ s_impName,
    s_impName ++ " -[ `LEX ]-> " ++ top.s_lookupName
  ] ++ d.statixConstraints ++ ds.statixConstraints;
  d.sName = top.sName;
  d.s_impName = s_impName;
  ds.sName = top.sName;
  ds.s_lookupName = s_impName;
}

aspect production declsNil
top::Decls ::= 
{
  top.statixConstraints = ["true"];
}

--------------------------------------------------

attribute statixConstraints occurs on Decl;
attribute sName occurs on Decl;
attribute s_impName occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  top.statixConstraints = []; -- TODO
}

aspect production declImport
top::Decl ::= r::ModRef
{
  top.statixConstraints = []; -- TODO
}

aspect production declDef
top::Decl ::= b::ParBind
{
  local bName::String = "b_" ++ toString (genInt());
  top.statixConstraints = b.statixConstraints;
  b.sName = top.s_impName;
  b.s_defName = top.sName;
}

--------------------------------------------------

attribute statixConstraints occurs on Expr;
attribute sName occurs on Expr;
attribute tyName occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.statixConstraints = [
    top.tyName ++ " == INT()"
  ];
}

aspect production exprTrue
top::Expr ::= 
{
  top.statixConstraints = [
    top.tyName ++ " == BOOL()"
  ];
}

aspect production exprFalse
top::Expr ::= 
{
  top.statixConstraints = [
    top.tyName ++ " == BOOL()"
  ];
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  local rName::String = "r_" ++ toString (genInt());
  local pName::String = "p_" ++ toString (genInt());
  local xName::String = "x_" ++ toString (genInt());
  top.statixConstraints = r.statixConstraints ++ [
    "datum(" ++ pName ++ ", (" ++ xName ++ ", " ++ top.tyName ++ "))"
  ];
  r.sName = top.sName;
  r.pName = pName;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString (genInt());
  local e2Name::String = "e2_" ++ toString (genInt());
  top.statixConstraints = e1.statixConstraints ++ e2.statixConstraints ++ [
    top.tyName ++ " == INT()"
  ];
  e1.sName = top.sName;
  e1.tyName = "INT()";
  e2.sName = top.sName;
  e2.tyName = "INT()";
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString (genInt());
  local e2Name::String = "e2_" ++ toString (genInt());
  top.statixConstraints = e1.statixConstraints ++ e2.statixConstraints ++ [
    top.tyName ++ " == INT()"
  ];
  e1.sName = top.sName;
  e1.tyName = "INT()";
  e2.sName = top.sName;
  e2.tyName = "INT()";
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString (genInt());
  local e2Name::String = "e2_" ++ toString (genInt());
  top.statixConstraints = e1.statixConstraints ++ e2.statixConstraints ++ [
    top.tyName ++ " == INT()"
  ];
  e1.sName = top.sName;
  e1.tyName = "INT()";
  e2.sName = top.sName;
  e2.tyName = "INT()";
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString (genInt());
  local e2Name::String = "e2_" ++ toString (genInt());
  top.statixConstraints = e1.statixConstraints ++ e2.statixConstraints ++ [
    top.tyName ++ " == INT()"
  ];
  e1.sName = top.sName;
  e1.tyName = "INT()";
  e2.sName = top.sName;
  e2.tyName = "INT()";
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString (genInt());
  local e2Name::String = "e2_" ++ toString (genInt());
  top.statixConstraints = e1.statixConstraints ++ e2.statixConstraints ++ [
    top.tyName ++ " == BOOL()"
  ];
  e1.sName = top.sName;
  e1.tyName = "BOOL()";
  e2.sName = top.sName;
  e2.tyName = "BOOL()";
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString (genInt());
  local e2Name::String = "e2_" ++ toString (genInt());
  top.statixConstraints = e1.statixConstraints ++ e2.statixConstraints ++ [
    top.tyName ++ " == BOOL()"
  ];
  e1.sName = top.sName;
  e1.tyName = "BOOL()";
  e2.sName = top.sName;
  e2.tyName = "BOOL()";
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  local tyPrimeName::String = "ty_" ++ toString(genInt());
  local e1Name::String = "e1_" ++ toString (genInt());
  local e2Name::String = "e2_" ++ toString (genInt());
  top.statixConstraints = e1.statixConstraints ++ e2.statixConstraints ++ [
    top.tyName ++ " == BOOL()"
  ];
  e1.sName = top.sName;
  e1.tyName = tyPrimeName;
  e2.sName = top.sName;
  e2.tyName = tyPrimeName;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  local ty1Name::String = "ty_" ++ toString(genInt());
  local e1Name::String = "e1_" ++ toString (genInt());
  local e2Name::String = "e2_" ++ toString (genInt());
  top.statixConstraints = e1.statixConstraints ++ e2.statixConstraints;
  e1.sName = top.sName;
  e1.tyName = "FUN(" ++ ty1Name ++ ", " ++ top.tyName ++ ")";
  e2.sName = top.sName;
  e2.tyName = ty1Name;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  local e1Name::String = "e1_" ++ toString (genInt());
  local e2Name::String = "e2_" ++ toString (genInt());
  local e3Name::String = "e3_" ++ toString (genInt());
  top.statixConstraints = e1.statixConstraints ++ e2.statixConstraints ++ e3.statixConstraints;
  e1.sName = top.sName;
  e1.tyName = "BOOL()";
  e2.sName = top.sName;
  e2.tyName = top.tyName;
  e3.sName = top.sName;
  e3.tyName = top.tyName;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr 
{
  local dName::String = "d_" ++ toString (genInt());
  local eName::String = "e_" ++ toString (genInt());
  local s_funName::String = "s_fun_" ++ toString (genInt());
  local ty1Name::String = "ty_" ++ toString (genInt());
  local ty2Name::String = "ty_" ++ toString (genInt());
  top.statixConstraints = [
    "new " ++ s_funName,
    s_funName ++ " -[ `LEX ]-> " ++ top.sName
  ] ++ d.statixConstraints ++ e.statixConstraints ++ [
    top.tyName ++ " == FUN(" ++ ty1Name ++ ", " ++ ty2Name ++ ")"
  ];
  d.sName = s_funName;
  d.tyName = ty1Name;
  e.sName = s_funName;
  e.tyName = ty2Name;
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local bsName::String = "bs_" ++ toString (genInt());
  local eName::String = "e_" ++ toString (genInt());
  local s_letName::String = "s_let_" ++ toString (genInt());
  top.statixConstraints = [
    "new " ++ s_letName
  ] ++ bs.statixConstraints ++ e.statixConstraints;
  bs.sName = top.sName;
  bs.s_defName = s_letName;
  e.sName = s_letName;
  e.tyName = top.tyName;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local bsName::String = "bs_" ++ toString (genInt());
  local eName::String = "e_" ++ toString (genInt());
  local s_letName::String = "s_let_" ++ toString (genInt());
  top.statixConstraints = [
    "new " ++ s_letName,
    s_letName ++ " -[ `LEX ]-> " ++ top.sName
  ] ++ bs.statixConstraints ++ e.statixConstraints;
  bs.sName = s_letName;
  bs.s_defName = s_letName;
  e.sName = s_letName;
  e.tyName = top.tyName;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local bsName::String = "bs_" ++ toString (genInt());
  local eName::String = "e_" ++ toString (genInt());
  local s_letName::String = "s_let_" ++ toString (genInt());
  top.statixConstraints = [
    "new " ++ s_letName,
    s_letName ++ " -[ `LEX ]-> " ++ top.sName
  ] ++ bs.statixConstraints ++ e.statixConstraints;
  bs.sName = top.sName;
  bs.s_defName = s_letName;
  e.sName = s_letName;
  e.tyName = top.tyName;
}

--------------------------------------------------

attribute statixConstraints occurs on SeqBinds;
attribute sName occurs on SeqBinds;
attribute s_defName occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.statixConstraints = [
    top.s_defName ++ " -[ `LEX ]-> " ++ top.sName
  ];
}

aspect production seqBindsOne
top::SeqBinds ::= b::SeqBind
{
  local bName::String = "b_" ++ toString (genInt());
  top.statixConstraints = [
    top.s_defName ++ " -[ `LEX ]-> " ++ top.sName
  ] ++ b.statixConstraints;
  b.sName = top.sName;
  b.s_defName = top.s_defName;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local bName::String = "b_" ++ toString (genInt());
  local bsName::String = "bs_" ++ toString (genInt());
  local s_defprimeName::String = "s_def_" ++ toString (genInt());
  top.statixConstraints = [
    "new " ++ s_defprimeName,
    s_defprimeName ++ " -[ `LEX ]-> " ++ top.sName
  ] ++ s.statixConstraints ++ ss.statixConstraints;
  s.sName = top.sName;
  s.s_defName = s_defprimeName;
  ss.sName = s_defprimeName;
  ss.s_defName = top.s_defName;
}

--------------------------------------------------

attribute statixConstraints occurs on SeqBind;
attribute sName occurs on SeqBind;
attribute s_defName occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local xName::String = "\"" ++ id ++ "\"";
  local eName::String = "e_" ++ toString (genInt());
  local s_varName::String = "s_var_" ++ toString (genInt());
  local tyName::String = "ty_" ++ toString (genInt());
  top.statixConstraints = [
    "new " ++ s_varName ++ " -> (" ++ xName ++ ", " ++ tyName ++ ")",
    top.s_defName ++ " -[ `VAR ]-> " ++ s_varName
  ] ++ e.statixConstraints;
  e.sName = top.sName;
  e.tyName = tyName;
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local xName::String = "\"" ++ id ++ "\"";
  local eName::String = "e_" ++ toString (genInt());
  local s_varName::String = "s_var_" ++ toString (genInt());
  local tyName::String = "ty_" ++ toString (genInt());
  top.statixConstraints = [
    "new " ++ s_varName ++ " -> (" ++ xName ++ ", " ++ tyName ++ ")",
    top.s_defName ++ " -[ `VAR ]-> " ++ s_varName
  ] ++ ty.statixConstraints ++ e.statixConstraints;
  ty.sName = top.sName;
  ty.tyName = tyName;
  e.sName = top.sName;
  e.tyName = tyName;
}

--------------------------------------------------

attribute statixConstraints occurs on ParBinds;
attribute sName occurs on ParBinds;
attribute s_defName occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.statixConstraints = [
    "true"
  ];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  top.statixConstraints = s.statixConstraints ++ ss.statixConstraints;
  s.sName = top.sName;
  s.s_defName = top.s_defName;
  ss.sName = top.sName;
  ss.s_defName = top.s_defName;
}

--------------------------------------------------

attribute statixConstraints occurs on ParBind;
attribute sName occurs on ParBind;
attribute s_defName occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local xName::String = "\"" ++ id ++ "\"";
  local eName::String = "e_" ++ toString (genInt());
  local s_varName::String = "s_var_" ++ toString (genInt());
  local tyName::String = "ty_" ++ toString (genInt());
  top.statixConstraints = [
    "new " ++ s_varName ++ " -> (" ++ xName ++ ", " ++ tyName ++ ")",
    top.s_defName ++ " -[ `VAR ]-> " ++ s_varName
  ] ++ e.statixConstraints;
  e.sName = top.sName;
  e.tyName = tyName;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local xName::String = "\"" ++ id ++ "\"";
  local eName::String = "e_" ++ toString (genInt());
  local s_varName::String = "s_var_" ++ toString (genInt());
  local tyName::String = "ty_" ++ toString (genInt());
  top.statixConstraints = [
    "new " ++ s_varName ++ " -> (" ++ xName ++ ", " ++ tyName ++ ")",
    top.s_defName ++ " -[ `VAR ]-> " ++ s_varName
  ] ++ ty.statixConstraints ++ e.statixConstraints;
  ty.sName = top.sName;
  ty.tyName = tyName;
  e.sName = top.sName;
  e.tyName = tyName;
}

--------------------------------------------------

attribute statixConstraints occurs on ArgDecl;
attribute sName occurs on ArgDecl;
attribute tyName occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local xName::String = "\"" ++ id ++ "\"";
  local tyannName::String = "tyann_" ++ toString (genInt());
  local s_varName::String = "s_var_" ++ toString (genInt());
  top.statixConstraints = ty.statixConstraints ++ [
    "new " ++ s_varName ++ " -> (" ++ xName ++ ", " ++ top.tyName ++ ")",
    top.sName ++ " -[ `VAR ]-> " ++ s_varName
  ];
  ty.sName = top.sName;
  ty.tyName = top.tyName;
}

--------------------------------------------------

attribute statixConstraints occurs on Type;
attribute sName occurs on Type;
attribute tyName occurs on Type;

aspect production tInt
top::Type ::= 
{
  top.statixConstraints = [
    top.tyName ++ " == INT()"
  ];
}

aspect production tBool
top::Type ::= 
{
  top.statixConstraints = [
    top.tyName ++ " == BOOL()"
  ];
}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  local ty1Name::String = "ty_" ++ toString (genInt());
  local ty2Name::String = "ty_" ++ toString (genInt());
  top.statixConstraints = tyann1.statixConstraints ++ tyann2.statixConstraints ++ [
    top.tyName ++ " == FUN(" ++ ty1Name ++ ", " ++ ty2Name ++ ")"
  ];
  tyann1.sName = top.sName;
  tyann1.tyName = ty1Name;
  tyann2.sName = top.sName;
  tyann2.tyName = ty2Name;
}

aspect production tErr
top::Type ::=
{
  top.statixConstraints = [];
}

--------------------------------------------------

attribute statixConstraints occurs on ModRef;
attribute sName occurs on ModRef;
attribute pName occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  top.statixConstraints = []; -- TODO
}

aspect production modQRef
top::ModRef ::= r::ModRef x::String
{
  top.statixConstraints = []; -- TODO
}

--------------------------------------------------

attribute statixConstraints occurs on VarRef;
attribute sName occurs on VarRef;
attribute pName occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local xName::String = "\"" ++ x ++ "\"";
  local modsName::String = "mods_" ++ toString (genInt());
  local xmodsName::String = "xmods_" ++ toString (genInt());
  local xmodsprimeName::String = "xmods_" ++ toString (genInt());
  top.statixConstraints = [
    "query " ++ top.sName ++ " `LEX*`IMP? `VAR as " ++ modsName,
    "filter " ++ modsName ++ " ((x, _) where x == " ++ xName ++ ") " ++ xmodsName,
    "min-refs(" ++ xmodsName ++ ", " ++ xmodsprimeName ++ ")",
    "only(" ++ xmodsprimeName ++ ", " ++ top.pName ++ ")"
  ];
}

aspect production varQRef
top::VarRef ::= r::ModRef x::String
{
  top.statixConstraints = []; -- TODO
}