grammar lmr1:lmr:nameanalysis5;

imports syntax:lmr1:lmr:abstractsyntax;

import silver:langutil; -- for location.unparse

--------------------------------------------------

monoid attribute ok::Boolean with true, &&;

inherited attribute s::SGRegNode;
--monoid attribute VAR_s::[LMScope] with [], ++;
--monoid attribute MOD_s::[LMScope] with [], ++;
--monoid attribute IMP_s::[LMScope] with [], ++;

inherited attribute s_def::SGRegNode;
monoid attribute VAR_s_def::[Decorated SGVarNode] with [], ++;
monoid attribute MOD_s_def::[Decorated SGModNode] with [], ++;
monoid attribute IMP_s_def::[Decorated SGModNode] with [], ++;

inherited attribute s_module::SGRegNode;
monoid attribute VAR_s_module::[Decorated SGVarNode] with [], ++;
monoid attribute MOD_s_module::[Decorated SGModNode] with [], ++;
--monoid attribute IMP_s_module::[LMScope] with [], ++;

synthesized attribute type::Type;

--------------------------------------------------

nonterminal Main with location;

attribute ok occurs on Main;
propagate ok on Main;

production program
top::Main ::= ds::Decls
{
  production attribute globScope::SGLexNode = sgLexNode();
  globScope.lex := []; globScope.var := [];
  globScope.mod := []; globScope.imp := [];

  ds.s = globScope.asSGRegNode;
  ds.s_module = error("ds.s_module - where ds is child of program - shouldn't be demanded");
}

--------------------------------------------------

nonterminal Decls with location;

attribute ok occurs on Decls;
propagate ok on Decls;

attribute s occurs on Decls;
attribute s_module, VAR_s_module, MOD_s_module occurs on Decls;

production declsCons
top::Decls ::= d::Decl ds::Decls
{
  production attribute seqScope::SGLexNode = sgLexNode();
  seqScope.lex := [top.s];
  seqScope.var := d.VAR_s_def;
  seqScope.mod := d.MOD_s_def;
  seqScope.imp := d.IMP_s_def;

  d.s = top.s;
  d.s_def = seqScope.asSGRegNode;
  d.s_module = top.s_module;

  ds.s = seqScope.asSGRegNode;
  ds.s_module = top.s_module;

  top.VAR_s_module := d.VAR_s_module ++ ds.VAR_s_module;
  top.MOD_s_module := d.MOD_s_module ++ ds.MOD_s_module;
}

production declsNil
top::Decls ::=
{
  top.VAR_s_module := [];
  top.MOD_s_module := [];
}

--------------------------------------------------

nonterminal Decl with location;

attribute ok occurs on Decl;
propagate ok on Decl;

attribute s occurs on Decl;
attribute s_def, VAR_s_def, MOD_s_def, IMP_s_def occurs on Decl;
attribute s_module, VAR_s_module, MOD_s_module occurs on Decl;

production declModule
top::Decl ::= m::Module
{
  m.s = top.s;
  m.s_def = top.s_def;
  m.s_module = top.s_module;

  top.VAR_s_def := m.VAR_s_def;
  top.MOD_s_def := m.MOD_s_def;
  top.IMP_s_def := m.IMP_s_def;

  top.VAR_s_module := m.VAR_s_module;
  top.MOD_s_module := m.MOD_s_module;
}

production declImport
top::Decl ::= r::ModRef
{
  r.s = top.s;
  r.s_def = top.s_def;

  top.VAR_s_def := [];
  top.MOD_s_def := [];
  top.IMP_s_def := r.IMP_s_def;

  top.VAR_s_module := [];
  top.MOD_s_module := [];
}

production declDef
top::Decl ::= b::Bind
{
  b.s = top.s;
  b.s_def = top.s_module;

  top.VAR_s_def := b.VAR_s_def;
  top.MOD_s_def := [];
  top.IMP_s_def := [];

  top.VAR_s_module := b.VAR_s_def;
  top.MOD_s_module := [];
}

--------------------------------------------------

nonterminal Module with location, name;

attribute ok occurs on Module;
propagate ok on Module;

attribute s occurs on Module;
attribute s_def, VAR_s_def, MOD_s_def, IMP_s_def occurs on Module;
attribute s_module, VAR_s_module, MOD_s_module occurs on Module;

production module
top::Module ::= id::String ds::Decls
{
  production attribute modScope::SGModNode = sgModNode(top);
  modScope.lex := [top.s];
  modScope.var := ds.VAR_s_module;
  modScope.mod := ds.MOD_s_module;
  modScope.imp := [];

  top.name = id;

  top.VAR_s_def := [];
  top.MOD_s_def := [modScope];
  top.IMP_s_def := [];

  top.VAR_s_module := [];
  top.MOD_s_module := [modScope];

  ds.s = top.s;
  ds.s_module = modScope.asSGRegNode;
}

--------------------------------------------------

nonterminal Expr with location;

attribute s occurs on Expr;

attribute type occurs on Expr;

attribute ok occurs on Expr;
propagate ok on Expr excluding exprFun, exprApp, exprIf;

production exprFloat
top::Expr ::= f::Float
{
  top.type = tFloat();
}

production exprInt
top::Expr ::= i::Integer
{
  top.type = tInt();
}

production exprTrue
top::Expr ::=
{
  top.type= tBool();
}

production exprFalse
top::Expr ::=
{
  top.type= tBool();
}

production exprVar
top::Expr ::= r::VarRef
{
  propagate s;

  top.type = r.type;
}

production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  propagate s;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, tInt())
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  propagate s;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tBool(), tBool() -> (true, tBool())
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  propagate s;

  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | t1, t2 when t1 == t2 -> (true, tBool())
                                   | _, _ -> (false, tErr())
                                   end;

  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

production exprFun
top::Expr ::= d::Bind e::Expr
{
  top.ok := false; --todo
  top.type = tErr(); --todo
}

production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  top.ok := false; --todo
  top.type = tErr(); --todo
}

production exprIf
top::Expr ::= c::Expr e1::Expr e2::Expr
{
  top.ok := false; --todo
  top.type = tErr(); --todo
}

production exprLet
top::Expr ::= bs::Binds e::Expr
{
  bs.s = top.s;
  e.s = bs.lastScope;

  top.type = e.type;
}

production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  production attribute letScope::SGLexNode = sgLexNode();
  letScope.lex := [top.s];
  letScope.var := bs.VAR_s_def;
  letScope.mod := [];
  letScope.imp := [];


  bs.s = letScope.asSGRegNode;
  bs.s_def = letScope.asSGRegNode;

  e.s = letScope.asSGRegNode;

  top.type = e.type;
}

production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  production attribute letScope::SGLexNode = sgLexNode();
  letScope.lex := [top.s];
  letScope.var := bs.VAR_s_def;
  letScope.mod := [];
  letScope.imp := [];

  bs.s = top.s;
  bs.s_def = letScope.asSGRegNode;

  e.s = letScope.asSGRegNode;

  top.type = e.type;
}

--------------------------------------------------

nonterminal Binds with location;

attribute ok, s, lastScope occurs on Binds;

propagate ok on Binds;

synthesized attribute lastScope::SGRegNode;

production seqBindsNil
top::Binds ::=
{
  top.lastScope = top.s;
}

production seqBindsLast
top::Binds ::= s::Bind
{
  production attribute sbScope::SGLexNode = sgLexNode();
  sbScope.lex := [top.s];
  sbScope.var := s.VAR_s_def;
  sbScope.mod := [];
  sbScope.imp := [];

  s.s = top.s;
  s.s_def = sbScope.asSGRegNode;

  top.lastScope = sbScope.asSGRegNode;
}

production seqBindsCons
top::Binds ::= s::Bind ss::Binds
{
  production attribute sbScope::SGLexNode = sgLexNode();
  sbScope.lex := [top.s];
  sbScope.var := s.VAR_s_def;
  sbScope.mod := [];
  sbScope.imp := [];

  s.s = top.s;
  s.s_def = sbScope.asSGRegNode;

  ss.s = sbScope.asSGRegNode;

  top.lastScope = ss.lastScope;
}


--------------------------------------------------

nonterminal ParBinds with location;

attribute ok occurs on ParBinds;
propagate ok on ParBinds;

attribute s occurs on ParBinds;
attribute s_def, VAR_s_def occurs on ParBinds;

production parBindsNil
top::ParBinds ::=
{
  top.VAR_s_def := [];
}

production parBindsCons
top::ParBinds ::= s::Bind ss::ParBinds
{
  s.s = top.s;
  s.s_def = top.s_def;

  ss.s = top.s;
  ss.s_def = top.s_def;

  top.VAR_s_def := s.VAR_s_def ++ ss.VAR_s_def;
}

--------------------------------------------------

nonterminal Bind with location, name, type;

attribute ok occurs on Bind;
propagate ok on Bind;

attribute s occurs on Bind;
attribute s_def, VAR_s_def occurs on Bind;

production bind
top::Bind ::= id::String e::Expr
{
  production attribute varScope::SGVarNode = sgVarNode(top);
  varScope.lex := []; varScope.var := [];
  varScope.mod := []; varScope.imp := [];

  e.s = top.s;

  top.name = id;
  top.type = e.type;
  top.VAR_s_def := [varScope];
}

production bindTyped
top::Bind ::= ty::Type id::String e::Expr
{
  production attribute varScope::SGVarNode = sgVarNode(top);
  varScope.lex := []; varScope.var := [];
  varScope.mod := []; varScope.imp := [];

  e.s = top.s;

  top.name = id;
  top.type = ^ty;
  top.ok <- e.type == ^ty;
  top.VAR_s_def := [varScope];
}

production bindArgDcl
top::Bind ::= id::String ty::Type
{
  top.name = id;
  top.type = ^ty;
  top.VAR_s_def := []; -- todo
}

--------------------------------------------------

nonterminal Type;

production tFun
top::Type ::= tyann1::Type tyann2::Type
{}

production tFloat
top::Type ::=
{}

production tInt
top::Type ::=
{}

production tBool
top::Type ::=
{}

production tErr
top::Type ::=
{}

fun eqType Boolean ::= t1::Type t2::Type =
  case t1, t2 of
  | tFloat(), tFloat() -> true
  | tInt(), tInt() -> true
  | tBool(), tBool() -> true
  | tFun(t1_1, t1_2), tFun(t2_1, t2_2) -> eqType(^t1_1, ^t2_1) && eqType(^t1_2, ^t2_2)
  | tErr(), tErr() -> true
  | _, _ -> false
  end;

instance Eq Type {
  eq = eqType;
}

--------------------------------------------------

nonterminal VarRef with location;

attribute ok occurs on VarRef;
propagate ok on VarRef;

attribute s, type occurs on VarRef;

production varRef
top::VarRef ::= x::String
{
  local vars::[Decorated SGVarNode with LMInhs] =
    varQuery(
      varPredicate(x),
      top.s
    );

  local onlyVar::Maybe<Decorated Bind> =
    if length(vars) == 1 then just(head(vars).astBnd) else nothing();
  
  top.type = mapOrElse(tErr(), (.type), onlyVar);
}

--------------------------------------------------

nonterminal ModRef with location;

attribute ok occurs on ModRef;
propagate ok on ModRef;

attribute s occurs on ModRef;
attribute s_def, IMP_s_def occurs on ModRef;

production modRef
top::ModRef ::= x::String
{
  local mods::[Decorated SGModNode with LMInhs] =
    modQuery(
      modPredicate(x),
      top.s
    );

  top.IMP_s_def :=
    if length(mods) == 1 then [head(mods)] else [];
}
