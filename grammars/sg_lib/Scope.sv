grammar sg_lib;

--------------------------------------------------

nonterminal SGNode with location;

synthesized attribute id::Integer occurs on SGNode;
inherited attribute datum::SGDatum occurs on SGNode;

inherited attribute lex::[Decorated SGNode] occurs on SGNode;
inherited attribute var::[Decorated SGNode] occurs on SGNode;
inherited attribute mod::[Decorated SGNode] occurs on SGNode;
inherited attribute imp::[Decorated SGNode] occurs on SGNode;

abstract production mkNode
top::SGNode ::=
{ top.id = genInt(); }

--------------------------------------------------

type SGScope = SGNode;

abstract production mkScope
top::SGScope ::=
{ forwards to mkNode(location=top.location); }


--------------------------------------------------

--synthesized attribute test::(Boolean ::= Decorated SGRef);

synthesized attribute name::String;

nonterminal SGDatum with name, location; --, test;

abstract production datum
top::SGDatum ::= name::String
{
  top.name = name;
  --top.test = \r::Decorated SGRef -> r.name == top.name;
}

abstract production datumNone
top::SGDatum ::= 
{
  top.name = "";
  --top.test = \r::Decorated SGRef -> false;
}

--------------------------------------------------

function tgt
(Boolean, Decorated SGScope) ::= p::Path
{
  return
    case p of
    | pEnd(s) -> (true, s)
    | pEdge(s, l, ps) -> tgt(^ps) -- QUESTION: why need ^ here?
    | pBad() -> (false, error("sadness"))
    end;
}

function src
(Boolean, Decorated SGScope) ::= p::Path
{
  return
    case p of
    | pEnd(s) -> (true, s)
    | pEdge(s, l, ps) -> (true, s)
    | pBad() -> (false, error("sadness"))
    end;
}

function datumOf
(Boolean, SGDatum) ::= p::Path
{
  local pair1::(Boolean, Decorated SGScope) = tgt(^p); -- QUESTION: why need ^ here?
  local ok1::Boolean = pair1.1;
  local s::Decorated SGScope = pair1.2;

  return (ok1, s.datum);
}