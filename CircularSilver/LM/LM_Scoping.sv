grammar LM;

{-
 - The lexically enclosing scope of a program construct.
 -}
inherited attribute lexScope::Decorated Scope;

{-
 - VAR edge targets
 -}
synthesized attribute vars::[Decorated Scope];

{-
 - MOD edge targets
 -}
synthesized attribute mod::[Decorated Scope];

{-
 - RES edge targets
 -}
synthesized attribute ress::[Res];


{-
 - Program resolution stuff
 -}
nonterminal Resolution;

abstract production varRefRes
top::Resolution ::= r::VarRef dcls::[Decorated Scope] {}

abstract production modRefRes
top::Resolution ::= r::ModRef dcls::[Decorated Scope] {}

abstract production ambigRes
top::Resolution ::= ress::[Resolution] {}

{-
 - RES edge targets
 -}
synthesized attribute programResolution::[Resolution];



-----------------------------------------
{---------- Interesting stuff ----------}


nonterminal Program with programResolution;

abstract production program
top::Program ::= ds::Decls
{
  -- Creating the new global scope node
  local glob::Scope = scope();
  glob.lexScope = nothing();
  glob.var = ds.var; glob.mod = ds.mod; glob.res = ds.ress;
  glob.datum = nothing();

  -- Drawing all the IMP edges
  r.imp = map ((.resTgt), ds.res);

  -- Decls is scoped the global scope
  ds.lexScope = globScope;

  -- [RECURSIVE] below is building the single program resolution for recursive imports



  -- [UNORDERED] below is building the coherent program resolutions for unordered imports



}


nonterminal Decls with lexScope, root, vars, mods, ress;

abstract production declsCons
top::Decls ::= d::Decl ds::Decls
{
  -- Passing down lexical scope
  d.lexScope = top.lexScope;
  ds.lexScope = top.lexScope;

  -- Synthesizing edge targets
  top.vars = d.vars ++ ds.vars;
  top.mods = d.mods ++ ds.mods;
  top.ress  = d.ress ++ ds.ress;
}

abstract production declsNil
top::Decls ::=
  -- Synthesizing empty edge targets
{ top.vars = []; top.mods = []; top.ress = []; }



nonterminal Decl with lexScope, root, vars, mods, ress;

abstract production declModule
top::Decl ::= id::String ds::Decls
{
  -- Creating the new module node
  local modScope::Scope = scope();
  r.lex = just(top.lexscope);
  r.var = ds.var; r.mod = ds.mod; r.res = ds.ress;
  r.datum = datumMod((id, modScope));

  -- Drawing all the IMP edges
  r.imp = map ((.resTgt), ds.ress);

  -- Decls is scoped the module scope
  ds.lexScope = modScope;

  -- declModule only provides the target of MOD edges
  top.vars = [];
  top.mods = [modScope];
  top.ress  = [];

  -- [RECURSIVE] below is building the single program resolution for recursive imports



  -- [UNORDERED] below is building the coherent program resolutions for unordered imports
  


}

abstract production declImport
top::Decl ::= r::ModRef
{
  r.lexScope = top.lexScope;

  -- ModRef only provides the target of RES edges
  top.vars = [];
  top.mods = [];
  top.ress  = r.ress;
}

abstract production declDef
top::Decl ::= b::ParBind
{
  b.lexScope = top.lexScope;

  -- ParBind only provides the target of VAR edges
  top.vars = b.vars;
  top.mods = [];
  top.ress  = [];
}


nonterminal Bind with lexScope, root;

abstract production bindUntyped
top::Bind ::= id::String e::Expr
{
  -- Creating the new decl node
  local scopeVar::Scope = scope();
  r.lex = just(top.lexscope);
  r.var = []; r.mod = []; r.imps = []; r.res = [];
  scopeVar.datum = datumVar((id, e.ty));

  -- Synthesizing the decl node as the target of a VAR edge from the lexically surrounding scope
  top.vars = [scopeVar];

  -- The expression is scoped in the lexically surrounding scope
  e.lexScope = top.lexScope;
}

abstract production bindTyped
top::Bind ::= ty::Type id::String e::Expr
{
  -- Creating the new decl node
  local scopeVar::Scope = scope();
  r.lex = just(top.lexscope);
  r.var = []; r.mod = []; r.imps = []; r.res = [];
  scopeVar.datum = datumVar((id, ty));

  -- Synthesizing the decl node as the target of a VAR edge from the lexically surrounding scope
  top.vars = [scopeVar];

  -- The expression is scoped in the lexically surrounding scope
  e.lexScope = top.lexScope;
}


nonterminal ModRef with lexScope, imps;

abstract production modRef
top::ModRef ::= x::String
{
  -- Creating the new reference node
  local r :: Scope = scope();
  r.lex = just(top.lexscope);
  r.var = []; r.mod = []; r.imps = []; r.res = [];
  r.datum = nothing();

  -- Demanding impsReachable, getting all res found from this node
  r.ress = filter ((\res::Res -> res.fromRef == top), top.lexScope.impsReachable);
 
  -- Contributing our resolution to impsReachable
  top.lexScope.impsReachable <- dfaMod.findReachableMod(x, top);

  -- Synthesizing this ref for use in the surrounding scope's declaration. Not really necessary?
  -- top.refs = [r];
}


nonterminal VarRef with lexScope;

abstract production varRef
top::VarRef ::= x::String
{
  -- Creating the new reference node
  local r :: Scope = scope();
  r.lex = just(top.lexscope);
  r.var = []; r.mod = []; r.imps = []; r.res = [];
  r.datum = nothing();

  -- Getting all visible declarations that match this VarRef
  -- impsReachable not used. dfaVarRef will demand impsReachable is fully computed first
  r.ress = dfaVarRef.findReachableVar(x, top);
 
  -- Synthesizing this ref for use in the surrounding scope's declaration. Not really necessary?
  -- top.refs = [r];
}




---------------------------------
{---------- Let stuff ----------}


abstract production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  -- Creating the new let scope node
  local sLet::Scope = scope();
  sLet.lex = just(bs.lastScope);
  sLet.var = bs.var; sLet.mod = []; sLet.res = []; sLet.imp = [];
  sLet.datum = nothing();

  -- The bind list is scoped in the lexically surrounding scope
  bs.lexScope = top.lexScope;

  -- The expression is scoped in the let scope
  e.lexScope = sLet;
}

abstract production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  -- Creating the new let scope node
  local sLet::Scope = scope();
  sLet.lex = just(top.lexScope);
  sLet.var = bs.var; sLet.mod = []; sLet.res = bs.ress ++ e.ress; sLet.imp = [];
  sLet.datum = nothing();

  -- The bind list is scoped in the let scope
  bs.lexScope = sLet;
  
  -- The expression is scoped in the let scope
  e.lexScope = sLet;
}

abstract production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  -- Creating the new let scope node
  local sLet::Scope = scope();
  sLet.lex = just(top.lexScope);
  sLet.var = bs.var; sLet.mod = []; sLet.res = bs.ress ++ e.ress; sLet.imp = [];
  sLet.datum = nothing();

  -- The bind list is scoped in the lexically surrounding scope
  bs.lexScope = top.lexScope;
  
  -- The expression is scoped in the let scope
  e.lexScope = sLet;
}



inherited attribute lastScope::Decorated Scope;

nonterminal SeqBinds with lexScope, lastScope, vars, ress;

abstract production seqBindsNil
top::SeqBinds ::=
{
  top.vars = [];
  top.ress = [];

  top.lastScope = top.lexScope;
}

abstract production seqBindsOne
top::SeqBinds ::= s::Bind
{
  s.lexScope = top.lexScope;

  top.vars = s.vars;
  top.ress = s.ress;

  top.lastScope = top.lexScope;
}

abstract production seqBindsCons
top::SeqBinds ::= s::Bind ss::SeqBinds
{
  local sLet::Scope = scope();
  sLet.var = s.vars; sLet.mod = []; sLet.res = s.ress; sLet.imp = [];
  sLet.datum = nothing();

  s.lexScope = top.lexScope;

  ss.lexScope = sLet;

  top.vars = ss.vars;
  top.ress = ss.ress;

  top.lastScope = ss.lastScope;
}



nonterminal ParBinds with lexScope, root, ress;

abstract production parBindsCons
top::ParBinds ::= s::Bind ss::ParBinds
{
  s.lexScope = top.lexScope;

  ss.lexScope = top.lexScope;

  top.vars = s.vars ++ ss.vars;
  top.ress = s.ress ++ ss.ress;
}

abstract production parBindsNil
top::ParBinds ::= 
{ top.ress = []; }




------------------------------------
{---------- Boring Stuff ----------}


nonterminal Expr with lexScope, ress;

abstract production exprInt
top::Expr ::= i::Integer
{ top.ress = []; }

abstract production exprTrue
top::Expr ::=
{ top.ress = []; }

abstract production exprFalse
top::Expr ::=
{ top.ress = []; }

abstract production exprVar
top::Expr ::= r::VarRef
{
  r.lexScope = top.lexScope;

  top.ress = r.ress;
}

abstract production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;

  top.ress = e1.ress ++ e2.ress;
}

abstract production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;

  top.ress = e1.ress ++ e2.ress;
}

abstract production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;

  top.ress = e1.ress ++ e2.ress;
}

nonterminal Type;
abstract production tInt  top::Type  ::= {}
abstract production tBool top::Type  ::= {}
abstract production tFun  top::Type  ::= tyann1::Type tyann2::Type {}
abstract production tErr  top::Type  ::= {}
