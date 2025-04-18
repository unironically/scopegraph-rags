grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_ag::String occurs on AG;

aspect production ag
top::AG ::= 
  nts::AG_Decls
  globs::AG_Decls
  prods::AG_Decls
  funs::AG_Decls
{
  top.silver_ag = 
    nts.silver_decls ++ globs.silver_decls ++ 
    prods.silver_decls ++ funs.silver_decls;
}

--------------------------------------------------