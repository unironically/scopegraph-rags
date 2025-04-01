grammar statix_translate:to_silver;

--------------------------------------------------

nonterminal AG_Type;

attribute pp occurs on AG_Type;

abstract production nameTypeAG
top::AG_Type ::= name::String
{
  top.pp = "nameTypeAG(" ++ name ++ ")";
}

abstract production listTypeAG
top::AG_Type ::= ty::AG_Type
{
  top.pp = "listTypeAG(" ++ ty.pp ++ ")";
}

abstract production tupleTypeAG
top::AG_Type ::= tys::[AG_Type]
{
  top.pp = "tupleTypeAG([" ++ implode(", ", map((.pp), tys)) ++ "])";
}

abstract production varTypeAG
top::AG_Type ::=
{
  top.pp = "varTypeAG()";
}

abstract production funTypeAG
top::AG_Type ::= l::AG_Type r::AG_Type
{
  top.pp = "funTypeAG(" ++ l.pp ++ ", " ++ r.pp ++ ")";
}