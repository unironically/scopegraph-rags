grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_type occurs on TypeAnn;

aspect production nameTypeAnn
top::TypeAnn ::= name::String
{
  top.ag_type = nameTypeAG(name);
}

aspect production listTypeAnn
top::TypeAnn ::= ty::TypeAnn
{
  top.ag_type = listTypeAG(ty.ag_type);
}

aspect production setTypeAnn
top::TypeAnn ::= ty::TypeAnn
{
  top.ag_type = listTypeAG(ty.ag_type);
}

--------------------------------------------------

attribute ag_type occurs on Type;

aspect production nameType
top::Type ::= name::String
{
  top.ag_type = nameTypeAG(name);
}

aspect production listType
top::Type ::= ty::Type
{
  top.ag_type = listTypeAG(ty.ag_type);
}

aspect production setType
top::Type ::= ty::Type
{
  top.ag_type = listTypeAG(ty.ag_type);
}

aspect production tupleType
top::Type ::= tys::[Type]
{
  top.ag_type = tupleTypeAG(map((.ag_type), tys));
}

aspect production varType
top::Type ::=
{
  top.ag_type = varTypeAG();
}