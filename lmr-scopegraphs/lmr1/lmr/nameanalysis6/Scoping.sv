grammar lmr1:lmr:nameanalysis6;

imports syntax:lmr1:lmr:abstractsyntax;

--------------------------------------------------

inherited attribute s::Decorated Region;
monoid attribute s_lex::[Decorated Region] with [], ++;
monoid attribute s_var::[Decorated Var] with [], ++;
monoid attribute s_mod::[Decorated Mod] with [], ++;
monoid attribute s_imp::[Decorated Mod] with [], ++;

monoid attribute ok::Boolean with true, &&;

--------------------------------------------------

attribute ok occurs on Main;
propagate ok on Main;

aspect production program
top::Main ::= ds::Decls
{
  local glob::Lex = mkLex();
  glob.lex = ds.s_lex;
  glob.var = ds.s_var;
  glob.mod = ds.s_mod;
  glob.imp = ds.s_imp;

  ds.s = asRegion(glob);
  ds.s = glob; -- overload?
}

--------------------------------------------------

attribute ok, s, s_lex, s_var, s_mod, s_imp occurs on Decls;
propagate ok, s, s_lex, s_var, s_mod, s_imp on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
}

aspect production declsNil
top::Decls ::=
{
}

--------------------------------------------------

attribute ok, s, s_lex, s_var, s_mod, s_imp occurs on Decl;
propagate ok on Decl;

aspect production declModule
top::Decl ::= id::String ds::Decls
{
  local modScope::Mod = mkMod(id, 0);
  modScope.lex = ds.s_lex;
  modScope.var = ds.s_var;
  modScope.mod = ds.s_mod;
  modScope.imp = ds.s_imp;

  ds.s = asRegion(modScope);

  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [modScope];
  top.s_imp := [];
}

aspect production declImport
top::Decl ::= r::ModRef
{
  r.s = top.s;

  top.s_lex := r.s_lex;
  top.s_var := r.s_var;
  top.s_mod := r.s_mod;
  top.s_imp := r.s_imp;
}

aspect production declDef
top::Decl ::= b::ParBind
{
  b.s = top.s;

  top.s_lex := b.s_lex;
  top.s_var := b.s_var;
  top.s_mod := b.s_mod;
  top.s_imp := b.s_imp;
}

--------------------------------------------------

attribute ok, s, s_lex, s_var, s_mod, s_imp, type occurs on Expr;
propagate ok on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{
  top.type = tInt();
}

aspect production exprTrue
top::Expr ::=
{
  top.type = tBool();
}

aspect production exprFalse
top::Expr ::=
{
  top.type = tBool();
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  top.type = r.type;
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Lex = mkLex();
  letScope.lex = [top.s] ++ bs.s_lex ++ e.s_lex;
  letScope.var = bs.s_var ++ e.s_var;
  letScope.mod = bs.s_mod ++ e.s_mod;
  letScope.imp = bs.s_imp ++ e.s_imp;

  top.type = e.type;
}

--------------------------------------------------

attribute ok, s, s_lex, s_var, s_mod, s_imp occurs on ParBinds;
propagate ok on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];
}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{
  s.s = top.s;
  ss.s = top.s;

  top.s_lex := s.s_lex ++ ss.s_lex;
  top.s_var := s.s_var ++ ss.s_var;
  top.s_mod := s.s_mod ++ ss.s_mod;
  top.s_imp := s.s_imp ++ ss.s_imp;
}

--------------------------------------------------

attribute ok, s, s_lex, s_var, s_mod, s_imp occurs on ParBind;
propagate ok on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local varScope::Var = mkVar(id, e.type);
  varScope.lex = [];
  varScope.var = [];
  varScope.mod = [];
  varScope.imp = [];

  e.s = top.s;

  top.s_lex := [];
  top.s_var := [varScope];
  top.s_mod := [];
  top.s_imp := [];
}

--------------------------------------------------

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

--------------------------------------------------

attribute ok, s_lex, s_var, s_mod, s_imp, type occurs on VarRef;
propagate ok on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  top.type = tInt();
}

--------------------------------------------------

attribute ok, s, s_lex, s_var, s_mod, s_imp occurs on ModRef;
propagate ok on ModRef;

aspect production modRef
top::ModRef ::= x::String
{

  local res::[Decorated Dcl] = query(..., lex*(mod|var), ...);

  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];
}
