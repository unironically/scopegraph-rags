grammar lm_semantics_4:nameanalysis;

--------------------------------------------------

inherited attribute parentPath::String;
synthesized attribute java::[String];
synthesized attribute javaName::String;

--------------------------------------------------

attribute java occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  ds.parentPath = "<main>";
  top.java = 
    reverse(
      ("Main m = new main(" ++ ds.javaName ++ ");") :: ds.java
    );
}

--------------------------------------------------

attribute parentPath, java, javaName occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  top.javaName = "ds" ++ toString(genInt());
  top.java = ("Dcls" ++ top.parentPath ++ " " ++ top.javaName ++ " = " ++
             "new dclsCons" ++ top.parentPath ++ "(" ++ d.javaName ++ ", " ++ ds.javaName ++ ");")
             :: (d.java ++ ds.java);
  d.parentPath = "<dclsCons" ++ top.parentPath ++ ">";
  ds.parentPath = "<dclsCons" ++ top.parentPath ++ ">";
}

aspect production declsNil
top::Decls ::=
{
  top.javaName = "ds" ++ toString(genInt());
  top.java = ("Dcls" ++ top.parentPath ++ " " ++ top.javaName ++ " = " ++
             "new dclsNil" ++ top.parentPath ++ "();")
             :: [];
}

--------------------------------------------------

attribute parentPath, java, javaName occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  top.javaName = "d" ++ toString(genInt());
  top.java = ("Dcl" ++ top.parentPath ++ " " ++ top.javaName ++ " = " ++
             "new dclMod" ++ top.parentPath ++ "(\"" ++ id ++ "\", " ++ ds.javaName ++ ");")
             :: ds.java;
  ds.parentPath = "<dclMod" ++ top.parentPath ++ ">";
}

aspect production declImport
top::Decl ::= r::ModRef
{
  top.javaName = "d" ++ toString(genInt());
  top.java = ("Dcl" ++ top.parentPath ++ " " ++ top.javaName ++ " = " ++
             "new dclImp" ++ top.parentPath ++ "(" ++ r.javaName ++ ");")
             :: r.java;
  r.parentPath = "<dclImp" ++ top.parentPath ++ ">";
}

aspect production declDef
top::Decl ::= b::ParBind
{
  top.javaName = "d" ++ toString(genInt());
  top.java = ("Dcl" ++ top.parentPath ++ " " ++ top.javaName ++ " = " ++
             "new dclBind" ++ top.parentPath ++ "(" ++ b.javaName ++ ");")
             :: b.java;
  b.parentPath = "<dclBind" ++ top.parentPath ++ ">";
}

--------------------------------------------------

attribute parentPath, java, javaName occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.javaName = "expInt_" ++ toString(genInt());
  top.java = ("Exp" ++ top.parentPath ++ " " ++ top.javaName ++ " = " ++ 
             "new expInt" ++ top.parentPath ++ "(" ++ toString(i) ++ ");")
             :: [];
}

aspect production exprTrue
top::Expr ::=
{
  top.java = [];
  top.javaName = "";
}

aspect production exprFalse
top::Expr ::=
{
  top.java = [];
  top.javaName = "";
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  top.javaName = "expRef_" ++ toString(genInt());
  top.java = ("Exp" ++ top.parentPath ++ " " ++ top.javaName ++ " = " ++ 
             "new expRef" ++ top.parentPath ++ "(" ++ r.javaName ++ ");")
             :: r.java;
  r.parentPath = "<expRef" ++ top.parentPath ++ ">";
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  top.java = [];
  top.javaName = "";
  e1.parentPath = "";
  e2.parentPath = "";
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  top.java = [];
  top.javaName = "";
  e1.parentPath = "";
  e2.parentPath = "";
}
aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  top.java = [];
  top.javaName = "";
  e1.parentPath = "";
  e2.parentPath = "";
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  top.java = [];
  top.javaName = "";
  e1.parentPath = "";
  e2.parentPath = "";
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  top.java = [];
  top.javaName = "";
  e1.parentPath = "";
  e2.parentPath = "";
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  top.java = [];
  top.javaName = "";
  e1.parentPath = "";
  e2.parentPath = "";
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  top.java = [];
  top.javaName = "";
  e1.parentPath = "";
  e2.parentPath = "";
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  top.java = [];
  top.javaName = "";
  e1.parentPath = "";
  e2.parentPath = "";
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  top.java = [];
  top.javaName = "";
  e1.parentPath = "";
  e2.parentPath = "";
  e3.parentPath = "";
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  top.java = [];
  top.javaName = "";
  d.parentPath = "";
  e.parentPath = "";
}


aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  top.java = [];
  top.javaName = "";
  bs.parentPath = "";
  e.parentPath = "";
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  top.java = [];
  top.javaName = "";
  bs.parentPath = "";
  e.parentPath = "";
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  top.java = [];
  top.javaName = "";
  e.parentPath = "";
  bs.parentPath = "";
}

--------------------------------------------------

attribute parentPath, java, javaName occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.java = [];
  top.javaName = "";
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  top.java = [];
  top.javaName = "";
  s.parentPath = "";
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  top.java = [];
  top.javaName = "";
  s.parentPath = "";
  ss.parentPath = "";
}

--------------------------------------------------

attribute parentPath, java, javaName occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  top.java = [];
  top.javaName = "";
  e.parentPath = "";
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  top.java = [];
  top.javaName = "";
  ty.parentPath = "";
  e.parentPath = "";
}

--------------------------------------------------

attribute parentPath, java, javaName occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.java = [];
  top.javaName = "";
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  top.java = [];
  top.javaName = "";
  s.parentPath = "";
  ss.parentPath = "";
}

--------------------------------------------------

attribute parentPath, java, javaName occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  top.java = [];
  top.javaName = "";
  e.parentPath = "";
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  top.javaName = "bnd_" ++ toString(genInt());
  top.java = ("Bind" ++ top.parentPath ++ " " ++ top.javaName ++ " = " ++
             "new bnd" ++ top.parentPath ++ "(\"" ++ id ++ "\", " ++ ty.javaName ++ ", " ++ e.javaName ++ ");")
             :: (ty.java ++ e.java);
  
  ty.parentPath = "<bnd" ++ top.parentPath ++ ">";
  e.parentPath = "<bnd" ++ top.parentPath ++ ">";
}


--------------------------------------------------

attribute parentPath, java, javaName occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  top.java = [];
  top.javaName = "";
  ty.parentPath = "";
}

--------------------------------------------------

attribute parentPath, java, javaName occurs on Type;

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  top.java = [];
  top.javaName = "";
  tyann1.parentPath = "";
  tyann2.parentPath = "";
}

aspect production tInt
top::Type ::=
{
  top.javaName = "intType_" ++ toString(genInt());
  top.java = ("Type " ++ top.javaName ++ " = new intType();")
             :: [];
}

aspect production tBool
top::Type ::=
{
  top.javaName = "boolType_" ++ toString(genInt());
  top.java = ("Type " ++ top.javaName ++ " = new boolType();")
             :: [];
}

aspect production tErr
top::Type ::=
{
  top.java = [];
  top.javaName = "";
}

--------------------------------------------------

attribute parentPath, java, javaName occurs on ModRef;

aspect production modRef
top::ModRef ::= name::String
{
  top.javaName = "mref_" ++ toString(genInt());
  top.java = ("ModRef" ++ top.parentPath ++ " " ++ top.javaName ++ " = " ++
             "new mref" ++ top.parentPath ++ "(\"" ++ name ++ "\");")
             ::[];
}

--------------------------------------------------

attribute parentPath, java, javaName occurs on VarRef;

aspect production varRef
top::VarRef ::= name::String
{
  top.javaName = "vref_" ++ toString(genInt());
  top.java = ("VarRef" ++ top.parentPath ++ " " ++ top.javaName ++ " = " ++
             "new vref" ++ top.parentPath ++ "(\"" ++ name ++ "\");")
             ::[];
}