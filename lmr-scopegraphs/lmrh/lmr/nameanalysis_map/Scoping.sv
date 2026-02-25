grammar lmrh:lmr:nameanalysis_map;

imports syntax:lmr0:lmr:abstractsyntax;

--------------------------------------------------

inherited attribute scope::Decorated Scope;

monoid attribute synVar::[Decorated Scope] with [], ++;

synthesized attribute type::Type;
monoid attribute ok::Boolean with true, &&;

--------------------------------------------------

attribute ok occurs on Main;
propagate ok on Main;

aspect production program
top::Main ::= ds::Decls
{
  production attribute globScope::Scope = scopeNoData();
  globScope.edges := mapLast("VAR", ds.synVar);

  ds.scope = globScope;
}

--------------------------------------------------

attribute scope, synVar, ok occurs on Decls;
propagate scope, ok on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{ top.synVar := d.synVar ++ ds.synVar; }

aspect production declsNil
top::Decls ::=
{ top.synVar := []; }

--------------------------------------------------

attribute scope, synVar, ok occurs on Decl;
propagate scope, synVar, ok on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{}

--------------------------------------------------

attribute scope, synVar, ok, type occurs on Expr;

propagate ok on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{ 
  top.synVar := [];
  top.type = tInt();
}

aspect production exprTrue
top::Expr ::=
{ 
  top.synVar := [];
  top.type = tBool();
}

aspect production exprFalse
top::Expr ::=
{ 
  top.synVar := [];
  top.type = tBool();
}

aspect production exprVar
top::Expr ::= r::VarRef
{ 
  propagate scope;
  top.synVar := []; 
  top.type = r.type;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synVar;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synVar;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synVar;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synVar;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synVar;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tBool(), tBool() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synVar;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tBool(), tBool() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synVar;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | t1, t2 when t1 == t2 -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synVar;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tFun(t1, t2), t3 when ^t1 == t3 -> (true, ^t2)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  propagate scope, synVar;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type, e3.type of
                                   | tBool(), t2, t3 when t2 == t3 -> (true, t2)
                                   | _, _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  propagate synVar;
  
  local funScope::Scope = scopeNoData();
  funScope.edges := mapLast("VAR", d.synVar);

  d.scope = top.scope;
  e.scope = funScope;

  top.type = tFun(d.type, e.type);
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local letScope::Decorated Scope = bs.lastScope;

  bs.scope = top.scope;
  e.scope = letScope;

  top.type = e.type;
  top.synVar := [];
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = scopeNoData();
  letScope.edges := mapLast("VAR", bs.synVar);

  bs.scope = letScope;
  e.scope = letScope;

  top.type = e.type;
  top.synVar := [];
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = scopeNoData();
  letScope.edges := mapLast("VAR", bs.synVar);

  bs.scope = top.scope;
  e.scope = letScope;

  top.type = e.type;
  top.synVar := [];
}

--------------------------------------------------

attribute ok, scope, lastScope occurs on SeqBinds;

propagate ok on SeqBinds;

synthesized attribute lastScope::Decorated Scope;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.lastScope = top.scope;
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  local sbScope::Scope = scopeNoData();
  sbScope.edges := 
    mapCons("LEX", [top.scope], 
    mapLast("VAR", s.synVar));

  s.scope = top.scope;

  top.lastScope = sbScope;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local sbScope::Scope = scopeNoData();
  sbScope.edges := 
    mapCons("LEX", [top.scope], 
    mapLast("VAR", s.synVar));

  s.scope = top.scope;
  ss.scope = sbScope;

  top.lastScope = ss.lastScope;
}

--------------------------------------------------

attribute ok, scope, synVar occurs on SeqBind;

propagate ok, scope on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, e.type);
  bindScope.edges := mapNone();

  top.synVar := [ bindScope ];
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, ^ty);
  bindScope.edges := mapNone();

  top.synVar := [ bindScope ];

  top.ok <- ^ty == e.type;
}

--------------------------------------------------

attribute ok, scope, synVar occurs on ParBinds;
propagate ok, scope, synVar on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{}

--------------------------------------------------

attribute ok, scope, synVar occurs on ParBind;
propagate ok, scope on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, e.type);
  bindScope.edges := mapNone();

  top.synVar := [ bindScope ];
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, ^ty);
  bindScope.edges := mapNone();

  top.synVar := [ bindScope ];

  top.ok <- ^ty == e.type;
}

--------------------------------------------------

attribute ok, scope, synVar, type occurs on ArgDecl;
propagate ok, scope on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local bindScope::Scope = scopeVar(id, ^ty);
  bindScope.edges := mapNone();

  top.synVar := [ bindScope ];

  top.type = ^ty;
}

--------------------------------------------------

aspect production tInt
top::Type ::=
{}

aspect production tBool
top::Type ::=
{}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{}

aspect production tErr
top::Type ::=
{}

--------------------------------------------------

attribute ok, scope, type occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  production attribute vars::[Decorated Scope] with ++;
  vars := resolve(isName(x), varRx(), top.scope);

  local ty::Maybe<Type> =
    case vars of
    | h::[] -> case h.datum of
               | datumVar(_, ty) -> just(^ty)
               | _ -> nothing()
               end
    | _ -> nothing()
    end;

  top.ok := ty.isJust;
  top.type = if ty.isJust then ty.fromJust else tErr();
}
