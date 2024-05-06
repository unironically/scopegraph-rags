grammar lm_semantics_1:nameanalysis;

--------------------------------------------------

synthesized attribute jastEquations::[String];

--------------------------------------------------

attribute jastEquations occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local dsNameSilver::String = "Decls_" ++ toString (genInt());
  local globalScopeName::String = "globalScope";
  local topName::String = "Main_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ globalScopeName ++ "::Scope = mkScope();",
    ds.topName ++ ".s = " ++ globalScopeName ++ ";"
    --topName ++ ".ok = " ++ dsNameSilver ++ ".ok;"
  ] ++ ds.jastEquations;

}

--------------------------------------------------

attribute jastEquations occurs on Decls;


aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local dNameSilver::String = "Decl_" ++ toString (genInt());
  local dsNameSilver::String = "Decls_" ++ toString (genInt());

  top.jastEquations = [
    dNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    dsNameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ok = " ++ dNameSilver ++ ".ok && " ++ dsNameSilver ++ ".ok;"
  ] ++ d.jastEquations ++ ds.jastEquations;

}

aspect production declsNil
top::Decls ::= 
{
  top.jastEquations = [
    --top.topName ++ ".ok = true;"
  ];
}

--------------------------------------------------

attribute jastEquations occurs on Decl;


aspect production declDef
top::Decl ::= b::ParBind
{
  local bNameSilver::String = "ParBind_" ++ toString (genInt());

  top.jastEquations = [
    bNameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ok = " ++ bNameSilver ++ ".ok;"
  ] ++ b.jastEquations;

}

--------------------------------------------------

attribute jastEquations occurs on Expr;


aspect production exprInt
top::Expr ::= i::Integer
{
  top.jastEquations = [
    --top.topName ++ ".ty = tInt();"
  ];
}

aspect production exprTrue
top::Expr ::= 
{
  top.jastEquations = [
    --top.topName ++ ".ty = tBool();"
  ];
}

aspect production exprFalse
top::Expr ::= 
{
  top.jastEquations = [
    --top.topName ++ ".ty = tBool();"
  ];
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  local rNameSilver::String = "VarRef_" ++ toString (genInt());

  top.jastEquations = [
    rNameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = case " ++ rNameSilver ++ ".datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;"
  ] ++ r.jastEquations;

}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString (genInt());
  local e2NameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tInt() && " ++ e2NameSilver ++ ".ty == tInt() then tInt() else tErr();"
  ] ++ e1.jastEquations ++ e2.jastEquations;

}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString (genInt());
  local e2NameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tInt() && " ++ e2NameSilver ++ ".ty == tInt() then tInt() else tErr();"
  ] ++ e1.jastEquations ++ e2.jastEquations;

}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString (genInt());
  local e2NameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tInt() && " ++ e2NameSilver ++ ".ty == tInt() then tInt() else tErr();"
  ] ++ e1.jastEquations ++ e2.jastEquations;

}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString (genInt());
  local e2NameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tInt() && " ++ e2NameSilver ++ ".ty == tInt() then tInt() else tErr();"
  ] ++ e1.jastEquations ++ e2.jastEquations;

}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString (genInt());
  local e2NameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tBool() && " ++ e2NameSilver ++ ".ty == tBool() then tBool() else tErr();"
  ] ++ e1.jastEquations ++ e2.jastEquations;

}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString (genInt());
  local e2NameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tBool() && " ++ e2NameSilver ++ ".ty == tBool() then tBool() else tErr();"
  ] ++ e1.jastEquations ++ e2.jastEquations;

}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString (genInt());
  local e2NameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == " ++ e2NameSilver ++ ".ty then tBool() else tErr();"
  ] ++ e1.jastEquations ++ e2.jastEquations;

}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString (genInt());
  local e2NameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = case " ++ e1NameSilver ++ ".ty, " ++ e2NameSilver ++ ".ty of | tFun(t1, t2), t3 when t1 == t3 -> t3 | _, _ -> tErr() end;"
  ] ++ e1.jastEquations ++ e2.jastEquations;

}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  local e1NameSilver::String = "Expr_" ++ toString (genInt());
  local e2NameSilver::String = "Expr_" ++ toString (genInt());
  local e3NameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    e1NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e2NameSilver ++ ".s = " ++ top.topName ++ ".s;",
    e3NameSilver ++ ".s = " ++ top.topName ++ ".s;"
    --top.topName ++ ".ty = if " ++ e1NameSilver ++ ".ty == tBool() && " ++ e2NameSilver ++ ".ty == " ++ e3NameSilver ++ ".ty then " ++ e2NameSilver ++ ".ty else tErr();"
  ] ++ e1.jastEquations ++ e2.jastEquations ++ e3.jastEquations;

}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr 
{
  local funScopeNameSilver::String = "funScope_" ++ toString(genInt());
  local dNameSilver::String = "ArgDecl_" ++ toString (genInt());
  local eNameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ funScopeNameSilver ++ "::Scope = mkScope();",
    dNameSilver ++ ".s = " ++ funScopeNameSilver ++ ";",
    eNameSilver ++ ".s = " ++ funScopeNameSilver ++ ";"
    --top.topName ++ ".ty = tFun(" ++ dNameSilver ++ ".ty, " ++ eNameSilver ++ ".ty);"
  ] ++ d.jastEquations ++ e.jastEquations;

}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local letScopeNameSilver::String = "letScope_" ++ toString (genInt());
  local bsNameSilver::String = "SeqBinds_" ++ toString (genInt());
  local eNameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ letScopeNameSilver ++ "::Scope = mkScopeLet();",
    bsNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    bsNameSilver ++ ".s_def = " ++ letScopeNameSilver ++ ";",
    eNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";"
    --top.topName ++ ".ty = " ++ eNameSilver ++ ".ty;"
  ] ++ bs.jastEquations ++ e.jastEquations;

}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScopeNameSilver::String = "letScope_" ++ toString (genInt());
  local bsNameSilver::String = "ParBinds_" ++ toString (genInt());
  local eNameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ letScopeNameSilver ++ "::Scope = mkScopeLet();",
    bsNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";",
    bsNameSilver ++ ".s_def = " ++ letScopeNameSilver ++ ";",
    eNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";"
    --top.topName ++ ".ty = " ++ eNameSilver ++ ".ty;"
  ] ++ bs.jastEquations ++ e.jastEquations;

}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScopeNameSilver::String = "letScope_" ++ toString (genInt());
  local bsNameSilver::String = "ParBinds_" ++ toString (genInt());
  local eNameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ letScopeNameSilver ++ "::Scope = mkScopeLet();",
    bsNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    bsNameSilver ++ ".s_def = " ++ letScopeNameSilver ++ ";",
    eNameSilver ++ ".s = " ++ letScopeNameSilver ++ ";"
    --top.topName ++ ".ty = " ++ eNameSilver ++ ".ty;"
  ] ++ bs.jastEquations ++ e.jastEquations;

}

--------------------------------------------------

attribute jastEquations occurs on SeqBinds;


aspect production seqBindsNil
top::SeqBinds ::=
{
  top.jastEquations = [
    top.topName ++ "s_def.lexScopes <- [" ++ top.topName ++ ".s];"
    --top.topName ++ ".ok = true;"
  ];
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  local sNameSilver::String = "SeqBind_" ++ toString (genInt());

  top.jastEquations = [
    sNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ "s_def.lexScopes <- [" ++ top.topName ++ ".s];"
    --top.topName ++ ".ok = " ++ sNameSilver ++ ".ok;"
  ] ++ s.jastEquations;

}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local letBindScopeNameSilver::String = "letBindScope_" ++ toString (genInt()); 
  local sNameSilver::String = "SeqBind_" ++ toString (genInt());
  local ssNameSilver::String = "SeqBinds_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ letBindScopeNameSilver ++ "::Scope = mkScopeSeqBind();",
    letBindScopeNameSilver ++ ".lexScopes <- " ++ top.topName ++ ".s;",
    sNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    sNameSilver ++ ".s_def = " ++ letBindScopeNameSilver ++ ";",
    ssNameSilver ++ ".s = " ++ letBindScopeNameSilver ++ ";",
    ssNameSilver ++ ".s_def = " ++ top.topName ++ ".s_def;"
    --top.topName ++ ".ok = " ++ sNameSilver ++ ".ok && " ++ ssNameSilver ++ ".ok;"
  ] ++ s.jastEquations ++ ss.jastEquations;

}

--------------------------------------------------

attribute jastEquations occurs on SeqBind;


aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local varScopeNameSilver::String = "varScope_" ++ toString (genInt());
  local eNameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ varScopeNameSilver ++ "::Scope = mkScopeVar((" ++ idNameSilver ++ ", " ++ eNameSilver ++ ".ty));",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".s_def.varScopes <- [" ++ varScopeNameSilver ++ "];"
    --top.topName ++ ".ok = " ++ eNameSilver ++ ".ty != tErr();"
  ] ++ e.jastEquations;

}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local tyNameSilver::String = "Type_" ++ toString (genInt());
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local varScopeNameSilver::String = "varScope_" ++ toString (genInt());
  local eNameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ varScopeNameSilver ++ "::Scope = mkScopeVar((" ++ idNameSilver ++ ", " ++ tyNameSilver ++ "));",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    tyNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".s_def.varScopes <- [" ++ varScopeNameSilver ++ "];"
    --top.topName ++ ".ok = " ++ tyNameSilver ++ " == " ++ eNameSilver ++ ".ty;"
  ] ++ ty.jastEquations ++ e.jastEquations;

}

--------------------------------------------------

attribute jastEquations occurs on ParBinds;


aspect production parBindsNil
top::ParBinds ::=
{
  top.jastEquations = [
    --top.topName ++ "ok = true;"
  ];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  local sNameSilver::String = "ParBind_" ++ toString (genInt());
  local ssNameSilver::String = "ParBinds_" ++ toString (genInt());

  top.jastEquations = [
    sNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    sNameSilver ++ ".s_def = " ++ top.topName ++ ".s_def;",
    ssNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    ssNameSilver ++ ".s_def = " ++ top.topName ++ ".s_def;"
    --top.topName ++ ".ok = " ++ sNameSilver ++ ".ok && " ++ ssNameSilver ++ ".ok;"
  ] ++ s.jastEquations ++ ss.jastEquations;

}

--------------------------------------------------

attribute jastEquations occurs on ParBind;


aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local varScopeNameSilver::String = "varScope_" ++ toString (genInt());
  local eNameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ varScopeNameSilver ++ "::Scope = mkScopeVar((" ++ idNameSilver ++ ", " ++ eNameSilver ++ ".ty));",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".s_def.varScopes <- [" ++ varScopeNameSilver ++ "];"
    --top.topName ++ ".ok = " ++ eNameSilver ++ ".ty != tErr();"
  ] ++ e.jastEquations;

}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local tyNameSilver::String = "Type_" ++ toString (genInt());
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local varScopeNameSilver::String = "varScope_" ++ toString (genInt());
  local eNameSilver::String = "Expr_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ varScopeNameSilver ++ "::Scope = mkScopeVar((" ++ idNameSilver ++ ", " ++ tyNameSilver ++ "));",
    eNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    tyNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".s_def.varScopes <- [" ++ varScopeNameSilver ++ "];"
    --top.topName ++ ".ok = " ++ tyNameSilver ++ " == " ++ eNameSilver ++ ".ty;"
  ] ++ ty.jastEquations ++ e.jastEquations;

}

--------------------------------------------------

attribute jastEquations occurs on ArgDecl;


aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  local idNameSilver::String = "\"" ++ id ++ "\"";
  local varScopeNameSilver::String = "varScope_" ++ toString (genInt());
  local tyannNameSilver::String = "Type_" ++ toString (genInt());

  top.jastEquations = [
    "local" ++ varScopeNameSilver ++ "::Scope = mkScopeVar((" ++ idNameSilver ++ ", " ++ tyannNameSilver ++ "));",
    tyannNameSilver ++ ".s = " ++ top.topName ++ ".s;",
    top.topName ++ ".s.varScopes <- [" ++ varScopeNameSilver ++ "];"
    --top.topName ++ ".ty = " ++ tyannNameSilver ++ ".ty;"
  ] ++ tyann.jastEquations;

}

--------------------------------------------------

attribute jastEquations occurs on Type;


aspect production tInt
top::Type ::= 
{
  top.jastEquations = [
    --top.topName ++ ".ty = tInt();"
  ];
}

aspect production tBool
top::Type ::= 
{
  top.jastEquations = [
    --top.topName ++ ".ty = tBool();"
  ];
}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  local tyann1NameSilver::String = "Type_" ++ toString (genInt());
  local tyann2NameSilver::String = "Type_" ++ toString (genInt());
  top.jastEquations = [
    --top.topName ++ ".ty = tFun(" ++ tyann1NameSilver ++ ".ty, " ++ tyann2NameSilver ++ ".ty);"
  ] ++ tyann1.jastEquations ++ tyann2.jastEquations;
}

aspect production tErr
top::Type ::=
{
  top.jastEquations = [
    --top.topName ++ ".ty = tErr();"
  ];
}

--------------------------------------------------

attribute jastEquations occurs on VarRef;


aspect production varRef
top::VarRef ::= x::String
{
  local regexNameSilver::String = "regex_" ++ toString (genInt());
  local dfaNameSilver::String = "dfa_" ++ toString (genInt());
  local resFunNameSilver::String = "resFun_" ++ toString (genInt());
  local resultNameSilver::String = "result_" ++ toString (genInt());
  local declNameSilver::String = "decl_" ++ toString (genInt());

  top.jastEquations = [
    "local " ++ regexNameSilver ++ "::Regex = `LEX* VAR`;",
    "local " ++ dfaNameSilver ++ "::DFA = " ++ regexNameSilver ++ ".dfa;",
    "local " ++ resFunNameSilver ++ "::ResFunTy = resolutionFun(" ++ dfaNameSilver ++ ");",
    "local " ++ resultNameSilver ++ "::[Decorated Scope] = " ++ resFunNameSilver ++ "(" ++ top.topName ++ ".s, \"" ++ x ++ "\");",
    top.topName ++ ".datum = \n" ++
      "\tcase " ++ resultNameSilver ++ " of\n" ++
        "\t| s::_ -> s.datum\n" ++ 
        "\t| [] -> nothing()\n" ++
      "\tend;"
  ];
}