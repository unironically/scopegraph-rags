grammar src;

-- TODO: how do we do this without the library exporting the importing language?
exports test;

--------------------------------------------------------------------------------

type Predicate = (Boolean ::= Datum);
type Order = (Boolean ::= Label Label);

synthesized attribute resolve::([Decorated Scope] ::= Predicate Regex Order);

-- Scope:

attribute resolve occurs on Scope;

aspect production scope
top::Scope ::= datum::Datum
{  
  top.resolve = \p::Predicate r::Regex o::Order ->
    let rSimp::Regex = r.simplify in
      case r.simplify of
      | regexEmpty() -> []
      | regexEpsilon() -> if p(^datum) then [top] else []
      | _ ->
        let validLabs::[Label] = r.first in
          let sortedLabs::[Label] = sortBy(o, validLabs) in
            foldr(
              \l::Label acc::[Decorated Scope] ->
                if !null(acc)
                then acc -- current label is shadowed
                else concat(map(\s::Decorated Scope -> 
                                  s.resolve(p, rSimp.deriv(l), o), 
                                l.demand(top))),
              [],
              sortedLabs
            )
          end
        end
      end
    end;
}

-- Regex:

nonterminal Regex;

production regexLabel
top::Regex ::= label::Label
{}

production regexEpsilon
top::Regex ::=
{}

production regexEmpty
top::Regex ::=
{}

production regexCat
top::Regex ::= left::Regex right::Regex
{}

production regexOr
top::Regex ::= left::Regex right::Regex
{}

production regexAnd
top::Regex ::= left::Regex right::Regex
{}

production regexStar
top::Regex ::= sub::Regex
{}

production regexPlus
top::Regex ::= sub::Regex
{ forwards to regexCat(^sub, regexStar(^sub)); }

production regexMaybe
top::Regex ::= sub::Regex
{ forwards to regexOr(regexEpsilon(), ^sub); }
