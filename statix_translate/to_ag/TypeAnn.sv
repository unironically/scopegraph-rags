grammar statix_translate:to_ag;

--------------------------------------------------

attribute ag_type occurs on TypeAnn;

aspect production nameTypeAnn
top::TypeAnn ::= name::String
{
  top.ag_type = nameTypeAG(name);
}

aspect production stringType
top::Type ::=
{
  top.ag_type = stringTypeAG();
}

aspect production boolType
top::Type ::=
{
  top.ag_type = boolTypeAG();
}

aspect production scopeType
top::Type ::=
{
  top.ag_type = scopeTypeAG();
}

aspect production datumType
top::Type ::=
{
  top.ag_type = datumTypeAG();
}

aspect production labelType
top::Type ::=
{
  top.ag_type = labelTypeAG();
}

aspect production pathType
top::Type ::=
{
  top.ag_type = pathTypeAG();
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