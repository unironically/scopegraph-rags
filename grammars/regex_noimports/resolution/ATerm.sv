grammar regex_noimports:resolution;
imports lmr:lang;


{- Synthesizes all of the bindings found -}

monoid attribute binds::[(VarRef, Bind)] with [], ++
  occurs on Program, Decls, Decl, Bind, Expr, VarRef, SeqBinds, ParBinds;
propagate binds on Program, Decls, Decl, Bind, Expr, SeqBinds, ParBinds;


{- Scoping stuff -}

inherited attribute scope::Decorated Scope
  occurs on Decls, Decl, Bind, Expr, VarRef, SeqBinds, ParBinds;
propagate scope on Decls, Decl, Bind, Expr, VarRef excluding decl_module, expr_let, expr_letrec, expr_letpar;

monoid attribute varScopes::[Decorated Scope] with [], ++
  occurs on Decls, Decl, Bind, ParBinds;
propagate varScopes on Decls;


{- Aspects -}

aspect production program
top::Program ::= h::String ds::Decls
{
  local initScope::Scope = mkScope ([], ds.varScopes);
  ds.scope = initScope;
}


aspect production decl_module
top::Decl ::= x::String ds::Decls
{
  local modScope::Scope = mkScopeMod ([top.scope], ds.varScopes, top);
  top.varScopes := [modScope];
  top.defname = x;
  ds.scope = modScope;
}

aspect production decl_def
top::Decl ::= b::Bind
{
  local defScope::Scope = mkScopeBind ([], [], b);
  top.varScopes := [defScope];
  top.defname = b.defname;
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
  local letScope::Scope = mkScope([top.scope], bs.varScopes);
  bs.lookupScope = letScope;
  bs.scope = letScope;
}

aspect production expr_letpar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = mkScope([top.scope], bs.varScopes);
  bs.lookupScope = top.scope;
  bs.scope = letScope;
}

{- Seq_Binds -}

synthesized attribute finalScope::Decorated Scope occurs on SeqBinds;

aspect production seq_binds_single
top::SeqBinds ::= b::Bind
{
  local letScope::Scope = mkScope([top.scope], [defScope]);
  local defScope::Scope = mkScopeBind ([], [], b);

  top.finalScope = letScope;
  b.scope = top.scope;
}

aspect production seq_binds_list
top::SeqBinds ::= b::Bind bs::SeqBinds
{
  local letScope::Scope = mkScope([top.scope], [defScope]);
  local defScope::Scope = mkScopeBind ([], [], b);

  top.finalScope = bs.finalScope;
  b.scope = top.scope;
  bs.scope = letScope;
}


{- Par_Binds -}

inherited attribute lookupScope::Decorated Scope occurs on ParBinds;

aspect production par_binds_list
top::ParBinds ::= b::Bind bs::ParBinds
{
  b.scope = top.scope;
  bs.scope = top.lookupScope;

  local defScope::Scope = mkScopeBind ([], [], b);
  top.varScopes <- [defScope];
}







{- Bind -}

aspect production bind
top::Bind ::= x::String e::Expr
{
  top.defname = x;
}

synthesized attribute defname::String occurs on Bind, Decl;
synthesized attribute refname::String occurs on VarRef;

aspect production var_ref_single
top::VarRef ::= x::String
{
  
  local regex::Regex = regexCat (regexStar (regexSingle(labelLex())), regexSingle(labelVar()));
  local dfa::DFA = regex.dfa;

  local resFun::([Decorated Scope] ::= Decorated Scope VarRef) = resolutionFun (dfa);

  top.refname = x;

  top.binds := 
    let res::[Decorated Scope] = resFun (top.scope, top) in

      -- allows multiple resolutions
      concat (
        map (
          (\ds::Decorated Scope -> 
            case ds of
              mkScopeBind(_, _, d) -> [(top, d)]    
            | _ -> []
            end
          ),
          res
        )
      )

      {-
      -- allows only one resolution
      case res of
        mkScopeNamed(_, _, d) -> [(top, d)]    
      | _ -> []
      end
      -}  

    end;

}