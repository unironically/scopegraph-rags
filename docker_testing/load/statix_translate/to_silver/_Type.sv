grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_type::String occurs on AG_Type;
synthesized attribute nta_type::String occurs on AG_Type;

aspect production nameTypeAG
top::AG_Type ::= name::String
{
  top.silver_type = preNt ++ name;
  top.nta_type = top.silver_type;
}

aspect production stringTypeAG
top::AG_Type ::=
{
  top.silver_type = "String";
  top.nta_type = top.silver_type;
}

aspect production boolTypeAG
top::AG_Type ::=
{
  top.silver_type = "Boolean";
  top.nta_type = top.silver_type;
}

aspect production intTypeAG
top::AG_Type ::=
{
  top.silver_type = "Integer";
  top.nta_type = top.silver_type;
}

aspect production scopeTypeAG
top::AG_Type ::=
{
  top.silver_type = "Decorated Scope";
  top.nta_type = "Scope";
}

aspect production datumTypeAG
top::AG_Type ::=
{
  top.silver_type = "Decorated Datum";
  top.nta_type = "Datum";
}

aspect production pathTypeAG
top::AG_Type ::=
{
  top.silver_type = "Decorated Path";
  top.nta_type = "Path";
}

aspect production labelTypeAG
top::AG_Type ::=
{
  top.silver_type = "Label";
  top.nta_type = top.silver_type;
}

aspect production listTypeAG
top::AG_Type ::= ty::AG_Type
{
  top.silver_type = "[" ++ ty.silver_type ++ "]";
  top.nta_type = top.silver_type;
}

aspect production tupleTypeAG
top::AG_Type ::= tys::[AG_Type]
{
  top.silver_type = "(" ++ implode(", ", map((.silver_type), tys)) ++ ")";
  top.nta_type = top.silver_type;
}

aspect production funResultTypeAG
top::AG_Type ::= retTy::AG_Type
{
  top.silver_type = "FunResult<" ++ retTy.silver_type ++ ">";
  top.nta_type = top.silver_type;
}

aspect production varTypeAG
top::AG_Type ::=
{
  -- todo: remove this
  top.silver_type = "a";
  top.nta_type = top.silver_type;
}

aspect production funTypeAG
top::AG_Type ::= l::AG_Type r::AG_Type
{
  top.silver_type = "(" ++ r.silver_type ++ " ::= " ++ l.silver_type ++ ")";
  top.nta_type = top.silver_type;
}