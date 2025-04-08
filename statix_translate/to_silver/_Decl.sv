grammar statix_translate:to_silver;

--------------------------------------------------

nonterminal AG_Decl;

attribute pp occurs on AG_Decl;

abstract production functionDecl
top::AG_Decl ::= 
  name::String 
  retTy::AG_Type
  args::[(String, AG_Type)] 
  body::[AG_Eq]
{
  top.pp = "functionDecl(" ++
    name ++ ", " ++
    retTy.pp ++ ", " ++
    "[" ++ implode(", ", map((\p::(String, AG_Type) -> "(" ++ p.1 ++ ", " ++ p.2.pp ++ ")"), args)) ++ "], [" ++
    implode(", ", map((.pp), body)) ++
  "])";
}

abstract production globalDecl
top::AG_Decl ::=
  name::String
  ty::AG_Type
  e::AG_Expr
{
  top.pp = "globalDecl(" ++
    name ++ ", " ++
    ty.pp ++ ", " ++
    e.pp ++
  ")";
}

abstract production productionDecl
top::AG_Decl ::=
  name::String
  ty::AG_Type
  args::[(String, AG_Type)]
  body::[AG_Eq]
{
  top.pp = "productionDecl(" ++
    name ++ ", " ++
    ty.pp ++ ", " ++
    "[" ++ implode(", ", map((\p::(String, AG_Type) -> "(" ++ p.1 ++ ", " ++ p.2.pp ++ ")"), args)) ++ "], [" ++
    implode(", ", map((.pp), body)) ++
  "])";
}

abstract production nonterminalDecl
top::AG_Decl ::=
  name::String
  inhs::[(String, AG_Type)]
  syns::[(String, AG_Type)]
{
  top.pp = "nonterminalDecl(" ++
    name ++
    "[" ++ implode(", ", map(\p::(String, AG_Type) -> "(" ++ p.1 ++ "," ++ p.2.pp ++ ")", inhs)) ++ "]" ++
    "[" ++ implode(", ", map(\p::(String, AG_Type) -> "(" ++ p.1 ++ "," ++ p.2.pp ++ ")", syns)) ++ "]" ++
  ")";
}