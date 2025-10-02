grammar statix_translate:to_ag;

--------------------------------------------------

attribute ag_globals occurs on Order;

aspect production order
top::Order ::= name::String pathComp::PathComp
{
  top.ag_globals := agDeclsOne(globalDecl (
    name,
    funTypeAG(labelTypeAG(), funTypeAG(labelTypeAG(), intTypeAG())),
    pathComp.ag_expr
  ));
}

--------------------------------------------------

attribute ag_globals occurs on Orders;
propagate ag_globals on Orders;

aspect production ordersCons
top::Orders ::= ord::Order ords::Orders
{}

aspect production ordersNil
top::Orders ::= 
{}