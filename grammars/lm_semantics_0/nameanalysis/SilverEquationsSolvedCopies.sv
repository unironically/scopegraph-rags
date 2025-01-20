grammar lm_semantics_0:nameanalysis;

--------------------------------------------------

synthesized attribute equationsSolvedCopies::[String];

inherited attribute sName::String;

synthesized attribute eqVAR_s::[String];
synthesized attribute eqLEX_s::[String];

synthesized attribute eqVAR_s_def::[String];
synthesized attribute eqLEX_s_def::[String];

synthesized attribute eqOk::String;

synthesized attribute eqTy::String;

synthesized attribute eqP::String;

--------------------------------------------------

attribute equationsSolvedCopies occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local topName::String = top.topNameRoot;
  local sName::String = topName ++ ".s";
  local dsName::String = ds.topName;

  ds.sName = sName;

  top.equationsSolvedCopies = [
    "-- from " ++ topName,
    topName ++ ".ok = " ++ ds.eqOk,
    sName ++ " = mkScope()",
    sName ++ ".var = [" ++ implode(", ", ds.eqVAR_s) ++ "]",
    sName ++ ".lex = [" ++ implode(", ", ds.eqLEX_s) ++ "]"
  ] ++ ds.equationsSolvedCopies;
}

--------------------------------------------------

attribute equationsSolvedCopies, sName, eqVAR_s, eqLEX_s, eqOk occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local dName::String = d.topName;
  local dsName::String = ds.topName;

  d.sName = top.sName;

  ds.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ] ++ d.equationsSolvedCopies ++ ds.equationsSolvedCopies;

  top.eqVAR_s = d.eqVAR_s ++ ds.eqVAR_s;
  top.eqLEX_s = d.eqLEX_s ++ ds.eqLEX_s;
  top.eqOk = d.eqOk ++ " && " ++ ds.eqOk;
}

aspect production declsNil
top::Decls ::=
{
  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ];

  top.eqVAR_s = [];
  top.eqLEX_s = [];

  top.eqOk = "true";
}

--------------------------------------------------

attribute equationsSolvedCopies, sName, eqVAR_s, eqLEX_s, eqOk occurs on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{
  local bName::String = b.topName;

  b.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ] ++ b.equationsSolvedCopies;

  top.eqVAR_s = b.eqVAR_s ++ b.eqVAR_s_def;
  top.eqLEX_s = b.eqLEX_s ++ b.eqLEX_s_def;

  top.eqOk = b.eqOk;
}

--------------------------------------------------

attribute equationsSolvedCopies, sName, eqVAR_s, eqLEX_s, eqOk, eqTy occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ];

  top.eqVAR_s = [];
  top.eqLEX_s = [];
  
  top.eqOk = "true";

  top.eqTy = "tInt()";
}

aspect production exprTrue
top::Expr ::=
{
  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ];

  top.eqVAR_s = [];
  top.eqLEX_s = [];

  top.eqOk = "true";

  top.eqTy = "tBool()";
}

aspect production exprFalse
top::Expr ::=
{
  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ];

  top.eqVAR_s = [];
  top.eqLEX_s = [];

  top.eqOk = "true";

  top.eqTy = "tBool()";
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  local rName::String = r.topName;

  local tgtPairName::String = top.topName ++ ".tgtPair";
  local okTgtName::String = top.topName ++ ".okTgt";
  local s_Name::String = top.topName ++ ".s_";
  local dName::String = top.topName ++ ".d";
  local datumPairName::String = top.topName ++ ".datumPair";
  local eqOkName::String = top.topName ++ ".eqOk";
  local xName::String = top.topName ++ ".x";
  local ty_Name::String = top.topName ++ ".ty_";
  local pName::String = top.topName ++ ".p";

  r.sName = top.sName;

  top.equationsSolvedCopies = [
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
    pName ++ " = " ++ r.eqP
  ] ++ r.equationsSolvedCopies;

  top.eqVAR_s = r.eqVAR_s;
  top.eqLEX_s = r.eqLEX_s;

  top.eqOk = okTgtName ++ " && " ++ r.eqOk ++ " && " ++ eqOkName;

  top.eqTy = ty_Name;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = e1.topName;
  local e2Name::String = e2.topName;

  e1.sName = top.sName;

  e2.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty1 = " ++ e1.eqTy,
    top.topName ++ ".ty2 = " ++ e2.eqTy
  ] ++ e1.equationsSolvedCopies ++ e2.equationsSolvedCopies;

  top.eqVAR_s = e1.eqVAR_s ++ e2.eqVAR_s;
  top.eqLEX_s = e1.eqLEX_s ++ e2.eqLEX_s;

  top.eqOk = e1.eqOk ++ " && " ++ e2.eqOk ++ " && " ++ 
            top.topName ++ ".ty1 == tInt() && " ++ top.topName ++ ".ty2 == tInt()";

  top.eqTy = "tInt()";
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = e1.topName;
  local e2Name::String = e2.topName;

  e1.sName = top.sName;

  e2.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty"
  ] ++ e1.equationsSolvedCopies ++ e2.equationsSolvedCopies;

  top.eqVAR_s = e1.eqVAR_s ++ e2.eqVAR_s;
  top.eqLEX_s = e1.eqLEX_s ++ e2.eqLEX_s;

  top.eqOk = e1.eqOk ++ " && " ++ e2.eqOk ++ " && " ++ 
            top.topName ++ ".ty1 == tInt() && " ++ top.topName ++ ".ty2 == tInt()";

  top.eqTy = "tInt()";
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = e1.topName;
  local e2Name::String = e2.topName;

  e1.sName = top.sName;

  e2.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty"
  ] ++ e1.equationsSolvedCopies ++ e2.equationsSolvedCopies;

  top.eqVAR_s = e1.eqVAR_s ++ e2.eqVAR_s;
  top.eqLEX_s = e1.eqLEX_s ++ e2.eqLEX_s;

  top.eqOk = e1.eqOk ++ " && " ++ e2.eqOk ++ " && " ++ 
            top.topName ++ ".ty1 == tInt() && " ++ top.topName ++ ".ty2 == tInt()";

  top.eqTy = "tInt()";
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = e1.topName;
  local e2Name::String = e2.topName;

  e1.sName = top.sName;

  e2.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty"
  ] ++ e1.equationsSolvedCopies ++ e2.equationsSolvedCopies;

  top.eqVAR_s = e1.eqVAR_s ++ e2.eqVAR_s;
  top.eqLEX_s = e1.eqLEX_s ++ e2.eqLEX_s;

  top.eqOk = e1.eqOk ++ " && " ++ e2.eqOk ++ " && " ++ 
            top.topName ++ ".ty1 == tInt() && " ++ top.topName ++ ".ty2 == tInt()";

  top.eqTy = "tInt()";
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = e1.topName;
  local e2Name::String = e2.topName;

  e1.sName = top.sName;

  e2.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty"
  ] ++ e1.equationsSolvedCopies ++ e2.equationsSolvedCopies;

  top.eqVAR_s = e1.eqVAR_s ++ e2.eqVAR_s;
  top.eqLEX_s = e1.eqLEX_s ++ e2.eqLEX_s;

  top.eqOk = e1.eqOk ++ " && " ++ e2.eqOk ++ " && " ++ 
            top.topName ++ ".ty1 == tBool() && " ++ top.topName ++ ".ty2 == tBool()";

  top.eqTy = "tBool()";
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = e1.topName;
  local e2Name::String = e2.topName;

  e1.sName = top.sName;

  e2.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty"
  ] ++ e1.equationsSolvedCopies ++ e2.equationsSolvedCopies;

  top.eqVAR_s = e1.eqVAR_s ++ e2.eqVAR_s;
  top.eqLEX_s = e1.eqLEX_s ++ e2.eqLEX_s;

  top.eqOk = e1.eqOk ++ " && " ++ e2.eqOk ++ " && " ++ 
            top.topName ++ ".ty1 == tBool() && " ++ top.topName ++ ".ty2 == tBool()";

  top.eqTy = "tBool()";
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  local e1Name::String = e1.topName;
  local e2Name::String = e2.topName;

  e1.sName = top.sName;

  e2.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty1 = " ++ e1Name ++ ".ty",
    top.topName ++ ".ty2 = " ++ e2Name ++ ".ty"
  ] ++ e1.equationsSolvedCopies ++ e2.equationsSolvedCopies;

  top.eqVAR_s = e1.eqVAR_s ++ e2.eqVAR_s;
  top.eqLEX_s = e1.eqLEX_s ++ e2.eqLEX_s;

  top.eqOk = e1.eqOk ++ " && " ++ e2.eqOk ++ " && " ++ 
             top.topName ++ ".ty1 == " ++ top.topName ++ ".ty2 == tBool()";

  top.eqTy = "tBool()";
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  top.equationsSolvedCopies = ["TODO"];
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  top.equationsSolvedCopies = ["TODO"];
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  top.equationsSolvedCopies = ["TODO"];
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local bsName::String = bs.topName;
  local eName::String = e.topName;

  bs.sName = top.sName;

  e.sName = top.topName ++ ".s_let";

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    top.topName ++ ".s_let = mkScope()",
    top.topName ++ ".s_let.var = [" ++ implode(", ", bs.eqVAR_s_def ++ e.eqVAR_s) ++ "]",
    top.topName ++ ".s_let.lex = [" ++ implode(", ", bs.eqLEX_s_def ++ e.eqLEX_s) ++ "]"
  ] ++ bs.equationsSolvedCopies ++ e.equationsSolvedCopies;

  top.eqVAR_s = bs.eqVAR_s;
  top.eqLEX_s = bs.eqLEX_s;

  top.eqOk = bs.eqOk ++ " && " ++ e.eqOk;

  top.eqTy = e.eqTy;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  top.equationsSolvedCopies = ["TODO"];
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  top.equationsSolvedCopies = ["TODO"];
}

--------------------------------------------------

attribute equationsSolvedCopies, sName, eqVAR_s, eqLEX_s, eqVAR_s_def, eqLEX_s_def, eqOk occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ];

  top.eqVAR_s = [];
  top.eqLEX_s = [];

  top.eqVAR_s_def = [];
  top.eqLEX_s_def = [ top.sName ];

  top.eqOk = "true";
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  local sName::String = s.topName;

  s.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ] ++ s.equationsSolvedCopies;

  top.eqVAR_s = s.eqVAR_s;
  top.eqLEX_s = s.eqLEX_s;

  top.eqVAR_s_def = s.eqVAR_s_def;
  top.eqLEX_s_def = top.sName :: s.eqLEX_s_def;

  top.eqOk = s.eqOk;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local sName::String = s.topName;
  local ssName::String = ss.topName;
  local s_def_Name::String = top.topName ++ ".s_def_";

  s.sName = top.sName;

  ss.sName = s_def_Name;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    s_def_Name ++ "_ = mkScope()",
    s_def_Name ++ ".lex = [" ++ implode(", ", top.sName :: (s.eqLEX_s_def ++ ss.eqLEX_s)) ++ "]",
    s_def_Name ++ ".var = [" ++ implode(", ", s.eqVAR_s_def ++ ss.eqVAR_s) ++ "]"
  ] ++ s.equationsSolvedCopies ++ ss.equationsSolvedCopies;

  top.eqVAR_s = s.eqVAR_s;
  top.eqLEX_s = s.eqLEX_s;

  top.eqVAR_s_def = ss.eqVAR_s_def;
  top.eqLEX_s_def = ss.eqLEX_s_def;

  top.eqOk = s.eqOk ++ " && " ++ ss.eqOk;
}

--------------------------------------------------

attribute equationsSolvedCopies, sName, eqVAR_s, eqLEX_s, eqVAR_s_def, eqLEX_s_def, eqOk occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local eName::String = e.topName;
  local s_var_Name::String = top.topName ++ ".s_var";

  e.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    s_var_Name ++ " = mkScopeDatum(datumVar(\"" ++ id ++ "\", " ++ e.eqTy ++ "))",
    s_var_Name ++ ".lex = []",
    s_var_Name ++ ".var = []"
  ] ++ e.equationsSolvedCopies;

  top.eqVAR_s = e.eqVAR_s;
  top.eqLEX_s = e.eqLEX_s;

  top.eqVAR_s_def = [ s_var_Name ];
  top.eqLEX_s_def = [];

  top.eqOk = e.eqOk;
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local eName::String = e.topName;
  local tyannName::String = ty.topName;
  local s_var_Name::String = top.topName ++ ".s_var";

  e.sName = top.sName;

  ty.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    s_var_Name ++ " = mkScopeDatum(datumVar(\"" ++ id ++ "\", " ++ top.topName ++ ".ty1))",
    s_var_Name ++ ".lex = []",
    s_var_Name ++ ".var = []",
    
    top.topName ++ ".ty1 = " ++ tyannName ++ ".ty",

    top.topName ++ ".ty2 = " ++ eName ++ ".ty"
  ] ++ ty.equationsSolvedCopies ++ e.equationsSolvedCopies;

  top.eqVAR_s = e.eqVAR_s ++ ty.eqVAR_s;
  top.eqLEX_s = e.eqLEX_s ++ ty.eqLEX_s;

  top.eqVAR_s_def = [ s_var_Name ];
  top.eqLEX_s_def = [];

  top.eqOk = e.eqOk ++ " && " ++ top.topName ++ ".ty1 == " ++
                                 top.topName ++ ".ty2";
}

--------------------------------------------------

attribute equationsSolvedCopies, sName, eqVAR_s, eqLEX_s, eqVAR_s_def, eqLEX_s_def, eqOk occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ];

  top.eqVAR_s = [];
  top.eqLEX_s = [];

  top.eqVAR_s_def = [];
  top.eqLEX_s_def = [];

  top.eqOk = "true";
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  local sName::String = s.topName;
  local ssName::String = ss.topName;

  s.sName = top.sName;

  ss.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ] ++ s.equationsSolvedCopies ++ ss.equationsSolvedCopies;

  top.eqVAR_s = s.eqVAR_s ++ ss.eqVAR_s;
  top.eqLEX_s = s.eqLEX_s ++ ss.eqLEX_s;

  top.eqVAR_s_def = s.eqVAR_s_def ++ ss.eqVAR_s_def;
  top.eqLEX_s_def = s.eqLEX_s_def ++ ss.eqLEX_s_def;

  top.eqOk = s.eqOk ++ " && " ++ ss.eqOk;
}

--------------------------------------------------

attribute equationsSolvedCopies, sName, eqVAR_s, eqLEX_s, eqVAR_s_def, eqLEX_s_def, eqOk occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local eName::String = e.topName;
  local s_var_Name::String = top.topName ++ ".s_var";

  e.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    s_var_Name ++ " = mkScopeDatum(datumVar(\"" ++ id ++ "\", " ++ e.eqTy ++ "))",
    s_var_Name ++ ".lex = []",
    s_var_Name ++ ".var = []"
  ] ++ e.equationsSolvedCopies;

  top.eqVAR_s = e.eqVAR_s;
  top.eqLEX_s = e.eqLEX_s;

  top.eqVAR_s_def = [ s_var_Name ];
  top.eqLEX_s_def = [];

  top.eqOk = e.eqOk;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local eName::String = e.topName;
  local tyannName::String = ty.topName;
  local s_var_Name::String = top.topName ++ ".s_var";

  e.sName = top.sName;

  ty.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    s_var_Name ++ " = mkScopeDatum(datumVar(\"" ++ id ++ "\", " ++ top.topName ++ ".ty1))",
    s_var_Name ++ ".lex = []",
    s_var_Name ++ ".var = []",
    
    top.topName ++ ".ty1 = " ++ tyannName ++ ".ty",

    top.topName ++ ".ty2 = " ++ eName ++ ".ty"
  ] ++ ty.equationsSolvedCopies ++ e.equationsSolvedCopies;

  top.eqVAR_s = e.eqVAR_s ++ ty.eqVAR_s;
  top.eqLEX_s = e.eqLEX_s ++ ty.eqLEX_s;

  top.eqVAR_s_def = [ s_var_Name ];
  top.eqLEX_s_def = [];

  top.eqOk = e.eqOk ++ " && " ++ top.topName ++ ".ty1 == " ++
                                 top.topName ++ ".ty2";
}

--------------------------------------------------

attribute equationsSolvedCopies, sName, eqVAR_s, eqLEX_s, eqOk, eqTy occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  local tyannName::String = tyann.topName;
  local s_var_Name::String = top.topName ++ ".s_var";

  tyann.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    s_var_Name ++ " = mkScopeDatum(datumVar(\"" ++ id ++ "\", " ++ tyann.eqTy ++ "))",
    s_var_Name ++ ".var = []",
    s_var_Name ++ ".lex = []"
  ] ++ tyann.equationsSolvedCopies;

  top.eqVAR_s = s_var_Name  :: tyann.eqVAR_s;
  top.eqLEX_s = tyann.eqLEX_s;

  top.eqOk = "true";

  top.eqTy = tyann.eqTy;
}

--------------------------------------------------

attribute equationsSolvedCopies, sName, eqVAR_s, eqLEX_s, eqOk, eqTy occurs on Type;

aspect production tInt
top::Type ::=
{
  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ];

  top.eqVAR_s = [];
  top.eqLEX_s = [];

  top.eqOk = "true";

  top.eqTy = "tInt()";
}

aspect production tBool
top::Type ::=
{
  top.equationsSolvedCopies = [
    "-- from " ++ top.topName
  ];

  top.eqVAR_s = [];
  top.eqLEX_s = [];

  top.eqOk = "true";

  top.eqTy = "tBool()";
}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  local tyann1Name::String = tyann1.topName;
  local tyann2Name::String = tyann2.topName;

  tyann1.sName = top.sName;

  tyann2.sName = top.sName;

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,

    top.topName ++ ".ty1 = " ++ tyann1Name ++ ".ty",

    top.topName ++ ".ty1 = " ++ tyann1Name ++ ".ty"
  ] ++ tyann1.equationsSolvedCopies ++ tyann2.equationsSolvedCopies;

  top.eqVAR_s = tyann1.eqVAR_s ++ tyann2.eqVAR_s;
  top.eqLEX_s = tyann1.eqLEX_s ++ tyann2.eqLEX_s;

  top.eqOk = tyann1.eqOk ++ " && " ++ tyann2.eqOk;

  top.eqTy = "tFun(" ++ tyann1.eqTy ++ ", " ++ tyann2.eqTy ++ ")";
}

aspect production tErr
top::Type ::=
{
  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    top.topName ++ ".ty = tErr()"
  ];

  top.eqVAR_s = [];
  top.eqLEX_s = [];

  top.eqOk = "false";

  top.eqTy = "tErr()";
}

--------------------------------------------------

attribute equationsSolvedCopies, sName, eqVAR_s, eqLEX_s, eqOk, eqP occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local varsName::String = top.topName ++ ".vars";
  local xvarsName::String = top.topName ++ ".xvars";
  local xvars_Name::String = top.topName ++ ".xvars_";

  top.equationsSolvedCopies = [
    "-- from " ++ top.topName,
    xvars_Name ++ " = query (" ++
                        top.sName ++ ", varRefDFA(), " ++
                        "\\d -> case d of datumVar(x, _) -> x = \"" ++ x ++ "\" | _ -> false end" ++
                      ")",

    top.topName ++ ".onlyResult = onlyPath(" ++ xvars_Name ++ ")"
  ];

  top.eqVAR_s = [];
  top.eqLEX_s = [];

  top.eqOk = top.topName ++ ".onlyResult.1";

  top.eqP = top.topName ++ ".onlyResult.2";
}