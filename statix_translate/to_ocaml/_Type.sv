grammar statix_translate:to_ocaml;

--------------------------------------------------

aspect production nameTypeAG
top::AG_Type ::= name::String
{
}

aspect production listTypeAG
top::AG_Type ::= ty::AG_Type
{
}

aspect production tupleTypeAG
top::AG_Type ::= tys::[AG_Type]
{
}

aspect production varTypeAG
top::AG_Type ::=
{
}

aspect production funTypeAG
top::AG_Type ::= l::AG_Type r::AG_Type
{
}