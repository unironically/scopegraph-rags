grammar src;

--

type Predicate = (Boolean ::= Datum);
type Ordering<(i::InhSet)> = [Label<i>];

--

function resolve
[Decorated Scope with i] ::=
  p::Predicate
  r::Regex<i>
  o::Ordering<i>
  s::Decorated Scope with i
{
  return
    let cont::[Decorated Scope with i] =
      let derivs::[Regex<i>] = map(r.deriv(_), o) in
        foldl (
          \acc::([Label<i>], [Decorated Scope with i]) dr::Regex<i> ->
            let remainingLabels::[Label<i>] = acc.1 in
            let accResolutions::[Decorated Scope with i] = acc.2 in
              if !null(accResolutions)
              then acc -- acc will shadow any more resolutions we may find
              else (tail(remainingLabels),
                    concat(map(resolve(p, dr.simplify, o, _), 
                              head(remainingLabels).demand(s))))
            end end,
          (o, []),
          derivs
        ).2
      end
    in
      case r.simplify of
      | regexEmpty() -> []
      | _ -> if p(s.datum) && r.nullable then s::cont else cont
      end
    end;
}