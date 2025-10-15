grammar src3;

{-

  works when this definition is replaced with "null":
  https://github.com/melt-umn/silver/blob/467f9e0f019834268a816f6e54579fec48d86e22/grammars/silver/compiler/translation/java/type/Type.sv#L168

-}

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
  -- todo: order
  return
    let rest::[Decorated Scope with i] = 
      let allowedLabs::[Label<i>] = r.first in
        concat(map (
          \l::Label<i> ->
            let deriv::Regex<i> = r.deriv(l).simplify in
              let allowedScopes::[Decorated Scope with i] = l.demand(s) in
                concat(map(\s::Decorated Scope with i -> resolve(s, p, deriv, o),
                    allowedScopes))
              end
            end,
          allowedLabs
        ))
      end
    in
      if p(s.datum)
      then s::rest
      else rest
    end;
}