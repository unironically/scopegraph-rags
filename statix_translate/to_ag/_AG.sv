grammar statix_translate:to_ag;

--------------------------------------------------

nonterminal AG;

synthesized attribute nts::AG_Decls occurs on AG;
synthesized attribute globs::AG_Decls occurs on AG;
synthesized attribute prods::AG_Decls occurs on AG;
synthesized attribute funs::AG_Decls occurs on AG;

abstract production ag
top::AG ::= 
  nts::AG_Decls
  globs::AG_Decls
  prods::AG_Decls
  funs::AG_Decls
{
  top.nts   = ^nts;
  top.globs = ^globs;
  top.prods = ^prods;
  top.funs  = ^funs;
}