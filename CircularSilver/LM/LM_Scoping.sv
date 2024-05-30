grammar LM;

--EVW: scope, scopeDef, and program should be Decorated, right?

--EVW: maybe rename scope to be lexscope? the name is very general otherwise.
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
--EVW: there is no equation defining this on ModRef.

{-
 - Collection attribute which will synthesize all VarRef bindings found. Demanding this attribute
 - is the trigger for name analysis on the program, as by following its dependencies we demand
 - the resolution of references in the tree. 
 -}
collection attribute binds::[(String, String)] with ++, [] root Program;
--EVW: binds can just be a synthesized attribute the pulles up all the binding
--in the tree, right?
--Thus, the inherited attribute root is not needed?

{-
 - Program node to pass down the AST, so that contributions can be made to its `binds`.
 -}
inherited attribute root::Program;



nonterminal Program with binds;

abstract production program
top::Program ::= ds::Decls
{
  local globScope::Scope = scope();

  ds.scope = globScope;
  ds.root = top;
}



nonterminal Decls with scope, root;

abstract production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.scope = top.scope;
  d.root = top.root;

  ds.scope = top.scope;
  ds.root = top.root;
}

abstract production declsNil
top::Decls ::=
{
}



nonterminal Decl with scope, root;

abstract production declModule
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = scopeDatum(datumMod(id, modScope));
                                                 --EVW: top? ds?

  top.scope.mods <- [modScope];  -- scope    -[ `MOD ]-> modScope
  modScope.lexs <- [top.scope];  -- modScope -[ `LEX ]-> scope

  ds.scope = modScope;
  ds.root = top.root;
}

abstract production declImport
top::Decl ::= r::ModRef
{
  r.scope = top.scope;
  r.root = top.root;
}

abstract production declDef
top::Decl ::= b::ParBind
{
  b.scope = top.scope;
  b.scopeDef = top.scope;
  b.root = top.root;
}



nonterminal Expr with scope, root;

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
  r.root = top.root;
}

abstract production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e1.root = top.root;

  e2.scope = top.scope;
  e2.root = top.root;
}

abstract production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e1.root = top.root;

  e2.scope = top.scope;
  e2.root = top.root;
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
  e1.root = top.root;

  e2.scope = top.scope;
  e2.root = top.root;
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
  e1.root = top.root;

  e2.scope = top.scope;
  e2.root = top.root;
}

abstract production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e1.root = top.root;

  e2.scope = top.scope;
  e2.root = top.root;
}

abstract production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.scope = top.scope;
  e1.root = top.root;

  e2.scope = top.scope;
  e2.root = top.root;
}

abstract production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.scope = top.scope;
  e1.root = top.root;

  e2.scope = top.scope;
  e2.root = top.root;

  e3.scope = top.scope;
  e3.root = top.root;
}

abstract production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local sFun::Scope = scope();

  sFun.lexs <- [top.scope]; -- sFun -[ `LEX ]-> scope

  d.scope = sFun;
  d.root = top.root;

  e.scope = sFun;
  e.root = top.root;
}

abstract production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local sLet::Scope = scope();

  sLet.lexs <- [top.scope]; -- sLet -[ `LEX ]-> scope

  bs.scope = top.scope;
  bs.sDef = sLet;
  bf.root = top.root;

  e.scope = sLet;
  e.root = top.root;
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



nonterminal SeqBinds with scope, scopeDef, root;

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
  s.root = top.root;
}

abstract production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local sDef::Scope = scope();

  sDef.lexs <- [top.scope]; -- sDef -[ `LEX ]-> scope

  s.scope = top.scope;
  s.scopeDef = sDef;
  s.root = top.root;

  ss.scope = sDef;
  ss.scopeDef = top.scopeDef;
  ss.root = top.root;
}



nonterminal SeqBind with scope, scopeDef, root;

abstract production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local scopeVar::Scope = scopeDatum(datumVar(id, e.ty));

  top.scopeDef.vars <- [scopeVar]; -- scopeDef -[ `VAR ]-> scopeVar

  e.scope = top.scope;
  e.root = top.root;
}

abstract production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local scopeVar::Scope = scopeDatum(datumVar(id, ty));

  top.scopeDef.vars <- [scopeVar]; -- scopeDef -[ `VAR ]-> scopeVar

  e.scope = top.scope;
  e.root = top.root;
}



nonterminal ParBinds with scope, scopeDef, root;

abstract production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.scope = top.scope;
  s.scopeDef = top.scopeDef;
  s.root = top.root;

  ss.scope = top.scope;
  ss.scopeDef = top.scopeDef;
  ss.root = top.root;
}

abstract production parBindsNil
top::ParBinds ::=
{
}



nonterminal ParBind with scope, scopeDef, root;

abstract production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local scopeVar::Scope = scopeDatum(datumVar(id, e.ty));

  top.scopeDef.vars <- [scopeVar]; -- scopeDef -[ `VAR ]-> scopeVar

  e.scope = top.scope;
  e.root = top.root;
}

abstract production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local scopeVar::Scope = scopeDatum(datumVar(id, ty));

  top.scopeDef.vars <- [scopeVar]; -- scopeDef -[ `VAR ]-> scopeVar

  e.scope = top.scope;
  e.root = top.root;
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
  top.scope.impsReachable <- dfaMod.findReachable(x, left(top), [], true, top.scope);

  top.scope.imps <- minRef(scope.impsReachable, top);
  --EVW: does imps need to be a collection?  Can we not just assign the result of minRefs
  --to it?
}

abstract production modQRef
top::ModRef ::= r::ModRef x::String
{
  -- TODO
}



nonterminal VarRef with scope;

abstract production varRef
top::VarRef ::= x::String
{
  local res::[Scope] = minRef(dfaVarRef.findReachable(x, right(top), [], false, top.scope), top);

  top.root.binds <- map ((\r::Res -> (x, r.datum.fromJust.id)), res);
}

abstract production varQRef
top::VarRef ::= r::ModRef x::String
{
  -- TODO
}
