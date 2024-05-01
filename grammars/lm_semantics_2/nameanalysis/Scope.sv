grammar lm_semantics_2:nameanalysis;

nonterminal Scope with location;

synthesized attribute lexEdge::Maybe<Decorated Scope> occurs on Scope;
synthesized attribute varEdges::[Decorated Scope] occurs on Scope;
synthesized attribute datum::Maybe<Datum> occurs on Scope;
synthesized attribute id::Integer occurs on Scope;

abstract production mkScope
top::Scope ::=
  lex::Maybe<Decorated Scope>
  var::[Decorated Scope]
  datum::Maybe<Datum>
{
  top.id = genInt();
  top.lexEdge = lex;
  top.varEdges = var;
  top.datum = datum;
}

abstract production mkScopeLet
top::Scope ::=
  lex::Decorated Scope
  var::[Decorated Scope]
{
  forwards to mkScope (just (lex), var, nothing (), location=top.location);
}

abstract production mkScopeGlobal
top::Scope ::=
  var::[Decorated Scope]
{
  forwards to mkScope (nothing (), var, nothing (), location=top.location);
}


abstract production mkScopeVar
top::Scope ::=
  datum::(String, Type)
{
  forwards to mkScope (nothing (), [], just(datumVar (fst(datum), snd(datum), location=top.location)), location=top.location);
}

abstract production mkScopeSeqBind
top::Scope ::=
  lex::Decorated Scope
  var::[Decorated Scope]
{
  forwards to mkScope (just(lex), var, nothing(), location=top.location);
}

--------------------------------------------------

nonterminal Datum with datumId, datumTy, nameEq, location;

synthesized attribute datumId::String;
synthesized attribute datumTy::Type;
synthesized attribute nameEq::(Boolean ::= String);

abstract production datumVar
top::Datum ::= id::String ty::Type
{
  top.datumId = id;
  top.datumTy = ty;
  top.nameEq = \s::String -> s == id;
}