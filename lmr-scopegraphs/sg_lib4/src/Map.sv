grammar sg_lib4:src;

--

nonterminal Map<k v>;

synthesized attribute compare<k>::(Boolean ::= k k) occurs on Map<k v>;

synthesized attribute lookup<k v>::([v] ::= k) occurs on Map<k v>;

production mapNone
top::Map<k v> ::= compare::(Boolean ::= k k)
{
  top.compare = compare;
  
  top.lookup = \_ -> [];
}

production mapCons
top::Map<k v> ::= key::k val::v next::Map<k v>
{
  top.compare = next.compare;
  
  top.lookup = 
    \key_::k -> let lookupNext::[v] = next.lookup(key_) in
                  if top.compare(key, key_)
                  then val::lookupNext
                  else lookupNext
                end;
}

--

fun combineMap
Map<k v> ::= l::Map<k v> r::Map<k v>
=
  case l of
  | mapNone(_) -> r
  | mapCons(k, v, next) -> mapCons(k, v, combineMap(^next, r))
  end
;