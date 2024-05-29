grammar LM;


{-
 - The lexically enclosing scope of a program construct.
 -}
inherited attribute scope::Scope;

{-
 - The source scope for edges to declarations that are created in SeqBinds, SeqBind, ParBind and ParBinds.
 -}
inherited attribute scopeDef::Scope;

{-
 - The module which a ModRef resolves to, if such a resolution is found.
 -}
synthesized attribute resMod::Maybe<Scope>;



nonterminal Program;

abstract production program
top::Main ::= ds::Decls
{
  local globScope::Scope = scope();

  ds.scope = globScope;
}



nonterminal Decls with scope;

abstract production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.scope = top.scope;
  ds.scope = top.scope;
}

abstract production declsNil
top::Decls ::=
{
}



nonterminal Decl with scope;

abstract production declModule
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = scopeDatum(datumMod(id, modScope));

  top.scope.mods <- [modScope];  -- scope    -[ `MOD ]-> modScope
  modScope.lexs <- [top.scope];  -- modScope -[ `LEX ]-> scope

  ds.scope = modScope;
}

abstract production declImport
top::Decl ::= r::ModRef
{
  r.scope = top.scope;
}

abstract production declDef
top::Decl ::= b::ParBind
{
  b.scope = top.scope;
  b.scopeDef = top.scope;
}



nonterminal Expr with scope;

abstract production exprInt
top::Expr ::= i::Integer
{
}

abstract production exprTrue
top::Expr ::=
{
}

abstract production exprFalse
top::Expr ::=
{
}

abstract production exprVar
top::Expr ::= r::VarRef
{
  r.scope = top.scope;
}

abstract production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e2.scope = top.scope;
}

abstract production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e2.scope = top.scope;
}

abstract production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e2.scope = top.scope;
}

abstract production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e2.scope = top.scope;
}

abstract production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e2.scope = top.scope;
}

abstract production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e2.scope = top.scope;
}

abstract production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e2.scope = top.scope;
}

abstract production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e2.scope = top.scope;
}

abstract production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.scope = top.scope;
  e2.scope = top.scope;
  e3.scope = top.scope;
}

abstract production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local sFun::Scope = scope();

  sFun.lexs <- [top.scope]; -- sFun -[ `LEX ]-> scope

  d.scope = sFun;
  e.scope = sFun;
}

abstract production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local sLet::Scope = scope();

  sLet.lexs <- [top.scope]; -- sLet -[ `LEX ]-> scope

  bs.scope = top.scope;
  bs.sDef = sLet;

  e.scope = sLet;
}

abstract production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local sLet::Scope = scope();

  sLet.lexs <- [top.scope]; -- sLet -[ `LEX ]-> scope

  bs.scope = sLet;
  bs.scopeDef = sLet;
  
  e.scope = sLet;
}

abstract production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local sLet::Scope = scope();

  sLet.lexs <- [top.scope]; -- sLet -[ `LEX ]-> scope

  bs.scope = top.scope;
  bs.scopeDef = sLet;
  
  e.scope = sLet;
}



nonterminal SeqBinds with scope, scopeDef;

abstract production seqBindsNil
top::SeqBinds ::=
{
  top.scopeDef.lexs <- [top.scope]; -- scopeDef -[ `LEX ]-> scope
}

abstract production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  top.scopeDef.lexs <- [top.scope]; -- scopeDef -[ `LEX ]-> scope

  s.scope = top.scope;
  s.scopeDef = top.scopeDef;
}

abstract production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local sDef::Scope = scope();

  sDef.lexs <- [top.scope]; -- sDef -[ `LEX ]-> scope

  s.scope = top.scope;
  s.scopeDef = sDef;

  ss.scope = sDef;
  ss.scopeDef = top.scopeDef;
}



nonterminal SeqBind with scope, scopeDef;

abstract production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local scopeVar::Scope = scopeDatum(datumVar(id, e.ty));

  top.scopeDef.vars <- [scopeVar]; -- scopeDef -[ `VAR ]-> scopeVar

  e.scope = top.scope;
}

abstract production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local scopeVar::Scope = scopeDatum(datumVar(id, ty));

  top.scopeDef.vars <- [scopeVar]; -- scopeDef -[ `VAR ]-> scopeVar

  e.scope = top.scope;
}



nonterminal ParBinds with scope, scopeDef;

abstract production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.scope = top.scope;
  s.scopeDef = top.scopeDef;

  ss.scope = top.scope;
  ss.scopeDef = top.scopeDef;
}

abstract production parBindsNil
top::ParBinds ::=
{
}



nonterminal ParBind with scope, scopeDef;

abstract production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local scopeVar::Scope = scopeDatum(datumVar(id, e.ty));

  top.scopeDef.vars <- [scopeVar]; -- scopeDef -[ `VAR ]-> scopeVar

  e.scope = top.scope;
}

abstract production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local scopeVar::Scope = scopeDatum(datumVar(id, ty));

  top.scopeDef.vars <- [scopeVar]; -- scopeDef -[ `VAR ]-> scopeVar

  e.scope = top.scope;
}



nonterminal ArgDecl with scope;

abstract production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local scopeVar::Scope = scopeDatum(datumVar(id, ty));

  top.scope.vars <- [scopeVar]; -- scope -[ `VAR ]-> scopeVar
}



nonterminal Type;

abstract production tInt
top::Type ::=
{
}

abstract production tBool
top::Type ::=
{
}

abstract production tFun
top::Type ::= tyann1::Type tyann2::Type
{
}

abstract production tErr
top::Type ::=
{
}



nonterminal ModRef with scope, resMod;

abstract production modRef
top::ModRef ::= x::String
{
  local res::[Scope] = dfaModRef.findVisible(x, top.scope);

  top.resMod <- 
    case res of 
    | [] -> nothing()
    | h::_ -> just(h)
    end;
}

abstract production modQRef
top::ModRef ::= r::ModRef x::String
{
  local res::[Scope] = 
    case r.resMod of 
    | just(sMod) -> dfaMod.findVisible(x, sMod)
    | nothing() -> []
    end;

  top.resMod <- 
    case res of 
    | [] -> nothing()
    | h::_ -> just(h)
    end;
}



nonterminal VarRef with scope;

abstract production varRef
top::VarRef ::= x::String
{
  local res::[Scope] = dfaVarRef.findVisible(x, top.scope);

  top.resMod <- 
    case res of 
    | [] -> nothing()
    | h::_ -> just(h)
    end;
}

abstract production varQRef
top::VarRef ::= r::ModRef x::String
{
  local res::[Scope] = 
    case r.resMod of 
    | just(sMod) -> dfaVar.findVisible(x, sMod)
    | nothing() -> []
    end;

  top.resMod <- 
    case res of 
    | [] -> nothing()
    | h::_ -> just(h)
    end;
}