grammar src3;

-- TODO: how do we do this without the library exporting the importing language?
exports test;

--------------------------------------------------------------------------------

type Predicate = (Boolean ::= Datum);
type Order = [Label];

synthesized attribute resolve::([Decorated Scope] ::= Predicate Regex Order);

-- Scope:

attribute resolve occurs on Scope;

aspect production scope
top::Scope ::= datum::Datum
{
  top.resolve = \p::Predicate r::Regex orderedLabels::Order ->
    let rSimp::Regex = r.simplify in
      case r.simplify of

        -- current scope cannot be a valid resolution
      | regexEmpty() -> []

        -- no more edges to follow, but this scope is a possible resolution
        -- check whether its datum satisfies the resolution predicate (name resolution)
      | regexEpsilon() -> if p(^datum) then [top] else []

      | _ ->
        -- for every label in the set of all labels, compute Brzozowski derivative w.r.t current regex
        let derivs::[Regex] = map(r.deriv(_), orderedLabels) in
          foldl(
            \acc::([Label], [Decorated Scope]) dr::Regex ->
              -- list of possible edge labels
              let remainingLabels::[Label] = acc.1 in
                -- resolution results so far
                let accResolutions::[Decorated Scope] = acc.2 in
                  if !null(accResolutions) 
                  then acc -- resolutions in acc will shadow any more we may find
                  else (tail(remainingLabels),
                        concat(map(\s::Decorated Scope -> 
                                     s.resolve(p, dr.simplify, orderedLabels), 
                                   head(remainingLabels).demand(top))))
                end
              end,
            (orderedLabels, []),
            derivs
          ).2
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
