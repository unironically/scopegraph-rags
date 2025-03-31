grammar statix_translate:to_silver;

--------------------------------------------------

nonterminal AG_Decl;

abstract production functionDecl
top::AG_Decl ::= 
  name::String 
  retTy::AG_Type
  args::[(String, AG_Type)] 
  body::[AG_Eq]
{}