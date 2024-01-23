grammar regex_noimports:resolution;


nonterminal Scope;


synthesized attribute lexEdges::[Decorated Scope] occurs on Scope;
synthesized attribute varEdges::[Decorated Scope] occurs on Scope;
synthesized attribute name::String occurs on Scope; 

abstract production mkScope
top::Scope ::=
  lex::[Decorated Scope]
  var::[Decorated Scope]
{
  top.lexEdges = lex;
  top.varEdges = var;
  top.name = "";
}

abstract production mkScopeNamed
top::Scope ::=
  lex::[Decorated Scope]
  var::[Decorated Scope]
  decl::Decl
{
  top.lexEdges = lex;
  top.varEdges = var;
  top.name = decl.defname;
}