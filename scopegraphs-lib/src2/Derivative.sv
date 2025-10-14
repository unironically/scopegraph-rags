grammar src2;

--------------------------------------------------------------------------------

-- Transform a Regex to an equivalent fully simplified one
synthesized attribute simplify<a>::Regex<a> occurs on Regex<a>;
-- Theorem 3.1 of Brzozowski (1964). Derivative with respect to a single token
synthesized attribute deriv<a>::(Regex<a> ::= Label<a>) occurs on Regex<a>;
-- Definition 3.2 of Brzozowski (1964), return epsilon if Regex contains epsilon
synthesized attribute hasEps<a>::Regex<a> occurs on Regex<a>;
-- True if epsilon is a valid string in the language of the Regex
synthesized attribute nullable::Boolean occurs on Regex<a>;
-- Compute the first set of a Regex
synthesized attribute first<a>::[Label<a>] occurs on Regex<a>;

aspect production regexLabel
top::Regex<a> ::= label::Label<a>
{
  top.hasEps = regexEmpty();
  top.deriv = \l::Label<a> -> if l.name == label.name 
                              then regexEpsilon() else regexEmpty();
  top.simplify = ^top;
  top.nullable = false;

  top.first = [^label];
}

aspect production regexEpsilon
top::Regex<a> ::=
{
  top.hasEps = regexEpsilon();
  top.deriv = \_ -> regexEmpty();
  top.simplify = ^top;
  top.nullable = true;

  top.first = [];
}

aspect production regexEmpty
top::Regex<a> ::=
{
  top.hasEps = regexEmpty();
  top.deriv = \_ -> regexEmpty();
  top.simplify = ^top;
  top.nullable = false;

  top.first = [];
}

aspect production regexCat
top::Regex<a> ::= left::Regex<a> right::Regex<a>
{
  top.hasEps = regexAnd(left.hasEps, right.hasEps);
  top.deriv = \l -> regexOr(regexCat(left.deriv(l), ^right),
                            regexCat(left.hasEps, right.deriv(l)));
  top.simplify = 
    let simpR1::Regex<a> = left.simplify in
    let simpR2::Regex<a> = right.simplify in
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

aspect production regexOr
top::Regex<a> ::= left::Regex<a> right::Regex<a>
{
  top.hasEps = regexOr(left.hasEps, right.hasEps);
  top.deriv = \l -> regexOr(left.deriv(l), right.deriv(l));
  top.simplify = 
    let simpR1::Regex<a> = left.simplify in
    let simpR2::Regex<a> = right.simplify in
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

aspect production regexAnd
top::Regex<a> ::= left::Regex<a> right::Regex<a>
{
  top.hasEps = regexAnd(left.hasEps, right.hasEps);
  top.deriv = \l -> regexAnd(left.deriv(l), right.deriv(l));
  top.simplify =
    let simpR1::Regex<a> = left.simplify in
    let simpR2::Regex<a> = right.simplify in
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
top::Regex<a> ::= sub::Regex<a>
{
  top.hasEps = regexEpsilon();
  top.deriv = \l -> regexCat(sub.deriv(l), regexStar(^sub));
  top.simplify =
    let simpR::Regex<a> = sub.simplify in 
      case simpR of
      | regexEmpty() -> regexEmpty()
      | regexEpsilon() -> regexEpsilon()
      | _ -> regexStar(simpR)
      end
    end;
  top.nullable = true;

  top.first = sub.first;
}