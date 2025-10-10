grammar sg_lib3:src;

-- TODO: how do we do this without the library exporting the importing language?
exports lmr3:lmr:nameanalysis5;

--------------------------------------------------------------------------------

type Predicate = (Boolean ::= Datum);
type Order = [Label];

synthesized attribute resolve::([Decorated Scope] ::= Predicate Regex Order);

-- Scope:

attribute resolve occurs on Scope;

aspect production scope
top::Scope ::= datum::Datum
{
  top.resolve = \p::Predicate r::Regex ord::Order ->
    let rSimp::Regex = r.simplify in
      case r.simplify of
      | regexEmpty() -> []
      | regexEpsilon() -> if p(^datum) then [top] else []
      | _ ->
        -- todo: only supports strictly greater/less than label ordering
        let derivs::[Regex] = map(r.deriv(_), ord) in
          foldl(
            \acc::([Label], [Decorated Scope]) dr::Regex ->
              if !null(acc.2) then acc else
                (tail(acc.1),
                 case dr.simplify of
                 | regexEmpty() -> []
                 | _ -> concat(map(\s::Decorated Scope -> 
                                     s.resolve(p, dr, ord), 
                                   head(acc.1).demand(top)))
                 end),
            (ord, []),
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
