grammar src;

-- TODO: non-strict label ordering

--

type DecScope<(i::InhSet)> = Decorated Scope with i;
type Predicate = (Boolean ::= Datum);
type Ordering<(i::InhSet)> = (Integer ::= Label<i> Label<i>);

--

fun resolve
[DecScope<i>] ::= p::Predicate r::Regex<i> o::Maybe<Ordering<i>> s::DecScope<i>
=
  let cont::[DecScope<i>] =
    let validLabels::[Label<i>] = r.first in
      foldl (
        \acc::(Maybe<Label<i>>, [DecScope<i>]) nextLab::Label<i> ->
          let prevLab::Maybe<Label<i>> = acc.1 in
          let prevRes::[DecScope<i>] = acc.2 in
          let nextRes::[DecScope<i>] =
            concat(map(resolve(p, r.deriv(nextLab).simplify, o, _),
                       nextLab.demand(s))) in
          let compare::Integer = o.fromJust(nextLab, prevLab.fromJust) in
            if o.isJust && prevLab.isJust && compare != 0 && !null(nextRes)
            then  -- visibility
              if compare < 0
              then (just(nextLab), nextRes) -- nextLab < prevLab
              else (prevLab, prevRes)       -- prevLab < nextLab
            else  -- reachability
              (just(nextLab), prevRes ++ nextRes)
          end end end end,
        (nothing(), []),
        validLabels
      ).2
    end
  in
    case r.simplify of
    | regexEmpty() -> []
    | _ -> if p(s.datum) && r.nullable then s::cont else cont
    end
  end;

fun visible
[DecScope<i>] ::= p::Predicate r::Regex<i> o::Ordering<i> s::DecScope<i>
= resolve(p, r, just(o), s);

fun reachable
[DecScope<i>] ::= p::Predicate r::Regex<i> s::DecScope<i> 
= resolve(p, r, nothing(), s);