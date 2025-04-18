grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_type::String occurs on AG_Type;

aspect production nameTypeAG
top::AG_Type ::= name::String
{
  top.silver_type = name;
}

aspect production listTypeAG
top::AG_Type ::= ty::AG_Type
{
  top.silver_type = "[" ++ ty.silver_type ++ "]";
}

aspect production tupleTypeAG
top::AG_Type ::= tys::[AG_Type]
{
  top.silver_type = "(" ++ implode(", ", map((.silver_type), tys)) ++ ")";
}

aspect production varTypeAG
top::AG_Type ::=
{
  -- todo: remove this
  top.silver_type = "a";
}

aspect production funTypeAG
top::AG_Type ::= l::AG_Type r::AG_Type
{
  top.silver_type = "(" ++ r.silver_type ++ " ::= " ++ l.silver_type ++ ")";
}