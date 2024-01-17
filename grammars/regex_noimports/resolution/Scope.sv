grammar regex_noimports:resolution;


nonterminal Scope;


synthesized attribute lexScopes::[Scope] occurs on Scope;
synthesized attribute varScopes::[Scope] occurs on Scope;


abstract production mkScope
top::Scope ::=
  lex::[Scope]
  var::[Scope]
{
  top.lexScopes = lex;
  top.varScopes = var;
}