grammar LM;

{-
 - The lexically enclosing scope of a program construct.
 -}
inherited attribute lexScope::Decorated Scope;

{-
 - The source scope for edges to declarations that are created in SeqBinds, SeqBind, ParBind and ParBinds.
 -}
inherited attribute scopeDef::Decorated Scope;

{-
 - Collection attribute which will synthesize all VarRef bindings found. Demanding this attribute
 - is the trigger for name analysis on the program, as by following its dependencies we demand
 - the resolution of references in the tree. 
 -}
monoid attribute binds::[(String, String)] with ++, [];


nonterminal Program with binds;

abstract production program
top::Program ::= ds::Decls
{
  local globScope::Scope = scopeGlobal(ds.vars, ds.mods, ds.imps);

  ds.lexScope = globScope;
}



nonterminal Decls with lexScope, root, vars, mods, imps, binds;

propagate binds on Decls;

abstract production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.lexScope = top.lexScope;
  ds.lexScope = top.lexScope;

  top.vars = d.vars ++ ds.vars;
  top.mods = d.mods ++ ds.mods;
  top.imps = d.imps ++ ds.imps;
}

abstract production declsNil
top::Decls ::=
{
  top.vars = [];
  top.mods = [];
  top.imps = [];
}



nonterminal Decl with lexScope, root, vars, mods, imps, binds;

propagate binds on Decl;

abstract production declModule
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = scopeMod(ds.vars, ds.mods, ds.imps, just(top.scope), (id, modScope));

  ds.lexScope = modScope;

  top.vars = [];
  top.mods = [modScope];
  top.imps = [];
}

abstract production declImport
top::Decl ::= r::ModRef
{
  r.lexScope = top.lexScope;

  top.vars = [];
  top.mods = [];
  top.imps = r.imps;
}

abstract production declDef
top::Decl ::= b::ParBind
{
  b.lexScope = top.lexScope;
  b.scopeDef = top.lexScope;

  top.vars = b.vars;
  top.mods = [];
  top.imps = [];
}



nonterminal Expr with lexScope, root, binds;

propagate binds on Expr;

abstract production exprInt
top::Expr ::= i::Integer
{}

abstract production exprTrue
top::Expr ::=
{}

abstract production exprFalse
top::Expr ::=
{}

abstract production exprVar
top::Expr ::= r::VarRef
{
  r.lexScope = top.lexScope;
}

abstract production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
}

abstract production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
}

abstract production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
}

abstract production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local sLet::Scope = scopeLet(bs.vars, bs.lastScope);

  bs.lexScope = top.lexScope;
  bs.sDef = sLet;

  e.lexScope = sLet;
}

abstract production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local sLet::Scope = scopeLet(bs.vars, top.lexScope);

  bs.lexScope = sLet;
  bs.scopeDef = sLet;
  
  e.lexScope = sLet;
}

abstract production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local sLet::Scope = scopeLet(bs.vars, top.lexScope);

  bs.lexScope = top.lexScope;
  bs.scopeDef = sLet;
  
  e.lexScope = sLet;
}



inherited attribute lastScope::Decorated Scope;

nonterminal SeqBinds with lexScope, scopeDef, lastScope, vars, binds;

propagate binds on SeqBinds;

abstract production seqBindsNil
top::SeqBinds ::=
{
  top.vars = [];
  top.lastScope = top.lexScope;
}

abstract production seqBindsOne
top::SeqBinds ::= s::Bind
{
  s.lexScope = top.lexScope;
  s.scopeDef = top.scopeDef;

  top.vars = s.vars;
  top.lastScope = top.lexScope;
}

abstract production seqBindsCons
top::SeqBinds ::= s::Bind ss::SeqBinds
{
  local sDef::Scope = scope(s.vars, [], [top.lexScope]);

  s.lexScope = top.lexScope;
  s.scopeDef = sDef;

  ss.lexScope = sDef;
  ss.scopeDef = top.scopeDef;

  top.vars = ss.vars;
  top.lastScope = ss.lastScope;
}



nonterminal ParBinds with lexScope, scopeDef, root, binds;

propagate binds on ParBinds;

abstract production parBindsCons
top::ParBinds ::= s::Bind ss::ParBinds
{
  s.lexScope = top.lexScope;
  s.scopeDef = top.scopeDef;

  ss.lexScope = top.lexScope;
  ss.scopeDef = top.scopeDef;
}

abstract production parBindsNil
top::ParBinds ::= {}



nonterminal Bind with lexScope, scopeDef, root, binds;

propagate binds on Bind;

abstract production bindUntyped
top::Bind ::= id::String e::Expr
{
  local scopeVar::Scope = scopeDcl(datumVar(id, e.ty));

  top.vars = [scopeVar];

  e.lexScope = top.lexScope;
}

abstract production bindTyped
top::Bind ::= ty::Type id::String e::Expr
{
  local scopeVar::Scope = scopeDcl(datumVar(id, ty));

  top.vars = [scopeVar];

  e.lexScope = top.lexScope;
}



nonterminal Type;
abstract production tInt  top::Type  ::= {}
abstract production tBool top::Type  ::= {}
abstract production tFun  top::Type  ::= tyann1::Type tyann2::Type {}
abstract production tErr  top::Type  ::= {}



nonterminal ModRef with lexScope, imps;

abstract production modRef
top::ModRef ::= x::String
{
 local n :: Scope = scope ( )
 n.lex = just (top.lexscope);
 n.mod = [];  n.imps = [];
 n.res = get all resolutions for x in top.lexscope.impsReachable - and these have their resolution pasths on them.
 
  top.lexScope.impsReachable <- dfaMod.findReachable(x, left(top), [], [], top.lexScope);

 top.imps = minRef(n.res));   -- finds only minimal ones - not doing program resolutions here
   - for program 4, this only get A2 or B1

   ---- how to build program resolutions ...
  
}



nonterminal VarRef with lexScope, binds;

abstract production varRef
top::VarRef ::= x::String
{
  local res::[Scope] = dfaVarRef.findReachable(x, right(top), [], [], top.lexScope);

  top.binds := map ((\r::Res -> (x, r.datum.fromJust.id)), res);
}
