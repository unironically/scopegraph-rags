grammar lmr_scopefunctions:resolution;
imports lmr:lang;
imports lmr_scopefunctions:driver;

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

monoid attribute impScopes::[Decorated Scope] with [], ++
  occurs on Decls, Decl, ModRef;
propagate impScopes on Decls;

synthesized attribute impLookupScope::Maybe<Decorated Scope> occurs on Decl;

{- Aspects -}

aspect production program
top::Program ::= h::String ds::Decls
{
  local initScope::Scope = mkScopeGlobal (genInt(), ds.varScopes, ds.modScopes, ds.impScopes);
  ds.scope = initScope;
}

aspect production decls_list
top::Decls ::= d::Decl ds::Decls
{ 
  propagate scope, modScopes, impScopes, varScopes;
  d.scope = top.scope;
  ds.scope = top.scope;

  top.modScopes := d.modScopes ++ ds.modScopes;
  top.impScopes := d.modScopes ++ ds.modScopes;
  top.varScopes := [];
}


aspect production decl_module
top::Decl ::= x::String ds::Decls
{
  local modScope::Scope = 
    mkScopeMod (ds.varScopes, ds.modScopes, ds.impScopes, just(top));
  
  top.modScopes := [modScope];
  top.impScopes := [];
  top.varScopes := [];

  ds.scope = modScope;
}

aspect production decl_def
top::Decl ::= b::Bind
{  
  local defScope::Scope = mkScopeBind (genInt(), [], [], [], [], b);

  top.varScopes := [defScope];
  top.modScopes := [];
  top.impScopes := [];
  
  top.defname = b.defname;

  top.impLookupScope = nothing ();
}

aspect production decl_import
top::Decl ::= r::ModRef
{
  top.modScopes := [];
  top.varScopes := [];
  top.impScopes := r.impScopes;
  
  top.defname = r.refname;

  --local lookupScope::Scope = mkScope (genInt(), "", [top.scope], [], [], r.impScopes);
  r.scope = top.scope;

  --top.impLookupScope = just(lookupScope);
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
  local letScope::Scope = mkScope(genInt(), "", [top.scope], bs.varScopes, [], []);
  bs.lookupScope = letScope;
  bs.scope = letScope;
  e.scope = letScope;
}

aspect production expr_letpar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = mkScope(genInt(), "", [top.scope], bs.varScopes, [], []);
  bs.lookupScope = top.scope;
  bs.scope = letScope;
  e.scope = letScope;
}




{- Seq_Binds -}

synthesized attribute finalScope::Decorated Scope occurs on SeqBinds;

aspect production seq_binds_single
top::SeqBinds ::= b::Bind
{
  local letScope::Scope = mkScope(genInt(), "", [top.scope], [defScope], [], []);
  local defScope::Scope = mkScopeBind (genInt(), [], [], [], [], b);

  top.finalScope = letScope;
  b.scope = top.scope;
}

aspect production seq_binds_list
top::SeqBinds ::= b::Bind bs::SeqBinds
{
  local letScope::Scope = mkScope(genInt(), "", [top.scope], [defScope], [], []);
  local defScope::Scope = mkScopeBind (genInt(), [], [], [], [], b);

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

  local defScope::Scope = mkScopeBind (genInt(), [], [], [], [], b);
  top.varScopes <- [defScope];
}


{- Bind -}

synthesized attribute label::String occurs on Bind, VarRef, ModRef;

aspect production bind
top::Bind ::= x::VarRef_t e::Expr

{
  top.defname = x.lexeme;
  top.label = x.lexeme ++ "_" ++ toString(x.line) ++ "_" ++ toString(x.column);
}

synthesized attribute defname::String occurs on Bind, Decl;
synthesized attribute refname::String occurs on VarRef, ModRef;

aspect production var_ref_single
top::VarRef ::= x::VarRef_t
{
  
  local regex::Regex = regexCat (regexStar (regexSingle(labelLex())), regexCat (regexOption (regexSingle (labelImp())), regexSingle(labelVar())));
  
  local dfa::DFA = regex.dfa;

  top.refname = x.lexeme;
  top.label = x.lexeme ++ "_" ++ toString(x.line) ++ "_" ++ toString(x.column);

  top.binds := 
    let res::[Decorated Scope] = top.scope.resolve (pathOne(top.scope), dfa, fst(snd(snd(dfa))), \s::String -> s == x.lexeme) in
      case res of
        mkScopeBind(_, _, _, _, _, b)::_ -> unsafeTrace ([(left(top), b)], printT ("Trying to resolve " ++ x.lexeme ++ ". Decl scope at the top\n", unsafeIO()))
      | mkScopeMod (_, _, _, _, _, _)::_ -> unsafeTrace ([], printT ("Trying to resolve " ++ x.lexeme ++ ". Mod scope at the top\n", unsafeIO()))
      | mkScopeGlobal (_, _, _, _)::_ -> unsafeTrace ([], printT ("Trying to resolve " ++ x.lexeme ++ ". Global scope at the top\n", unsafeIO()))
      | mkScope (_, _, _, _, _, _)::_ -> unsafeTrace ([], printT ("Trying to resolve " ++ x.lexeme ++ ". Normal scope at the top\n", unsafeIO()))
      | [] -> unsafeTrace ([], printT ("Trying to resolve " ++ x.lexeme ++ ". No scope at the top\n", unsafeIO()))
      end
    end;
}


aspect production mod_ref_single
top::ModRef ::= x::TypeRef_t
{
  local regex::Regex = regexCat (regexStar (regexSingle(labelLex())), regexCat (regexOption (regexSingle (labelImp())), regexSingle(labelMod())));

  local dfa::DFA = regex.dfa;

  top.refname = x.lexeme;
  top.label = x.lexeme ++ "_" ++ toString(x.line) ++ "_" ++ toString(x.column);

  top.impScopes := 
    let res::[Decorated Scope] = top.scope.resolve (pathOne(top.scope), dfa, fst(snd(snd(dfa))), \s::String -> s == x.lexeme) in
      case res of
        mkScopeBind(_, _, _, _, _, b)::_ -> unsafeTrace ([head(res)], printT ("Trying to resolve " ++ x.lexeme ++ ". Decl scope at the top\n", unsafeIO()))
      | mkScopeMod (_, _, _, _, _, _)::_ -> unsafeTrace ([], printT ("Trying to resolve " ++ x.lexeme ++ ". Mod scope at the top\n", unsafeIO()))
      | mkScopeGlobal (_, _, _, _)::_ -> unsafeTrace ([], printT ("Trying to resolve " ++ x.lexeme ++ ". Global scope at the top\n", unsafeIO()))
      | mkScope (_, _, _, _, _, _)::_ -> unsafeTrace ([head(res)], printT ("Trying to resolve " ++ x.lexeme ++ ". Normal scope at the top\n", unsafeIO()))
      | [] -> unsafeTrace ([], printT ("Trying to resolve " ++ x.lexeme ++ ". No scope at the top\n", unsafeIO()))
      end
    end;
}

abstract production mod_to_varref
top::VarRef ::= x::ModRef
{
  top.refname = x.refname;
  top.label = x.label;
  top.binds := [];
}