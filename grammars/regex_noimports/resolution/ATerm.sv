grammar regex_noimports:resolution;
imports lmr:lang;
imports regex_noimports:driver;

{- Synthesizes all of the bindings found -}

monoid attribute binds::[(Either<VarRef ModRef>, Bind)] with [], ++
  occurs on Program, Decls, Decl, Bind, Expr, VarRef, SeqBinds, ParBinds;
propagate binds on Program, Decls, Decl, Bind, Expr, SeqBinds, ParBinds;


{- Scoping stuff -}

inherited attribute scope::Decorated Scope
  occurs on Decls, Decl, Bind, Expr, VarRef, ModRef, SeqBinds, ParBinds;
propagate scope on Decl, Bind, Expr, VarRef excluding decl_module, expr_let, expr_letrec, expr_letpar, decl_import;

monoid attribute varScopes::[Decorated Scope] with [], ++
  occurs on Decls, Decl, ParBinds;
propagate varScopes on Decls;

monoid attribute modScopes::[Decorated Scope] with [], ++
  occurs on Decls, Decl;
propagate modScopes on Decls;

synthesized attribute impScope::Maybe<Decorated Scope>
  occurs on ModRef;

synthesized attribute impLookupScope::Maybe<Decorated Scope> occurs on Decl;

{- Aspects -}

aspect production program
top::Program ::= h::String ds::Decls
{
  local initScope::Scope = mkScopeGlobal(ds.varScopes, ds.modScopes);
  ds.scope = initScope;
}

aspect production decls_list
top::Decls ::= d::Decl ds::Decls
{
  d.scope = top.scope;
  ds.scope = case d.impLookupScope of nothing() -> top.scope | just(s) -> s end;
}

aspect production decl_module
top::Decl ::= x::String ds::Decls
{
  local modScope::Scope = mkScopeMod(top.scope, ds.varScopes, ds.modScopes, top);
  
  top.modScopes := [modScope];
  top.varScopes := [];

  ds.scope = modScope;

  top.impLookupScope = nothing();
}

aspect production decl_def
top::Decl ::= b::Bind
{
  local defScope::Scope = mkScopeVar(b);

  top.varScopes := [defScope];
  top.modScopes := [];
  
  top.impLookupScope = nothing();
}

aspect production decl_import
top::Decl ::= r::ModRef
{
  top.modScopes := [];
  top.varScopes := [];
  
  local lookupScope::Scope = mkScope(just(top.scope), [], [], r.impScope, nothing());
  r.scope = top.scope;

  top.impLookupScope = just(lookupScope);
}


{- Expressions -}

aspect production expr_let
top::Expr ::= bs::SeqBinds e::Expr
{
  bs.scope = top.scope;
  e.scope = bs.finalScope;
}

aspect production expr_letrec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = mkScope(just(top.scope), bs.varScopes, [], nothing(), nothing());
  bs.lookupScope = letScope;
  bs.scope = letScope;
  e.scope = letScope;
}

aspect production expr_letpar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = mkScope(just(top.scope), bs.varScopes, [], nothing(), nothing());
  bs.lookupScope = top.scope;
  bs.scope = letScope;
  e.scope = letScope;
}




{- Seq_Binds -}

synthesized attribute finalScope::Decorated Scope occurs on SeqBinds;

aspect production seq_binds_single
top::SeqBinds ::= b::Bind
{
  local letScope::Scope = mkScope(just(top.scope), [defScope], [], nothing(), nothing());
  local defScope::Scope = mkScopeVar(b);

  top.finalScope = letScope;
  b.scope = top.scope;
}

aspect production seq_binds_list
top::SeqBinds ::= b::Bind bs::SeqBinds
{
  local letScope::Scope = mkScope(just(top.scope), [defScope], [], nothing(), nothing());
  local defScope::Scope = mkScopeVar(b);

  top.finalScope = bs.finalScope;
  b.scope = top.scope;
  bs.scope = letScope;
}


{- Par_Binds -}

inherited attribute lookupScope::Decorated Scope occurs on ParBinds;

aspect production par_binds_empty
top::ParBinds ::=
{
  top.varScopes := [];
}

aspect production par_binds_list
top::ParBinds ::= b::Bind bs::ParBinds
{
  propagate varScopes;
  b.scope = top.scope;
  bs.scope = top.lookupScope;

  local defScope::Scope = mkScopeVar(b);
  top.varScopes <- [defScope];
}


{- Bind -}

synthesized attribute label::String occurs on Bind, VarRef, ModRef;

aspect production bind
top::Bind ::= x::VarRef_t e::Expr
{
  top.label = x.lexeme ++ "_" ++ toString(x.line) ++ "_" ++ toString(x.column);
}

synthesized attribute refname::String occurs on VarRef, ModRef;

aspect production var_ref_single
top::VarRef ::= x::VarRef_t
{
  local regex::Regex = regexCat(regexStar(regexSingle(labelLex())), regexCat(regexOption(regexSingle(labelImp())), regexSingle(labelVar())));
  
  local dfa::DFA = regex.dfa;

  local resFun::([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) = resolutionFun(dfa);

  top.refname = x.lexeme;
  top.label = x.lexeme ++ "_" ++ toString(x.line) ++ "_" ++ toString(x.column);

  top.binds :=
    let res::[Decorated Scope] = resFun(top.scope, x.lexeme, []) in
      case res of
        mkScopeVar(d)::t -> [(left(top), d)]
      | _ -> []
      end
    end;
}


aspect production mod_ref_single
top::ModRef ::= x::TypeRef_t
{
  local regex::Regex = regexCat(regexStar(regexSingle(labelLex())), regexCat(regexOption(regexSingle(labelImp())), regexSingle(labelMod())));

  local dfa::DFA = regex.dfa;

  local resFun::([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) = resolutionFun(dfa);

  top.refname = x.lexeme;
  top.label = x.lexeme ++ "_" ++ toString(x.line) ++ "_" ++ toString(x.column);

  top.impScope = just(head(resFun(top.scope, x.lexeme, [])));
}

abstract production mod_to_varref
top::VarRef ::= x::ModRef
{
  top.refname = x.refname;
  top.label = x.label;
  top.binds := [];
}