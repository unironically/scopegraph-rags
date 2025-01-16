grammar lm_semantics_0:nameanalysis;

monoid attribute binds::[(String, String)] with [], ++;

attribute binds occurs on Main, Decls, Decl, SeqBinds, SeqBind, ParBinds,
                          ParBind, Expr, ArgDecl, VarRef;

propagate binds on Main, Decls, Decl, SeqBinds, SeqBind, ParBinds, ParBind,
                   Expr, ArgDecl;

aspect production varRef
top::VarRef ::= name::String
{
  local refStr::String = name ++ "_" ++ toString(top.location.line) ++ 
                                 "_" ++ toString(top.location.column);
  top.binds := [(refStr, printDecl(tgt(top.p).2))];
}