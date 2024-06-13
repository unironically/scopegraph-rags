grammar lm_semantics_1:nameanalysis;

--------------------------------------------------

inherited attribute lexScope::Decorated Scope;

synthesized attribute varDcls::[Decorated Scope];

monoid attribute binds::[(String, String)] with [], ++;
monoid attribute allScopes::[Decorated Scope] with [], ++;

--------------------------------------------------

attribute binds occurs on Main;
propagate binds on Main;

attribute allScopes occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local globalScope::Scope = mkScopeGlobal(ds.varDcls, location=top.location);
  ds.lexScope = globalScope;

  top.allScopes := globalScope :: ds.allScopes;
}

--------------------------------------------------

attribute s occurs on Decls;
attribute varDcls occurs on Decls;

attribute binds occurs on Decls;
propagate binds on Decls;

attribute allScopes occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.lexScope = top.lexScope;
  ds.lexScope = top.lexScope;

  top.varDcls = d.varDcls ++ ds.varDcls;

  top.allScopes := d.allScopes ++ ds.allScopes;
}

aspect production declsNil
top::Decls ::=
{
  top.varDcls = [];

  top.allScopes := [];
}

--------------------------------------------------

attribute s occurs on Decl;
attribute varDcls occurs on Decl;

attribute binds occurs on Decl;
propagate binds on Decl;

attribute allScopes occurs on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{
  top.varDcls = b.varDcls;

  b.lexScope = top.lexScope;

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
  r.lexScope = top.lexScope;
  top.allScopes := [];
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;

  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
  
  top.allScopes := e1.allScopes ++ e2.allScopes;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.lexScope = top.lexScope;
  e2.lexScope = top.lexScope;
  e3.lexScope = top.lexScope;
  
  top.allScopes := e1.allScopes ++ e2.allScopes ++ e3.allScopes;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local funScope::Scope = mkScopeLet(top.lexScope, d.varDcls, location=top.location);

  d.lexScope = funScope;
  e.lexScope = funScope;

  top.allScopes := funScope :: (d.allScopes ++ e.allScopes);
}


aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local letScope::Scope = mkScopeLet(bs.lastScope, bs.varDcls, location=top.location);

  bs.lexScope = top.lexScope;
  e.lexScope = letScope;

  top.allScopes := letScope :: (bs.allScopes ++ e.allScopes);
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = mkScopeLet(top.lexScope, bs.varDcls, location=top.location);

  bs.lexScope = letScope;
  e.lexScope = letScope;

  top.allScopes := letScope :: (bs.allScopes ++ e.allScopes);
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = mkScopeLet(top.lexScope, bs.varDcls, location=top.location);

  bs.lexScope = top.lexScope;
  e.lexScope = letScope;

  top.allScopes := letScope :: (bs.allScopes ++ e.allScopes);
}

--------------------------------------------------

attribute s occurs on SeqBinds;

synthesized attribute lastScope::Decorated Scope occurs on SeqBinds;

attribute varDcls occurs on SeqBinds;
attribute allScopes occurs on SeqBinds;

attribute binds occurs on SeqBinds;
propagate binds on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.varDcls = [];
  top.lastScope = top.lexScope;

  top.allScopes := [];
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  s.lexScope = top.lexScope;

  top.varDcls = s.varDcls;
  top.lastScope = top.lexScope;

  top.allScopes := s.allScopes;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local letBindScope::Scope = mkScopeSeqBind(top.lexScope, s.varDcls, location=top.location);

  s.lexScope = top.lexScope;
  ss.lexScope = letBindScope;

  top.varDcls = ss.varDcls;
  top.lastScope = ss.lastScope;

  top.allScopes := letBindScope :: (s.allScopes ++ ss.allScopes);
}

--------------------------------------------------

attribute s occurs on SeqBind;

attribute varDcls occurs on SeqBind;
attribute allScopes occurs on SeqBind;

attribute binds occurs on SeqBind;
propagate binds on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local varScope::Scope = mkScopeVar((id, e.ty), location=top.location);

  e.lexScope = top.lexScope;

  top.varDcls = [varScope];
  top.allScopes := [varScope];
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local varScope::Scope = mkScopeVar((id, ty), location=top.location);

  e.lexScope = top.lexScope;
  ty.lexScope = top.lexScope;

  top.varDcls = [varScope];
  top.allScopes := [varScope];
}

--------------------------------------------------

attribute s occurs on ParBinds;

attribute varDcls occurs on ParBinds;
attribute allScopes occurs on ParBinds;

attribute binds occurs on ParBinds;
propagate binds on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.varDcls = [];
  top.allScopes := [];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.lexScope = top.lexScope;
  ss.lexScope = top.lexScope;

  top.varDcls = s.varDcls ++ ss.varDcls;
  top.allScopes := s.allScopes ++ ss.allScopes;
}

--------------------------------------------------

attribute s occurs on ParBind;

attribute varDcls occurs on ParBind;
attribute allScopes occurs on ParBind;

attribute binds occurs on ParBind;
propagate binds on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local s_var::Scope = mkScopeVar((id, e.ty), location=top.location);

  top.varDcls = [s_var];

  e.lexScope = top.lexScope;

  top.allScopes := s_var :: e.allScopes;
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local s_var::Scope = mkScopeVar((id, ty), location=top.location);

  top.varDcls = [s_var];

  e.lexScope = top.lexScope;

  top.allScopes := s_var :: e.allScopes;
}

--------------------------------------------------

attribute s occurs on ArgDecl;

attribute varDcls occurs on ArgDecl;
attribute allScopes occurs on ArgDecl;

attribute binds occurs on ArgDecl;
propagate binds on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local varScope::Scope = mkScopeVar((id, ty), location=top.location);

  ty.lexScope = top.lexScope;

  top.varDcls = [varScope];
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
  tyann1.lexScope = top.lexScope;
  tyann2.lexScope = top.lexScope;
}

aspect production tErr
top::Type ::=
{

}

--------------------------------------------------

attribute s occurs on VarRef;

attribute binds occurs on VarRef;
synthesized attribute varRefDatum::Maybe<Datum> occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local regex::Regex = regexCat(regexStar(regexSingle(labelLex())), regexSingle(labelVar()));
  
  local dfa::DFA = regex.dfa;
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun(dfa);
  local result::[Decorated Scope] = resFun(top.lexScope, x);

  local bindStr::String = x ++ "_" ++ toString(top.location.line) ++ ":" ++ toString(top.location.column);

  top.varRefDatum = fst(queryResult);
  top.binds := snd(queryResult);

  local queryResult::(Maybe<Datum>, [(String, String)]) =
    case result of
      s::_ -> (case s.datum of
            | just(d) -> (just(d), [(bindStr, d.datumId ++ "_" ++ toString(d.location.line) ++ ":" ++ toString(d.location.column))])
            | nothing() -> unsafeTrace((nothing(), [(bindStr, "?")]), printT("[✗] Unable to find a binding for " ++ bindStr ++ "\n", unsafeIO()))
            end)
    | [] ->  unsafeTrace((nothing(), [(bindStr, "?")]), printT("[✗] Unable to find a binding for " ++ bindStr ++ "\n", unsafeIO()))
    end;

  
}