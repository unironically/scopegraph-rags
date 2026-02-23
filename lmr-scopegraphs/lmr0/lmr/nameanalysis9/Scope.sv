grammar lmr0:lmr:nameanalysis9;


---------
-- scope:

-- these three are generated:
type LMSet = {lex, var};
type LMScopeUndec = Scope<LMSet>;
type LMScope = Decorated LMScopeUndec with LMSet;

nonterminal Scope<(a::InhSet)>;

synthesized attribute datum::Datum occurs on Scope<(a::InhSet)>;

production mkScope
top::Scope<a> ::= datum::Datum
{
  top.datum = datum;
}

-- generated based on type of LMScope. differs in the arg given to mkScope.
-- since generic datum type is Either<Unit (String, Type)> it is left(()).
-- if generic datum type was Unit (i.e., no sg nodes have data), then we would
-- have mkscope(())
global blankScope::LMScope =
  decorate mkScope(noDatum()) with { lex = []; var = []; };

-------------------
-- edge attributes:

-- `edge -[ lex ]->;`:

inherited attribute lex::[Decorated Scope<LMSet>]
  occurs on Scope<(a::InhSet)>;

-- `edge -[ var ]-> data (String, Type);`:
-- the `data (String, Type)` part has no effect on this attribute, but is used
-- when selecting data off of scopes

inherited attribute var::[Decorated Scope<LMSet>]
  occurs on Scope<(a::InhSet)>;

-- generated from above var edge spec
type VarData = (String, Type);

-- generated from above var edge spec
fun collectVarData VarData ::= s::LMScope dflt::VarData =
  case s.datum of
  | var(d) -> d
  | _ -> dflt
  end;

-- generated from above var edge spec
production var
top::Datum ::= d::VarData
{
}

----------
-- labels:

production label_lex
top::Label<LMSet> ::=
{
  top.name = "lex";

  top.demand = \s::Decorated Scope<LMSet> with LMSet -> s.lex;
}

production label_var
top::Label<LMSet> ::=
{
  top.name = "var";

  top.demand = \s::Decorated Scope<LMSet> with LMSet -> s.var;
}

-------------
-- predicate:

type Predicate<(a::InhSet)> = (Boolean ::= Decorated Scope<(a::InhSet)> with a);

fun isName Predicate<LMSet> ::= name::String =
  \s::Decorated Scope<LMSet> ->
    case s.datum of
    | var((id, _)) -> id == name
    | _ -> false
    end;

-----------
-- queries:

fun resolve
[Decorated Scope<a> with a] ::= p::Predicate<a> r::Regex<a> s::Decorated Scope<a> with a
=
  let cont::[Decorated Scope<a> with a] =
    -- labels that form a prefix of a word in L(r)
    let validLabels::[Label<a>] = r.first in
      foldl (
        \acc::(Maybe<Label<a>>, [Decorated Scope<a> with a]) nextLab::Label<a> ->
          -- label followed to get the resolution in acc.2
          let prevLab::Maybe<Label<a>> = acc.1
          in
          -- resolution found by following the label in acc.1
          let prevRes::[Decorated Scope<a> with a] = acc.2
          in
          -- make a new resolution by following edges with label nextLab
          let nextRes::[Decorated Scope<a> with a] =
            concat(map(resolve(p, r.deriv(nextLab), _), nextLab.demand(s)))
          in
          (just(nextLab), prevRes ++ nextRes)
          end end end,
        (nothing(), []),
        validLabels
      ).2
    end
  in
    case r.simplify of
    | regexEmpty() -> []
    | _ -> if p(s) && r.nullable then s::cont else cont
    end
  end;

------------
-- data lib:

data nonterminal Datum;

production noDatum
top::Datum ::=
{
}

--------------
-- labels lib:

nonterminal Label<(a::InhSet)>;

synthesized attribute name::String occurs on Label<(a::InhSet)>;

synthesized attribute 
  demand<(a::InhSet)>::([Decorated Scope<a> with a] ::= Decorated Scope<a> with a)
occurs on Label<(a::InhSet)>;

instance Eq Label<a> {
  eq = \l::Label<a> r::Label<a> -> l.name == r.name;
}

---------
-- regex:

nonterminal Regex<(a::InhSet)>;

-- Transform a Regex to an equivalent fully simplified one
synthesized attribute simplify<(a::InhSet)>::Regex<a> occurs on Regex<(a::InhSet)>;
-- Theorem 3.1 of Brzozowski (1964). Derivative with respect to a single token
synthesized attribute deriv<(a::InhSet)>::(Regex<a> ::= Label<a>) occurs on Regex<(a::InhSet)>;
-- Definition 3.2 of Brzozowski (1964), return epsilon if Regex contains epsilon
synthesized attribute hasEps<(a::InhSet)>::Regex<a> occurs on Regex<(a::InhSet)>;
-- True if epsilon is a valid string in the language of the Regex
synthesized attribute nullable::Boolean occurs on Regex<(a::InhSet)>;
-- Compute first set of a Regex
synthesized attribute first<(a::InhSet)>::[Label<a>] occurs on Regex<(a::InhSet)>;

production regexLabel
top::Regex<a> ::= label::Label<a>
{
  top.hasEps = regexEmpty();
  top.deriv = \l::Label<a> -> if l.name == label.name 
                                then regexEpsilon() else regexEmpty();
  top.simplify = ^top;
  top.nullable = false;
  top.first = [^label];
}

production regexEpsilon
top::Regex<a> ::=
{
  top.hasEps = regexEpsilon();
  top.deriv = \_ -> regexEmpty();
  top.simplify = ^top;
  top.nullable = true;
  top.first = [];
}

production regexEmpty
top::Regex<a> ::=
{
  top.hasEps = regexEmpty();
  top.deriv = \_ -> regexEmpty();
  top.simplify = ^top;
  top.nullable = false;
  top.first = [];
}

production regexCat
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
  top.first = if !left.nullable then left.first else union(left.first, right.first); 
}

production regexOr
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
  top.first = union(left.first, right.first);
}

production regexAnd
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

production regexStar
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

production regexPlus
top::Regex<a> ::= sub::Regex<a>
{ forwards to regexCat(^sub, regexStar(^sub)); }

production regexMaybe
top::Regex<a> ::= sub::Regex<a>
{ forwards to regexOr(regexEpsilon(), ^sub); }
