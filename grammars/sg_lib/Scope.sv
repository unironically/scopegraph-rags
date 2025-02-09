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

-- nwce

function nwce_
Boolean ::= s::Decorated SGScope 
            dfa::DFA
{
  return nwceState(s, dfa.start);
}

function nwceState
Boolean ::= s::Decorated SGScope 
            state::Decorated DFAState
{
  return
    case state of
      stateVar()   -> all(map(nwceState(_, state.varT), s.var)) &&
                      all(map(nwceState(_, state.lexT), s.lex))
    | stateFinal() -> true
    | stateSink()  -> true
    | stateMod()   -> true -- ignore for now
    end;
}

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