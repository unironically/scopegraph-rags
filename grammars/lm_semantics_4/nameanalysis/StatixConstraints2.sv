grammar lm_semantics_4:nameanalysis;

--------------------------------------------------

synthesized attribute statixConstraintsTwo::[String];
inherited attribute sName2::String;
inherited attribute tyName2::String;
inherited attribute s_defName2::String;
inherited attribute pName2::String;
inherited attribute s_letName2::String;

--------------------------------------------------

attribute statixConstraintsTwo occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local sName2::String = "s_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ sName2 ++ "}",
    "new " ++ sName2
  ] ++ ds.statixConstraintsTwo;
  ds.sName2 = sName2;
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on Decls;
attribute sName2 occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  top.statixConstraintsTwo = d.statixConstraintsTwo ++ ds.statixConstraintsTwo;

  d.sName2 = top.sName2;
  ds.sName2 = top.sName2;
}

aspect production declsNil
top::Decls ::=
{
  top.statixConstraintsTwo = [
    "true"
  ];
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on Decl;
attribute sName2 occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local xName::String = "\"" ++ id ++ "\"";
  local dsName2::String = "ds_" ++ toString(genInt());
  local s_modName::String = "s_mod_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ s_modName ++ "}",
    "new " ++ s_modName ++ " -> (" ++ xName ++ ", " ++ s_modName ++ ")",
    top.sName2 ++ " -[ `MOD ]-> " ++ s_modName,
    s_modName ++ " -[ `LEX ]-> " ++ top.sName2
  ] ++ ds.statixConstraintsTwo;

  ds.sName2 = s_modName;
}

aspect production declImport
top::Decl ::= r::ModRef
{
  local rName::String = "r_" ++ toString(genInt());
  local pName2::String = "p_" ++ toString(genInt());
  local xName::String = "x_" ++ toString(genInt());
  local s_modName::String = "s_mod_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ pName2 ++ ", " ++ xName ++ ", " ++ s_modName ++ "}"
  ] ++ r.statixConstraintsTwo ++ [
    "datum(" ++ pName2 ++ ", (" ++ xName ++ ", " ++ s_modName ++ "))",
    top.sName2 ++ " -[ `IMP ]-> " ++ s_modName
  ];
  r.sName2 = top.sName2;
  r.pName2 = pName2;
}

aspect production declDef
top::Decl ::= b::ParBind
{
  local bName::String = "b_" ++ toString(genInt());
  top.statixConstraintsTwo = b.statixConstraintsTwo;
  b.sName2 = top.sName2;
  b.s_defName2 = top.sName2;
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on Expr;
attribute sName2 occurs on Expr;
attribute tyName2 occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.statixConstraintsTwo = [
    top.tyName2 ++ " := INT()"
  ];
}

aspect production exprTrue
top::Expr ::=
{
  top.statixConstraintsTwo = [
    top.tyName2 ++ " := BOOL()"
  ];
}

aspect production exprFalse
top::Expr ::=
{
  top.statixConstraintsTwo = [
    top.tyName2 ++ " := BOOL()"
  ];
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  local rName::String = "r_" ++ toString(genInt());
  local pName2::String = "p_" ++ toString(genInt());
  local xName::String = "x_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ pName2 ++ ", " ++ xName ++ "}"
  ] ++ r.statixConstraintsTwo ++ [
    "datum(" ++ pName2 ++ ", (" ++ xName ++ ", " ++ top.tyName2 ++ "))"
  ];
  r.sName2 = top.sName2;
  r.pName2 = pName2;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString(genInt());
  local e2Name::String = "e2_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ t1Name ++ ", " ++ t2Name ++ "}"
  ] ++ e1.statixConstraintsTwo ++ e2.statixConstraintsTwo ++ [
    t1Name ++ " == " ++ t2Name,
    top.tyName2 ++ " := INT()"
  ];
  e1.sName2 = top.sName2;
  e1.tyName2 = t1Name;
  e2.sName2 = top.sName2;
  e2.tyName2 = t2Name;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString(genInt());
  local e2Name::String = "e2_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ t1Name ++ ", " ++ t2Name ++ "}"
  ] ++ e1.statixConstraintsTwo ++ e2.statixConstraintsTwo ++ [
    t1Name ++ " == " ++ t2Name,
    top.tyName2 ++ " := INT()"
  ];
  e1.sName2 = top.sName2;
  e1.tyName2 = t1Name;
  e2.sName2 = top.sName2;
  e2.tyName2 = t2Name;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString(genInt());
  local e2Name::String = "e2_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ t1Name ++ ", " ++ t2Name ++ "}"
  ] ++ e1.statixConstraintsTwo ++ e2.statixConstraintsTwo ++ [
    t1Name ++ " == " ++ t2Name,
    top.tyName2 ++ " := INT()"
  ];
  e1.sName2 = top.sName2;
  e1.tyName2 = t1Name;
  e2.sName2 = top.sName2;
  e2.tyName2 = t2Name;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString(genInt());
  local e2Name::String = "e2_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ t1Name ++ ", " ++ t2Name ++ "}"
  ] ++ e1.statixConstraintsTwo ++ e2.statixConstraintsTwo ++ [
    t1Name ++ " == " ++ t2Name,
    top.tyName2 ++ " := INT()"
  ];
  e1.sName2 = top.sName2;
  e1.tyName2 = t1Name;
  e2.sName2 = top.sName2;
  e2.tyName2 = t2Name;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString(genInt());
  local e2Name::String = "e2_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ t1Name ++ ", " ++ t2Name ++ "}"
  ] ++ e1.statixConstraintsTwo ++ e2.statixConstraintsTwo ++ [
    t1Name ++ " == " ++ t2Name,
    top.tyName2 ++ " := BOOL()"
  ];
  e1.sName2 = top.sName2;
  e1.tyName2 = t1Name;
  e2.sName2 = top.sName2;
  e2.tyName2 = t2Name;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = "e1_" ++ toString(genInt());
  local e2Name::String = "e2_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ t1Name ++ ", " ++ t2Name ++ "}"
  ] ++ e1.statixConstraintsTwo ++ e2.statixConstraintsTwo ++ [
    t1Name ++ " == " ++ t2Name,
    top.tyName2 ++ " := BOOL()"
  ];
  e1.sName2 = top.sName2;
  e1.tyName2 = t1Name;
  e2.sName2 = top.sName2;
  e2.tyName2 = t2Name;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  local tyPrimeName::String = "ty_" ++ toString(genInt());
  local e1Name::String = "e1_" ++ toString(genInt());
  local e2Name::String = "e2_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ t1Name ++ ", " ++ t2Name ++ "}"
  ] ++ e1.statixConstraintsTwo ++ e2.statixConstraintsTwo ++ [
    t1Name ++ " == " ++ t2Name,
    top.tyName2 ++ " := BOOL()"
  ];
  e1.sName2 = top.sName2;
  e1.tyName2 = t1Name;
  e2.sName2 = top.sName2;
  e2.tyName2 = t1Name;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  --local ty1Name::String = "ty_" ++ toString(genInt());
  local e1Name::String = "e1_" ++ toString(genInt());
  local e2Name::String = "e2_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  local t3Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ t1Name ++ ", " ++ t2Name ++ ", " ++ t3Name ++ "}"
  ] ++ e1.statixConstraintsTwo ++ e2.statixConstraintsTwo ++ [
    t3Name ++ " == " ++ t1Name,
    top.tyName2 ++ " := " ++ t2Name
  ];
  e1.sName2 = top.sName2;
  e1.tyName2 = "FUN(" ++ t1Name ++ ", " ++ t2Name ++ ")";
  e2.sName2 = top.sName2;
  e2.tyName2 = t3Name;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  local e1Name::String = "e1_" ++ toString(genInt());
  local e2Name::String = "e2_" ++ toString(genInt());
  local e3Name::String = "e3_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  local t3Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ t1Name ++ ", " ++ t2Name ++ ", " ++ t3Name ++ "}"
  ] ++ e1.statixConstraintsTwo ++ e2.statixConstraintsTwo ++ e3.statixConstraintsTwo ++ [
    t1Name ++ " == BOOL()",
    t2Name ++ " == " ++ t3Name,
    top.tyName2 ++ " := " ++ t2Name
  ];
  e1.sName2 = top.sName2;
  e1.tyName2 = t1Name;
  e2.sName2 = top.sName2;
  e2.tyName2 = t2Name;
  e3.sName2 = top.sName2;
  e3.tyName2 = t3Name;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local dName::String = "d_" ++ toString(genInt());
  local eName::String = "e_" ++ toString(genInt());
  local s_funName::String = "s_fun_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  local t3Name::String = "t_" ++ toString(genInt());
  local t4Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ s_funName ++ ", " ++ t1Name ++ ", " ++ t2Name ++ ", " ++ t3Name ++ ", " ++ t4Name ++ "}",
    "new " ++ s_funName,
    s_funName ++ " -[ `LEX ]-> " ++ top.sName2
  ] ++ d.statixConstraintsTwo ++ e.statixConstraintsTwo ++ [
    t1Name ++ " == " ++ t3Name,
    t2Name ++ " == " ++ t4Name,
    top.tyName2 ++ " := FUN(" ++ t1Name ++ ", " ++ t2Name ++ ")"
  ];
  d.sName2 = s_funName;
  d.tyName2 = t1Name;
  e.sName2 = s_funName;
  e.tyName2 = t2Name;
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local bsName2::String = "bs_" ++ toString(genInt());
  local eName::String = "e_" ++ toString(genInt());
  local s_letName2::String = "s_let_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ s_letName2 ++ ", " ++ t1Name ++ "}",
    "new " ++ s_letName2
  ] ++ bs.statixConstraintsTwo ++ e.statixConstraintsTwo ++ [
    top.tyName2 ++ " := " ++ t1Name
  ];
  bs.sName2 = top.sName2;
  bs.s_defName2 = s_letName2;
  e.sName2 = s_letName2;
  e.tyName2 = t1Name;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local bsName2::String = "bs_" ++ toString(genInt());
  local eName::String = "e_" ++ toString(genInt());
  local s_letName2::String = "s_let_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ s_letName2 ++ ", " ++ t1Name ++ "}",
    "new " ++ s_letName2,
    s_letName2 ++ " -[ `LEX ]-> " ++ top.sName2
  ] ++ bs.statixConstraintsTwo ++ e.statixConstraintsTwo ++ [
    top.tyName2 ++ " := " ++ t1Name
  ];
  bs.sName2 = s_letName2;
  bs.s_defName2 = s_letName2;
  e.sName2 = s_letName2;
  e.tyName2 = t1Name;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local bsName2::String = "bs_" ++ toString(genInt());
  local eName::String = "e_" ++ toString(genInt());
  local s_letName2::String = "s_let_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ s_letName2 ++ "}",
    "new " ++ s_letName2,
    s_letName2 ++ " -[ `LEX ]-> " ++ top.sName2
  ] ++ bs.statixConstraintsTwo ++ e.statixConstraintsTwo ++ [
    top.tyName2 ++ " := " ++ t1Name
  ];
  bs.sName2 = top.sName2;
  bs.s_defName2 = s_letName2;
  e.sName2 = s_letName2;
  e.tyName2 = t1Name;
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on SeqBinds;
attribute sName2 occurs on SeqBinds;
attribute s_defName2 occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.statixConstraintsTwo = [
    top.s_defName2 ++ " -[ `LEX ]-> " ++ top.sName2
  ];
}

aspect production seqBindsOne
top::SeqBinds ::= b::SeqBind
{
  local bName::String = "b_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    top.s_defName2 ++ " -[ `LEX ]-> " ++ top.sName2
  ] ++ b.statixConstraintsTwo;
  b.sName2 = top.sName2;
  b.s_defName2 = top.s_defName2;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local bName::String = "b_" ++ toString(genInt());
  local bsName2::String = "bs_" ++ toString(genInt());
  local s_defprimeName::String = "s_def_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ s_defprimeName ++ "}",
    "new " ++ s_defprimeName,
    s_defprimeName ++ " -[ `LEX ]-> " ++ top.sName2
  ] ++ s.statixConstraintsTwo ++ ss.statixConstraintsTwo;
  s.sName2 = top.sName2;
  s.s_defName2 = s_defprimeName;
  ss.sName2 = s_defprimeName;
  ss.s_defName2 = top.s_defName2;
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on SeqBind;
attribute sName2 occurs on SeqBind;
attribute s_defName2 occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local xName::String = "\"" ++ id ++ "\"";
  local eName::String = "e_" ++ toString(genInt());
  local s_varName::String = "s_var_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ s_varName ++ ", " ++ t1Name ++ ", " ++ t2Name ++ "}",
    "new " ++ s_varName ++ " -> (" ++ xName ++ ", " ++ t1Name ++ ")",
    top.s_defName2 ++ " -[ `VAR ]-> " ++ s_varName
  ] ++ e.statixConstraintsTwo ++ [
    t1Name ++ " := " ++ t2Name
  ];
  e.sName2 = top.sName2;
  e.tyName2 = t2Name;
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local xName::String = "\"" ++ id ++ "\"";
  local eName::String = "e_" ++ toString(genInt());
  local s_varName::String = "s_var_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  local t3Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ s_varName ++ ", " ++ t1Name ++ ", " ++ t2Name ++ ", " ++ t3Name ++ "}",
    "new " ++ s_varName ++ " -> (" ++ xName ++ ", " ++ t1Name ++ ")",
    top.s_defName2 ++ " -[ `VAR ]-> " ++ s_varName
  ] ++ ty.statixConstraintsTwo ++ e.statixConstraintsTwo ++ [
    t1Name ++ " := " ++ t2Name,
    t2Name ++ " == " ++ t3Name
  ];
  ty.sName2 = top.sName2;
  ty.tyName2 = t2Name;
  e.sName2 = top.sName2;
  e.tyName2 = t3Name;
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on ParBinds;
attribute sName2 occurs on ParBinds;
attribute s_defName2 occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.statixConstraintsTwo = [
    "true"
  ];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  top.statixConstraintsTwo = s.statixConstraintsTwo ++ ss.statixConstraintsTwo;
  s.sName2 = top.sName2;
  s.s_defName2 = top.s_defName2;
  ss.sName2 = top.sName2;
  ss.s_defName2 = top.s_defName2;
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on ParBind;
attribute sName2 occurs on ParBind;
attribute s_defName2 occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local xName::String = "\"" ++ id ++ "\"";
  local eName::String = "e_" ++ toString(genInt());
  local s_varName::String = "s_var_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ s_varName ++ ", " ++ t1Name ++ ", " ++ t2Name ++ "}",
    "new " ++ s_varName ++ " -> (" ++ xName ++ ", " ++ t1Name ++ ")",
    top.s_defName2 ++ " -[ `VAR ]-> " ++ s_varName
  ] ++ e.statixConstraintsTwo ++ [
    t1Name ++ " := " ++ t2Name
  ];
  e.sName2 = top.sName2;
  e.tyName2 = t2Name;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local xName::String = "\"" ++ id ++ "\"";
  local eName::String = "e_" ++ toString(genInt());
  local s_varName::String = "s_var_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  local t3Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ s_varName ++ ", " ++ t1Name ++ ", " ++ t2Name ++ ", " ++ t3Name ++ "}",
    "new " ++ s_varName ++ " -> (" ++ xName ++ ", " ++ t1Name ++ ")",
    top.s_defName2 ++ " -[ `VAR ]-> " ++ s_varName
  ] ++ ty.statixConstraintsTwo ++ e.statixConstraintsTwo ++ [
    t1Name ++ " := " ++ t2Name,
    t2Name ++ " == " ++ t3Name
  ];
  ty.sName2 = top.sName2;
  ty.tyName2 = t2Name;
  e.sName2 = top.sName2;
  e.tyName2 = t3Name;
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on ArgDecl;
attribute sName2 occurs on ArgDecl;
attribute tyName2 occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local xName::String = "\"" ++ id ++ "\"";
  local tyannName::String = "tyann_" ++ toString(genInt());
  local s_varName::String = "s_var_" ++ toString(genInt());
  local t1Name::String = "t_" ++ toString(genInt());
  local t2Name::String = "t_" ++ toString(genInt());
  top.statixConstraintsTwo = ty.statixConstraintsTwo ++ [
    "{" ++ s_varName ++ ", " ++ t1Name ++ ", " ++ t2Name ++ "}",
    "new " ++ s_varName ++ " -> (" ++ xName ++ ", " ++ t2Name ++ ")",
    top.sName2 ++ " -[ `VAR ]-> " ++ s_varName,
    t1Name ++ " == " ++ t2Name
  ];
  ty.sName2 = top.sName2;
  ty.tyName2 = t1Name;
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on Type;
attribute sName2 occurs on Type;
attribute tyName2 occurs on Type;

aspect production tInt
top::Type ::=
{
  top.statixConstraintsTwo = [
    top.tyName2 ++ " := INT()"
  ];
}

aspect production tBool
top::Type ::=
{
  top.statixConstraintsTwo = [
    top.tyName2 ++ " := BOOL()"
  ];
}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  local ty1Name::String = "ty_" ++ toString(genInt());
  local ty2Name::String = "ty_" ++ toString(genInt());
  top.statixConstraintsTwo = tyann1.statixConstraintsTwo ++ tyann2.statixConstraintsTwo ++ [
    top.tyName2 ++ " == FUN(" ++ ty1Name ++ ", " ++ ty2Name ++ ")"
  ];
  tyann1.sName2 = top.sName2;
  tyann1.tyName2 = ty1Name;
  tyann2.sName2 = top.sName2;
  tyann2.tyName2 = ty2Name;
}

aspect production tErr
top::Type ::=
{
  top.statixConstraintsTwo = [];
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on ModRef;
attribute sName2 occurs on ModRef;
attribute pName2 occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  local xName::String = "\"" ++ x ++ "\"";
  local modsName2::String = "mods_" ++ toString(genInt());
  local xmodsName2::String = "xmods_" ++ toString(genInt());
  local xmodsPrimeName::String = "xmods_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ modsName2 ++ ", " ++ xmodsName2 ++ ", " ++ xmodsPrimeName ++ "}",
    "query " ++ top.sName2 ++ " `LEX*`IMP? `VAR as " ++ modsName2,
    "filter " ++ modsName2 ++ " ((x, _) where x == " ++ xName ++ ") " ++ xmodsName2,
    "min-refs(" ++ xmodsName2 ++ ", " ++ xmodsPrimeName ++ ")",
    "only(" ++ xmodsPrimeName ++ ", " ++ top.pName2 ++ ")"
  ];
}

--------------------------------------------------

attribute statixConstraintsTwo occurs on VarRef;
attribute sName2 occurs on VarRef;
attribute pName2 occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local xName::String = "\"" ++ x ++ "\"";
  local varsName2::String = "vars_" ++ toString(genInt());
  local xvarsName2::String = "xvars_" ++ toString(genInt());
  local xvarsPrimeName::String = "xvars_" ++ toString(genInt());
  top.statixConstraintsTwo = [
    "{" ++ varsName2 ++ ", " ++ xvarsName2 ++ ", " ++ xvarsPrimeName ++ "}",
    "query " ++ top.sName2 ++ " `LEX*`IMP? `VAR as " ++ varsName2,
    "filter " ++ varsName2 ++ " ((x, _) where x == " ++ xName ++ ") " ++ xvarsName2,
    "min-refs(" ++ xvarsName2 ++ ", " ++ xvarsPrimeName ++ ")",
    "only(" ++ xvarsPrimeName ++ ", " ++ top.pName2 ++ ")"
  ];
}