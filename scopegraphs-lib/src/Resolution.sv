grammar src;

--

type Predicate = (Boolean ::= Datum);
type Ordering<(i::InhSet)> = (Boolean ::= Label<i> Label<i>); --[Label<i>];

--

function resolve
[Decorated Scope with i] ::=
  p::Predicate
  r::Regex<i>
  o::Maybe<Ordering<i>>
  s::Decorated Scope with i
{
  return
    let cont::[Decorated Scope with i] =
      let validLabels::[Label<i>] = r.first in
        foldl (
          \acc::(Maybe<Label<i>>, [Decorated Scope with i]) nextLab::Label<i> ->
            let prevLab::Maybe<Label<i>> = acc.1 in
            let prevRes::[Decorated Scope with i] = acc.2 in
            let nextRes::[Decorated Scope with i] =
              concat(map(resolve(p, r.deriv(nextLab).simplify, o, _),
                         nextLab.demand(s)))
            in
              if o.isJust && prevLab.isJust && !null(nextRes)
              then  -- visibility
                if o.fromJust(nextLab, prevLab.fromJust)
                then (prevLab, nextRes)       -- nextLab < prevLab
                else (just(nextLab), prevRes) -- prevLab < nextLab
              else  -- reachability
                (just(nextLab), prevRes ++ nextRes)
            end end end,
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
}

function visible
[Decorated Scope with i] ::=
  p::Predicate
  r::Regex<i>
  o::Ordering<i>
  s::Decorated Scope with i
{ return resolve(p, ^r, just(o), s); }

function reachable
[Decorated Scope with i] ::=
  p::Predicate
  r::Regex<i>
  s::Decorated Scope with i
{ return resolve(p, ^r, nothing(), s); }