grammar lm_resolve1:nameanalysis;

--------------------------------------------------

synthesized attribute silverEquations::[String];

inherited attribute topName::String;
inherited attribute sNameSilver::String;
inherited attribute s_lookupNameSilver::String;

--------------------------------------------------

attribute silverEquations occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local dsName::String = "Decls_" ++ toString(genInt());
  local globalScopeName::String = "globalScope";

  top.silverEquations = [
    "local " ++ globalScopeName ++ "::Scope = mkScopeGlobal(" ++ ds.topName ++ ".varScopes, " ++ ds.topName ++ ".modScopes);",
    ds.topName ++ ".s = " ++ globalScopeName ++ ";",
    ds.topName ++ ".s_lookup = " ++ globalScopeName ++ ";"
  ] ++ ds.silverEquations;

  ds.topName = dsName;
  ds.sNameSilver = globalScopeName;
  ds.s_lookupNameSilver = globalScopeName;
}

--------------------------------------------------

attribute silverEquations occurs on Decls;

attribute topName occurs on Decls;
attribute sNameSilver occurs on Decls;
attribute s_lookupNameSilver occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local dNameSilver::String = "Decl_" ++ toString(genInt());
  local dsNameSilver::String = "Decls_" ++ toString(genInt());
  local s_impNameSilver::String = "s_imp_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ s_impNameSilver ++ "::Scope = mkLookupScope(" ++ top.topName ++ ".s_lookup, " ++ dNameSilver ++ ".impScope);",
    dNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    dNameSilver ++ ".s_lookup = " ++ s_impNameSilver ++ ";",
    dsNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    dsNameSilver ++ ".s_lookup = " ++ s_impNameSilver ++ ";",
    top.topName ++ ".varScopes = " ++ dNameSilver ++ ".varScopes ++ " ++ dsNameSilver ++ ".varScopes;",
    top.topName ++ ".modScopes = " ++ dNameSilver ++ ".modScopes ++ " ++ dsNameSilver ++ ".modScopes;"
  ] ++ d.silverEquations ++ ds.silverEquations;

  d.topName = dNameSilver;
  d.sNameSilver = top.sNameSilver;
  d.s_lookupNameSilver = s_impNameSilver;
  ds.topName = dsNameSilver;
  ds.sNameSilver = top.sNameSilver;
  ds.s_lookupNameSilver = s_impNameSilver;
}

aspect production declsNil
top::Decls ::=
{
  top.silverEquations = [
    top.topName ++ ".varScopes = [];",
    top.topName ++ ".modScopes = [];"
  ];
}

--------------------------------------------------

attribute silverEquations occurs on Decl;

attribute topName occurs on Decl;
attribute sNameSilver occurs on Decl;
attribute s_lookupNameSilver occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local dsNameSilver::String = "Decls_" ++ toString(genInt());
  local s_modNameSilver::String = "s_mod_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ s_modNameSilver ++ "::Scope = mkScopeMod(" ++ top.topName ++ ".s, " ++ dsNameSilver ++ ".varScopes, " ++ dsNameSilver ++ ".modScopes, " ++ top.topName ++ ");",
    top.topName ++ ".varScopes = [];",
    top.topName ++ ".modScopes = [" ++ s_modNameSilver ++ "];",
    top.topName ++ ".impScope = nothing();",
    dsNameSilver ++ ".s = " ++ s_modNameSilver ++ ";",
    dsNameSilver ++ ".s_lookup = " ++ s_modNameSilver ++ ";"
  ] ++ ds.silverEquations;
  
  ds.topName = dsNameSilver;
  ds.sNameSilver = s_modNameSilver;
  ds.s_lookupNameSilver = s_modNameSilver;
}

aspect production declImport
top::Decl ::= r::ModRef
{
  local rNameSilver::String = "ModRef_" ++ toString(genInt());

  top.silverEquations = [
    top.topName ++ ".varScopes = [];",
    top.topName ++ ".modScopes = [];",
    top.topName ++ ".impScope = " ++ rNameSilver ++ ".impScope;"
  ] ++ r.silverEquations;

  r.sNameSilver = top.sNameSilver;
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
    bNameSilver ++ ".s = " ++ top.topName ++ ".s_lookup;"
  ] ++ b.silverEquations;

  b.topName = bNameSilver;
  b.sNameSilver = top.s_lookupNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on Expr;

attribute topName occurs on Expr;
attribute sNameSilver occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.silverEquations = [];
}

aspect production exprTrue
top::Expr ::=
{
  top.silverEquations = [];
}

aspect production exprFalse
top::Expr ::=
{
  top.silverEquations = [];
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  local rNameSilver::String = "VarRef_" ++ toString(genInt());

  top.silverEquations = [
    rNameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ r.silverEquations;

  r.topName = rNameSilver;
  r.sNameSilver = top.sNameSilver;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e1.sNameSilver = top.sNameSilver;
  e2.topName = e2NameSilver;
  e2.sNameSilver = top.sNameSilver;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e1.sNameSilver = top.sNameSilver;
  e2.topName = e2NameSilver;
  e2.sNameSilver = top.sNameSilver;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e1.sNameSilver = top.sNameSilver;
  e2.topName = e2NameSilver;
  e2.sNameSilver = top.sNameSilver;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e1.sNameSilver = top.sNameSilver;
  e2.topName = e2NameSilver;
  e2.sNameSilver = top.sNameSilver;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e1.sNameSilver = top.sNameSilver;
  e2.topName = e2NameSilver;
  e2.sNameSilver = top.sNameSilver;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e1.sNameSilver = top.sNameSilver;
  e2.topName = e2NameSilver;
  e2.sNameSilver = top.sNameSilver;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e1.sNameSilver = top.sNameSilver;
  e2.topName = e2NameSilver;
  e2.sNameSilver = top.sNameSilver;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString(genInt());
  local e2NameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ e1.silverEquations ++ e2.silverEquations;

  e1.topName = e1NameSilver;
  e1.sNameSilver = top.sNameSilver;
  e2.topName = e2NameSilver;
  e2.sNameSilver = top.sNameSilver;
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
  ] ++ e1.silverEquations ++ e2.silverEquations ++ e3.silverEquations;

  e1.topName = e1NameSilver;
  e1.sNameSilver = top.sNameSilver;
  e2.topName = e2NameSilver;
  e2.sNameSilver = top.sNameSilver;
  e3.topName = e3NameSilver;
  e3.sNameSilver = top.sNameSilver;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local dNameSilver::String = "ArgDecl_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    dNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ d.silverEquations ++ e.silverEquations;

  d.topName = dNameSilver;
  d.sNameSilver = top.sNameSilver;
  e.topName = eNameSilver;
  e.sNameSilver = top.sNameSilver;
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local letScopeNameSilver::String = "letScope_" ++ toString(genInt());
  local bsNameSilver::String = "SeqBinds_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ letScopeNameSilver ++ "::Scope = mkScope(just(" ++ bsNameSilver ++ ".lastScope), " ++ bsNameSilver ++ ".varScopes, [], nothing(), nothing());",
    bsNameSilver ++ ".s = " ++ top.sNameSilver ++ ".s;",
    eNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";"
  ] ++ bs.silverEquations ++ e.silverEquations;

  bs.topName = bsNameSilver;
  bs.sNameSilver = top.sNameSilver;
  e.topName = eNameSilver;
  e.sNameSilver = letScopeNameSilver;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScopeNameSilver::String = "letScope_" ++ toString(genInt());
  local bsNameSilver::String = "ParBinds_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ letScopeNameSilver ++ "::Scope = mkScope(just(" ++ top.topName ++ ".s), " ++ bsNameSilver ++ ".varScopes, [], nothing(), nothing());",
    bsNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";",
    eNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";"
  ] ++ bs.silverEquations ++ e.silverEquations;

  bs.topName = bsNameSilver;
  bs.sNameSilver = bsNameSilver;
  e.topName = eNameSilver;
  e.sNameSilver = letScopeNameSilver;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScopeNameSilver::String = "letScope_" ++ toString(genInt());
  local bsNameSilver::String = "ParBinds_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ letScopeNameSilver ++ "::Scope = mkScope(just(" ++ top.topName ++ ".s), " ++ bsNameSilver ++ ".varScopes, [], nothing(), nothing());",
    bsNameSilver ++ ".s = " ++ top.sNameSilver ++ ".s;",
    eNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";"
  ] ++ bs.silverEquations ++ e.silverEquations;

  bs.topName = bsNameSilver;
  bs.sNameSilver = bsNameSilver;
  e.topName = eNameSilver;
  e.sNameSilver = letScopeNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on SeqBinds;

attribute topName occurs on SeqBinds;
attribute sNameSilver occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.silverEquations = [
    top.topName ++ ".varScopes = [];",
    top.topName ++ ".lastScope = " ++ top.topName ++ ".s;"
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
  ] ++ s.silverEquations;

  s.topName = sNameSilver;
  s.sNameSilver = top.sNameSilver;
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
    top.topName ++ ".varScopes = [];",
    top.topName ++ ".lastScope = " ++ letBindScopeNameSilver ++ ";"
  ] ++ s.silverEquations ++ ss.silverEquations;

  s.topName = sNameSilver;
  s.sNameSilver = top.sNameSilver;
  ss.topName = ssNameSilver;
  ss.sNameSilver = letBindScopeNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on SeqBind;

attribute topName occurs on SeqBind;
attribute sNameSilver occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local varScopeNameSilver::String = "varScope_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ varScopeNameSilver ++ "::Scope = mkScopeSeqVar(" ++ top.topName ++ ");",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".varScopes = [" ++ varScopeNameSilver ++ "];"
  ] ++ e.silverEquations;

  e.topName = eNameSilver;
  e.sNameSilver = top.sNameSilver;
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local tyNameSilver::String = "Type_" ++ toString(genInt());
  local varScopeNameSilver::String = "varScope_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ varScopeNameSilver ++ "::Scope = mkScopeSeqVar(" ++ top.topName ++ ");",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    tyNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".varScopes = [" ++ varScopeNameSilver ++ "];"
  ] ++ ty.silverEquations ++ e.silverEquations;

  e.topName = eNameSilver;
  e.sNameSilver = top.sNameSilver;
  ty.topName = tyNameSilver;
  ty.sNameSilver = top.sNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on ParBinds;

attribute topName occurs on ParBinds;
attribute sNameSilver occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.silverEquations = [top.topName ++ ".varScopes = [];"];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  local sNameSilver::String = "ParBind_" ++ toString(genInt());
  local ssNameSilver::String = "ParBinds_" ++ toString(genInt());

  top.silverEquations = [
    sNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    ssNameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ s.silverEquations ++ ss.silverEquations;

  s.topName = sNameSilver;
  s.sNameSilver = top.sNameSilver;
  ss.topName = sNameSilver;
  ss.sNameSilver = top.sNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on ParBind;

attribute topName occurs on ParBind;
attribute sNameSilver occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local eNameSilver::String = "Expr_" ++ toString(genInt());
  local s_varNameSilver::String = "s_var_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ s_varNameSilver ++ "::Scope = mkScopeParVar(" ++ top.topName ++ ");",
    top.topName ++ ".varScopes = [" ++ s_varNameSilver ++ "];",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ e.silverEquations;

  e.topName = eNameSilver;
  e.sNameSilver = top.sNameSilver;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local tyNameSilver::String = "Type_" ++ toString(genInt());
  local eNameSilver::String = "Expr_" ++ toString(genInt());
  local s_varNameSilver::String = "s_var_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ s_varNameSilver ++ "::Scope = mkScopeParVar(" ++ top.topName ++ ");",
    top.topName ++ ".varScopes = [" ++ s_varNameSilver ++ "];",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    tyNameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ ty.silverEquations ++ e.silverEquations;

  ty.topName = tyNameSilver;
  ty.sNameSilver = top.sNameSilver;
  e.topName = eNameSilver;
  e.sNameSilver = top.sNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on ArgDecl;

attribute topName occurs on ArgDecl;
attribute sNameSilver occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local varScopeNameSilver::String = "varScope_" ++ toString(genInt());
  local tyNameSilver::String = "Type_" ++ toString(genInt());

  top.silverEquations = [
    "local" ++ varScopeNameSilver ++ "::Scope = mkScopeArgVar(" ++ top.topName ++ ");",
    tyNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".varScopes = [" ++ varScopeNameSilver ++ "];"
  ] ++ ty.silverEquations;

  ty.topName = tyNameSilver;
  ty.sNameSilver = top.sNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on Type;

attribute topName occurs on Type;
attribute sNameSilver occurs on Type;

aspect production tInt
top::Type ::=
{
  top.silverEquations = [];
}

aspect production tBool
top::Type ::=
{
  top.silverEquations = [];
}

aspect production tArrow
top::Type ::= tyann1::Type tyann2::Type
{
  local ty1NameSilver::String = "Type_" ++ toString(genInt());
  local ty2NameSilver::String = "Type_" ++ toString(genInt());

  top.silverEquations = [
    ty1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    ty2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
  ] ++ tyann1.silverEquations ++ tyann2.silverEquations;

  tyann1.topName = ty1NameSilver;
  tyann1.sNameSilver = top.sNameSilver;
  tyann2.topName = ty2NameSilver;
  tyann2.sNameSilver = top.sNameSilver;
}

--------------------------------------------------

attribute silverEquations occurs on ModRef;

attribute topName occurs on ModRef;
attribute sNameSilver occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  local regexNameSilver::String = "regex_" ++ toString(genInt());
  local dfaNameSilver::String = "dfa_" ++ toString(genInt());
  local resFunNameSilver::String = "resFun_" ++ toString(genInt());
  local resultNameSilver::String = "result_" ++ toString(genInt());
  local impXbindNameSilver::String = "impXbind" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ regexNameSilver ++ "::Regex = `LEX* IMP? MOD`;",
    "local " ++ dfaNameSilver ++ "::DFA = " ++ regexNameSilver ++ ".dfa;",
    "local " ++ resFunNameSilver ++ "::ResFunTy = resolutionFun(" ++ dfaNameSilver ++ ");",
    "local " ++ resultNameSilver ++ "::[Decorated Scope] = " ++ resFunNameSilver ++ "(" ++ top.topName ++ ".s, \"" ++ x ++ "\");",
    "local " ++ impXbindNameSilver ++ "::(Maybe<Decorated Scope>, [(String, String)]) =\n" ++
      "\tcase " ++ resultNameSilver ++ " of\n" ++
        "\t\t| s::_ ->\n\t\t\t(case s.datum of\n" ++
          "\t\t\t| just(datumMod(d)) -> (just(s), [(x, d.datumId)])\n" ++
          "\t\t\t| nothing() -> (nothing(), [])\n" ++
        "\t\t\tend)\n" ++
        "\t\t| [] -> (nothing(), [])\n" ++
      "\tend;",
    top.topName ++ ".impScope = fst(" ++ impXbindNameSilver ++ ");"
  ];
}

aspect production modQRef
top::ModRef ::= r::ModRef x::String
{
  top.silverEquations = []; -- TODO
}

--------------------------------------------------

attribute silverEquations occurs on VarRef;

attribute topName occurs on VarRef;
attribute sNameSilver occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local regexNameSilver::String = "regex_" ++ toString(genInt());
  local dfaNameSilver::String = "dfa_" ++ toString(genInt());
  local resFunNameSilver::String = "resFun_" ++ toString(genInt());
  local resultNameSilver::String = "result_" ++ toString(genInt());
  local declNameSilver::String = "decl_" ++ toString(genInt());

  top.silverEquations = [
    "local " ++ regexNameSilver ++ "::Regex = `LEX* IMP? VAR`;",
    "local " ++ dfaNameSilver ++ "::DFA = " ++ regexNameSilver ++ ".dfa;",
    "local " ++ resFunNameSilver ++ "::ResFunTy = resolutionFun(" ++ dfaNameSilver ++ ");",
    "local " ++ resultNameSilver ++ "::[Decorated Scope] = " ++ resFunNameSilver ++ "(" ++ top.topName ++ ".s, \"" ++ x ++ "\");",
    "local " ++ declNameSilver ++ "::Maybe<Decorated ParBind> =\n" ++
      "\tcase " ++ resultNameSilver ++ " of\n" ++
        "\t| s::_ ->\n\t\t(case s.datum of\n" ++
          "\t\t| just(datumVar(d)) -> just(d)\n" ++
          "\t\t| _ -> nothing()\n" ++
        "\t\tend)\n" ++
        "\t| [] -> nothing()\n" ++
      "\tend;"
  ];
}

aspect production varQRef
top::VarRef ::= r::ModRef x::String
{
  top.silverEquations = []; -- TODO
}