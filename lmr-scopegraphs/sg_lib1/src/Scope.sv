grammar sg_lib1:src;

--------------------------------------------------

nonterminal Scope;

synthesized attribute datum::Datum occurs on Scope;

inherited attribute lex::[Decorated Scope] occurs on Scope;
inherited attribute var::[Decorated Scope] occurs on Scope;
inherited attribute mod::[Decorated Scope] occurs on Scope;
inherited attribute imp::[Decorated Scope] occurs on Scope;

--------------------------------------------------

abstract production scope
top::Scope ::= datum::Datum
{
  top.datum = ^datum;
}

--------------------------------------------------

synthesized attribute name::String;

nonterminal Datum with name;

abstract production datum
top::Datum ::= name::String
{ top.name = name; }

abstract production datumNone
top::Datum ::= 
{ top.name = ""; }
