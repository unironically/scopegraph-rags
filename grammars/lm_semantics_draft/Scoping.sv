grammar lm_semantics_4:nameanalysis;

--------------------------------------------------

inherited attribute s::Decorated Scope;

--------------------------------------------------

attribute allScopes occurs on Main;

aspect production program
top::Main ::= ds::Decls
{
  local globalScope::Scope = mkScope();

  ds.s = globalScope;

  top.allScopes := globalScope :: ds.allScopes;
}

--------------------------------------------------

attribute s occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.s = top.s;
  ds.s = top.s;
}

aspect production declsNil
top::Decls ::=
{
}

--------------------------------------------------

attribute s occurs on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = mkScopeMod(id);--mkScopeMod(top.s, ds.varScopes, ds.modScopes, ds.impScopes, id, location=top.location);
  modScope.lexScopes <- [top.s];

  ds.s = modScope;

  top.s.modScopes <- [modScope];
}

aspect production declImport
top::Decl ::= r::ModRef
{
  r.s = top.s;

  top.s.impScopes <- r.s_mod;
}

aspect production declDef
top::Decl ::= b::ParBind
{
  b.s = top.s;
}

--------------------------------------------------

attribute s occurs on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
}

aspect production exprTrue
top::Expr ::=
{
}

aspect production exprFalse
top::Expr ::=
{
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  r.s = top.s;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  e2.s = top.s;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.s = top.s;
  e2.s = top.s;
  e3.s = top.s;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  local funScope::Scope = mkScope(); --mkScopeLet(top.s, d.varScopes, location=top.location);
  funScope.lexScopes <- [top.s];

  d.s = funScope;
  e.s = funScope;
}


aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local s_let::Scope = mkscope();--mkScopeLet(bs.lastScope, bs.varScopes, location=top.location);

  bs.s = top.s;
  bs.s_def = s_let;

  e.s = s_let;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local s_let::Scope = mkScope();--mkScopeLet(top.s, bs.varScopes, location=top.location);
  funScope.lexScopes <- [top.s];

  bs.s = s_let;
  bs.s_def = s_let;

  e.s = s_let;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local s_let::Scope = mkScopeLet(top.s, bs.varScopes, location=top.location);

  bs.s = top.s;
  bs.s_def = s_let;

  e.s = s_let;
}

--------------------------------------------------

attribute s occurs on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.s_def.lexScopes <- [top.s];
}

aspect production seqBindsOne
top::SeqBinds ::= b::SeqBind
{
  top.s_def.lexScopes <- [top.s];

  b.s = top.s;
  b.s_def = top.s_def;
}

aspect production seqBindsCons
top::SeqBinds ::= b::SeqBind bs::SeqBinds
{
  local s_defPrime::Scope = mkScope();--mkScopeSeqBind(top.s, s.varScopes, location=top.location);
  s_defPrime.lexScopes <- [top.s];

  b.s = top.s;
  b.s_def = s_defPrime;

  bs.s = s_defPrime;
  bs.s_def = top.s_def;
}

--------------------------------------------------

attribute s occurs on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local s_var::Scope = mkScopeVar((id, e.ty));

  top.s_def.varScopes <- [s_var];

  e.s = top.s;
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local s_var::Scope = mkScopeVar((id, ty));

  top.s_def.varScopes <- [s_var];

  ty.s = top.s;
  e.s = top.s;
}

--------------------------------------------------

attribute s occurs on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
}

aspect production parBindsCons
top::ParBinds ::= b::ParBind bs::ParBinds
{
  b.s = top.s;
  b.s_def = top.s_def;

  bs.s = top.s;
  bs.s_def = top.s_def;
}

--------------------------------------------------

attribute s occurs on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local s_var::Scope = mkScopeVar((id, e.ty));

  top.s_def.varScopes <- [s_var];

  e.s = top.s;
}


aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local s_var::Scope = mkScopeVar((id, ty));

  top.s_def.varScopes <- [s_var];

  ty.s = top.s;
  e.s = top.s;
}


--------------------------------------------------

attribute s occurs on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local varScope::Scope = mkScopeVar((id, ty));

  top.s.varScopes <- [s_var];

  ty.s = top.s;
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
synthesized attribute s_mod::[Decorated Scope] occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  local regex::Regex = regexCat(regexStar(regexSingle(labelLex())), regexCat(regexOption(regexSingle(labelImp())), regexSingle(labelMod())));
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun(regex.dfa);

  local ref::Ref = mkRef(x, top.s, resFun);

  top.s_mod = 
    case ref.res of
    | s::_ -> (case s.datum of
              | just(d) -> [d]
              | _ -> []
              end)
    | _ -> []
    end;
}

aspect production modQRef
top::ModRef ::= r::ModRef x::String
{
  local regex::Regex = regexSingle(labelMod());
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun(regex.dfa);

  local ref::Ref = mkRef(x, head(r.s_mod), resFun);

  top.s_mod = 
    case ref.res of
    | s::_ -> (case s.datum of
              | just(d) -> [d]
              | _ -> []
              end)
    | _ -> []
    end;
}

--------------------------------------------------

attribute s occurs on VarRef;
synthesized attribute varRefDatum::Maybe<Decorated Scope> occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  local regex::Regex = regexCat(regexStar(regexSingle(labelLex())), regexCat(regexOption(regexSingle(labelImp())), regexSingle(labelVar())));
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun(regex.dfa);

  local ref::Ref = mkRef(x, top.s, resFun);

  top.varRefDatum = 
    case ref.res of
    | s::_ -> (case s.datum of
              | just(d) -> just(d)
              | _ -> nothing()
              end)
    | _ -> nothing()
    end;
}

aspect production varQRef
top::VarRef ::= r::ModRef x::String
{
  local regex::Regex = regexSingle(labelVar());
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun(regex.dfa);

  local ref::Ref = mkRef(x, head(r.s_mod), resFun);

  top.varRefDatum = 
    case ref.res of
    | s::_ -> (case s.datum of
              | just(d) -> just(d)
              | _ -> nothing()
              end)
    | _ -> nothing()
    end;
}