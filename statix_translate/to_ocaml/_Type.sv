grammar statix_translate:to_ocaml;

--------------------------------------------------

synthesized attribute ocaml_type::String occurs on AG_Type;

aspect production nameTypeAG
top::AG_Type ::= name::String
{
  top.ocaml_type = name;
}

aspect production stringTypeAG
top::AG_Type ::=
{
  top.ocaml_type = "string";
}

aspect production boolTypeAG
top::AG_Type ::=
{
  top.ocaml_type = "bool";
}

aspect production intTypeAG
top::AG_Type ::=
{
  top.ocaml_type = "integer";
}

aspect production scopeTypeAG
top::AG_Type ::=
{
  top.ocaml_type = "scope";
}

aspect production datumTypeAG
top::AG_Type ::=
{
  top.ocaml_type = "datum";
}

aspect production pathTypeAG
top::AG_Type ::=
{
  top.ocaml_type = "path";
}

aspect production labelTypeAG
top::AG_Type ::=
{
  top.ocaml_type = "label";
}

aspect production listTypeAG
top::AG_Type ::= ty::AG_Type
{
  top.ocaml_type = error("tupleTypeAG.ocaml_type");
}

aspect production tupleTypeAG
top::AG_Type ::= tys::[AG_Type]
{
  top.ocaml_type = error("tupleTypeAG.ocaml_type");
}

aspect production varTypeAG
top::AG_Type ::=
{
  top.ocaml_type = error("varTypeAG.ocaml_type");
}

aspect production funTypeAG
top::AG_Type ::= l::AG_Type r::AG_Type
{
  top.ocaml_type = error("funTypeAG.ocaml_type");
}