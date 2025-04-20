grammar statix_translate:to_ag;

--------------------------------------------------

nonterminal AG_Type;

attribute pp occurs on AG_Type;

abstract production nameTypeAG
top::AG_Type ::= name::String
{
  top.pp = "nameTypeAG(" ++ name ++ ")";
}

abstract production stringTypeAG
top::AG_Type ::=
{
  top.pp = "stringTypeAG()";
}

abstract production intTypeAG
top::AG_Type ::=
{
  top.pp = "intTypeAG()";
}

abstract production boolTypeAG
top::AG_Type ::=
{
  top.pp = "boolTypeAG()";
}

abstract production scopeTypeAG
top::AG_Type ::=
{
  top.pp = "scopeTypeAG()";
}

abstract production datumTypeAG
top::AG_Type ::=
{
  top.pp = "datumTypeAG()";
}

abstract production pathTypeAG
top::AG_Type ::=
{
  top.pp = "pathTypeAG()";
}

abstract production labelTypeAG
top::AG_Type ::=
{
  top.pp = "labelTypeAG()";
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

abstract production funResultTypeAG
top::AG_Type ::= retTy::AG_Type
{
  top.pp = "funResultTypeAG(" ++ retTy.pp ++ ")";
}