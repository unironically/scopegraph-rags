grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_type occurs on TypeAnn;

aspect production nameType
top::TypeAnn ::= name::String
{
  top.ag_type = nameTypeAG(name);
}

aspect production listType
top::TypeAnn ::= ty::TypeAnn
{
  top.ag_type = listTypeAG(ty.ag_type);
}

aspect production setType
top::TypeAnn ::= ty::TypeAnn
{
  -- interpret sets as lists
  top.ag_type = listTypeAG(ty.ag_type);
}