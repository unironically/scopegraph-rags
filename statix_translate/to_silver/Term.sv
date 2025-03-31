grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_expr occurs on Term;
attribute name occurs on Term;

aspect production labelTerm
top::Term ::= lab::Label
{
  top.ag_expr = falseExpr(); -- TODO
  top.name = ""; -- TODO
}

aspect production labelArgTerm
top::Term ::= lab::Label t::Term
{
  top.ag_expr = falseExpr(); -- TODO
  top.name = ""; -- TODO
}

aspect production constructorTerm
top::Term ::= name::String ts::TermList
{
  top.ag_expr = falseExpr(); -- TODO
  top.name = ""; -- TODO
}

aspect production nameTerm
top::Term ::= name::String
{
  top.ag_expr = falseExpr(); -- TODO
  top.name = name;
}

aspect production consTerm
top::Term ::= t1::Term t2::Term
{
  top.ag_expr = falseExpr(); -- TODO
  top.name = ""; -- TODO
}

aspect production nilTerm
top::Term ::=
{
  top.ag_expr = falseExpr(); -- TODO
  top.name = ""; -- TODO
}

aspect production tupleTerm
top::Term ::= ts::TermList
{
  top.ag_expr = falseExpr(); -- TODO
  top.name = ""; -- TODO
}

aspect production stringTerm
top::Term ::= s::String
{
  top.ag_expr = falseExpr(); -- TODO
  top.name = ""; -- TODO
}


--------------------------------------------------


aspect production termListCons
top::TermList ::= t::Term ts::TermList
{}

aspect production termListNil
top::TermList ::=
{}