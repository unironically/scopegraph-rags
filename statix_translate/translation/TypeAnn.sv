grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute typeTrans::String occurs on TypeAnn;

aspect production nameType
top::TypeAnn ::= name::String
{
  top.typeTrans = name;
}

aspect production listType
top::TypeAnn ::= ty::TypeAnn
{
  top.typeTrans = "[" ++ ty.typeTrans ++ "]";
}