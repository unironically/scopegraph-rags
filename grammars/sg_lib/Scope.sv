grammar sg_lib;

--------------------------------------------------

nonterminal SGNode with location;

synthesized attribute id::Integer occurs on SGNode;
synthesized attribute datum::Maybe<SGDatum> occurs on SGNode;

inherited attribute lex::[Decorated SGNode] occurs on SGNode;
inherited attribute var::[Decorated SGNode] occurs on SGNode;
inherited attribute mod::[Decorated SGNode] occurs on SGNode;
inherited attribute imp::[Decorated SGNode] occurs on SGNode;

abstract production mkNode
top::SGNode ::=
  datum::Maybe<SGDatum>
{
  top.id = genInt();
  top.datum = datum;
}

--------------------------------------------------

type SGScope = SGNode;

abstract production mkScope
top::SGScope ::=
{ forwards to mkNode(nothing(), location=top.location); }

--------------------------------------------------

type SGDecl = SGNode;

--------------------------------------------------

synthesized attribute name::String;
synthesized attribute res::[Decorated SGDecl];
attribute id occurs on SGRef;

nonterminal SGRef with name, lex, res, location;

abstract production mkRefVar
top::SGRef ::= name::String
{
  top.id = genInt();

  local dfa::DFA = varRefDFA();
  top.name = name;
  top.res = dfa.decls(top, head(top.lex));
}

abstract production mkRefMod
top::SGRef ::= name::String
{
  top.id = genInt();

  local dfa::DFA = modRefDFA();
  top.name = name;
  top.res = dfa.decls(top, head(top.lex));
}

--------------------------------------------------

synthesized attribute test::(Boolean ::= Decorated SGRef);

nonterminal SGDatum with name, test, location;

--synthesized attribute str::String occurs on Datum;

abstract production datum
top::SGDatum ::= name::String
{
  top.name = name;
  top.test = \r::Decorated SGRef -> r.name == top.name;
}

{-abstract production datumId
top::Datum ::= id::String str::String
{
  top.datumId = id;
  top.nameEq = \s::String -> s == id;
  top.str = str;
}-}

{-abstract production datumMod
top::SGDatum ::= name::String
{
  top.name = name;
  top.test = \r::Ref -> r.name == top.name;
}

abstract production datumVar
top::SGDatum ::= name::String
{
  top.name = name;
  top.test = \r::Ref -> r.name == top.name;
}-}

--------------------------------------------------

function printRef
String ::= r::Decorated SGRef
{
  return r.name ++ "_" ++ 
         toString(r.location.line) ++ "_" ++ toString(r.location.column);
}