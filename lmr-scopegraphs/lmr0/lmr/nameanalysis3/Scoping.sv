grammar lmr0:lmr:nameanalysis2;

imports syntax:lmr0:lmr:abstractsyntax;

--------------------------------------------------

inherited attribute scope::Decorated Scope;

synthesized attribute type::Type;
monoid attribute ok::Boolean with true, &&;

--------------------------------------------------

attribute ok occurs on Main;
propagate ok on Main;

aspect production program
top::Main ::= ds::Decls
{
  scope globScope; -- assertion of globScope with no data

  ds.scope = globScope;
}

--------------------------------------------------

attribute scope, ok occurs on Decls;
propagate scope, ok on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{}

aspect production declsNil
top::Decls ::=
{}

--------------------------------------------------

attribute scope, ok occurs on Decl;
propagate scope, ok on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{}

--------------------------------------------------

attribute scope, ok, type occurs on Expr;

propagate ok on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{ 
  top.type = tInt();
}

aspect production exprTrue
top::Expr ::=
{ 
  top.type = tBool();
}

aspect production exprFalse
top::Expr ::=
{ 
  top.type = tBool();
}

aspect production exprVar
top::Expr ::= r::VarRef
{ 
  propagate scope;

  top.type = r.type;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope;

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
  propagate scope;

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
  propagate scope;

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
  propagate scope;

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
  propagate scope;

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
  propagate scope;

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
  propagate scope;

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
  propagate scope;

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
  propagate scope;

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
  scope funScope; -- assertion of funScope with no data
  funScope -[ LEX ]-> top.scope; -- assertion of LEX edge

  d.scope = top.scope;
  e.scope = funScope;

  top.type = tFun(d.type, e.type);
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  -- not asserting a scope here
  local letScope::Decorated Scope = bs.lastScope;

  bs.scope = top.scope;
  e.scope = letScope;

  top.type = e.type;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  scope letScope; -- assertion of letScope with no data

  bs.scope = letScope;
  e.scope = letScope;

  top.type = e.type;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  scope letScope; -- assertion of letScope with no data

  bs.scope = top.scope;
  e.scope = letScope;

  top.type = e.type;
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
  scope sbScope; -- assertion of sbScope with no data
  sbScope -[ LEX ]-> top.scope;

  s.scope = top.scope;

  top.lastScope = sbScope;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  scope sbScope; -- assertion of sbScope with no data
  sbScope -[ LEX ]-> top.scope;

  s.scope = top.scope;
  ss.scope = sbScope;

  top.lastScope = ss.lastScope;
}

--------------------------------------------------

attribute ok, scope, synEdges occurs on SeqBind;

propagate ok, scope on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  scope bindScope -> (id, e.type); -- assertion of bindScope with id, type

  top.scope -[ VAR ]-> bindScope; -- assertion of VAR edge
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  scope bindScope -> (id, ^ty); -- assertion of bindScope with id, type

  top.scope -[ VAR ]-> bindScope; -- assertion of VAR edge

  top.ok <- ^ty == e.type;
}

--------------------------------------------------

attribute ok, scope, synEdges occurs on ParBinds;
propagate ok, scope, synEdges on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{}

--------------------------------------------------

attribute ok, scope, synEdges occurs on ParBind;
propagate ok, scope on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  scope bindScope -> (id, e.type); -- assertion of bindScope with id, type

  top.scope -[ VAR ]-> bindScope; -- assertion of VAR edge
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  scope bindScope -> (id, ^ty); -- assertion of bindScope with id, type

  top.scope -[ VAR ]-> bindScope; -- assertion of VAR edge

  top.ok <- ^ty == e.type;
}

--------------------------------------------------

attribute ok, scope, synEdges, type occurs on ArgDecl;
propagate ok, scope on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  scope bindScope -> (id, ^ty); -- assertion of bindScope with id, type

  top.scope -[ VAR ]-> bindScope; -- assertion of VAR edge

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
  query top.scope isName(x) varRx() -> vars; -- vars gets query result

  local okAndTy::(Boolean, Type) =
    if length(vars) != 1
    then (false, tErr())
    else case head(vars).datum of
         | datumVar(_, ty) -> (true, ^ty)
         | _ -> (false, tErr())
         end;

  top.ok := okAndTy.1;
  top.type = okAndTy.2;
}