grammar src3;

-- TODO: how do we do this without the library exporting the importing language?
--exports test;

--------------------------------------------------------------------------------

type Predicate = (Boolean ::= Datum);
type Order<(i::InhSet)> = [Label<i>];

-- Resolution function:

function resolve
[Decorated Scope with i] ::=
  s::Decorated Scope with i
  p::Predicate
  r::Regex<i>
  o::Order<i>
{
  return [];
}