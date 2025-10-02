grammar lm_semantics_4:nameanalysis;


monoid attribute binds::[(String, String)] with [], ++;

synthesized attribute resolution::[SGScope];

attribute binds occurs on Main, Decls, Decl, SeqBinds, SeqBind, ParBinds,
                          ParBind, Expr, ArgDecl, VarRef, ModRef;

propagate binds on Main, Decls, Decl, SeqBinds, SeqBind, ParBinds, ParBind,
                   Expr, ArgDecl;

aspect production modRef
top::ModRef ::= name::String
{
  top.binds := 
    map ((\d::SGScope -> (name, printDecl(d))), top.resolution);
}

aspect production varRef
top::VarRef ::= name::String
{
  top.binds := 
    map ((\d::SGScope -> (name, printDecl(d))), top.resolution);
}
