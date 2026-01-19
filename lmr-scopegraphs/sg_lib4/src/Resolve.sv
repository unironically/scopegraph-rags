grammar sg_lib4:src;

--

type Predicate = (Boolean ::= Datum);

--

fun resolve
[Decorated Scope] ::= p::Predicate r::Regex s::Decorated Scope
=
  let cont::[Decorated Scope] =
    let validLabels::[Label] = r.first in
      foldl(
        \acc::(Maybe<Label>, [Decorated Scope]) nextLab::Label ->
          let prevLab::Maybe<Label> = acc.1 in
            let prevRes::[Decorated Scope] = acc.2 in
              let nextRes::[Decorated Scope] = concat(map(resolve(p, r.deriv(nextLab), _), nextLab.demand(s))) in
                (just(nextLab), prevRes ++ nextRes)
              end
            end
          end,
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