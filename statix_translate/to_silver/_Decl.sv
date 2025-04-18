grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_decl::String occurs on AG_Decl;

aspect production functionDecl
top::AG_Decl ::= 
  name::String 
  retTy::AG_Type
  args::[(String, AG_Type)] 
  body::[AG_Eq]
{
  top.silver_decl = "function " ++ name ++ " " ++ 
    retTy.silver_type ++ " ::= " ++ 
    implode(" ", map(\arg::(String, AG_Type) -> arg.1 ++ "::" ++ 
                                                arg.2.silver_type, args)) ++ 
  "{\n\t" ++
    implode("\n\t", map((.silver_eq), body)) ++
  "}";
}

aspect production productionDecl
top::AG_Decl ::=
  name::String
  ty::AG_Type
  args::[(String, AG_Type)]
  body::[AG_Eq]
{
  top.silver_decl = "production " ++ name ++ " " ++ 
    "top::" ++ ty.silver_type ++ " ::= " ++ 
    implode(" ", map(\arg::(String, AG_Type) -> arg.1 ++ "::" ++ 
                                                arg.2.silver_type, args)) ++ 
  "{\n\t" ++
    implode("\n\t", map((.silver_eq), body)) ++ "\n" ++
  "}";
}


aspect production nonterminalDecl
top::AG_Decl ::=
  name::String
  inhs::[(String, AG_Type)]
  syns::[(String, AG_Type)]
{
  top.silver_decl = "nonterminal " ++ name ++ " with " ++
    implode(", ", 
      map(\attr::(String, AG_Type) -> attr.1, inhs++syns)) ++
  ";";
}


aspect production globalDecl
top::AG_Decl ::=
  name::String
  ty::AG_Type
  e::AG_Expr
{
  top.silver_decl = "global " ++ name ++ "::" ++ ty.silver_type ++ 
    e.silver_expr ++
  ";";
}

--------------------------------------------------

synthesized attribute silver_decls::String occurs on AG_Decls;

aspect production agDeclsCons
top::AG_Decls ::= h::AG_Decl t::AG_Decls
{
  top.silver_decls = h.silver_decl ++ "\n\n" ++ t.silver_decls;
}

aspect production agDeclsNil
top::AG_Decls ::= 
{
  top.silver_decls = "";
}

--------------------------------------------------