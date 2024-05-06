grammar lm_semantics_2:nameanalysis;

--------------------------------------------------

inherited attribute s::Decorated Scope;
inherited attribute sLookup::Decorated Scope;

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
  local globalScope::Scope = mkScopeGlobal ([], [], location=top.location);
  ds.s = globalScope;

  top.allScopes := globalScope :: ds.allScopes;
}

--------------------------------------------------

attribute s occurs on Decls;
attribute varScopes occurs on Decls;
attribute modScopes occurs on Decls;

attribute binds occurs on Decls;
propagate binds on Decls;

attribute allScopes occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local lookupScope::Scope = mkScopeImpLookup(top.s, d.varScopes, d.modScopes, d.impScope, location=top.location);

  d.s = top.s;
  ds.s = lookupScope;

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
attribute varScopes occurs on Decl;
attribute modScopes occurs on Decl;
attribute impScope occurs on Decl;

attribute binds occurs on Decl;
propagate binds on Decl;

attribute allScopes occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = mkScopeMod(top.s, ds.varScopes, ds.modScopes, id, location=top.location);

  top.varScopes = [];
  top.modScopes = [modScope];
  top.impScope = nothing();

  ds.s = top.s;

  top.allScopes := modScope::ds.allScopes;
}

aspect production declImport
top::Decl ::= r::ModRef
{
  top.varScopes = [];
  top.modScopes = [];
  top.impScope = r.declScope;

  r.s = top.s;

  top.allScopes := [];
}

aspect production declDef
top::Decl ::= b::ParBind
{
  top.varScopes = b.varScopes;
  top.modScopes = [];
  top.impScope = nothing();

  b.s = top.s;

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
  local funScope::Scope = mkScopeLet(top.s, d.varScopes, location=top.location);

  d.s = funScope;
  e.s = funScope;

  top.allScopes := funScope :: (d.allScopes ++ e.allScopes);
}


aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local letScope::Scope = mkScopeLet(bs.lastScope, bs.varScopes, location=top.location);

  bs.s = top.s;
  e.s = letScope;

  top.allScopes := letScope :: (bs.allScopes ++ e.allScopes);
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = mkScopeLet(top.s, bs.varScopes, location=top.location);

  bs.s = letScope;
  e.s = letScope;

  top.allScopes := letScope :: e.allScopes;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = mkScopeLet(top.s, bs.varScopes, location=top.location);

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
  local letBindScope::Scope = mkScopeSeqBind(top.s, s.varScopes, location=top.location);

  s.s = top.s;
  ss.s = letBindScope;

  top.varScopes = ss.varScopes;
  top.lastScope = ss.lastScope;

  top.allScopes := letBindScope :: (s.allScopes ++ ss.allScopes);
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
  local varScope::Scope = mkScopeVar ((id, e.ty), location=top.location);

  e.s = top.s;

  top.varScopes = [varScope];
  top.allScopes := [varScope];
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local varScope::Scope = mkScopeVar ((id, ty), location=top.location);

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
  local s_var::Scope = mkScopeVar((id, e.ty), location=top.location);

  top.varScopes = [s_var];

  e.s = top.s;

  top.allScopes := s_var :: e.allScopes;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local s_var::Scope = mkScopeVar((id, ty), location=top.location);

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
  local varScope::Scope = mkScopeVar((id, ty), location=top.location);

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

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  tyann1.s = top.s;
  tyann2.s = top.s;
}

aspect production tErr
top::Type ::=
{

}

--------------------------------------------------

attribute s occurs on ModRef;

synthesized attribute declScope::Maybe<Decorated Scope> occurs on ModRef;
attribute datum occurs on ModRef;
attribute binds occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  local regex::Regex = regexCat (regexStar (regexSingle(labelLex())), regexCat (regexOption (regexSingle (labelImp())), regexSingle(labelMod())));
  
  local dfa::DFA = regex.dfa;
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun (dfa);
  local result::[Decorated Scope] = resFun (top.s, x);

  local bindStr::String = x ++ "_" ++ toString(top.location.line) ++ ":" ++ toString(top.location.column);

  top.declScope = fst(queryResult);
  top.datum = fst(snd(queryResult));
  top.binds := snd(snd (queryResult));

  local queryResult::(Maybe<Decorated Scope>, Maybe<Datum>, [(String, String)]) =
    case result of
      s::_ -> (case s.datum of
            | just (d) -> (just(s), just(d), [(bindStr, d.datumId ++ "_" ++ toString(d.location.line) ++ ":" ++ toString(d.location.column))])
            | nothing() -> unsafeTrace ((nothing(), nothing(), [(bindStr, "?")]), printT("[✗] Unable to find a binding for " ++ bindStr ++ "\n", unsafeIO()))
            end)
    | [] ->  unsafeTrace ((nothing(), nothing(), [(bindStr, "?")]), printT("[✗] Unable to find a binding for " ++ bindStr ++ "\n", unsafeIO()))
    end;
  
}

aspect production modQRef
top::ModRef ::= r::ModRef x::String
{

  local regex::Regex = regexSingle(labelMod());
  
  local dfa::DFA = regex.dfa;
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun (dfa);
  local result::[Decorated Scope] = case r.declScope of | just(sMod) -> resFun (sMod, x) | _ -> [] end;

  local bindStr::String = x ++ "_" ++ toString(top.location.line) ++ ":" ++ toString(top.location.column);

  top.declScope = fst(queryResult);
  top.datum = fst(snd(queryResult));
  top.binds := snd(snd (queryResult));

  local queryResult::(Maybe<Decorated Scope>, Maybe<Datum>, [(String, String)]) =
    case result of
      s::_ -> (case s.datum of
            | just (d) -> (just(s), just(d), [(bindStr, d.datumId ++ "_" ++ toString(d.location.line) ++ ":" ++ toString(d.location.column))])
            | nothing() -> unsafeTrace ((nothing(), nothing(), [(bindStr, "?")]), printT("[✗] Unable to find a binding for " ++ bindStr ++ "\n", unsafeIO()))
            end)
    | [] ->  unsafeTrace ((nothing(), nothing(), [(bindStr, "?")]), printT("[✗] Unable to find a binding for " ++ bindStr ++ "\n", unsafeIO()))
    end;

  r.s = top.s;

}

--------------------------------------------------

attribute s occurs on VarRef;

attribute declScope occurs on VarRef;
attribute datum occurs on VarRef;
attribute binds occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local regex::Regex = regexCat (regexStar (regexSingle(labelLex())), regexCat (regexOption (regexSingle (labelImp())), regexSingle(labelVar())));
  
  local dfa::DFA = regex.dfa;
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun (dfa);
  local result::[Decorated Scope] = resFun (top.s, x);

  local bindStr::String = x ++ "_" ++ toString(top.location.line) ++ ":" ++ toString(top.location.column);

  top.declScope = fst(queryResult);
  top.datum = fst(snd(queryResult));
  top.binds := snd(snd (queryResult));

  local queryResult::(Maybe<Decorated Scope>, Maybe<Datum>, [(String, String)]) =
    case result of
      s::_ -> (case s.datum of
            | just (d) -> (just(s), just(d), [(bindStr, d.datumId ++ "_" ++ toString(d.location.line) ++ ":" ++ toString(d.location.column))])
            | nothing() -> unsafeTrace ((nothing(), nothing(), [(bindStr, "?")]), printT("[✗] Unable to find a binding for " ++ bindStr ++ "\n", unsafeIO()))
            end)
    | [] ->  unsafeTrace ((nothing(), nothing(), [(bindStr, "?")]), printT("[✗] Unable to find a binding for " ++ bindStr ++ "\n", unsafeIO()))
    end;
  
}

aspect production varQRef
top::VarRef ::= r::ModRef x::String
{

  local regex::Regex = regexSingle(labelVar());
  
  local dfa::DFA = regex.dfa;
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun (dfa);
  local result::[Decorated Scope] = case r.declScope of | just(sMod) -> resFun (sMod, x) | _ -> [] end;

  local bindStr::String = x ++ "_" ++ toString(top.location.line) ++ ":" ++ toString(top.location.column);

  top.declScope = fst(queryResult);
  top.datum = fst(snd(queryResult));
  top.binds := snd(snd (queryResult));

  local queryResult::(Maybe<Decorated Scope>, Maybe<Datum>, [(String, String)]) =
    case result of
      s::_ -> (case s.datum of
            | just (d) -> (just(s), just(d), [(bindStr, d.datumId ++ "_" ++ toString(d.location.line) ++ ":" ++ toString(d.location.column))])
            | nothing() -> unsafeTrace ((nothing(), nothing(), [(bindStr, "?")]), printT("[✗] Unable to find a binding for " ++ bindStr ++ "\n", unsafeIO()))
            end)
    | [] ->  unsafeTrace ((nothing(), nothing(), [(bindStr, "?")]), printT("[✗] Unable to find a binding for " ++ bindStr ++ "\n", unsafeIO()))
    end;

  r.s = top.s;

}