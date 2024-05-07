grammar lm_semantics_6:nameanalysis;

--------------------------------------------------

synthesized attribute silverEquations::[String];

inherited attribute topName::String;

--------------------------------------------------

attribute silverEquations occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local dsNameSilver::String = "Decls_" ++ toString(genInt());
  local globalScopeName::String = "globalScope";
  local topName::String = "Main_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ globalScopeName ++ "::Scope = mkScopeGlobal([], []);",
    ds.topName ++ ".s = " ++ globalScopeName ++ ";"
    --topName ++ ".ok = " ++ dsNameSilver ++ ".ok;"
  ] ++ ds.silverEquations;

  ds.topName = dsNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on Decls;

attribute topName occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local lookupScopeNameSilver::String = "lookupScope_" ++ toString(genInt());
  local dNameSilver::String = "Decl_" ++ toString(genInt());
  local dsNameSilver::String = "Decls_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ lookupScopeNameSilver ++ "::Scope = mkScopeImpLookup(" ++ top.topName ++ ".s, " ++ dNameSilver ++ ".varScopes, " ++ dNameSilver ++ ".modScopes, " ++ dNameSilver ++ ".impScope);",
    dNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    dNameSilver ++ ".sLooukp = " ++ lookupScopeNameSilver ++ ";",
    dsNameSilver ++ ".s = " ++ lookupScopeNameSilver ++ ";",
    top.topName ++ ".varScopes = " ++ dNameSilver ++ ".varScopes ++ " ++ dsNameSilver ++ ".varScopes;",
    top.topName ++ ".modScopes = " ++ dNameSilver ++ ".modScopes ++ " ++ dsNameSilver ++ ".modScopes;"
    --top.topName ++ ".ok = " ++ dNameSilver ++ ".ok && " ++ dsNameSilver ++ ".ok;"
  ] ++ d.silverEquations ++ ds.silverEquations;

  d.topName = dNameSilver;

  ds.topName = dsNameSilver;
}

aspect production declsNil
top::Decls ::=
{
  top.silverEquations = [
    top.topName ++ ".varScopes = [];",
    top.topName ++ ".modScopes = [];"
    --top.topName ++ ".ok = true;"
  ];
}

--------------------------------------------------

attribute silverEquations occurs on Decl;

attribute topName occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local dsNameSilver::String = "Decls_" ++ toString(genInt());
  local modScopeNameSilver::String = "modScope_" ++ toString(genInt());
  top.silverEquations = [
    "local " ++ modScopeNameSilver ++ "::Scope = mkScopeMod(" ++ top.topName ++ ".s, " ++ dsNameSilver ++ ".varScopes, " ++ dsNameSilver ++ ".modScopes, " ++ idNameSilver ++ ");",
    top.topName ++ ".varScopes = [];",
    top.topName ++ ".modScopes = [" ++ modScopeNameSilver ++ "];",
    top.topName ++ ".impScope = nothing();",
    dsNameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ok = " ++ dsNameSilver ++ ".ok;"
  ] ++ ds.silverEquations;

  ds.topName = dsNameSilver;
}

aspect production declImport
top::Decl ::= r::ModRef
{
  local rNameSilver::String = "ModRef_" ++ toString(genInt());
  top.silverEquations = [
    top.topName ++ ".varScopes = [];",
    top.topName ++ ".modScopes = [];",
    top.topName ++ ".impScope = " ++ rNameSilver ++ ".declScope;",
    rNameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ok = true;"
  ] ++ r.silverEquations;

  r.topName = rNameSilver;
}

aspect production declDef
top::Decl ::= b::ParBind
{
  local bNameSilver::String = "ParBind_" ++ toString(genInt());

  top.silverEquations = [
    top.topName ++ ".varScopes = " ++ bNameSilver ++ ".varScopes;",
    top.topName ++ ".modScopes = [];",
    top.topName ++ ".impScope = nothing();",
    bNameSilver ++ ".s = " ++ top.topName ++ ".sLookup;"
    --top.topName ++ ".ok = " ++ bNameSilver ++ ".ok;"
  ] ++ b.silverEquations;

  b.topName = bNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on Expr;

attribute topName occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.silverEquations = [
    --top.topName ++ ".ty = tInt();"
  ];
}

aspect production exprTrue
top::Expr ::=
{
  top.silverEquations = [
    --top.topName ++ ".ty = tBool();"
  ];
}

aspect production exprFalse
top::Expr ::=
{
  top.silverEquations = [
    --top.topName ++ ".ty = tBool();"
  ];
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  local rNameSilver::String = "VarRef_" ++ toString(genInt());

  top.silverEquations = [
    rNameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = case " ++ rNameSilver ++ ".datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;"
  ] ++ r.silverEquations;

  r.topName = rNameSilver;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tInt() && " ++ e2NameSilver ++ ".ty == tInt() then tInt() else tErr();"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e2.topName = e2NameSilver;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tInt() && " ++ e2NameSilver ++ ".ty == tInt() then tInt() else tErr();"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e2.topName = e2NameSilver;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tInt() && " ++ e2NameSilver ++ ".ty == tInt() then tInt() else tErr();"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e2.topName = e2NameSilver;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tInt() && " ++ e2NameSilver ++ ".ty == tInt() then tInt() else tErr();"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e2.topName = e2NameSilver;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tBool() && " ++ e2NameSilver ++ ".ty == tBool() then tBool() else tErr();"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e2.topName = e2NameSilver;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tBool() && " ++ e2NameSilver ++ ".ty == tBool() then tBool() else tErr();"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e2.topName = e2NameSilver;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == " ++ e2NameSilver ++ ".ty then tBool() else tErr();"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e2.topName = e2NameSilver;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = case " ++ e1NameSilver ++ ".ty, " ++ e2NameSilver ++ ".ty of | tFun(t1, t2), t3 when t1 == t3 -> t3 | _, _ -> tErr() end;"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e2.topName = e2NameSilver;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());
  local e3NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e3NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tBool() && " ++ e2NameSilver ++ ".ty == " ++ e3NameSilver ++ ".ty then " ++ e2NameSilver ++ ".ty else tErr();"
  ] ++ e1.silverEquations ++ e2.silverEquations ++ e3.silverEquations;

  e1.topName = e1NameSilver;
  e2.topName = e2NameSilver;
  e3.topName = e3NameSilver;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local funScopeNameSilver::String = "funScope_" ++ toString(genInt());
  local dNameSilver::String = "ArgDecl_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ funScopeNameSilver ++ "::Scope = mkScopeLet(" ++ top.topName ++ ".s, " ++ dNameSilver ++ ".varScopes);",
    dNameSilver ++ ".s = " ++ funScopeNameSilver ++ ";",
    eNameSilver ++ ".s = " ++ funScopeNameSilver ++ ";"
    --top.topName ++ ".ty = tFun(" ++ dNameSilver ++ ".ty, " ++ eNameSilver ++ ".ty);"
  ] ++ d.silverEquations ++ e.silverEquations;

  d.topName = dNameSilver;
  e.topName = eNameSilver;
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local letScopeNameSilver::String = "letScope_" ++ toString(genInt());
  local bsNameSilver::String = "SeqBinds_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ letScopeNameSilver ++ "::Scope = mkScopeLet(" ++ bsNameSilver ++ ".lastScope, " ++ bsNameSilver ++ ".varScopes);",
    bsNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    eNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";"
    --top.topName ++ ".ty = " ++ eNameSilver ++ ".ty;"
  ] ++ bs.silverEquations ++ e.silverEquations;

  bs.topName = bsNameSilver;
  e.topName = eNameSilver;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScopeNameSilver::String = "letScope_" ++ toString(genInt());
  local bsNameSilver::String = "ParBinds_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ letScopeNameSilver ++ "::Scope = mkScopeLet(" ++ top.topName ++ ".s, " ++ bsNameSilver ++ ".varScopes);",
    bsNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";",
    eNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";"
    --top.topName ++ ".ty = " ++ eNameSilver ++ ".ty;"
  ] ++ bs.silverEquations ++ e.silverEquations;

  bs.topName = bsNameSilver;
  e.topName = eNameSilver;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScopeNameSilver::String = "letScope_" ++ toString(genInt());
  local bsNameSilver::String = "ParBinds_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ letScopeNameSilver ++ "::Scope = mkScopeLet(" ++ top.topName ++ ".s, " ++ bsNameSilver ++ ".varScopes);",
    bsNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    eNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";"
    --top.topName ++ ".ty = " ++ eNameSilver ++ ".ty;"
  ] ++ bs.silverEquations ++ e.silverEquations;

  bs.topName = bsNameSilver;
  e.topName = eNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on SeqBinds;

attribute topName occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.silverEquations = [
    top.topName ++ ".varScopes = [];",
    top.topName ++ ".lastScope = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ok = true;"
  ];
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  local sNameSilver::String = "SeqBind_" ++ toString(genInt());

  top.silverEquations = [
    sNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".varScopes = " ++ sNameSilver ++ ".varScopes;",
    top.topName ++ ".lastScope = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ok = " ++ sNameSilver ++ ".ok;"
  ] ++ s.silverEquations;

  s.topName = sNameSilver;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local letBindScopeNameSilver::String = "letBindScope_" ++ toString(genInt());
  local sNameSilver::String = "SeqBind_" ++ toString(genInt());
  local ssNameSilver::String = "SeqBinds_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ letBindScopeNameSilver ++ "::Scope = mkScopeSeqBind(" ++ top.topName ++ ".s, " ++ sNameSilver ++ ".varScopes);",
    sNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    ssNameSilver ++ ".s = " ++ letBindScopeNameSilver ++ ";",
    top.topName ++ ".varScopes = " ++ ssNameSilver ++ ".varScopes;",
    top.topName ++ ".lastScope = " ++ ssNameSilver ++ ".lastScope;"
    --top.topName ++ ".ok = " ++ sNameSilver ++ ".ok && " ++ ssNameSilver ++ ".ok;"
  ] ++ s.silverEquations ++ ss.silverEquations;

  s.topName = sNameSilver;
  ss.topName = ssNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on SeqBind;

attribute topName occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local varScopeNameSilver::String = "varScope_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ varScopeNameSilver ++ "::Scope = mkScopeVar((" ++ idNameSilver ++ ", " ++ eNameSilver ++ ".ty));",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".varScopes = [" ++ varScopeNameSilver ++ "];"
    --top.topName ++ ".ok = " ++ eNameSilver ++ ".ty != tErr();"
  ] ++ e.silverEquations;

  e.topName = eNameSilver;
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local tyNameSilver::String = "Type_" ++ toString(genInt());
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local varScopeNameSilver::String = "varScope_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ varScopeNameSilver ++ "::Scope = mkScopeVar((" ++ idNameSilver ++ ", " ++ tyNameSilver ++ "));",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    tyNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".varScopes = [" ++ varScopeNameSilver ++ "];"
    --top.topName ++ ".ok = " ++ tyNameSilver ++ " == " ++ eNameSilver ++ ".ty;"
  ] ++ ty.silverEquations ++ e.silverEquations;

  e.topName = eNameSilver;
  ty.topName = tyNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on ParBinds;

attribute topName occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.silverEquations = [
    top.topName ++ ".varScopes = [];"
    --top.topName ++ "ok = true;"
  ];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  local sNameSilver::String = "ParBind_" ++ toString(genInt());
  local ssNameSilver::String = "ParBinds_" ++ toString(genInt());

  top.silverEquations = [
    sNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    ssNameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ok = " ++ sNameSilver ++ ".ok && " ++ ssNameSilver ++ ".ok;"
  ] ++ s.silverEquations ++ ss.silverEquations;

  s.topName = sNameSilver;
  ss.topName = sNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on ParBind;

attribute topName occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local varScopeNameSilver::String = "varScope_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ varScopeNameSilver ++ "::Scope = mkScopeVar((" ++ idNameSilver ++ ", " ++ eNameSilver ++ ".ty));",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".varScopes = [" ++ varScopeNameSilver ++ "];"
    --top.topName ++ ".ok = " ++ eNameSilver ++ ".ty != tErr();"
  ] ++ e.silverEquations;

  e.topName = eNameSilver;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local tyNameSilver::String = "Type_" ++ toString(genInt());
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local varScopeNameSilver::String = "varScope_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ varScopeNameSilver ++ "::Scope = mkScopeVar((" ++ idNameSilver ++ ", " ++ tyNameSilver ++ "));",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    tyNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".varScopes = [" ++ varScopeNameSilver ++ "];"
    --top.topName ++ ".ok = " ++ tyNameSilver ++ " == " ++ eNameSilver ++ ".ty;"
  ] ++ ty.silverEquations ++ e.silverEquations;

  e.topName = eNameSilver;
  ty.topName = tyNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on ArgDecl;

attribute topName occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local varScopeNameSilver::String = "varScope_" ++ toString(genInt());
  local tyannNameSilver::String = "Type_" ++ toString(genInt());

  top.silverEquations = [
    "local" ++ varScopeNameSilver ++ "::Scope = mkScopeVar((" ++ idNameSilver ++ ", " ++ tyannNameSilver ++ "));",
    tyannNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".varScopes = [" ++ varScopeNameSilver ++ "];"
    --top.topName ++ ".ty = " ++ tyannNameSilver ++ ".ty;"
  ] ++ tyann.silverEquations;

  tyann.topName = tyannNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on Type;

attribute topName occurs on Type;

aspect production tInt
top::Type ::=
{
  top.silverEquations = [
    --top.topName ++ ".ty = tInt();"
  ];
}

aspect production tBool
top::Type ::=
{
  top.silverEquations = [
    --top.topName ++ ".ty = tBool();"
  ];
}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  local tyann1NameSilver::String = "Type_" ++ toString(genInt());
  local tyann2NameSilver::String = "Type_" ++ toString(genInt());
  top.silverEquations = [
    --top.topName ++ ".ty = tFun(" ++ tyann1NameSilver ++ ".ty, " ++ tyann2NameSilver ++ ".ty);"
  ] ++ tyann1.silverEquations ++ tyann2.silverEquations;
  tyann1.topName = tyann1NameSilver;
  tyann2.topName = tyann2NameSilver;
}

aspect production tErr
top::Type ::=
{
  top.silverEquations = [
    --top.topName ++ ".ty = tErr();"
  ];
}

--------------------------------------------------

attribute silverEquations occurs on ModRef;

attribute topName occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  local regexNameSilver::String = "regex_" ++ toString(genInt());
  local dfaNameSilver::String = "dfa_" ++ toString(genInt());
  local resFunNameSilver::String = "resFun_" ++ toString(genInt());
  local resultNameSilver::String = "result_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ regexNameSilver ++ "::Regex = `LEX* IMP? MOD`;",
    "local " ++ dfaNameSilver ++ "::DFA = " ++ regexNameSilver ++ ".dfa;",
    "local " ++ resFunNameSilver ++ "::ResFunTy = resolutionFun(" ++ dfaNameSilver ++ ");",
    "local " ++ resultNameSilver ++ "::[Decorated Scope] = " ++ resFunNameSilver ++ "(" ++ top.topName ++ ".s, \"" ++ x ++ "\");",
    top.topName ++ ".declScope = \n" ++
      "\tcase " ++ resultNameSilver ++ " of\n" ++
        "\t| s::_ -> just(s)\n" ++
        "\t| [] -> nothing()\n" ++
      "\tend;",
    top.topName ++ ".ok = " ++ top.topName ++ ".declScope.isJust;"
  ];
}


aspect production modQRef
top::ModRef ::= r::ModRef x::String
{
  local rNameSilver::String = "ModRef_" ++ toString(genInt());
  local regexNameSilver::String = "regex_" ++ toString(genInt());
  local dfaNameSilver::String = "dfa_" ++ toString(genInt());
  local resFunNameSilver::String = "resFun_" ++ toString(genInt());
  local resultNameSilver::String = "result_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ regexNameSilver ++ "::Regex = `MOD`;",
    "local " ++ dfaNameSilver ++ "::DFA = " ++ regexNameSilver ++ ".dfa;",
    "local " ++ resFunNameSilver ++ "::ResFunTy = resolutionFun(" ++ dfaNameSilver ++ ");",
    "local " ++ resultNameSilver ++ "::[Decorated Scope] = case " ++ rNameSilver ++ ".declScope of just(p_mod) -> " ++ resFunNameSilver ++ "(p_mod, \"" ++ x ++ "\") | _ -> [] end;",
    top.topName ++ ".declScope = \n" ++
      "\tcase " ++ resultNameSilver ++ " of\n" ++
        "\t| s::_ -> just(s)\n" ++
        "\t| [] -> nothing()\n" ++
      "\tend;",
    top.topName ++ ".ok = " ++ top.topName ++ ".declScope.isJust;"
  ] ++ r.silverEquations;

  r.topName = rNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on VarRef;

attribute topName occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local regexNameSilver::String = "regex_" ++ toString(genInt());
  local dfaNameSilver::String = "dfa_" ++ toString(genInt());
  local resFunNameSilver::String = "resFun_" ++ toString(genInt());
  local resultNameSilver::String = "result_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ regexNameSilver ++ "::Regex = `LEX* IMP? VAR`;",
    "local " ++ dfaNameSilver ++ "::DFA = " ++ regexNameSilver ++ ".dfa;",
    "local " ++ resFunNameSilver ++ "::ResFunTy = resolutionFun(" ++ dfaNameSilver ++ ");",
    "local " ++ resultNameSilver ++ "::[Decorated Scope] = " ++ resFunNameSilver ++ "(" ++ top.topName ++ ".s, \"" ++ x ++ "\");",
    top.topName ++ ".declScope = \n" ++
      "\tcase " ++ resultNameSilver ++ " of\n" ++
        "\t| s::_ -> just(s)\n" ++
        "\t| [] -> nothing()\n" ++
      "\tend;",
    top.topName ++ ".ok = " ++ top.topName ++ ".declScope.isJust;"
  ];
}

aspect production varQRef
top::VarRef ::= r::ModRef x::String
{
  local rNameSilver::String = "ModRef_" ++ toString(genInt());
  local regexNameSilver::String = "regex_" ++ toString(genInt());
  local dfaNameSilver::String = "dfa_" ++ toString(genInt());
  local resFunNameSilver::String = "resFun_" ++ toString(genInt());
  local resultNameSilver::String = "result_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ regexNameSilver ++ "::Regex = `VAR`;",
    "local " ++ dfaNameSilver ++ "::DFA = " ++ regexNameSilver ++ ".dfa;",
    "local " ++ resFunNameSilver ++ "::ResFunTy = resolutionFun(" ++ dfaNameSilver ++ ");",
    "local " ++ resultNameSilver ++ "::[Decorated Scope] = case " ++ rNameSilver ++ ".declScope of just(p_mod) -> " ++ resFunNameSilver ++ "(p_mod, \"" ++ x ++ "\") | _ -> [] end;",
    top.topName ++ ".declScope = \n" ++
      "\tcase " ++ resultNameSilver ++ " of\n" ++
        "\t| s::_ -> just(s)\n" ++
        "\t| [] -> nothing()\n" ++
      "\tend;",
    top.topName ++ ".ok = " ++ top.topName ++ ".declScope.isJust;"
  ] ++ r.silverEquations;

  r.topName = rNameSilver;
}