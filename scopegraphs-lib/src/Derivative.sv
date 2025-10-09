grammar src;

--------------------------------------------------------------------------------

-- Transform a Regex to an equivalent fully simplified one
synthesized attribute simplify::Regex occurs on Regex;
-- Theorem 3.1 of Brzozowski (1964). Derivative with respect to a single token
synthesized attribute deriv::(Regex ::= String) occurs on Regex;
-- Definition 3.2 of Brzozowski (1964), return epsilon if Regex contains epsilon
synthesized attribute hasEps::Regex occurs on Regex;
-- True if epsilon is a valid string in the language of the Regex
synthesized attribute nullable::Boolean occurs on Regex;

synthesized attribute first::[Label] occurs on Regex;

aspect production regexLabel
top::Regex ::= label::Label
{
  top.hasEps = regexEmpty();
  top.deriv = \l -> if l == label.name then regexEpsilon() else regexEmpty();
  top.simplify = ^top;
  top.nullable = false;

  top.first = [^label];
}

aspect production regexEpsilon
top::Regex ::=
{
  top.hasEps = regexEpsilon();
  top.deriv = \_ -> regexEmpty();
  top.simplify = ^top;
  top.nullable = true;

  top.first = [];
}

aspect production regexEmpty
top::Regex ::=
{
  top.hasEps = regexEmpty();
  top.deriv = \_ -> regexEmpty();
  top.simplify = ^top;
  top.nullable = false;

  top.first = [];
}

aspect production regexCat
top::Regex ::= left::Regex right::Regex
{
  top.hasEps = regexAnd(left.hasEps, right.hasEps);
  top.deriv = \l -> regexOr(regexCat(left.deriv(l), ^right),
                            regexCat(left.hasEps, right.deriv(l)));
  top.simplify = 
    let simpR1::Regex = left.simplify in
    let simpR2::Regex = right.simplify in
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

  top.first = if left.nullable then left.first ++ right.first else left.first;
}

aspect production regexOr
top::Regex ::= left::Regex right::Regex
{
  top.hasEps = regexOr(left.hasEps, right.hasEps);
  top.deriv = \l -> regexOr(left.deriv(l), right.deriv(l));
  top.simplify = 
    let simpR1::Regex = left.simplify in
    let simpR2::Regex = right.simplify in
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

  top.first = left.first ++ right.first;
}

aspect production regexAnd
top::Regex ::= left::Regex right::Regex
{
  top.hasEps = regexAnd(left.hasEps, right.hasEps);
  top.deriv = \l -> regexAnd(left.deriv(l), right.deriv(l));
  top.simplify =
    let simpR1::Regex = left.simplify in
    let simpR2::Regex = right.simplify in
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

aspect production regexStar
top::Regex ::= sub::Regex
{
  top.hasEps = regexEpsilon();
  top.deriv = \l -> regexCat(sub.deriv(l), regexStar(^sub));
  top.simplify =
    let simpR::Regex = sub.simplify in 
      case simpR of
      | regexEmpty() -> regexEmpty()
      | regexEpsilon() -> regexEpsilon()
      | _ -> regexStar(simpR)
      end
    end;
  top.nullable = true;

  top.first = sub.first;
}