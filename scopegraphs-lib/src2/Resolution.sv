grammar src2;

--------------------------------------------------------------------------------

type Predicate = (Boolean ::= Datum);
type Order<a> = [Label<a>];

-- Scope:

--attribute resolve<a> occurs on Scope<a>;

aspect production scope
top::Scope<a> ::= datum::Datum
{}

function resolve
attribute datum {} occurs on a =>
[a] ::=
  current::a 
  p::Predicate
  r::Regex<a>
{
  -- todo: no label ordering yet
  return 
    let cont::[a] =
    concat(map (
      \l::Label<a> -> concat(map (
                        \s::a -> resolve(s, p, r.deriv(l)),
                        l.demand(^current)
                      )),
      r.first
    ))
    in
      if p(current.datum)
      then ^current::cont
      else cont
    end;
} 

-- Regex:

nonterminal Regex<a>;

production regexLabel
top::Regex<a> ::= label::Label<a>
{}

production regexEpsilon
top::Regex<a> ::=
{}

production regexEmpty
top::Regex<a> ::=
{}

production regexCat
top::Regex<a> ::= left::Regex<a> right::Regex<a>
{}

production regexOr
top::Regex<a> ::= left::Regex<a> right::Regex<a>
{}

production regexAnd
top::Regex<a> ::= left::Regex<a> right::Regex<a>
{}

production regexStar
top::Regex<a> ::= sub::Regex<a>
{}

production regexPlus
top::Regex<a> ::= sub::Regex<a>
{ forwards to regexCat(^sub, regexStar(^sub)); }

production regexMaybe
top::Regex<a> ::= sub::Regex<a>
{ forwards to regexOr(regexEpsilon(), ^sub); }
