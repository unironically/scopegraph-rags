grammar sg_lib;

--------------------------------------------------

nonterminal Scope with location;

synthesized attribute id::Integer occurs on Scope;
synthesized attribute lexEdge::Maybe<Decorated Scope> occurs on Scope;
synthesized attribute varEdges::[Decorated Scope] occurs on Scope;
synthesized attribute modEdges::[Decorated Scope] occurs on Scope;
synthesized attribute impEdges::[Decorated Scope] occurs on Scope;
synthesized attribute datum::Maybe<Datum> occurs on Scope;

abstract production mkScope
top::Scope ::=
  lex::Maybe<Decorated Scope>
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
  datum::Maybe<Datum>
{
  top.id = genInt();
  top.lexEdge = lex;
  top.varEdges = var;
  top.modEdges = mod;
  top.impEdges = imp;
  top.datum = datum;
}

--------------------------------------------------

nonterminal Datum with location;

synthesized attribute datumId::String occurs on Datum;
synthesized attribute nameEq::(Boolean ::= String) occurs on Datum;
synthesized attribute str::String occurs on Datum;

abstract production datumId
top::Datum ::= id::String str::String
{
  top.datumId = id;
  top.nameEq = \s::String -> s == id;
  top.str = str;
}

--------------------------------------------------