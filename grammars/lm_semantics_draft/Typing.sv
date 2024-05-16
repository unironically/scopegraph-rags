grammar lm_semantics_4:nameanalysis;

--------------------------------------------------

synthesized attribute ty::Type;
synthesized attribute ok::Boolean;

--------------------------------------------------

attribute ok occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  top.ok = ds.ok;
}

--------------------------------------------------

attribute ok occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  top.ok = d.ok && ds.ok;
}

aspect production declsNil
top::Decls ::=
{
  top.ok = true;
}

--------------------------------------------------

attribute ok occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  top.ok = ds.ok;
}

aspect production declImport
top::Decl ::= r::ModRef
{
  top.ok = r.ok;
}

aspect production declDef
top::Decl ::= b::ParBind
{
  top.ok = b.ok;
}

--------------------------------------------------

attribute ty occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.ty = tInt();
}

aspect production exprTrue
top::Expr ::=
{
  top.ty = tBool();
}

aspect production exprFalse
top::Expr ::=
{
  top.ty = tBool();
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  top.ty =
    case r.varRefDatum of
    | just(datumVar(id, ty)) -> ty
    | _ -> tErr()
    end;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  top.ty = if e1.ty == tInt() && e2.ty == tInt() then tInt() else tErr();
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  top.ty = if e1.ty == tInt() && e2.ty == tInt() then tInt() else tErr();
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  top.ty = if e1.ty == tInt() && e2.ty == tInt() then tInt() else tErr();
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  top.ty = if e1.ty == tInt() && e2.ty == tInt() then tInt() else tErr();
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  top.ty = if e1.ty == tBool() && e2.ty == tBool() then tBool() else tErr();
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  top.ty = if e1.ty == tBool() && e2.ty == tBool() then tBool() else tErr();
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  top.ty = if e1.ty == e2.ty then tBool() else tErr();
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  top.ty =
    case e1.ty, e2.ty of
    | tFun(t1, t2), t3 when t1 == t3 -> t3
    | _, _ -> tErr()
    end;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  top.ty = if e1.ty == tBool() && e2.ty == e3.ty then e2.ty else tErr();
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  top.ty = tFun(d.ty, e.ty);
}


aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  top.ty = e.ty;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  top.ty = e.ty;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  top.ty = e.ty;
}

--------------------------------------------------

attribute ok occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.ok = true;
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  top.ok = s.ok;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  top.ok = s.ok && ss.ok;
}

--------------------------------------------------

attribute ok occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  top.ok = e.ty != tErr();
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  top.ok = ty == e.ty;
}

--------------------------------------------------

attribute ok occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.ok = true;
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  top.ok = s.ok && ss.ok;
}

--------------------------------------------------

attribute ok occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  top.ok = e.ty != tErr();
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  top.ok = ty == e.ty;
}

--------------------------------------------------

attribute ty occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  top.ty = tyann.ty;
}

--------------------------------------------------

attribute ty occurs on Type;

-- A little absurd, but doing this to make equations look closer to the statix constraints

aspect production tInt
top::Type ::=
{
  top.ty = tInt();
}

aspect production tBool
top::Type ::=
{
  top.ty = tBool();
}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  top.ty = tFun(tyann1.ty, tyann2.ty);
}

aspect production tErr
top::Type ::=
{
  top.ty = tErr();
}

--------------------------------------------------

attribute ok occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  top.ok = !null(top.s_mod);
}

aspect production modQRef
top::ModRef ::= r::ModRef x::String
{
  top.ok = !null(top.s_mod);
}

--------------------------------------------------

aspect production varRef
top::VarRef ::= x::String
{
}

aspect production varQRef
top::VarRef ::= r::ModRef x::String
{
}