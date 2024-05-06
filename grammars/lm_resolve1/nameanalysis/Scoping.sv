grammar lm_resolve1:nameanalysis;

imports lm:lang:abstractsyntax;

--------------------------------------------------

inherited attribute s::Decorated Scope;
inherited attribute s_lookup::Decorated Scope;

synthesized attribute varScopes::[Decorated Scope];
synthesized attribute modScopes::[Decorated Scope];
synthesized attribute impScope::Maybe<Decorated Scope>;

monoid attribute binds::[(String, String)] with [], ++;
monoid attribute allScopes::[Decorated Scope] with [], ++;

--------------------------------------------------

attribute binds occurs on Main;
propagate binds on Main;

attribute allScopes occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local globalScope::Scope = mkScopeGlobal (ds.varScopes, ds.modScopes);
  ds.s = globalScope;
  ds.s_lookup = globalScope;

  top.allScopes := globalScope :: ds.allScopes;
}

--------------------------------------------------

attribute s occurs on Decls;
attribute s_lookup occurs on Decls;

attribute varScopes occurs on Decls;
attribute modScopes occurs on Decls;

attribute binds occurs on Decls;
propagate binds on Decls;

attribute allScopes occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local s_imp::Scope = mkLookupScope(top.s_lookup, d.impScope);
  
  d.s = top.s;
  d.s_lookup = s_imp;

  ds.s = top.s;
  ds.s_lookup = s_imp;

  top.varScopes = d.varScopes ++ ds.varScopes;
  top.modScopes = d.modScopes ++ ds.modScopes;

  top.allScopes := d.allScopes ++ ds.allScopes;
}

aspect production declsNil
top::Decls ::=
{
  top.varScopes = [];
  top.modScopes = [];

  top.allScopes := [];
}

--------------------------------------------------

attribute s occurs on Decl;
attribute s_lookup occurs on Decl;

attribute varScopes occurs on Decl;
attribute modScopes occurs on Decl;
attribute impScope occurs on Decl;

attribute binds occurs on Decl;
propagate binds on Decl;

attribute allScopes occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local s_mod::Scope = mkScopeMod (top.s, ds.varScopes, ds.modScopes, top);

  top.varScopes = [];
  top.modScopes = [s_mod];
  top.impScope = nothing();

  ds.s = s_mod;
  ds.s_lookup = s_mod;

  top.allScopes := s_mod :: ds.allScopes;
}

aspect production declImport
top::Decl ::= r::ModRef
{
  top.varScopes = [];
  top.modScopes = [];
  top.impScope = r.impScope;

  r.s = top.s;

  top.allScopes := [];
}

aspect production declDef
top::Decl ::= b::ParBind
{
  top.varScopes = b.varScopes;
  top.modScopes = [];
  top.impScope = nothing();

  b.s = top.s_lookup;

  top.allScopes := b.allScopes;
}

--------------------------------------------------

attribute s occurs on Expr;

attribute binds occurs on Expr;
propagate binds on Expr;

attribute allScopes occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.allScopes := [];
}

aspect production exprTrue
top::Expr ::=
{
  top.allScopes := [];
}

aspect production exprFalse
top::Expr ::=
{
  top.allScopes := [];
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  r.s = top.s;
  top.allScopes := [];
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;

  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  e3.s = top.s;
  
  top.allScopes := e1.allScopes ++ e2.allScopes ++ e3.allScopes;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  d.s = top.s;
  e.s = top.s;

  top.allScopes := e.allScopes;
}


aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local letScope::Scope = mkScope(just(bs.lastScope), bs.varScopes, [], nothing(), nothing());

  bs.s = top.s;
  e.s = letScope;

  top.allScopes := letScope :: (bs.allScopes ++ e.allScopes);
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = mkScope(just(top.s), bs.varScopes, [], nothing(), nothing());

  bs.s = letScope;
  e.s = letScope;

  top.allScopes := letScope :: e.allScopes;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = mkScope(just(top.s), bs.varScopes, [], nothing(), nothing());

  bs.s = top.s;
  e.s = letScope;

  top.allScopes := letScope :: e.allScopes;
}

--------------------------------------------------

attribute s occurs on SeqBinds;

synthesized attribute lastScope::Decorated Scope occurs on SeqBinds;

attribute varScopes occurs on SeqBinds;
attribute allScopes occurs on SeqBinds;

attribute binds occurs on SeqBinds;
propagate binds on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.varScopes = [];
  top.lastScope = top.s;

  top.allScopes := [];
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  s.s = top.s;

  top.varScopes = s.varScopes;
  top.lastScope = top.s;

  top.allScopes := [];
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local letBindScope::Scope = mkScopeSeqBind(top.s, s.varScopes);

  s.s = top.s;
  ss.s = letBindScope;

  top.varScopes = ss.varScopes;
  top.lastScope = letBindScope;

  top.allScopes := [letBindScope];
}

--------------------------------------------------

attribute s occurs on SeqBind;

attribute varScopes occurs on SeqBind;
attribute allScopes occurs on SeqBind;

attribute binds occurs on SeqBind;
propagate binds on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local varScope::Scope = mkScopeSeqVar (top);

  e.s = top.s;

  top.varScopes = [varScope];
  top.allScopes := [varScope];
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local varScope::Scope = mkScopeSeqVar (top);

  e.s = top.s;
  ty.s = top.s;

  top.varScopes = [varScope];
  top.allScopes := [varScope];
}

--------------------------------------------------

attribute s occurs on ParBinds;

attribute varScopes occurs on ParBinds;

attribute binds occurs on ParBinds;
propagate binds on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.varScopes = [];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.s = top.s;
  ss.s = top.s;

  top.varScopes = s.varScopes ++ ss.varScopes;
}

--------------------------------------------------

attribute s occurs on ParBind;

attribute varScopes occurs on ParBind;
attribute allScopes occurs on ParBind;

attribute binds occurs on ParBind;
propagate binds on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local s_var::Scope = mkScopeParVar(top);

  top.varScopes = [s_var];

  e.s = top.s;

  top.allScopes := s_var :: e.allScopes;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local s_var::Scope = mkScopeParVar(top);

  top.varScopes = [s_var];

  e.s = top.s;

  top.allScopes := s_var :: e.allScopes;
}

--------------------------------------------------

attribute s occurs on ArgDecl;

attribute varScopes occurs on ArgDecl;
attribute allScopes occurs on ArgDecl;

attribute binds occurs on ArgDecl;
propagate binds on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local varScope::Scope = mkScopeArgVar(top);

  ty.s = top.s;

  top.varScopes = [varScope];
  top.allScopes := [varScope];
}

--------------------------------------------------

attribute s occurs on Type;

aspect production tInt
top::Type ::=
{

}

aspect production tBool
top::Type ::=
{

}

aspect production tArrow
top::Type ::= tyann1::Type tyann2::Type
{
  tyann1.s = top.s;
  tyann2.s = top.s;
}

--------------------------------------------------

attribute s occurs on ModRef;

attribute impScope occurs on ModRef;
attribute binds occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  local regex::Regex = regexCat (regexStar (regexSingle(labelLex())), regexCat (regexOption (regexSingle (labelImp())), regexSingle(labelMod())));
  local dfa::DFA = regex.dfa;
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun (dfa);
  local result::[Decorated Scope] = resFun (top.s, x);

  local impXbind::(Maybe<Decorated Scope>, [(String, String)]) =
    case result of
      s::_ -> (case s.datum of
              | just (d) -> (just(s), [(x, d.datumId)])
              | nothing() -> (nothing(), [])
              end)
    | [] -> (nothing(), [])
    end;

  top.impScope = fst(impXbind);
  top.binds := snd(impXbind);
}

aspect production modQRef
top::ModRef ::= r::ModRef x::String
{
  top.binds := [];
  top.impScope = nothing();
}

--------------------------------------------------

attribute s occurs on VarRef;

attribute binds occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local regex::Regex = regexCat (regexStar (regexSingle(labelLex())), regexCat (regexOption (regexSingle (labelImp())), regexSingle(labelVar())));
  local dfa::DFA = regex.dfa;
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun (dfa);
  local result::[Decorated Scope] = resFun (top.s, x);

  top.binds :=
    case result of
      s::_ -> (case s.datum of
            | just (d) -> [(x, d.datumId)]
            | nothing() -> unsafeTrace ([], printT("Oh crap (var 1)...\n", unsafeIO()))
            end)
    | [] ->  unsafeTrace ([], printT("Oh crap (var 2)...\n", unsafeIO()))
    end;
}

aspect production varQRef
top::VarRef ::= r::ModRef x::String
{
  top.binds := [];
}