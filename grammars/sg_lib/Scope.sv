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


production nwce
FunResult<Boolean> ::= 
  rx::Regex
  s::Decorated SGScope 
{
  top.ret =
    case rx of
    | emptySet() -> true
    | epsilon()  -> case s.datum of _ -> true end
    | _          -> all(map(nwce(rx.deriv("LEX"), _), s.lex).ret).ret &&
                    all(map(nwce(rx.deriv("IMP"), _), s.imp).ret).ret &&
                    all(map(nwce(rx.deriv("VAR"), _), s.var).ret).ret &&
                    all(map(nwce(rx.deriv("MOD"), _), s.mod).ret).ret
    end;
  top.ok = top.ret;
}


{-
nwce :: Regex -> Scope -> Bool

nwce \emptyset _ = true
nwce \epsilon  s = case s.datum of _ -> true end
nwce rx        s = all . map (nwce (deriv "LEX" rx)) s.lex &&
                   all . map (nwce (deriv "VAR" rx)) s.var &&
                   all . map (nwce (deriv "IMP" rx)) s.imp &&
                   all . map (nwce (deriv "MOD" rx)) s.mod
-}


{-
nwce :: Regex -> Scope -> Bool

nwce \emptyset _ = true
nwce \epsilon s  = demand s.datum; true
nwce rx s        = \forall l \in \mathcal{L} .
                     \forall s' in s.l .
                       nwce(s', deriv l rx)

                 -- or --

                 = \forall s' in s.lex . nwce(s', deriv LEX rx) &&
                   \forall s' in s.imp . nwce(s', deriv IMP rx) &&
                   \forall s' in s.var . nwce(s', deriv VAR rx) &&
                   \forall s' in s.mod . nwce(s', deriv MOD rx)
-}


{-
nwce(_, \emptyset).
nwce(s, \epsilon) :- demand s.datum
nwce(s, rx) :- ?
-}



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