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
synthesized attribute mods::[Decorated Scope];

{-
 - Refs
 -}
synthesized attribute refs::[Decorated Scope];


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
synthesized attribute progRes::[Resolution];



-----------------------------------------
{---------- Interesting stuff ----------}


nonterminal Program with progRes;

abstract production program
top::Program ::= ds::Decls
{
  -- Creating the new global scope node
  local glob::Scope = scope();
  glob.lexScope = nothing();
  glob.var = ds.var; glob.mod = ds.mod; glob.res = [];
  glob.datum = nothing();

  -- Drawing all the IMP edges
  --r.imp = map ((.resTgt), ds.res);

  -- Decls is scoped the global scope
  ds.lexScope = globScope;

  -- [RECURSIVE] below is building the single program resolution for recursive imports

  r.imp = leftmostImps(ds.res);

  top.progRes = 
    map (minRefRes, ds.refs) -- best of all resolutions for every ref in this scope
    ++ ds.progRes            -- + all progRes done in other scopes further down the tree (e.g. let scopes)
  ;

  -- [UNORDERED] below is building the coherent program resolutions for unordered imports

  r.imp = ...;

  top.progRes = ...;

}


nonterminal Decls with lexScope, root, vars, mods, refs, progRes;

abstract production declsCons
top::Decls ::= d::Decl ds::Decls
{
  -- Passing down lexical scope
  d.lexScope = top.lexScope;
  ds.lexScope = top.lexScope;

  -- Synthesizing edge targets
  top.vars = d.vars ++ ds.vars;
  top.mods = d.mods ++ ds.mods;
  top.refs  = d.refs ++ ds.refs;
  top.progRes = d.progRes ++ ds.progRes;
}

abstract production declsNil
top::Decls ::=
  -- Synthesizing empty edge targets
{ top.vars = []; top.mods = []; top.refs = []; top.progRes = []; }



nonterminal Decl with lexScope, root, vars, mods, refs, progRes;

abstract production declModule
top::Decl ::= id::String ds::Decls
{
  -- Creating the new module node
  local modScope::Scope = scope();
  r.lex = just(top.lexscope);
  r.var = ds.var; r.mod = ds.mod; r.res = ds.ress;
  r.datum = datumMod((id, modScope));

  -- Drawing all the IMP edges
  --r.imp = map ((.resTgt), ds.ress);

  -- Decls is scoped the module scope
  ds.lexScope = modScope;

  -- declModule only provides the target of MOD edges
  top.vars = [];
  top.mods = [modScope];
  top.refs = [];

  -- [RECURSIVE] below is building the single program resolution for recursive imports

  r.imp = leftmostImps(ds.res);

  top.progRes = 
    map (minRefRes, ds.refs) -- best of all resolutions for every ref in this scope
    ++ ds.progRes            -- + all progRes done in other scopes further down the tree (e.g. let scopes)
  ;

  -- [UNORDERED] below is building the coherent program resolutions for unordered imports

  r.imp = ...;
  
  top.progRes = ...;

}

abstract production declImport
top::Decl ::= r::ModRef
{
  r.lexScope = top.lexScope;

  -- ModRef only provides the target of RES edges
  top.vars = [];
  top.mods = [];
  top.refs = r.refs;
  top.progRes = [];
}

abstract production declDef
top::Decl ::= b::ParBind
{
  b.lexScope = top.lexScope;

  -- ParBind only provides the target of VAR edges
  top.vars = b.vars;
  top.mods = [];
  top.refs = [];
  top.progRes = b.progRes;
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

  -- The expression is scoped in the lexically surrounding scope
  e.lexScope = top.lexScope;

  -- Synthesizing the decl node as the target of a VAR edge from the lexically surrounding scope
  top.vars = [scopeVar];
  top.progRes = e.progRes;
}

abstract production bindTyped
top::Bind ::= ty::Type id::String e::Expr
{
  -- Creating the new decl node
  local scopeVar::Scope = scope();
  r.lex = just(top.lexscope);
  r.var = []; r.mod = []; r.imps = []; r.res = [];
  scopeVar.datum = datumVar((id, ty));

  -- The expression is scoped in the lexically surrounding scope
  e.lexScope = top.lexScope;

  -- Synthesizing the decl node as the target of a VAR edge from the lexically surrounding scope
  top.vars = [scopeVar];
  top.progRes = e.progRes;
}


nonterminal ModRef with lexScope, imps, refs;

abstract production modRef
top::ModRef ::= x::String
{
  -- Creating the new reference node
  local r :: Scope = modRefScope();
  r.lex = just(top.lexscope);
  r.var = []; r.mod = []; r.imps = [];
  r.datum = datumModRef(top);

  -- Demanding impsReachable, getting all res found from this node
  r.res = filter ((\res::Res -> res.fromRef == top), top.lexScope.impsReachable);
 
  -- Contributing our resolution to impsReachable
  top.lexScope.impsReachable <- dfaMod.findReachableMod(x, top);

  -- Synthesizing this ref for use in the surrounding scope's declaration
  top.refs = [r];
}


nonterminal VarRef with lexScope, refs;

abstract production varRef
top::VarRef ::= x::String
{
  -- Creating the new reference node
  local r :: Scope = varRefScope();
  r.lex = just(top.lexscope);
  r.var = []; r.mod = []; r.imps = []; r.res = [];
  r.datum = datumVarRef(top);

  -- Getting all visible declarations that match this VarRef
  -- impsReachable not used. dfaVarRef will demand impsReachable is fully computed first
  r.res = dfaVarRef.findReachableVar(x, top);
 
  -- Synthesizing this ref for use in the surrounding scope's declaration
  top.refs = [r];
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

  top.refs = [];

  top.progRes = map (minRefRes, bs.refs ++ e.refs)
    ++ e.progRes ++ bs.progRes
  ;
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

  top.refs = [];

  top.progRes = map (minRefRes, bs.refs ++ e.refs)
    ++ e.progRes ++ bs.progRes
  ;
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

  top.refs = [];

  top.progRes = map (minRefRes, e.refs)
    ++ e.progRes ++ bs.progRes
  ;
}



inherited attribute lastScope::Decorated Scope;

nonterminal SeqBinds with lexScope, lastScope, vars, refs, progRes;

abstract production seqBindsNil
top::SeqBinds ::=
{
  top.vars = [];
  top.refs = [];

  top.lastScope = top.lexScope;
  top.progRes = [];
}

abstract production seqBindsOne
top::SeqBinds ::= s::Bind
{
  s.lexScope = top.lexScope;

  top.vars = s.vars;
  top.refs = s.refs;

  top.lastScope = top.lexScope;
  top.progRes = s.progRes;
}

abstract production seqBindsCons
top::SeqBinds ::= s::Bind ss::SeqBinds
{
  local sLet::Scope = scope();
  sLet.var = s.vars; sLet.mod = []; sLet.res = []; sLet.imp = [];
  sLet.datum = nothing();

  s.lexScope = top.lexScope;

  ss.lexScope = sLet;

  top.lastScope = ss.lastScope;

  top.vars = ss.vars;
  top.refs = s.refs;
  top.progRes = map (minRefRes, ss.refs)
    ++ s.progRes ++ ss.progRes
  ;
}



nonterminal ParBinds with lexScope, root, refs;

abstract production parBindsCons
top::ParBinds ::= s::Bind ss::ParBinds
{
  s.lexScope = top.lexScope;

  ss.lexScope = top.lexScope;

  top.vars = s.vars ++ ss.vars;
  top.refs = s.refs ++ ss.refs;
  top.progRes = s.progRes ++ ss.progRes;
}

abstract production parBindsNil
top::ParBinds ::= 
{ top.refs = []; top.progRes = []; }




------------------------------------
{---------- Boring Stuff ----------}


nonterminal Expr with lexScope, refs, progRes;

abstract production exprInt
top::Expr ::= i::Integer
{ top.refs = []; top.progRes = []; }

abstract production exprTrue
top::Expr ::=
{ top.refs = []; top.progRes = []; }

abstract production exprFalse
top::Expr ::=
{ top.refs = []; top.progRes = []; }

abstract production exprVar
top::Expr ::= r::VarRef
{
  r.lexScope = top.lexScope;

  top.refs = r.refs;
  top.progRes = r.progRes;
}

abstract production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;

  top.refs = e1.refs ++ e2.refs;
  top.progRes = e1.progRes ++ e2.progRes;
}

abstract production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;

  top.refs = e1.refs ++ e2.refs;
  top.progRes = e1.progRes ++ e2.progRes;
}

abstract production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;

  top.refs = e1.refs ++ e2.refs;
  top.progRes = e1.progRes ++ e2.progRes;
}

nonterminal Type;
abstract production tInt  top::Type  ::= {}
abstract production tBool top::Type  ::= {}
abstract production tFun  top::Type  ::= tyann1::Type tyann2::Type {}
abstract production tErr  top::Type  ::= {}
