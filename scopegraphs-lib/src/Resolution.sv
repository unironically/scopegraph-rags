grammar src;

-- TODO: how do we do this without the library exporting the importing language?
exports test;

--------------------------------------------------------------------------------

type Predicate = (Boolean ::= Datum);

synthesized attribute resolve::([Decorated Scope] ::= Predicate Regex);

--------------------------------------------------------------------------------

attribute resolve occurs on Scope;

aspect production scope
top::Scope ::= datum::Datum
{  
  top.resolve = \p::Predicate r::Regex ->
    case r.simplify of
    | regexEmpty() -> []
    | regexEpsilon() -> if p(^datum) then [top] else []
    | _ ->
      let validLabs::[Label] = r.first in
        concat(map(\l::Label -> 
          let stepScopes::[Decorated Scope] = l.demand(top) in
            concat(map(
              \s::Decorated Scope -> s.resolve(p, r.deriv(l.name)), 
              stepScopes
            ))
          end, 
          validLabs
        ))
      end
    end
  ;
}

--------------------------------------------------------------------------------

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
