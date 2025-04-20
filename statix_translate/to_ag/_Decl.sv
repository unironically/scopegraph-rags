grammar statix_translate:to_ag;

--------------------------------------------------

nonterminal AG_Decl;

attribute pp occurs on AG_Decl;

attribute name occurs on AG_Decl;

abstract production functionDecl
top::AG_Decl ::= 
  name::String 
  retTy::AG_Type
  args::[(String, AG_Type)] 
  body::[AG_Eq]
{
  top.name = name;
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
  top.name = name;
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
  top.name = name;
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
  top.name = name;
  top.pp = "nonterminalDecl(" ++
    name ++ ", " ++
    "[" ++ implode(", ", map(\p::(String, AG_Type) -> "(" ++ p.1 ++ "," ++ p.2.pp ++ ")", inhs)) ++ "], " ++
    "[" ++ implode(", ", map(\p::(String, AG_Type) -> "(" ++ p.1 ++ "," ++ p.2.pp ++ ")", syns)) ++ "]" ++
  ")";
}

--------------------------------------------------

nonterminal AG_Decls;

abstract production agDeclsCons
top::AG_Decls ::= h::AG_Decl t::AG_Decls
{}

abstract production agDeclsNil
top::AG_Decls ::= 
{}

abstract production agDeclsOne
top::AG_Decls ::= h::AG_Decl
{ forwards to agDeclsCons(^h, agDeclsNil()); }

--------------------------------------------------

function agDeclsCat
AG_Decls ::= l::AG_Decls r::AG_Decls
{
  return
    case l of
    | agDeclsCons(h, t) -> if agDeclsContains(h.name, ^r)
                           then agDeclsCat(^t, ^r)
                           else agDeclsCons(^h, agDeclsCat(^t, ^r))
    | agDeclsNil() -> ^r
    end;
}

function agDeclsContains
Boolean ::= name::String l::AG_Decls
{
  return
    case l of
    | agDeclsNil() -> false
    | agDeclsOne(d) -> d.name == name
    | agDeclsCons(h, t) -> h.name == name || agDeclsContains(name, ^t)
    end;
}

function agAttrsUnion
[(String, AG_Type)] ::= l::[(String, AG_Type)] r::[(String, AG_Type)]
{
  return 
    unionBy(
      \lAttr::(String, AG_Type) rAttr::(String, AG_Type) -> lAttr.1 == rAttr.1,
      l, 
      r
    );
}