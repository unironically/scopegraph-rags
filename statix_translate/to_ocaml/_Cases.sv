grammar statix_translate:to_ocaml;

--------------------------------------------------

aspect production agCasesCons
top::AG_Cases ::= c::AG_Case cs::AG_Cases
{
}

aspect production agCasesOne
top::AG_Cases ::= c::AG_Case
{
}

aspect production agCasesNil
top::AG_Cases ::=
{
}

--------------------------------------------------

aspect production agCase
top::AG_Case ::= pat::AG_Pattern wc::AG_WhereClause body::AG_Expr
{
}