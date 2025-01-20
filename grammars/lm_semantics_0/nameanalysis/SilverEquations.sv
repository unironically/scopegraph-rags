grammar lm_semantics_0:nameanalysis;

--------------------------------------------------

synthesized attribute equations::[String];

synthesized attribute topNameRoot::String;
inherited attribute topName::String;

fun genName String ::= id::String = id ++ "_" ++ toString(genInt()); 

--------------------------------------------------

attribute equations, topNameRoot occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local topName::String = genName("program");
  local sName::String = topName ++ ".s";
  local dsName::String = genName("decls");

  ds.topName = dsName;

  top.equations = [
    "-- from " ++ topName,
    sName ++ " = mkScope()",
    dsName ++ ".s = " ++ sName,
    sName ++ ".var = " ++ dsName ++ ".VAR_s",
    sName ++ ".lex = " ++ dsName ++ ".LEX_s",
    topName ++ ".ok = " ++ dsName ++ ".ok"
  ] ++ ds.equations;

  top.topNameRoot = topName;
}

--------------------------------------------------

attribute topName, equations occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local dName::String = genName("decl");
  local dsName::String = genName("decls");

  d.topName = dName;
  ds.topName = dsName;

  top.equations = [
    "-- from " ++ top.topName,
    dName ++ ".s = " ++ top.topName ++ ".s",
    dsName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".VAR_s = " ++ dName ++ ".VAR_s ++ " ++ dsName ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ dName ++ ".LEX_s ++ " ++ dsName ++ ".LEX_s",
    top.topName ++ ".ok = " ++ dName ++ ".ok && " ++ dsName ++ ".ok"
  ] ++ d.equations ++ ds.equations;
}

aspect production declsNil
top::Decls ::=
{
  top.equations = [
    "-- from " ++ top.topName,
    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",
    top.topName ++ ".ok = true"
  ];
}

--------------------------------------------------

attribute topName, equations occurs on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{
  local bName::String = genName("parBind");

  b.topName = bName;

  top.equations = [
    "-- from " ++ top.topName,
    bName ++ ".s = " ++ top.topName ++ ".s",
    bName ++ ".s_def = " ++ top.topName ++ ".s",
    top.topName ++ ".VAR_s = " ++ bName ++ ".VAR_s ++" ++ bName ++ ".VAR_s_def",
    top.topName ++ ".LEX_s = " ++ bName ++ ".LEX_s ++ " ++ bName ++ ".LEX_s_def",
    top.topName ++ ".ok = " ++ bName ++ ".ok"
  ] ++ b.equations;
}

--------------------------------------------------

attribute topName, equations occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.equations = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty = tInt()",
    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",
    top.topName ++ ".ok = true"
  ];
}

aspect production exprTrue
top::Expr ::=
{
  top.equations = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty = tBool()",
    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",
    top.topName ++ ".ok = true"
  ];
}

aspect production exprFalse
top::Expr ::=
{
  top.equations = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty = tBool()",
    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",
    top.topName ++ ".ok = true"
  ];
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  local rName::String = genName("varRef");

  local tgtPairName::String = top.topName ++ ".tgtPair";
  local okTgtName::String = top.topName ++ ".okTgt";
  local s_Name::String = top.topName ++ ".s_";
  local dName::String = top.topName ++ ".d";
  local datumPairName::String = top.topName ++ ".datumPair";
  local eqOkName::String = top.topName ++ ".eqOk";
  local xName::String = top.topName ++ ".x";
  local ty_Name::String = top.topName ++ ".ty_";
  local pName::String = top.topName ++ ".p";

  r.topName = rName;

  top.equations = [
    tgtPairName ++ " = tgt(" ++ pName ++ ")",
    okTgtName ++ " = " ++ tgtPairName ++ ".1",
    s_Name ++ " = " ++ tgtPairName ++ ".2",
    dName ++ " = " ++ s_Name ++ ".datum",
    datumPairName ++ " = case " ++ dName ++ " of " ++
                        "| daumVar(x, ty) -> (true, x, ty) " ++
                        "| _ -> (false, \"\", tErr()) end",
    eqOkName ++ " = " ++ datumPairName ++ ".1",
    xName ++ " = " ++ datumPairName ++ ".2",
    ty_Name ++ " = " ++ datumPairName ++ ".3",
    top.topName ++ ".ty = " ++ ty_Name,
    rName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".VAR_s = " ++ rName ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ rName ++ ".LEX_s",
    pName ++ " = " ++ rName ++ ".p",
    top.topName ++ ".ok = " ++ okTgtName ++ " && " ++ rName ++ ".ok && " ++
                                                      eqOkName
  ] ++ r.equations;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = genName("expr");
  local e2Name::String = genName("expr");

  e1.topName = e1Name;
  e2.topName = e2Name;

  top.equations = [
    "-- from " ++ top.topName,
    e1Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    e2Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty",
    top.topName ++ ".ty = tInt()",
    top.topName ++ ".VAR_s = " ++ e1Name ++ ".VAR_s ++ " ++ e2Name ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ e1Name ++ ".LEX_s ++ " ++ e2Name ++ ".LEX_s",
    top.topName ++ ".ok = " ++ e1Name ++ ".ok && " ++ e2Name ++ ".ok && " ++
      top.topName ++ ".ty1 == tInt() && " ++ top.topName ++ ".ty2 == tInt"
  ] ++ e1.equations ++ e2.equations;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = genName("expr");
  local e2Name::String = genName("expr");

  e1.topName = e1Name;
  e2.topName = e2Name;

  top.equations = [
    "-- from " ++ top.topName,
    e1Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    e2Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty",
    top.topName ++ ".ty = tInt()",
    top.topName ++ ".VAR_s = " ++ e1Name ++ ".VAR_s ++ " ++ e2Name ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ e1Name ++ ".LEX_s ++ " ++ e2Name ++ ".LEX_s",
    top.topName ++ ".ok = " ++ e1Name ++ ".ok && " ++ e2Name ++ ".ok && " ++
      top.topName ++ ".ty1 == tInt() && " ++ top.topName ++ ".ty2 == tInt"
  ] ++ e1.equations ++ e2.equations;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = genName("expr");
  local e2Name::String = genName("expr");

  e1.topName = e1Name;
  e2.topName = e2Name;

  top.equations = [
    "-- from " ++ top.topName,
    e1Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    e2Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty",
    top.topName ++ ".ty = tInt()",
    top.topName ++ ".VAR_s = " ++ e1Name ++ ".VAR_s ++ " ++ e2Name ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ e1Name ++ ".LEX_s ++ " ++ e2Name ++ ".LEX_s",
    top.topName ++ ".ok = " ++ e1Name ++ ".ok && " ++ e2Name ++ ".ok && " ++
      top.topName ++ ".ty1 == tInt() && " ++ top.topName ++ ".ty2 == tInt"
  ] ++ e1.equations ++ e2.equations;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = genName("expr");
  local e2Name::String = genName("expr");

  e1.topName = e1Name;
  e2.topName = e2Name;

  top.equations = [
    "-- from " ++ top.topName,
    e1Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    e2Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty",
    top.topName ++ ".ty = tInt()",
    top.topName ++ ".VAR_s = " ++ e1Name ++ ".VAR_s ++ " ++ e2Name ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ e1Name ++ ".LEX_s ++ " ++ e2Name ++ ".LEX_s",
    top.topName ++ ".ok = " ++ e1Name ++ ".ok && " ++ e2Name ++ ".ok && " ++
      top.topName ++ ".ty1 == tInt() && " ++ top.topName ++ ".ty2 == tInt"
  ] ++ e1.equations ++ e2.equations;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = genName("expr");
  local e2Name::String = genName("expr");

  e1.topName = e1Name;
  e2.topName = e2Name;

  top.equations = [
    "-- from " ++ top.topName,
    e1Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    e2Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty",
    top.topName ++ ".ty = tBool()",
    top.topName ++ ".VAR_s = " ++ e1Name ++ ".VAR_s ++ " ++ e2Name ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ e1Name ++ ".LEX_s ++ " ++ e2Name ++ ".LEX_s",
    top.topName ++ ".ok = " ++ e1Name ++ ".ok && " ++ e2Name ++ ".ok && " ++
      top.topName ++ ".ty1 == tBool() && " ++ top.topName ++ ".ty2 == tBool"
  ] ++ e1.equations ++ e2.equations;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = genName("expr");
  local e2Name::String = genName("expr");

  e1.topName = e1Name;
  e2.topName = e2Name;

  top.equations = [
    "-- from " ++ top.topName,
    e1Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    e2Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty",
    top.topName ++ ".ty = tBool()",
    top.topName ++ ".VAR_s = " ++ e1Name ++ ".VAR_s ++ " ++ e2Name ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ e1Name ++ ".LEX_s ++ " ++ e2Name ++ ".LEX_s",
    top.topName ++ ".ok = " ++ e1Name ++ ".ok && " ++ e2Name ++ ".ok && " ++
      top.topName ++ ".ty1 == tBool() && " ++ top.topName ++ ".ty2 == tBool"
  ] ++ e1.equations ++ e2.equations;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = genName("expr");
  local e2Name::String = genName("expr");

  e1.topName = e1Name;
  e2.topName = e2Name;

  top.equations = [
    "-- from " ++ top.topName,
    e1Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    e2Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty",
    top.topName ++ ".ty = tBool()",
    top.topName ++ ".VAR_s = " ++ e1Name ++ ".VAR_s ++ " ++ e2Name ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ e1Name ++ ".LEX_s ++ " ++ e2Name ++ ".LEX_s",
    top.topName ++ ".ok = " ++ e1Name ++ ".ok && " ++ e2Name ++ ".ok && " ++
      top.topName ++ ".ty1 == " ++ top.topName ++ ".ty2 == tBool"
  ] ++ e1.equations ++ e2.equations;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  top.equations = ["TODO"];
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  top.equations = ["TODO"];
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  top.equations = ["TODO"];
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local bsName::String = genName("seqBinds");
  local eName::String = genName("expr");

  bs.topName = bsName;
  e.topName = eName;

  top.equations = [
    "-- from " ++ top.topName,
    top.topName ++ ".s_let = mkScope()",
    bsName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".s_let.var = " ++ bsName ++ ".VAR_s_def ++ " ++ eName ++ ".VAR_s",
    top.topName ++ ".s_let.lex = " ++ bsName ++ ".LEX_s_def ++ " ++ eName ++ ".LEX_s",
    eName ++ ".s = " ++ top.topName ++ ".s_let",
    top.topName ++ ".ty = " ++ eName ++ ".ty",
    top.topName ++ ".VAR_s = " ++ bsName ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ bsName ++ ".LEX_s",
    top.topName ++ ".ok = " ++ bsName ++ ".ok && " ++ eName ++ ".ok"
  ] ++ bs.equations ++ e.equations;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local bsName::String = genName("seqBinds");
  local eName::String = genName("expr");

  bs.topName = bsName;
  e.topName = eName;

  top.equations = [
    "-- from " ++ top.topName,

    top.topName ++ ".s_let = mkScope()",
    
    top.topName ++ ".s_let.var = " ++ top.topName ++ ".s :: (" ++ bsName ++ ".VAR_s ++ " ++ bsName ++ ".VAR_s_def" ++ eName ++ ".VAR_s)",
    top.topName ++ ".s_let.lex = " ++ bsName ++ ".LEX_s ++ " ++ bsName ++ ".LEX_s_def" ++ eName ++ ".LEX_s",

    bsName ++ ".s = " ++ top.topName ++ ".s",
    
    eName ++ ".s = " ++ top.topName ++ ".s_let",
    top.topName ++ ".ty = " ++ eName ++ ".ty",
    
    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",
    top.topName ++ ".ok = " ++ bsName ++ ".ok && " ++ eName ++ ".ok"

  ] ++ bs.equations ++ e.equations;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  top.equations = ["TODO"];
}

--------------------------------------------------

attribute topName, equations occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.equations = [
    "-- from " ++ top.topName,
    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",
    top.topName ++ ".VAR_s_def = []",
    top.topName ++ ".LEX_s_def = [" ++ top.topName ++ ".s]",
    top.topName ++ ".ok = true"
  ];
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  local sName::String = genName("seqBind");

  s.topName = sName;

  top.equations = [
    "-- from " ++ top.topName,
    sName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".VAR_s = " ++ sName ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ sName ++ ".LEX_s",
    top.topName ++ ".VAR_s_def = " ++ sName ++ ".VAR_s_def",
    top.topName ++ ".LEX_s_def = " ++ top.topName ++ ".s :: " ++ sName ++ ".LEX_s_def",
    top.topName ++ ".ok = " ++ sName ++ ".ok"
  ] ++ s.equations;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local sName::String = genName("seqBind");
  local ssName::String = genName("seqBinds");
  local s_def_Name::String = top.topName ++ ".s_def_";

  s.topName = sName;
  ss.topName = ssName;

  top.equations = [
    "-- from " ++ top.topName,
    s_def_Name ++ "_ = mkScope()",
    s_def_Name ++ ".lex = " ++ top.topName ++ ".s :: (" ++ sName ++ ".LEX_s_def ++ " ++ ssName ++ ".LEX_s)",
    s_def_Name ++ ".var = " ++ sName ++ ".VAR_s_def ++ " ++ ssName ++ ".VAR_s",
    sName ++ ".s = " ++ top.topName ++ ".s",
    ssName ++ ".s = " ++ s_def_Name,
    top.topName ++ ".VAR_s = " ++ sName ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ sName ++ ".LEX_s",
    top.topName ++ ".VAR_s_def = " ++ ssName ++ ".VAR_s_def",
    top.topName ++ ".LEX_s_def = " ++ ssName ++ ".LEX_s_def",
    top.topName ++ ".ok = " ++ sName ++ ".ok && " ++ ssName ++ ".ok"
  ] ++ s.equations ++ ss.equations;
}

--------------------------------------------------

attribute topName, equations occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local eName::String = genName("expr");
  local s_var_Name::String = top.topName ++ ".s_var";

  e.topName = eName;

  top.equations = [
    "-- from " ++ top.topName,
    s_var_Name ++ " = mkScopeDatum(datumVar(\"" ++ id ++ "\", " ++ eName ++ ".ty))",
    s_var_Name ++ ".lex = []",
    s_var_Name ++ ".var = []",
    eName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".VAR_s = " ++ eName ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ eName ++ ".LEX_s",
    top.topName ++ ".VAR_s_def = [" ++ s_var_Name ++ "]",
    top.topName ++ ".LEX_s_def = []",
    top.topName ++ ".ok = " ++ eName ++ ".ok" 
  ] ++ e.equations;
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local eName::String = genName("expr");
  local tyannName::String = genName("type");
  local s_var_Name::String = top.topName ++ ".s_var";

  e.topName = eName;

  top.equations = [
    "-- from " ++ top.topName,
    s_var_Name ++ " = mkScopeDatum(datumVar(\"" ++ id ++ "\", " ++ top.topName ++ ".ty))",
    s_var_Name ++ ".lex = []",
    s_var_Name ++ ".var = []",
    
    tyannName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ tyannName ++ ".ty",

    eName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty2 = " ++ eName ++ ".ty",

    top.topName ++ ".VAR_s = " ++ eName ++ ".VAR_s ++ " ++ tyannName ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ eName ++ ".LEX_s ++ " ++ tyannName ++ ".LEX_s",

    top.topName ++ ".VAR_s_def = [" ++ s_var_Name ++ "]",
    top.topName ++ ".LEX_s_def = []",

    top.topName ++ ".ok = " ++ eName ++ ".ok && " ++ top.topName ++ ".ty1 == " ++
                                                     top.topName ++ ".ty2"
  ] ++ ty.equations ++ e.equations;
}

--------------------------------------------------

attribute topName, equations occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.equations = [
    "-- from " ++ top.topName,
    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",
    top.topName ++ ".VAR_s_def = []",
    top.topName ++ ".LEX_s_def = []",
    top.topName ++ "ok = true"
  ];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  local sName::String = genName("parBind");
  local ssName::String = genName("parBinds");

  s.topName = sName;
  ss.topName = ssName;

  top.equations = [
    "-- from " ++ top.topName,
    sName ++ ".s = " ++ top.topName ++ ".s",
    ssName ++ ".s = " ++ top.topName ++ ".s",

    top.topName ++ ".VAR_s = " ++ sName ++ ".VAR_s ++ " ++ ssName ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ sName ++ ".LEX_s ++ " ++ ssName ++ ".LEX_s",

    top.topName ++ ".VAR_s_def = " ++ sName ++ ".VAR_s_def ++ " ++ ssName ++ ".VAR_s_def",
    top.topName ++ ".LEX_s_def = " ++ sName ++ ".LEX_s_def ++ " ++ ssName ++ ".LEX_s_def",

    top.topName ++ ".ok = " ++ sName ++ ".ok && " ++ ssName ++ ".ok"
  ] ++ s.equations ++ ss.equations;
}

--------------------------------------------------

attribute topName, equations occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local eName::String = genName("expr");
  local s_var_Name::String = top.topName ++ ".s_var";

  e.topName = eName;

  top.equations = [
    "-- from " ++ top.topName,
    s_var_Name ++ " = mkScopeDatum(datumVar(\"" ++ id ++ "\", " ++ eName ++ ".ty))",
    s_var_Name ++ ".lex = []",
    s_var_Name ++ ".var = []",
    eName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".VAR_s = " ++ eName ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ eName ++ ".LEX_s",
    top.topName ++ ".VAR_s_def = [" ++ s_var_Name ++ "]",
    top.topName ++ ".LEX_s_def = []",
    top.topName ++ ".ok = " ++ eName ++ ".ok" 
  ] ++ e.equations;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local eName::String = genName("expr");
  local tyannName::String = genName("type");
  local s_var_Name::String = top.topName ++ ".s_var";

  e.topName = eName;

  top.equations = [
    "-- from " ++ top.topName,
    s_var_Name ++ " = mkScopeDatum(datumVar(\"" ++ id ++ "\", " ++ top.topName ++ ".ty))",
    s_var_Name ++ ".lex = []",
    s_var_Name ++ ".var = []",
    
    tyannName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ tyannName ++ ".ty",

    eName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty2 = " ++ eName ++ ".ty",

    top.topName ++ ".VAR_s = " ++ eName ++ ".VAR_s ++ " ++ tyannName ++ ".VAR_s" ,
    top.topName ++ ".LEX_s = " ++ eName ++ ".LEX_s ++ " ++ tyannName ++ ".LEX_s",

    top.topName ++ ".VAR_s_def = [" ++ s_var_Name ++ "]",
    top.topName ++ ".LEX_s_def = []",

    top.topName ++ ".ok = " ++ eName ++ ".ok && " ++ top.topName ++ ".ty1 == " ++
                                                     top.topName ++ ".ty2"
  ] ++ ty.equations ++ e.equations;
}

--------------------------------------------------

attribute topName, equations occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  local tyannName::String = genName("type");
  local s_var_Name::String = top.topName ++ ".s_var";

  tyann.topName = tyannName;

  top.equations = [
    "-- from " ++ top.topName,
    s_var_Name ++ " = mkScopeDatum(datumVar(\"" ++ id ++ "\", " ++ tyannName ++ ".ty))",
    s_var_Name ++ ".var = []",
    s_var_Name ++ ".lex = []",
    tyannName ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty = " ++ tyannName ++ ".ty",
    top.topName ++ ".VAR_s = " ++ s_var_Name ++ " :: " ++ tyannName ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ tyannName ++ ".LEX_s",
    top.topName ++ ".ok = true"
  ] ++ tyann.equations;
}

--------------------------------------------------

attribute topName, equations occurs on Type;

aspect production tInt
top::Type ::=
{
  top.equations = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty = tInt()",
    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",
    top.topName ++ ".ok = true"
  ];
}

aspect production tBool
top::Type ::=
{
  top.equations = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty = tBool()",
    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",
    top.topName ++ ".ok = true"
  ];
}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  local tyann1Name::String = genName("type");
  local tyann2Name::String = genName("type");

  tyann1.topName = tyann1Name;
  tyann2.topName = tyann2Name;

  top.equations = [
    "-- from " ++ top.topName,

    tyann1Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ tyann1Name ++ ".ty",

    tyann1Name ++ ".s = " ++ top.topName ++ ".s",
    top.topName ++ ".ty1 = " ++ tyann1Name ++ ".ty",

    top.topName ++ ".ty = tFun(" ++ top.topName ++ ".ty1, " ++
                                    top.topName ++ ".ty2)",

    top.topName ++ ".VAR_s = " ++ tyann1Name ++ ".VAR_s ++ " ++ 
                                  tyann2Name ++ ".VAR_s",
    top.topName ++ ".LEX_s = " ++ tyann1Name ++ ".LEX_s ++ " ++ 
                                  tyann2Name ++ ".LEX_s",

    top.topName ++ ".ok = true"
  ] ++ tyann1.equations ++ tyann2.equations;
}

aspect production tErr
top::Type ::=
{
  top.equations = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty = tErr()",
    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",
    top.topName ++ ".ok = false"
  ];
}

--------------------------------------------------

attribute topName, equations occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local varsName::String = top.topName ++ ".vars";
  local xvarsName::String = top.topName ++ ".xvars";
  local xvars_Name::String = top.topName ++ ".xvars_";

  top.equations = [
    "-- from " ++ top.topName,
    xvars_Name ++ " = query (" ++
                        top.topName ++ ".s, varRefDFA(), " ++
                        "\\d -> case d of datumVar(x, _) -> x = \"" ++ x ++ "\" | _ -> false end" ++
                      ")",

    top.topName ++ ".onlyResult = onlyPath(" ++ xvars_Name ++ ")",
    top.topName ++ ".p = " ++ top.topName ++ ".onlyResult.2",

    top.topName ++ ".VAR_s = []",
    top.topName ++ ".LEX_s = []",

    top.topName ++ ".ok = " ++ top.topName ++ ".onlyResult.1" 
  ];
}