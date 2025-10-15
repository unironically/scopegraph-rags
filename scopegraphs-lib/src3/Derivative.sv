grammar src3;

--------------------------------------------------------------------------------

nonterminal Regex<(i::InhSet)>;

-- Transform a Regex to an equivalent fully simplified one
synthesized attribute simplify<(i::InhSet)>::Regex<(i::InhSet)> occurs on Regex<(i::InhSet)>;
-- Theorem 3.1 of Brzozowski (1964). Derivative with respect to a single token
synthesized attribute deriv<(i::InhSet)>::(Regex<i> ::= Label<i>) occurs on Regex<(i::InhSet)>;
-- Definition 3.2 of Brzozowski (1964), return epsilon if Regex contains epsilon
synthesized attribute hasEps<(i::InhSet)>::Regex<i> occurs on Regex<(i::InhSet)>;
-- True if epsilon is a valid string in the language of the Regex
synthesized attribute nullable::Boolean occurs on Regex<(i::InhSet)>;
-- Compute the first set of a Regex
synthesized attribute first<(i::InhSet)>::[Label<i>] occurs on Regex<(i::InhSet)>;

production regexLabel
top::Regex<(i::InhSet)> ::= label::Label<(i::InhSet)>
{
  top.hasEps = regexEmpty();
  top.deriv = \l::Label<i> -> if l.name == label.name 
                              then regexEpsilon() else regexEmpty();
  top.simplify = ^top;
  top.nullable = false;

  top.first = [^label];
}

production regexEpsilon
top::Regex<(i::InhSet)> ::=
{
  top.hasEps = regexEpsilon();
  top.deriv = \_ -> regexEmpty();
  top.simplify = ^top;
  top.nullable = true;

  top.first = [];
}

production regexEmpty
top::Regex<(i::InhSet)> ::=
{
  top.hasEps = regexEmpty();
  top.deriv = \_ -> regexEmpty();
  top.simplify = ^top;
  top.nullable = false;

  top.first = [];
}

production regexCat
top::Regex<(i::InhSet)> ::= left::Regex<i> right::Regex<i>
{
  top.hasEps = regexAnd(left.hasEps, right.hasEps);
  top.deriv = \l -> regexOr(regexCat(left.deriv(l), ^right),
                            regexCat(left.hasEps, right.deriv(l)));
  top.simplify = 
    let simpR1::Regex<i> = left.simplify in
    let simpR2::Regex<i> = right.simplify in
      case (simpR1, simpR2) of
      | (regexEmpty(), _) -> regexEmpty()
      | (_, regexEmpty()) -> regexEmpty()
      | (regexEpsilon(), regexEpsilon()) -> regexEpsilon()
      | (regexEpsilon(), _) -> simpR2
      | (_, regexEpsilon()) -> simpR1
      | (_, _) -> regexCat(simpR1, simpR2)
      end
    end end;
  top.nullable = left.nullable && right.nullable;

  top.first = nub(if left.nullable 
                  then left.first ++ right.first 
                  else left.first);
}

production regexOr
top::Regex<(i::InhSet)> ::= left::Regex<i> right::Regex<i>
{
  top.hasEps = regexOr(left.hasEps, right.hasEps);
  top.deriv = \l -> regexOr(left.deriv(l), right.deriv(l));
  top.simplify = 
    let simpR1::Regex<i> = left.simplify in
    let simpR2::Regex<i> = right.simplify in
      case (simpR1, simpR2) of
      | (regexEmpty(), _) -> simpR2
      | (_, regexEmpty()) -> simpR1
      | (regexEpsilon(), regexEpsilon()) -> regexEpsilon()
      | (regexEpsilon(), _) -> regexOr(regexEpsilon(), simpR2)
      | (_, regexEpsilon()) -> regexOr(simpR1, regexEpsilon())
      | (_, _) -> regexOr(simpR1, simpR2)
      end
    end end;
  top.nullable = left.nullable || right.nullable;

  top.first = nub(left.first ++ right.first);
}

production regexAnd
top::Regex<(i::InhSet)> ::= left::Regex<i> right::Regex<i>
{
  top.hasEps = regexAnd(left.hasEps, right.hasEps);
  top.deriv = \l -> regexAnd(left.deriv(l), right.deriv(l));
  top.simplify =
    let simpR1::Regex<i> = left.simplify in
    let simpR2::Regex<i> = right.simplify in
      case (simpR1, simpR2) of
      | (regexEmpty(), _) -> regexEmpty()
      | (_ , regexEmpty()) -> regexEmpty()
      | (regexEpsilon(), sub) -> if sub.nullable then regexEpsilon() else regexEmpty()
      | (sub, regexEpsilon()) -> if sub.nullable then regexEpsilon() else regexEmpty()
      | (_, _) -> regexAnd(simpR1, simpR2)
      end
    end end;
  top.nullable = left.nullable && right.nullable;

  top.first = intersect(left.first, right.first);
}

production regexStar
top::Regex<(i::InhSet)> ::= sub::Regex<i>
{
  top.hasEps = regexEpsilon();
  top.deriv = \l -> regexCat(sub.deriv(l), regexStar(^sub));
  top.simplify =
    let simpR::Regex<i> = sub.simplify in 
      case simpR of
      | regexEmpty() -> regexEmpty()
      | regexEpsilon() -> regexEpsilon()
      | _ -> regexStar(simpR)
      end
    end;
  top.nullable = true;

  top.first = sub.first;
}

production regexPlus
top::Regex<(i::InhSet)> ::= sub::Regex<i>
{ forwards to regexCat(^sub, regexStar(^sub)); }

production regexMaybe
top::Regex<(i::InhSet)> ::= sub::Regex<i>
{ forwards to regexOr(regexEpsilon(), ^sub); }
