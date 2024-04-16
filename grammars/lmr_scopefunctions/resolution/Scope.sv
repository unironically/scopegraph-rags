grammar lmr_scopefunctions:resolution;


nonterminal Scope;


synthesized attribute lexEdges::[Decorated Scope] occurs on Scope;
synthesized attribute varEdges::[Decorated Scope] occurs on Scope;
synthesized attribute modEdges::[Decorated Scope] occurs on Scope;
synthesized attribute impEdges::[Decorated Scope] occurs on Scope;

synthesized attribute id::Integer occurs on Scope;

abstract production mkScope
top::Scope ::=
  id::Integer
  name::String
  lex::[Decorated Scope]
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
{
  top.id = id;
  top.lexEdges = lex;
  top.varEdges = var;
  top.modEdges = mod;
  top.impEdges = imp;
}

abstract production mkScopeGlobal
top::Scope ::=
  id::Integer
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
{
  forwards to mkScope (id, top.name, [], var, mod, imp);
}

abstract production mkScopeBind
top::Scope ::=
  id::Integer
  lex::[Decorated Scope]
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
  decl::Bind
{
  forwards to mkScope (id, top.name, lex, var, mod, imp);
}

abstract production mkScopeMod
top::Scope ::=
  id::Integer
  lex::[Decorated Scope]
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
  decl::Decl
{
  forwards to mkScope (id, top.name, lex, var, mod, imp);
}