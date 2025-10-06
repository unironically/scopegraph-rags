grammar lmr3:lmr:nameanalysis4;

imports syntax:lmr1:lmr:abstractsyntax;

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
  local globScope::Scope = scopeNoData();

  ds.scope = globScope;
}

--------------------------------------------------

attribute scope, ok occurs on Decls;
propagate ok on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.scope = top.scope;
  ds.scope = top.scope;
}

aspect production declsNil
top::Decls ::=
{}

--------------------------------------------------

attribute ok occurs on Decl;
propagate ok on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = scopeMod(id);
  modScope.lex <- [top.scope];

  ds.scope = lookupScope;

  top.scope.mod <- [modScope];
}

aspect production declImport
top::Decl ::= r::ModRef
{
  r.scope = top.scope;

  top.scope.imp <- case r.mod of -- contribution
                   | just(s) -> [ s ]
                   | _ -> []
                   end;
}

aspect production declDef
top::Decl ::= b::ParBind
{
  b.scope = top.scope;
}

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
  local funScope::Scope = scopeNoData();
  
  funScope.lex <- [top.scope]; -- contribution

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
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = scopeNoData();

  bs.scope = letScope;
  e.scope = letScope;

  top.type = e.type;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = scopeNoData();

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
  local sbScope::Scope = scopeNoData();
  sbScope.lex <- [top.scope]; -- contribution

  s.scope = top.scope;

  top.lastScope = sbScope;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local sbScope::Scope = scopeNoData();
  sbScope.lex <- [top.scope]; -- contribution

  s.scope = top.scope;
  ss.scope = sbScope;

  top.lastScope = ss.lastScope;
}

--------------------------------------------------

attribute ok, scope occurs on SeqBind;

propagate ok, scope on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, e.type);

  top.scope.var <- [bindScope]; -- contribution
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, ^ty);

  top.scope.var <- [bindScope]; -- contribution

  top.ok <- ^ty == e.type;
}

--------------------------------------------------

attribute ok, scope occurs on ParBinds;
propagate ok, scope on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{}

--------------------------------------------------

attribute ok, scope occurs on ParBind;
propagate ok, scope on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, e.type);

  top.scope.var <- [bindScope]; -- contribution
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, ^ty);

  top.scope.var <- [bindScope]; -- contribution

  top.ok <- ^ty == e.type;
}

--------------------------------------------------

attribute ok, scope, type occurs on ArgDecl;
propagate ok, scope on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local bindScope::Scope = scopeVar(id, ^ty);

  top.scope.var <- [bindScope]; -- contribution

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
  local vars::[Decorated Scope] = top.scope.resolve(isName(x), varRx());

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

--------------------------------------------------

attribute ok, scope, mod occurs on ModRef;

synthesized attribute mod::Maybe<Decorated Scope>;

aspect production modRef
top::ModRef ::= x::String
{
  local mods::[Decorated Scope] = top.scope.resolve(isName(x), modRx());

  local okAndTy::(Boolean, Maybe<Decorated Scope>) =
    if length(mods) < 1
    then unsafeTracePrint((false, nothing()), "[✗] " ++ top.location.unparse ++ 
                          ": error: unresolvable module reference '" ++ x ++ "'\n")
    else if length(mods) > 1
    then unsafeTracePrint((false, nothing()), "[✗] " ++ top.location.unparse ++ 
                          ": error: ambiguous module reference '" ++ x ++ "'\n")
    else case head(mods).datum of
         | datumMod(_) -> (true, just(head(mods)))
         | _ -> (false, nothing())
         end;

  top.ok := okAndTy.1;
  top.mod = okAndTy.2;
}