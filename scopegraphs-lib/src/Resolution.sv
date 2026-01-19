grammar src;

--

type DecScope<(i::InhSet)> = Decorated Scope with i;
type Predicate = (Boolean ::= Decorated Datum);
type Ordering<(i::InhSet)> = (Integer ::= Label<i> Label<i>);

--

fun resolve
[DecScope<i>] ::= p::Predicate r::Regex<i> o::Maybe<Ordering<i>> s::DecScope<i>
=
  let cont::[DecScope<i>] =
    -- labels that form a prefix of a word in L(r)
    let validLabels::[Label<i>] = r.first in
      foldl (
        \acc::(Maybe<Label<i>>, [DecScope<i>]) nextLab::Label<i> ->
          -- label followed to get the resolution in acc.2
          let prevLab::Maybe<Label<i>> = acc.1
          in
          -- resolution found by following the label in acc.1
          let prevRes::[DecScope<i>] = acc.2
          in
          -- make a new resolution by following edges with label nextLab
          let nextRes::[DecScope<i>] =
            concat(map(resolve(p, r.deriv(nextLab), o, _),
                       nextLab.demand(s)))
          in
          -- use function o to compare nextLab with the previous
          -- if -1, resolutions found by following edges of nextLab shadow previous resolutions
          -- if  0, combine results of following edges of label nextLab with previous results
          -- if  1, resolutions found by following edges of prevLab shadow those by following nextLab
          let compare::Integer = o.fromJust(nextLab, prevLab.fromJust)
          in
            -- if there is an ordering, a previous resolution, comparison is not 0, and new resolution is nonempty
            if o.isJust && prevLab.isJust && compare != 0 && !null(nextRes)
            then  -- visibility
              if compare < 0
              then (just(nextLab), nextRes) -- nextLab < prevLab
              else (prevLab, prevRes)       -- nextLab > nextLab
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