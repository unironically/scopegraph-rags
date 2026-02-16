grammar lmr3:lmr:nameanalysis_extension0;

imports syntax:lmr1:lmr:abstractsyntax;

import silver:langutil; -- for location.unparse

--

-- these attributes are not generated
monoid attribute ok::Boolean with true, &&;
synthesized attribute type::Type;

{- `scope attribute LMGraph:s;` generates:
 - The below inherited and monoid attributes
-}

inherited attribute s::Decorated Scope with LMGraph;
monoid attribute s_lex::[Decorated Scope with LMGraph] with [], ++;
monoid attribute s_var::[Decorated Scope with LMGraph] with [], ++;
monoid attribute s_mod::[Decorated Scope with LMGraph] with [], ++;
monoid attribute s_imp::[Decorated Scope with LMGraph] with [], ++;

{- `scope attribute LMGraph:s_def;` generates:
 - The below inherited and monoid attributes
-}

inherited attribute s_def::Decorated Scope with LMGraph;
monoid attribute s_def_lex::[Decorated Scope with LMGraph] with [], ++;
monoid attribute s_def_var::[Decorated Scope with LMGraph] with [], ++;
monoid attribute s_def_mod::[Decorated Scope with LMGraph] with [], ++;
monoid attribute s_def_imp::[Decorated Scope with LMGraph] with [], ++;

--

attribute ok occurs on Main;
propagate ok on Main;

aspect production program
top::Main ::= ds::Decls
{
  -- generated from `mkScope glob -> datumLex();`
  local glob::Scope = scope(datumLex());
  glob.lex = glob_lex;
  glob.var = glob_var;
  glob.mod = glob_mod;
  glob.imp = glob_imp;

  -- generated
  production attribute glob_lex::[Decorated Scope with LMGraph] with ++;
  production attribute glob_var::[Decorated Scope with LMGraph] with ++;
  production attribute glob_mod::[Decorated Scope with LMGraph] with ++;
  production attribute glob_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  glob_lex := [];
  glob_var := [];
  glob_mod := [];
  glob_imp := [];

  -- not generated
  ds.s = glob;

  -- generated from `ds.s = glob;`
  glob_lex <- ds.s_lex;
  glob_var <- ds.s_var;
  glob_mod <- ds.s_mod;
  glob_imp <- ds.s_imp;
}

--

attribute ok, s, s_lex, s_var, s_mod, s_imp occurs on Decls;
propagate ok on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  d.s = top.s;

  -- generated from `d.s = top.s;`
  top.s_lex <- d.s_lex;
  top.s_var <- d.s_var;
  top.s_mod <- d.s_mod;
  top.s_imp <- d.s_imp;

  -- not generated
  ds.s = top.s;

  -- generated from `ds.s = top.s;`
  top.s_lex <- ds.s_lex;
  top.s_var <- ds.s_var;
  top.s_mod <- ds.s_mod;
  top.s_imp <- ds.s_imp;
}

aspect production declsNil
top::Decls ::=
{
  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];
}

--

attribute s, s_lex, s_var, s_mod, s_imp occurs on Decl;

attribute ok occurs on Decl;
propagate ok on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  -- generated from `mkScope mod -> datumMod(id);`
  local mod::Scope = scope(datumMod(id));
  mod.lex = mod_lex;
  mod.var = mod_var;
  mod.mod = mod_mod;
  mod.imp = mod_imp;

  -- generated
  production attribute mod_lex::[Decorated Scope with LMGraph] with ++;
  production attribute mod_var::[Decorated Scope with LMGraph] with ++;
  production attribute mod_mod::[Decorated Scope with LMGraph] with ++;
  production attribute mod_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  mod_lex := [];
  mod_var := [];
  mod_mod := [];
  mod_imp := [];

  -- not generated
  ds.s = mod;

  -- generated from `ds.s = mod;`
  mod_lex <- ds.s_lex;
  mod_var <- ds.s_var;
  mod_mod <- ds.s_mod;
  mod_imp <- ds.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated from `mod -[ lex ]-> top.s;`
  mod_lex <- [top.s];

  -- generated from `top.s -[ mod ]-> mod;
  top.s_mod <- [mod];
}

aspect production declImport
top::Decl ::= r::ModRef
{
  -- not generated
  r.s = top.s;

  -- generated from `r.s = top.s;`
  top.s_lex <- r.s_lex;
  top.s_var <- r.s_var;
  top.s_mod <- r.s_mod;
  top.s_imp <- r.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];
}

aspect production declDef
top::Decl ::= b::ParBind
{
  -- not generated
  b.s = top.s;

  -- generated from `b.s = top.s;`
  top.s_lex <- b.s_lex;
  top.s_var <- b.s_var;
  top.s_mod <- b.s_mod;
  top.s_imp <- b.s_imp;

  -- not generated
  b.s_def = top.s;

  -- generated from `b.s_def = top.s;`
  top.s_lex <- b.s_def_lex;
  top.s_var <- b.s_def_var;
  top.s_mod <- b.s_def_mod;
  top.s_imp <- b.s_def_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];
}

--

attribute s, s_lex, s_var, s_mod, s_imp occurs on Expr;

attribute type occurs on Expr;
attribute ok occurs on Expr;

propagate ok on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.type = tInt();
}

aspect production exprTrue
top::Expr ::=
{
  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.type = tBool();
}

aspect production exprFalse
top::Expr ::=
{
  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.type = tBool();
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  -- not generated
  r.s = top.s;

  -- generated from `r.s = top.s;`
  top.s_lex <- r.s_lex;
  top.s_var <- r.s_var;
  top.s_mod <- r.s_mod;
  top.s_imp <- r.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.type = r.type;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  -- not generated
  e1.s = top.s;

  -- generated from `e1.s = top.s;`
  top.s_lex <- e1.s_lex;
  top.s_var <- e1.s_var;
  top.s_mod <- e1.s_mod;
  top.s_imp <- e1.s_imp;

  -- not generated
  e2.s = top.s;

  -- generated from `e2.s = top.s;`
  top.s_lex <- e2.s_lex;
  top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod;
  top.s_imp <- e2.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.ok <- e1.type == tInt();
  top.ok <- e2.type == tInt();

  -- not generated
  top.type = if top.ok then tInt() else tErr();
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  -- not generated
  e1.s = top.s;

  -- generated from `e1.s = top.s;`
  top.s_lex <- e1.s_lex;
  top.s_var <- e1.s_var;
  top.s_mod <- e1.s_mod;
  top.s_imp <- e1.s_imp;

  -- not generated
  e2.s = top.s;

  -- generated from `e2.s = top.s;`
  top.s_lex <- e2.s_lex;
  top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod;
  top.s_imp <- e2.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.ok <- e1.type == tInt();
  top.ok <- e2.type == tInt();

  -- not generated
  top.type = if top.ok then tInt() else tErr();
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  -- not generated
  e1.s = top.s;

  -- generated from `e1.s = top.s;`
  top.s_lex <- e1.s_lex;
  top.s_var <- e1.s_var;
  top.s_mod <- e1.s_mod;
  top.s_imp <- e1.s_imp;

  -- not generated
  e2.s = top.s;

  -- generated from `e2.s = top.s;`
  top.s_lex <- e2.s_lex;
  top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod;
  top.s_imp <- e2.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.ok <- e1.type == tInt();
  top.ok <- e2.type == tInt();

  -- not generated
  top.type = if top.ok then tInt() else tErr();
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  -- not generated
  e1.s = top.s;

  -- generated from `e1.s = top.s;`
  top.s_lex <- e1.s_lex;
  top.s_var <- e1.s_var;
  top.s_mod <- e1.s_mod;
  top.s_imp <- e1.s_imp;

  -- not generated
  e2.s = top.s;

  -- generated from `e2.s = top.s;`
  top.s_lex <- e2.s_lex;
  top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod;
  top.s_imp <- e2.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.ok <- e1.type == tInt();
  top.ok <- e2.type == tInt();

  -- not generated
  top.type = if top.ok then tInt() else tErr();
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  -- not generated
  e1.s = top.s;

  -- generated from `e1.s = top.s;`
  top.s_lex <- e1.s_lex;
  top.s_var <- e1.s_var;
  top.s_mod <- e1.s_mod;
  top.s_imp <- e1.s_imp;

  -- not generated
  e2.s = top.s;

  -- generated from `e2.s = top.s;`
  top.s_lex <- e2.s_lex;
  top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod;
  top.s_imp <- e2.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.ok <- e1.type == tBool();
  top.ok <- e2.type == tBool();

  -- not generated
  top.type = if top.ok then tBool() else tErr();
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  -- not generated
  e1.s = top.s;

  -- generated from `e1.s = top.s;`
  top.s_lex <- e1.s_lex;
  top.s_var <- e1.s_var;
  top.s_mod <- e1.s_mod;
  top.s_imp <- e1.s_imp;

  -- not generated
  e2.s = top.s;

  -- generated from `e2.s = top.s;`
  top.s_lex <- e2.s_lex;
  top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod;
  top.s_imp <- e2.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.ok <- e1.type == tBool();
  top.ok <- e2.type == tBool();

  -- not generated
  top.type = if top.ok then tBool() else tErr();
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  -- not generated
  e1.s = top.s;

  -- generated from `e1.s = top.s;`
  top.s_lex <- e1.s_lex;
  top.s_var <- e1.s_var;
  top.s_mod <- e1.s_mod;
  top.s_imp <- e1.s_imp;

  -- not generated
  e2.s = top.s;

  -- generated from `e2.s = top.s;`
  top.s_lex <- e2.s_lex;
  top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod;
  top.s_imp <- e2.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.ok <- e1.type == e2.type;

  -- not generated
  top.type = if top.ok then tBool() else tErr();
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  -- not generated
  e1.s = top.s;

  -- generated from `e1.s = top.s;`
  top.s_lex <- e1.s_lex;
  top.s_var <- e1.s_var;
  top.s_mod <- e1.s_mod;
  top.s_imp <- e1.s_imp;

  -- not generated
  e2.s = top.s;

  -- generated from `e2.s = top.s;`
  top.s_lex <- e2.s_lex;
  top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod;
  top.s_imp <- e2.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  local okAndTy::(Boolean, Type) =
    case e1.type of
    | tFun(t1, t2) when ^t1 == e2.type -> (true, ^t2)
    | _ -> (false, tErr())
    end;

  -- not generated
  top.ok <- okAndTy.1;

  -- not generated
  top.type = okAndTy.2;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  -- not generated
  e1.s = top.s;

  -- generated from `e1.s = top.s;`
  top.s_lex <- e1.s_lex;
  top.s_var <- e1.s_var;
  top.s_mod <- e1.s_mod;
  top.s_imp <- e1.s_imp;

  -- not generated
  e2.s = top.s;

  -- generated from `e2.s = top.s;`
  top.s_lex <- e2.s_lex;
  top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod;
  top.s_imp <- e2.s_imp;

  -- not generated
  e3.s = top.s;

  -- generated from `ee.s = top.s;`
  top.s_lex <- e3.s_lex;
  top.s_var <- e3.s_var;
  top.s_mod <- e3.s_mod;
  top.s_imp <- e3.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  local okAndTy::(Boolean, Type) =
    case e1.type of
    | tFun(t1, t2) when ^t1 == e2.type -> (true, ^t2)
    | _ -> (false, tErr())
    end;

  -- not generated
  top.ok <- e1.type == tBool() && e2.type == e3.type;

  -- not generated
  top.type = if top.ok then e2.type else tErr();
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  -- generated from `mkScope bodyScope -> datumLex();`
  local bodyScope::Scope = scope(datumLex());
  bodyScope.lex = bodyScope_lex;
  bodyScope.var = bodyScope_var;
  bodyScope.mod = bodyScope_mod;
  bodyScope.imp = bodyScope_imp;

  -- generated
  production attribute bodyScope_lex::[Decorated Scope with LMGraph] with ++;
  production attribute bodyScope_var::[Decorated Scope with LMGraph] with ++;
  production attribute bodyScope_mod::[Decorated Scope with LMGraph] with ++;
  production attribute bodyScope_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  bodyScope_lex := [];
  bodyScope_var := [];
  bodyScope_mod := [];
  bodyScope_imp := [];

  -- not generated
  d.s = top.s;

  -- generated from `d.s = top.s;`
  top.s_lex <- d.s_lex;
  top.s_var <- d.s_var;
  top.s_mod <- d.s_mod;
  top.s_imp <- d.s_imp;

  -- not generated
  e.s = bodyScope;

  -- generated from e.s = bodyScope;`
  bodyScope_lex <- e.s_lex;
  bodyScope_var <- e.s_var;
  bodyScope_mod <- e.s_mod;
  bodyScope_imp <- e.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated from `bodyScope -[ lex ]-> top.s;`
  bodyScope_lex <- [top.s];

  -- not generated
  top.type = tFun(d.type, e.type);
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  -- generated from `mkScope lastScope -> datumLex();`
  local lastScope::Scope = scope(datumLex());
  lastScope.lex = lastScope_lex;
  lastScope.var = lastScope_var;
  lastScope.mod = lastScope_mod;
  lastScope.imp = lastScope_imp;

  -- generated
  production attribute lastScope_lex::[Decorated Scope with LMGraph] with ++;
  production attribute lastScope_var::[Decorated Scope with LMGraph] with ++;
  production attribute lastScope_mod::[Decorated Scope with LMGraph] with ++;
  production attribute lastScope_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  lastScope_lex := [];
  lastScope_var := [];
  lastScope_mod := [];
  lastScope_imp := [];

  -- not generated
  bs.s = top.s;

  -- generated from `bs.s = top.s;`
  top.s_lex <- bs.s_lex;
  top.s_var <- bs.s_var;
  top.s_mod <- bs.s_mod;
  top.s_imp <- bs.s_imp;

  -- not generated
  bs.s_def = lastScope;

  -- generated from `bs.s_def = lastScope;`
  lastScope_lex <- bs.s_def_lex;
  lastScope_var <- bs.s_def_var;
  lastScope_mod <- bs.s_def_mod;
  lastScope_imp <- bs.s_def_imp;

  -- not generated
  e.s = lastScope;

  -- generated from `e.s = lastScope;`
  lastScope_lex <- e.s_lex;
  lastScope_var <- e.s_var;
  lastScope_mod <- e.s_mod;
  lastScope_imp <- e.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.type = e.type;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  -- generated from `mkScope letScope -> datumLex();`
  local letScope::Scope = scope(datumLex());
  letScope.lex = letScope_lex;
  letScope.var = letScope_var;
  letScope.mod = letScope_mod;
  letScope.imp = letScope_imp;

  -- generated
  production attribute letScope_lex::[Decorated Scope with LMGraph] with ++;
  production attribute letScope_var::[Decorated Scope with LMGraph] with ++;
  production attribute letScope_mod::[Decorated Scope with LMGraph] with ++;
  production attribute letScope_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  letScope_lex := [];
  letScope_var := [];
  letScope_mod := [];
  letScope_imp := [];

  -- not generated
  bs.s = letScope;

  -- generated from `bs.s = top.s;`
  letScope_lex <- bs.s_lex;
  letScope_var <- bs.s_var;
  letScope_mod <- bs.s_mod;
  letScope_imp <- bs.s_imp;

  -- not generated
  bs.s_def = letScope;

  -- generated from `bs.s_def = letScope;`
  letScope_lex <- bs.s_def_lex;
  letScope_var <- bs.s_def_var;
  letScope_mod <- bs.s_def_mod;
  letScope_imp <- bs.s_def_imp;

  -- not generated
  e.s = letScope;

  -- generated from `e.s = letScope;`
  letScope_lex <- e.s_lex;
  letScope_var <- e.s_var;
  letScope_mod <- e.s_mod;
  letScope_imp <- e.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated from `letScope -[ lex ]-> top.s;`
  letScope_lex <- [top.s];

  -- not generated
  top.type = e.type;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  -- generated from `mkScope letScope -> datumLex();`
  local letScope::Scope = scope(datumLex());
  letScope.lex = letScope_lex;
  letScope.var = letScope_var;
  letScope.mod = letScope_mod;
  letScope.imp = letScope_imp;

  -- generated
  production attribute letScope_lex::[Decorated Scope with LMGraph] with ++;
  production attribute letScope_var::[Decorated Scope with LMGraph] with ++;
  production attribute letScope_mod::[Decorated Scope with LMGraph] with ++;
  production attribute letScope_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  letScope_lex := [];
  letScope_var := [];
  letScope_mod := [];
  letScope_imp := [];

  -- not generated
  bs.s = letScope;

  -- generated from `bs.s = top.s;`
  letScope_lex <- bs.s_lex;
  letScope_var <- bs.s_var;
  letScope_mod <- bs.s_mod;
  letScope_imp <- bs.s_imp;

  -- not generated
  bs.s_def = letScope;

  -- generated from `bs.s_def = letScope;`
  letScope_lex <- bs.s_def_lex;
  letScope_var <- bs.s_def_var;
  letScope_mod <- bs.s_def_mod;
  letScope_imp <- bs.s_def_imp;

  -- not generated
  e.s = top.s;

  -- generated from `e.s = top.s;`
  top.s_lex <- e.s_lex;
  top.s_var <- e.s_var;
  top.s_mod <- e.s_mod;
  top.s_imp <- e.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated from `letScope -[ lex ]-> top.s;`
  letScope_lex <- [top.s];

  -- not generated
  top.type = e.type;
}

--

attribute s, s_lex, s_var, s_mod, s_imp occurs on SeqBinds;
attribute s_def, s_def_lex, s_def_var, s_def_mod, s_def_imp occurs on SeqBinds;

attribute ok occurs on SeqBinds;
propagate ok on SeqBinds;

aspect production seqBindsNil
top::SeqBinds ::=
{
  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated
  top.s_def_lex := [];
  top.s_def_var := [];
  top.s_def_mod := [];
  top.s_def_imp := [];

  -- generated from `top.s_def -[ lex ]-> top.s;`
  top.s_def_lex <- [top.s];
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  -- not generated
  s.s = top.s;

  -- generated from `s.s = top.s;`
  top.s_lex <- s.s_lex;
  top.s_var <- s.s_var;
  top.s_mod <- s.s_mod;
  top.s_imp <- s.s_imp;

  -- not generated
  s.s_def = top.s_def;

  -- generated from `s.s_def = top.s_def;`
  top.s_def_lex <- s.s_def_lex;
  top.s_def_var <- s.s_def_var;
  top.s_def_mod <- s.s_def_mod;
  top.s_def_imp <- s.s_def_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated
  top.s_def_lex := [];
  top.s_def_var := [];
  top.s_def_mod := [];
  top.s_def_imp := [];

  -- generated from `top.s_def -[ lex ]-> top.s`
  top.s_def_lex <- [top.s];
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  -- generated from `mkScope nextScope -> datumLex();`
  local nextScope::Scope = scope(datumLex());
  nextScope.lex = nextScope_lex;
  nextScope.var = nextScope_var;
  nextScope.mod = nextScope_mod;
  nextScope.imp = nextScope_imp;

  -- generated
  production attribute nextScope_lex::[Decorated Scope with LMGraph] with ++;
  production attribute nextScope_var::[Decorated Scope with LMGraph] with ++;
  production attribute nextScope_mod::[Decorated Scope with LMGraph] with ++;
  production attribute nextScope_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  nextScope_lex := [];
  nextScope_var := [];
  nextScope_mod := [];
  nextScope_imp := [];

  -- not generated
  s.s = top.s;

  -- genertated from `s.s = top.s;`
  top.s_lex <- s.s_lex;
  top.s_var <- s.s_var;
  top.s_mod <- s.s_mod;
  top.s_imp <- s.s_imp;

  -- not generated
  s.s_def = nextScope;

  -- generated from `s.s_def = nextScope;`
  nextScope_lex <- s.s_def_lex;
  nextScope_var <- s.s_def_var;
  nextScope_mod <- s.s_def_mod;
  nextScope_imp <- s.s_def_imp;

  ss.s = nextScope;

  -- generated from `ss.s = nextScope;`
  nextScope_lex <- ss.s_lex;
  nextScope_var <- ss.s_var;
  nextScope_mod <- ss.s_mod;
  nextScope_imp <- ss.s_imp;

  ss.s_def = top.s_def;

  -- generated from `ss.s_def = top.s_def;`
  top.s_def_lex <- ss.s_def_lex;
  top.s_def_var <- ss.s_def_var;
  top.s_def_mod <- ss.s_def_mod;
  top.s_def_imp <- ss.s_def_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated
  top.s_def_lex := [];
  top.s_def_var := [];
  top.s_def_mod := [];
  top.s_def_imp := [];

  -- generated from `nextScope -[ lex ]-> top.s`
  nextScope_lex <- [top.s];
}

--

attribute s, s_lex, s_var, s_mod, s_imp occurs on SeqBind;
attribute s_def, s_def_lex, s_def_var, s_def_mod, s_def_imp occurs on SeqBind;

attribute ok occurs on SeqBind;
propagate ok on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  -- generated from `mkScope varScope -> datumVar(id, e.type);`
  local varScope::Scope = scope(datumVar(id, e.type));
  varScope.lex = varScope_lex;
  varScope.var = varScope_var;
  varScope.mod = varScope_mod;
  varScope.imp = varScope_imp;

  -- generated
  production attribute varScope_lex::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_var::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_mod::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  varScope_lex := [];
  varScope_var := [];
  varScope_mod := [];
  varScope_imp := [];

  -- not generated
  e.s = top.s;

  -- generated from `e.s = top.s;`
  top.s_lex <- e.s_lex;
  top.s_var <- e.s_var;
  top.s_mod <- e.s_mod;
  top.s_imp <- e.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated
  top.s_def_lex := [];
  top.s_def_var := [];
  top.s_def_mod := [];
  top.s_def_imp := [];

  -- generated from `top.s_def -[ var ]-> varScope;`
  top.s_def_var <- [varScope];
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  -- generated from `mkScope varScope -> datumVar(id, ^ty);`
  local varScope::Scope = scope(datumVar(id, ^ty));
  varScope.lex = varScope_lex;
  varScope.var = varScope_var;
  varScope.mod = varScope_mod;
  varScope.imp = varScope_imp;

  -- generated
  production attribute varScope_lex::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_var::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_mod::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  varScope_lex := [];
  varScope_var := [];
  varScope_mod := [];
  varScope_imp := [];

  -- not generated
  e.s = top.s;

  -- generated from `e.s = top.s;`
  top.s_lex <- e.s_lex;
  top.s_var <- e.s_var;
  top.s_mod <- e.s_mod;
  top.s_imp <- e.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated
  top.s_def_lex := [];
  top.s_def_var := [];
  top.s_def_mod := [];
  top.s_def_imp := [];

  -- generated from `top.s_def -[ var ]-> varScope;`
  top.s_def_var <- [varScope];
}

--

attribute s, s_lex, s_var, s_mod, s_imp occurs on ParBinds;
attribute s_def, s_def_lex, s_def_var, s_def_mod, s_def_imp occurs on ParBinds;

attribute ok occurs on ParBinds;
propagate ok on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated
  top.s_def_lex := [];
  top.s_def_var := [];
  top.s_def_mod := [];
  top.s_def_imp := [];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  -- not generated
  s.s = top.s;

  -- generated from `s.s = top.s;`
  top.s_lex <- s.s_lex;
  top.s_var <- s.s_var;
  top.s_mod <- s.s_mod;
  top.s_imp <- s.s_imp;
  
  -- not generated
  s.s_def = top.s_def;

  -- generated from `s.s_def = top.s_def;`
  top.s_def_lex <- s.s_def_lex;
  top.s_def_var <- s.s_def_var;
  top.s_def_mod <- s.s_def_mod;
  top.s_def_imp <- s.s_def_imp;

  -- not generated
  ss.s = top.s;

  -- generated from `ss.s = top.s;`
  top.s_lex <- ss.s_lex;
  top.s_var <- ss.s_var;
  top.s_mod <- ss.s_mod;
  top.s_imp <- ss.s_imp;

  -- not generated
  ss.s_def = top.s_def;

  -- generated from `ss.s_def = top.s_def;`
  top.s_def_lex <- ss.s_def_lex;
  top.s_def_var <- ss.s_def_var;
  top.s_def_mod <- ss.s_def_mod;
  top.s_def_imp <- ss.s_def_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated
  top.s_def_lex := [];
  top.s_def_var := [];
  top.s_def_mod := [];
  top.s_def_imp := [];
}

--

attribute s, s_lex, s_var, s_mod, s_imp occurs on ParBind;
attribute s_def, s_def_lex, s_def_var, s_def_mod, s_def_imp occurs on ParBind;

attribute ok occurs on ParBind;
propagate ok on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  -- generated from `mkScope varScope -> datumVar(id, e.type);`
  local varScope::Scope = scope(datumVar(id, e.type));
  varScope.lex = varScope_lex;
  varScope.var = varScope_var;
  varScope.mod = varScope_mod;
  varScope.imp = varScope_imp;

  -- generated
  production attribute varScope_lex::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_var::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_mod::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  varScope_lex := [];
  varScope_var := [];
  varScope_mod := [];
  varScope_imp := [];

  -- not generated
  e.s = top.s;

  -- generated from `e.s = top.s;`
  top.s_lex <- e.s_lex;
  top.s_var <- e.s_var;
  top.s_mod <- e.s_mod;
  top.s_imp <- e.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated
  top.s_def_lex := [];
  top.s_def_var := [];
  top.s_def_mod := [];
  top.s_def_imp := [];

  -- generated from `top.s_def -[ var ]-> varScope;`
  top.s_def_var <- [varScope];
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  -- generated from `mkScope varScope -> datumVar(id, ^ty);`
  local varScope::Scope = scope(datumVar(id, ^ty));
  varScope.lex = varScope_lex;
  varScope.var = varScope_var;
  varScope.mod = varScope_mod;
  varScope.imp = varScope_imp;

  -- generated
  production attribute varScope_lex::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_var::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_mod::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  varScope_lex := [];
  varScope_var := [];
  varScope_mod := [];
  varScope_imp := [];

  -- not generated
  e.s = top.s;

  -- generated from `e.s = top.s;`
  top.s_lex <- e.s_lex;
  top.s_var <- e.s_var;
  top.s_mod <- e.s_mod;
  top.s_imp <- e.s_imp;

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated
  top.s_def_lex := [];
  top.s_def_var := [];
  top.s_def_mod := [];
  top.s_def_imp := [];

  -- generated from `top.s_def -[ var ]-> varScope;`
  top.s_def_var <- [varScope];
}

--

attribute s, s_lex, s_var, s_mod, s_imp occurs on ArgDecl;
attribute ok, type occurs on ArgDecl;
propagate ok on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String tyann::Type
{
  -- generated from `mkScope varScope -> datumVar(id, ^tyann);`
  local varScope::Scope = scope(datumVar(id, ^tyann));
  varScope.lex = varScope_lex;
  varScope.var = varScope_var;
  varScope.mod = varScope_mod;
  varScope.imp = varScope_imp;

  -- generated
  production attribute varScope_lex::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_var::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_mod::[Decorated Scope with LMGraph] with ++;
  production attribute varScope_imp::[Decorated Scope with LMGraph] with ++;

  -- generated
  varScope_lex := [];
  varScope_var := [];
  varScope_mod := [];
  varScope_imp := [];

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated from `top.s -[ var ]-> varScope;`
  top.s_var <- [varScope];

  -- not generated
  top.type = ^tyann;
}


--

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{}

aspect production tInt
top::Type ::=
{}

aspect production tBool
top::Type ::=
{}

aspect production tErr
top::Type ::=
{}

--

attribute s, s_lex, s_var, s_mod, s_imp occurs on VarRef;
attribute ok, type occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  -- not generated(?)
  local vars::[Decorated Scope with LMGraph] =
    visible(varPredicate(x), lmVarRx, lmOrd, top.s);

  -- not generated
  local okAndRes::(Boolean, Type) = 
    if length(vars) < 1
    then unsafeTracePrint((false, tErr()), "[✗] " ++ top.location.unparse ++ 
                          ": error: unresolvable variable reference '" ++ x ++ "'\n")
    else if length(vars) > 1
    then unsafeTracePrint((false, tErr()), "[✗] " ++ top.location.unparse ++ 
                          ": error: ambiguous variable reference '" ++ x ++ "'\n")
    else case head(vars).datum of
         | datumVar(_, ty) -> (true, ^ty)
         | _ -> (false, tErr())
         end; 

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- not generated
  top.ok := okAndRes.1;
  top.type = okAndRes.2;
}

--

attribute s, s_lex, s_var, s_mod, s_imp occurs on ModRef;
attribute ok occurs on ModRef;

aspect production modRef
top::ModRef ::= x::String
{
  -- not generated(?)
  local mods::[Decorated Scope with LMGraph] =
    visible(modPredicate(x), lmModRx, lmOrd, top.s);

  -- not generated
  local okAndRes::(Boolean, Decorated Scope with LMGraph) = 
    if length(mods) < 1
    then unsafeTracePrint((false, blankScope), "[✗] " ++ top.location.unparse ++ 
                          ": error: unresolvable module reference '" ++ x ++ "'\n")
    else if length(mods) > 1
    then unsafeTracePrint((false, blankScope), "[✗] " ++ top.location.unparse ++ 
                          ": error: ambiguous module reference '" ++ x ++ "'\n")
    else case head(mods).datum of
         | datumMod(_) -> (true, head(mods))
         | _ -> (false, blankScope)
         end; 

  -- generated
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  -- generated from `top.s -[ imp ]-> okAndRes.2;`
  top.s_imp <- [okAndRes.2];

  -- not generated
  top.ok := okAndRes.1;
}