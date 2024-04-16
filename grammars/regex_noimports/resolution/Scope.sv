grammar regex_noimports:resolution;


nonterminal Scope;

synthesized attribute lexEdge::Maybe<Decorated Scope> occurs on Scope;
synthesized attribute varEdges::[Decorated Scope] occurs on Scope;
synthesized attribute modEdges::[Decorated Scope] occurs on Scope;
synthesized attribute impEdge::Maybe<Decorated Scope> occurs on Scope;

synthesized attribute datum::Maybe<Datum> occurs on Scope;

synthesized attribute id::Integer occurs on Scope;

abstract production mkScope
top::Scope ::=
  lex::Maybe<Decorated Scope>
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::Maybe<Decorated Scope>
  datum::Maybe<Datum>
{
  top.id = genInt();
  top.lexEdge = lex;
  top.varEdges = var;
  top.modEdges = mod;
  top.impEdge = imp;
  top.datum = datum;
}

abstract production mkScopeGlobal
top::Scope ::=
  var::[Decorated Scope]
  mod::[Decorated Scope]
{
  forwards to mkScope (nothing (), var, mod, nothing (), nothing ());
}

abstract production mkScopeVar
top::Scope ::=
  decl::Decorated Bind
{
  forwards to mkScope (nothing (), [], [], nothing (), just(datumVar (decl)));
}

abstract production mkScopeMod
top::Scope ::=
  lex::Decorated Scope
  var::[Decorated Scope]
  mod::[Decorated Scope]
  decl::Decorated Decl
{
  forwards to mkScope (just(lex), var, mod, nothing (), just(datumMod (decl)));
}


nonterminal Datum;

synthesized attribute nameEq::(Boolean ::= String) occurs on Datum;

abstract production datumVar
top::Datum ::= d::Decorated Bind
{
  top.nameEq = \s::String -> s == d.defname;
}

abstract production datumMod
top::Datum ::= d::Decorated Decl
{
  top.nameEq = \s::String -> s == d.defname;
}