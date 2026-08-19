grammar lmr1:lmr:nameanalysis_hardcoded;

---------------
-- Map

nonterminal Map<k v>;

synthesized attribute lookup<k v>::([v] ::= k) occurs on Map<k v>;

production mapNone
Eq k =>
top::Map<k v> ::=
{
  top.lookup = \_ -> [];
}

production mapCons
Eq k =>
top::Map<k v> ::= key::k val::[v] next::Map<k v>
{
  top.lookup = 
    \key_::k -> 
      let lookupNext::[v] = next.lookup(key_) in
        if key == key_
        then val ++ lookupNext
        else lookupNext
      end;
}

production mapLast
Eq k =>
top::Map<k v> ::= key::k val::[v]
{
  top.lookup =
    \key_::k -> if key == key_ then val else [];
}

--

fun combineMap Map<k v> ::= l::Map<k v> r::Map<k v> =
  case l of
  | mapNone() -> r
  | mapLast(k, v) -> mapCons(k, v, r)
  | mapCons(k, v, next) -> mapCons(k, v, combineMap(^next, r))
  end
;
