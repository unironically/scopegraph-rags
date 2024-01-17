grammar regex_noimports:resolution;
imports lmr:lang;


{- Synthesizes all of the bindings found -}
monoid attribute binds::[(VarRef, Decl)] with [], ++
  occurs on Program, Decls, Decl, ParBind, Expr, VarRef;


propagate binds on Expr, Decls;


aspect production program
top::Program ::= h::String ds::Decls
{}


aspect production decl_module
top::Decl ::= x::String ds::Decls
{}

aspect production decl_def
top::Decl ::= b::ParBind
{}


aspect production par_defbind
top::ParBind ::= x::String e::Expr
{}

aspect production par_defbind_typed
top::ParBind ::= x::String tyann::Type e::Expr
{}


aspect production var_ref_single
top::VarRef ::= x::String
{}