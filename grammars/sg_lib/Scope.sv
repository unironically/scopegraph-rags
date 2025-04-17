grammar sg_lib;

--------------------------------------------------

nonterminal SGScope with location;

synthesized attribute id::Integer occurs on SGScope;
synthesized attribute datum::SGDatum occurs on SGScope;

inherited attribute lex::[Decorated SGScope] occurs on SGScope;
inherited attribute var::[Decorated SGScope] occurs on SGScope;
inherited attribute mod::[Decorated SGScope] occurs on SGScope;
inherited attribute imp::[Decorated SGScope] occurs on SGScope;

--------------------------------------------------

abstract production mkScope
top::SGScope ::=
{ forwards to mkScopeDatum(datumNone(location=top.location), 
                           location=top.location); }

abstract production mkScopeDatum
top::SGScope ::= datum::SGDatum
{
  top.id = genInt();
  top.datum = ^datum;
}

--------------------------------------------------

synthesized attribute name::String;

nonterminal SGDatum with name, location;

abstract production datum
top::SGDatum ::= name::String
{ top.name = name; }

abstract production datumNone
top::SGDatum ::= 
{ top.name = ""; }

--------------------------------------------------

{-
tgt(p,s) :- p match
  { End(x)       -> s == x
  | Edge(x,l,xs) -> tgt(xs,s)
  }.
-}
function tgt
(Boolean, Decorated SGScope) ::= p::Path
{
  return
    case p of
    | pEnd(s) -> (true, s)
    | pEdge(s, l, ps) -> tgt(^ps)
    | _ -> (false, error("tgt: sadness"))
    end;
}

{-
src(p,s) :- p match
  { End(x)       -> s == x
  | Edge(x,l,xs) -> s == x
  }.
-}
function src
(Boolean, Decorated SGScope) ::= p::Path
{
  return
    case p of
    | pEnd(s) -> (true, s)
    | pEdge(s, l, ps) -> (true, s)
    | _ -> (false, error("src: sadness"))
    end;
}

{-
datumOf(p,d) :- 
  {s} 
    tgt(p, s), 
    s -> d.
-}
function datumOf
(Boolean, SGDatum) ::= p::Path
{
  local tgtRes::(Boolean, Decorated SGScope) = tgt(^p);
  local ok1::Boolean = tgtRes.1;
  local s::Decorated SGScope = tgtRes.2;

  return (ok1, s.datum);
}

-- only(ps, p), a builtin for statix-core
-- returns `p` if `ps == [p]`
fun onlyPath
(Boolean, Path) ::= ps::[Path] =
  case ps of
  | [p] -> (true, p)
  | _   -> (false, error("onlyPath: sadness"))
  end;