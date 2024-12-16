grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute termTrans::String;

attribute termTrans occurs on Term;

--------------------------------------------------

aspect production labelTerm
top::Term ::= lab::Label
{
  top.termTrans = error("labelTerm.termTrans TODO");
}

aspect production labelArgTerm
top::Term ::= lab::Label t::Term
{
  top.termTrans = error("labelArgTerm.termTrans TODO");
}

aspect production constructorTerm
top::Term ::= name::String ts::TermList
{
  top.termTrans = error("constructorTerm.termTrans TODO");
}

aspect production nameTerm
top::Term ::= name::String
{
  top.termTrans = name;
}

aspect production consTerm
top::Term ::= t1::Term t2::Term
{
  top.termTrans = error("consTerm.termTrans TODO");
}

aspect production nilTerm
top::Term ::=
{
  top.termTrans = error("nilTerm.termTrans TODO");
}

aspect production tupleTerm
top::Term ::= ts::TermList
{
  top.termTrans = error("tupleTerm.termTrans TODO");
}

aspect production stringTerm
top::Term ::= s::String
{
  top.termTrans = error("stringTerm.termTrans TODO");
}

--------------------------------------------------

aspect production termListCons
top::TermList ::= t::Term ts::TermList
{}

aspect production termListNil
top::TermList ::=
{}


--------------------------------------------------

aspect production label
top::Label ::= label::String
{}