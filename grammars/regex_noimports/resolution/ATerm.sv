grammar regex_noimports:resolution;
imports lmr:lang;


{- Synthesizes all of the bindings found -}

monoid attribute binds::[(VarRef, Decl)] with [], ++
  occurs on Program, Decls, Decl, ParBind, Expr, VarRef;
propagate binds on Program, Decls, Decl, ParBind, Expr;


{- Scoping stuff -}

inherited attribute scope::Decorated Scope
  occurs on Decls, Decl, ParBind, Expr, VarRef;
propagate scope on Decls, Decl, ParBind, Expr, VarRef;

monoid attribute varScopes::[Decorated Scope] with [], ++
  occurs on Decls, Decl, ParBind;
propagate varScopes on Decls;


{- Aspects -}

aspect production program
top::Program ::= h::String ds::Decls
{
  local initScope::Scope = mkScope ([], ds.varScopes);
  ds.scope = initScope;
}


{-aspect production decls_list
top::Decls ::= d::Decl ds::Decls
{
  d.scope = top.scope;

}

aspect production decls_empty
top::Decls ::= 
{}-}


aspect production decl_module
top::Decl ::= x::String ds::Decls
{
  local modScope::Scope = mkScopeNamed ([top.scope], ds.varScopes, top);
  top.varScopes := [modScope];
  top.defname = x;
}

aspect production decl_def
top::Decl ::= b::ParBind
{
  local defScope::Scope = mkScopeNamed ([top.scope], [], top);
  top.varScopes := [defScope];
  top.defname = b.defname;
}

synthesized attribute defname::String occurs on ParBind, Decl;

aspect production par_defbind
top::ParBind ::= x::String e::Expr
{
  top.defname = x;
}

synthesized attribute refname::String occurs on VarRef;

aspect production var_ref_single
top::VarRef ::= x::String
{
  
  --local regex::Regex = regexCat (regexStar (regexSingle(labelLex())), regexSingle(labelVar()));
  --local dfa::DFA = regex.dfa;

  -- try above and undecorating regex prod children when resolution working
  local r1::Decorated Regex = decorate regexSingle(labelLex()) with {};
  local r2::Decorated Regex = decorate regexSingle(labelVar()) with {};
  local r1star::Decorated Regex = decorate regexStar (r1) with {};
  local regex::Decorated Regex = decorate regexCat (r1star, r2) with {};
  local dfa::DFA = regex.dfa;

  local resFun::([Decorated Scope] ::= Decorated Scope VarRef) = resolutionFun (dfa);

  top.refname = x;

  top.binds := 
    let res::[Decorated Scope] = resFun (top.scope, top) in
      case unsafeTrace (res, printT("Reslen: " ++ toString (length(res)) ++ "\n", unsafeIO())) of
        mkScopeNamed(_, _, d)::[] -> [(top, d)]    -- restricted to one decl found
      | _ -> []
      end
    end;

}