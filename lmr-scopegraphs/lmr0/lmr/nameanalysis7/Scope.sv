grammar lmr0:lmr:nameanalysis7;


---------
-- scope:

-- these three are generated:
type LMSet = {lex, var};
type LMScopeUndec = Scope<LMSet Either<Unit (String, Type)>>;
type LMScope = Decorated LMScopeUndec with LMSet;

nonterminal Scope<(a::InhSet) b>;

synthesized attribute datum<b>::b occurs on Scope<(a::InhSet) b>;

production mkScope
top::Scope<a b> ::= datum::b
{
  top.datum = datum;
}

-- generated based on type of LMScope. differs in the arg given to mkScope.
-- since generic datum type is Either<Unit (String, Type)> it is left(()).
-- if generic datum type was Unit (i.e., no sg nodes have data), then we would
-- have mkscope(())
global blankScope::LMScope =
  decorate mkScope(left(())) with { lex = []; var = []; };

-------------------
-- edge attributes:

-- `edge -[ lex ]->;`:

inherited attribute lex<b>::[Decorated Scope<LMSet b>]
  occurs on Scope<(a::InhSet) b>;

-- `edge -[ var ]-> data (String, Type);`:
-- the `data (String, Type)` part has no effect on this attribute, but is used
-- when selecting data off of scopes

inherited attribute var<b>::[Decorated Scope<LMSet b>]
  occurs on Scope<(a::InhSet) b>;

-- generated from above var edge spec
type VarData = (String, Type);

-- generated from above var edge spec
fun collectVarData VarData ::= s::LMScope dflt::VarData =
  case s.datum of
  | right(d) -> d
  | _ -> dflt
  end;

-- generated
fun mkScope_dflt
Scope<LMSet Either<Unit (String, Type)>> ::= =
  mkScope(left(()))
;

-- generated
fun mkScope_var
Scope<LMSet Either<Unit (String, Type)>> ::= a::String b::Type =
  mkScope(right((a, b)))
;

----------
-- labels:

production label_lex
top::Label<LMSet b> ::=
{
  top.name = "lex";

  top.demand = \s::Decorated Scope<LMSet b> with LMSet -> s.lex;
}

production label_var
top::Label<LMSet b> ::=
{
  top.name = "var";

  top.demand = \s::Decorated Scope<LMSet b> with LMSet -> s.var;
}


-------------
-- predicate:

type Predicate<(a::InhSet) b> = (Boolean ::= Decorated Scope<(a::InhSet) b> with a);

fun isName Predicate<LMSet Either<Unit (String, Type)>> ::= name::String =
  \s::Decorated Scope<LMSet Either<Unit (String, Type)>> ->
    case s.datum of
    | right((id, _)) -> id == name
    | _ -> false
    end;

-----------
-- queries:

fun resolve
[Decorated Scope<a b> with a] ::= p::Predicate<a b> r::Regex<a b> s::Decorated Scope<a b> with a
=
  let cont::[Decorated Scope<a b> with a] =
    -- labels that form a prefix of a word in L(r)
    let validLabels::[Label<a b>] = r.first in
      foldl (
        \acc::(Maybe<Label<a b>>, [Decorated Scope<a b> with a]) nextLab::Label<a b> ->
          -- label followed to get the resolution in acc.2
          let prevLab::Maybe<Label<a b>> = acc.1
          in
          -- resolution found by following the label in acc.1
          let prevRes::[Decorated Scope<a b> with a] = acc.2
          in
          -- make a new resolution by following edges with label nextLab
          let nextRes::[Decorated Scope<a b> with a] =
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

--------------
-- labels lib:

nonterminal Label<(a::InhSet) b>;

synthesized attribute name::String occurs on Label<(a::InhSet) b>;

synthesized attribute 
  demand<(a::InhSet) b>::([Decorated Scope<a b> with a] ::= Decorated Scope<a b> with a)
occurs on Label<(a::InhSet) b>;

instance Eq Label<a b> {
  eq = \l::Label<a b> r::Label<a b> -> l.name == r.name;
}

---------
-- regex:

nonterminal Regex<(a::InhSet) b>;

-- Transform a Regex to an equivalent fully simplified one
synthesized attribute simplify<(a::InhSet) b>::Regex<a b> occurs on Regex<(a::InhSet) b>;
-- Theorem 3.1 of Brzozowski (1964). Derivative with respect to a single token
synthesized attribute deriv<(a::InhSet) b>::(Regex<a b> ::= Label<a b>) occurs on Regex<(a::InhSet) b>;
-- Definition 3.2 of Brzozowski (1964), return epsilon if Regex contains epsilon
synthesized attribute hasEps<(a::InhSet) b>::Regex<a b> occurs on Regex<(a::InhSet) b>;
-- True if epsilon is a valid string in the language of the Regex
synthesized attribute nullable::Boolean occurs on Regex<(a::InhSet) b>;
-- Compute first set of a Regex
synthesized attribute first<(a::InhSet) b>::[Label<a b>] occurs on Regex<(a::InhSet) b>;

production regexLabel
top::Regex<a b> ::= label::Label<a b>
{
  top.hasEps = regexEmpty();
  top.deriv = \l::Label<a b> -> if l.name == label.name 
                                then regexEpsilon() else regexEmpty();
  top.simplify = ^top;
  top.nullable = false;
  top.first = [^label];
}

production regexEpsilon
top::Regex<a b> ::=
{
  top.hasEps = regexEpsilon();
  top.deriv = \_ -> regexEmpty();
  top.simplify = ^top;
  top.nullable = true;
  top.first = [];
}

production regexEmpty
top::Regex<a b> ::=
{
  top.hasEps = regexEmpty();
  top.deriv = \_ -> regexEmpty();
  top.simplify = ^top;
  top.nullable = false;
  top.first = [];
}

production regexCat
top::Regex<a b> ::= left::Regex<a b> right::Regex<a b>
{
  top.hasEps = regexAnd(left.hasEps, right.hasEps);
  top.deriv = \l -> regexOr(regexCat(left.deriv(l), ^right),
                            regexCat(left.hasEps, right.deriv(l)));
  top.simplify = 
    let simpR1::Regex<a b> = left.simplify in
    let simpR2::Regex<a b> = right.simplify in
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
top::Regex<a b> ::= left::Regex<a b> right::Regex<a b>
{
  top.hasEps = regexOr(left.hasEps, right.hasEps);
  top.deriv = \l -> regexOr(left.deriv(l), right.deriv(l));
  top.simplify =
    let simpR1::Regex<a b> = left.simplify in
    let simpR2::Regex<a b> = right.simplify in
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
top::Regex<a b> ::= left::Regex<a b> right::Regex<a b>
{
  top.hasEps = regexAnd(left.hasEps, right.hasEps);
  top.deriv = \l -> regexAnd(left.deriv(l), right.deriv(l));
  top.simplify =
    let simpR1::Regex<a b> = left.simplify in
    let simpR2::Regex<a b> = right.simplify in
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
top::Regex<a b> ::= sub::Regex<a b>
{
  top.hasEps = regexEpsilon();
  top.deriv = \l -> regexCat(sub.deriv(l), regexStar(^sub));
  top.simplify =
    let simpR::Regex<a b> = sub.simplify in 
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
top::Regex<a b> ::= sub::Regex<a b>
{ forwards to regexCat(^sub, regexStar(^sub)); }

production regexMaybe
top::Regex<a b> ::= sub::Regex<a b>
{ forwards to regexOr(regexEpsilon(), ^sub); }
