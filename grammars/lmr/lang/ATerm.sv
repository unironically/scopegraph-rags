grammar lmr:lang;

{- Nonterminals -}

nonterminal Program;
nonterminal Decls;
nonterminal Decl;
nonterminal Super;
nonterminal SeqBinds;
nonterminal ParBinds;
nonterminal Bind;
nonterminal Expr;
nonterminal FldBinds;
nonterminal FldBind;
nonterminal FldDecls;
nonterminal FldDecl;
nonterminal ArgDecl;
nonterminal Type;
nonterminal ModRef;
nonterminal TypeRef;
nonterminal VarRef;

{- Attributes -}

synthesized attribute pp :: String 
  occurs on Program, Decls, Decl, Super, 
    SeqBinds, Bind, ParBinds, Expr, FldBinds, FldBind, 
    FldDecls, FldDecl, ArgDecl, Type, ModRef, TypeRef, VarRef;

inherited attribute tab::String
  occurs on Program, Decls, Decl, Super, 
    SeqBinds, Bind, ParBinds, Expr, FldBinds, FldBind, 
    FldDecls, FldDecl, ArgDecl, Type, ModRef, TypeRef, VarRef;

{- Program -}

abstract production program
top::Program ::= h::String ds::Decls
{
  top.pp = "program(\n\t\"" ++ h ++ "\",\n" ++ ds.pp ++ "\n)\n";
  ds.tab = "\t";
}

{- Decls -}

abstract production decls_list
top::Decls ::= d::Decl ds::Decls
{
  top.pp = top.tab ++ "decls_list(\n" ++ d.pp ++ ",\n" ++ ds.pp ++ "\n" ++ top.tab ++ ")";
  d.tab = top.tab ++ "\t";
  ds.tab = top.tab ++ "\t";
}

abstract production decls_empty
top::Decls ::= 
{
  top.pp = top.tab ++ "decls_empty()";
}

{- Decl -}

abstract production decl_module
top::Decl ::= x::String ds::Decls
{
  top.pp = top.tab ++ "decl_module (\n" ++ top.tab ++ "\t" ++ "\"" ++ x ++ "\",\n" ++ ds.pp ++ "\n" ++ top.tab ++ ")";
  ds.tab = top.tab ++ "\t";
}

abstract production decl_import
top::Decl ::= r::ModRef
{
  top.pp = top.tab ++ "decl_import (\n" ++ r.pp ++ "\n" ++ top.tab ++ ")";
  r.tab = top.tab ++ "\t";
}

abstract production decl_def
top::Decl ::= b::Bind
{
  top.pp = top.tab ++ "decl_def (\n" ++ b.pp ++ "\n" ++ top.tab ++ ")";
  b.tab = top.tab ++ "\t";
}

abstract production decl_rec
top::Decl ::= x::String sup::Super ds::FldDecls
{
  top.pp = top.tab ++ "decl_rec (\n" ++ top.tab ++ "\t\"" ++ x ++ "\",\n" ++ sup.pp ++ ",\n" ++ ds.pp ++ "\n" ++ top.tab ++ ")";
  sup.tab = top.tab ++ "\t";
  ds.tab = top.tab ++ "\t";
}

{- Super -}

abstract production super_none
top::Super ::=
{
  top.pp = top.tab ++ "super_none()";
}

abstract production super_some
top::Super ::= r::TypeRef
{
  top.pp = top.tab ++ "super_some()";
}

{- Seq_Binds -}

abstract production seq_binds_empty
top::SeqBinds ::=
{
  top.pp = top.tab ++ "seq_binds_empty()";
}

abstract production seq_binds_single
top::SeqBinds ::= b::Bind
{
  top.pp = top.tab ++ "seq_binds_single (\n" ++ b.pp ++ "\n" ++ top.tab ++ ")";
  b.tab = top.tab ++ "\t";
}

abstract production seq_binds_list
top::SeqBinds ::= b::Bind bs::SeqBinds
{
  top.pp = top.tab ++ "seq_binds_list(" ++ b.pp ++ ",\n" ++ bs.pp ++ "\n" ++ top.tab ++ ")";
  b.tab = top.tab ++ "\t";
  bs.tab = top.tab ++ "\t";
}

{- Bind -}

abstract production bind
top::Bind ::= x::VarRef_t e::Expr
{
  top.pp = top.tab ++ "bind (\n" ++ top.tab ++ "\t\"" ++ x.lexeme ++ "\",\n" ++ e.pp ++ "\n" ++ top.tab ++ ")";
  e.tab = top.tab ++ "\t";
}

abstract production bind_typed
top::Bind ::= x::String tyann::Type e::Expr
{
  top.pp = top.tab ++ "bind_typed (\n" ++ top.tab ++ "\t\"" ++ x ++ "\",\n" ++ tyann.pp ++ ",\n" ++ e.pp ++ "\n" ++ top.tab ++ ")";
  tyann.tab = top.tab ++ "\t";
  e.tab = top.tab ++ "\t";
}

{- Par_Binds -}

abstract production par_binds_list
top::ParBinds ::= b::Bind bs::ParBinds
{
  top.pp = top.tab ++ "par_binds_list(\n" ++ b.pp ++ ",\n" ++ bs.pp ++ "\n" ++ top.tab ++ ")";
  b.tab = top.tab ++ "\t";
  bs.tab = top.tab ++ "\t";
}

abstract production par_binds_empty
top::ParBinds ::=
{
  top.pp = top.tab ++ "par_binds_empty()";
}

{- Expr -}

abstract production expr_int
top::Expr ::= i::Integer
{
  top.pp = top.tab ++ "expr_int(\"" ++ toString (i) ++ "\")";
}

abstract production expr_bool
top::Expr ::= b::Boolean
{
  top.pp = top.tab ++ "expr_bool(" ++ toString (b) ++ ")";
}

abstract production expr_var
top::Expr ::= r::VarRef
{
  top.pp = top.tab ++ "expr_var(\n" ++ r.pp ++ "\n" ++ top.tab ++ ")";
  r.tab = top.tab ++ "\t";
}

abstract production expr_add
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = top.tab ++ "expr_add(\n" ++ e1.pp ++ ",\n" ++ e2.pp ++ "\n" ++ top.tab ++ ")";
  e1.tab = top.tab ++ "\t";
  e2.tab = top.tab ++ "\t";
}

abstract production expr_sub
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = top.tab ++ "expr_sub(\n" ++ e1.pp ++ ",\n" ++ e2.pp ++ "\n" ++ top.tab ++ ")";
  e1.tab = top.tab ++ "\t";
  e2.tab = top.tab ++ "\t";
}

abstract production expr_mul
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = top.tab ++ "expr_mul(\n" ++ e1.pp ++ ",\n" ++ e2.pp ++ "\n" ++ top.tab ++ ")";
  e1.tab = top.tab ++ "\t";
  e2.tab = top.tab ++ "\t";
}

abstract production expr_div
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = top.tab ++ "expr_div(\n" ++ e1.pp ++ ",\n" ++ e2.pp ++ "\n" ++ top.tab ++ ")";
  e1.tab = top.tab ++ "\t";
  e2.tab = top.tab ++ "\t";
}

abstract production expr_and
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = top.tab ++ "expr_and(\n" ++ e1.pp ++ ",\n" ++ e2.pp ++ "\n" ++ top.tab ++ ")";
  e1.tab = top.tab ++ "\t";
  e2.tab = top.tab ++ "\t";
}

abstract production expr_or
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = top.tab ++ "expr_or(\n" ++ e1.pp ++ ",\n" ++ e2.pp ++ "\n" ++ top.tab ++ ")";
  e1.tab = top.tab ++ "\t";
  e2.tab = top.tab ++ "\t";
}

abstract production expr_eq
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = top.tab ++ "expr_eq(\n" ++ e1.pp ++ ",\n" ++ e2.pp ++ "\n" ++ top.tab ++ ")";
  e1.tab = top.tab ++ "\t";
  e2.tab = top.tab ++ "\t";
}

abstract production expr_app
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = top.tab ++ "expr_app(\n" ++ e1.pp ++ ",\n" ++ e2.pp ++ "\n" ++ top.tab ++ ")";
  e1.tab = top.tab ++ "\t";
  e2.tab = top.tab ++ "\t";
}

abstract production expr_if
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  top.pp = top.tab ++ "expr_if(\n" ++ e1.pp ++ ",\n" ++ e2.pp ++ ",\n" ++ e3.pp ++ "\n" ++ top.tab ++ ")";
  e1.tab = top.tab ++ "\t";
  e2.tab = top.tab ++ "\t";
  e3.tab = top.tab ++ "\t";
}

abstract production expr_fun
top::Expr ::= d::ArgDecl e::Expr
{
  top.pp = top.tab ++ "expr_fun(\n" ++ d.pp ++ ",\n" ++ e.pp ++ "\n" ++ top.tab ++ ")";
  d.tab = top.tab ++ "\t";
  e.tab = top.tab ++ "\t";
}

abstract production expr_let
top::Expr ::= bs::SeqBinds e::Expr
{
  top.pp = top.tab ++ "expr_let(\n" ++ bs.pp ++ ",\n" ++ e.pp ++ "\n" ++ top.tab ++ ")";
  bs.tab = top.tab ++ "\t";
  e.tab = top.tab ++ "\t";
}

abstract production expr_letrec
top::Expr ::= bs::ParBinds e::Expr
{
  top.pp = top.tab ++ "expr_letrec(\n" ++ bs.pp ++ ",\n" ++ e.pp ++ "\n" ++ top.tab ++ ")";
  bs.tab = top.tab ++ "\t";
  e.tab = top.tab ++ "\t";
}

abstract production expr_letpar
top::Expr ::= bs::ParBinds e::Expr
{
  top.pp = top.tab ++ "expr_letpar(\n" ++ bs.pp ++ ",\n" ++ e.pp ++ "\n" ++ top.tab ++ ")";
  bs.tab = top.tab ++ "\t";
  e.tab = top.tab ++ "\t";
}

abstract production expr_new
top::Expr ::= r::TypeRef bs::FldBinds
{
  top.pp = top.tab ++ "expr_new(\n" ++ r.pp ++ ",\n" ++ bs.pp ++ "\n" ++ top.tab ++ ")";
  r.tab = top.tab ++ "\t";
  bs.tab = top.tab ++ "\t";
}

abstract production expr_fld_access
top::Expr ::= e::Expr x::String
{
  top.pp = top.tab ++ "expr_fld_access(\n" ++ e.pp ++ ",\n" ++ top.tab ++ "\n\t\"" ++ x ++ "\"\n" ++ top.tab ++ ")";
  e.tab = top.tab ++ "\t";
}

abstract production expr_with
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = top.tab ++ "expr_with(\n" ++ e1.pp ++ ",\n" ++ e2.pp ++ "\n" ++ top.tab ++ ")";
  e1.tab = top.tab ++ "\t";
  e2.tab = top.tab ++ "\t";
}

{- Fld_Binds -}

abstract production fld_binds_list
top::FldBinds ::= b::FldBind bs::FldBinds
{
  top.pp = top.tab ++ "fld_binds_list(\n" ++ b.pp ++ ",\n" ++ bs.pp ++ "\n" ++ top.tab ++ "\n" ++ top.tab ++ ")";
  b.tab = top.tab ++ "\t";
  bs.tab = top.tab ++ "\t";
}

abstract production fld_binds_empty
top::FldBinds ::=
{
  top.pp = top.tab ++ "fld_binds_empty()";
}

{- Fld_Bind -}

abstract production fld_bind
top::FldBind ::= x::String e::Expr
{
  top.pp = top.tab ++ "fld_bind(\n" ++ top.tab ++ "\t\"" ++ x ++ "\",\n" ++ e.pp ++ "\n" ++ top.tab ++ ")";
  e.tab = top.tab ++ "\t";
}

{- Fld_Decls -}

abstract production fld_decls_list
top::FldDecls ::= d::FldDecl ds::FldDecls
{
  top.pp = top.tab ++ "fld_decls_list(\n" ++ d.pp ++ ",\n" ++ ds.pp ++ "\n" ++ top.tab ++ ")";
  d.tab = top.tab ++ "\t";
  ds.tab = top.tab ++ "\t";
}

abstract production fld_decls_empty
top::FldDecls ::=
{
  top.pp = top.tab ++ "fld_decls_empty()";
}

{- Fld_Decl -}

abstract production fld_decl
top::FldDecl ::= x::String tyann::Type
{
  top.pp = top.tab ++ "fld_decl(\n" ++ top.tab ++ "\t\"" ++ x ++ "\",\n" ++ tyann.pp ++ "\n" ++ top.tab ++ ")";
  tyann.tab = top.tab ++ "\t";
}

{- Arg_Decl -}

abstract production arg_decl
top::ArgDecl ::= x::String tyann::Type
{
  top.pp = top.tab ++ "arg_decl(\n" ++ top.tab ++ "\t\"" ++ x ++ "\",\n" ++ tyann.pp ++ "\n" ++ top.tab ++ ")";
  tyann.tab = top.tab ++ "\t";
}

{- Type -}

abstract production type_int
top::Type ::= 
{
  top.pp = top.tab ++ "type_int()";
}

abstract production type_bool
top::Type ::=
{
  top.pp = top.tab ++ "type_bool()";
}

abstract production type_arrow
top::Type ::= tyann1::Type tyann2::Type
{
  top.pp = top.tab ++ "type_arrow(\n" ++ tyann1.pp ++ ",\n" ++ tyann2.pp ++ "\n" ++ top.tab ++ ")";
  tyann1.tab = top.tab ++ "\t";
  tyann2.tab = top.tab ++ "\t"; 
}

abstract production type_rec
top::Type ::= r::TypeRef
{
  top.pp = top.tab ++ "type_rec(\n" ++ r.pp ++ "\n" ++ top.tab ++ ")";
}

{- Mod_Ref -}

abstract production mod_ref_single
top::ModRef ::= x::TypeRef_t
{
  top.pp = top.tab ++ "mod_ref_single(\"" ++ x.lexeme ++ "\")";
}

abstract production mod_ref_dot
top::ModRef ::= r::ModRef x::TypeRef_t
{
  top.pp = top.tab ++ "mod_ref_dot(\n" ++ r.pp ++ ",\n" ++ top.tab ++ "\t\"" ++ x.lexeme ++ "\"\n" ++ top.tab ++ ")";
  r.tab = top.tab ++ "\t";
}

{- Type_Ref -}

abstract production type_ref_single
top::TypeRef ::= x::String
{
  top.pp = top.tab ++ "type_ref_single(\"" ++ x ++ "\")";
}

abstract production type_ref_dot
top::TypeRef ::= r::ModRef x::String
{
  top.pp = top.tab ++ "type_ref_dot(\n" ++ r.pp ++ ",\n" ++ top.tab ++ "\t\"" ++ x ++ "\"\n" ++ top.tab ++ ")";
  r.tab = top.tab ++ "\t";
}

{- Var_Ref -}

abstract production var_ref_single
top::VarRef ::= x::VarRef_t
{
  top.pp = top.tab ++ "var_ref_single(\"" ++ x.lexeme ++ "\")";
}

abstract production var_ref_dot
top::VarRef ::= r::ModRef x::VarRef_t
{
  top.pp = top.tab ++ "var_ref_dot(\n" ++ r.pp ++ ",\n" ++ top.tab ++ "\t\"" ++ x.lexeme ++ "\"\n" ++ top.tab ++ ")";
  r.tab = top.tab ++ "\t";
}