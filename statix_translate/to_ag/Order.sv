grammar statix_translate:to_ag;

--------------------------------------------------

synthesized attribute ag_decl::AG_Decl occurs on Order;

aspect production order
top::Order ::= name::String pathComp::PathComp
{
  top.ag_decl = globalDecl (
    name,
    funTypeAG(nameTypeAG("Label"), funTypeAG(nameTypeAG("Label"), nameTypeAG("Integer"))),
    pathComp.ag_expr
  );
}

--------------------------------------------------

attribute ag_decls occurs on Orders;

aspect production ordersCons
top::Orders ::= ord::Order ords::Orders
{
  top.ag_decls := ord.ag_decl :: ords.ag_decls;
}

aspect production ordersNil
top::Orders ::= 
{
  top.ag_decls := [];
}