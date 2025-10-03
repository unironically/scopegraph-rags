grammar sg_lib2:src;

--

-- Data well-formedness predicate to filter resolution results
type DwfPred = (Boolean ::= Datum);

synthesized attribute pp::String;
synthesized attribute id::String;

--

nonterminal Scope with id, pp;

inherited attribute edges::[Edge] occurs on Scope;
synthesized attribute resolve::([Decorated Scope] ::= DwfPred Regex) occurs on Scope;
synthesized attribute datum::Decorated Datum occurs on Scope;

production scope
top::Scope ::= d::Datum
{
  top.id = toString(genInt());
  top.pp = "s" ++ top.id ++ " -> " ++ case d of datumName(n) -> "'" ++ n ++ "'" 
                                               | _ -> "()" end;
  top.datum = d;

  top.resolve = \p::DwfPred r::Regex ->
    let
      rSimp::Regex = r.simplify
    in
      case rSimp of
      | regexEmp() -> []
      | regexEps() -> if p(^d) then [top] else []
      | _ ->
        let cont::[Decorated Scope] =
          concat(map (tryEdge(rSimp, p, _), top.edges))
        in
          if rSimp.nullable && p(^d) then top::cont else cont
        end
      end
    end;
}

{- Given a regular expression and an edge in the scope graph, continue
 - resolution at the target of the edge so long as the derivitive of the
 - regular expression with respect to the edge label is not the empty set.
 - I.e. if the edge is valid at this point in the resolution, follow it.
 -}
fun tryEdge [Decorated Scope] ::= r::Regex p::DwfPred e::Edge =
  let 
    drx::Regex = r.deriv(e.label).simplify
  in
    case drx of
    | regexEmp() -> []           -- Edge does not represent a valid step
    | _ -> e.tgt.resolve(p, drx) -- Edge can be followed for this resolution
    end
  end;

--

nonterminal Datum with id;

production datumName
top::Datum ::= id::String
{ top.id = id; }

production datumNone
top::Datum ::=
{ top.id = "<unnamed datum>"; }

--

nonterminal Edge;

synthesized attribute label::String occurs on Edge;
synthesized attribute tgt::Decorated Scope occurs on Edge;

production edge
top::Edge ::= label::String tgt::Decorated Scope
{ top.label = label; top.tgt = tgt; }

--

nonterminal Regex with pp;

-- Transform a Regex to an equivalent fully simplified one
synthesized attribute simplify::Regex occurs on Regex;
-- Theorem 3.1 of Brzozowski (1964). Derivative with respect to a single token
synthesized attribute deriv::(Regex ::= String) occurs on Regex;
-- Definition 3.2 of Brzozowski (1964), return epsilon if Regex contains epsilon
synthesized attribute hasEps::Regex occurs on Regex;
-- True if epsilon is a valid string in the language of the Regex
synthesized attribute nullable::Boolean occurs on Regex;

production regexLab
top::Regex ::= label::String
{
  top.hasEps = regexEmp();
  top.deriv = \l -> if l == label then regexEps() else regexEmp();
  top.simplify = ^top;
  top.pp = label;
  top.nullable = false;
}

production regexCat
top::Regex ::= r1::Regex r2::Regex
{
  top.hasEps = regexAnd(r1.hasEps, r2.hasEps);
  top.deriv = \l -> regexAlt(regexCat(r1.deriv(l), ^r2),
                             regexCat(r1.hasEps, r2.deriv(l)));
  top.simplify = 
    let simpR1::Regex = r1.simplify in
    let simpR2::Regex = r2.simplify in
      case (simpR1, simpR2) of
      | (regexEmp(), _) -> regexEmp()
      | (_, regexEmp()) -> regexEmp()
      | (regexEps(), regexEps()) -> regexEps()
      | (regexEps(), _) -> simpR2
      | (_, regexEps()) -> simpR1
      | (_, _) -> regexCat(simpR1, simpR2)
      end
    end end;
  top.pp = r1.pp ++ r2.pp;
  top.nullable = r1.nullable && r2.nullable;
}

production regexStar
top::Regex ::= r::Regex
{
  top.hasEps = regexEps();
  top.deriv = \l -> regexCat(r.deriv(l), regexStar(^r));
  top.simplify =
    let simpR::Regex = r.simplify in 
      case simpR of
      | regexEmp() -> regexEmp()
      | regexEps() -> regexEps()
      | _ -> regexStar(simpR)
      end
    end;
  top.pp = "(" ++ r.pp ++ ")*";
  top.nullable = true;
}

production regexEps
top::Regex ::=
{
  top.hasEps = regexEps();
  top.deriv = \_ -> regexEmp();
  top.simplify = ^top;
  top.pp = "<EPS>";
  top.nullable = true;
}

production regexEmp
top::Regex ::=
{
  top.hasEps = regexEmp();
  top.deriv = \_ -> regexEmp();
  top.simplify = ^top;
  top.pp = "<EMP>";
  top.nullable = false;
}

production regexAlt
top::Regex ::= r1::Regex r2::Regex
{
  top.hasEps = regexAlt(r1.hasEps, r2.hasEps);
  top.deriv = \l -> regexAlt(r1.deriv(l), r2.deriv(l));
  top.simplify = 
    let simpR1::Regex = r1.simplify in
    let simpR2::Regex = r2.simplify in
      case (simpR1, simpR2) of
      | (regexEmp(), _) -> simpR2
      | (_, regexEmp()) -> simpR1
      | (regexEps(), regexEps()) -> regexEps()
      | (regexEps(), _) -> regexAlt(regexEps(), simpR2)
      | (_, regexEps()) -> regexAlt(simpR1, regexEps())
      | (_, _) -> regexAlt(simpR1, simpR2)
      end
    end end;
  top.pp = "(" ++ r1.pp ++ "|" ++ r2.pp ++ ")";
  top.nullable = r1.nullable && r2.nullable;
}

production regexAnd
top::Regex ::= r1::Regex r2::Regex
{
  top.hasEps = regexAnd(r1.hasEps, r2.hasEps);
  top.deriv = \l -> regexAnd(r1.deriv(l), r2.deriv(l));
  top.simplify =
    let simpR1::Regex = r1.simplify in
    let simpR2::Regex = r2.simplify in
      case (simpR1, simpR2) of
      | (regexEmp(), _) -> regexEmp()
      | (_ , regexEmp()) -> regexEmp()
      | (regexEps(), r) -> if r.nullable then regexEps() else regexEmp()
      | (r, regexEps()) -> if r.nullable then regexEps() else regexEmp()
      | (_, _) -> regexAnd(simpR1, simpR2)
      end
    end end;
  top.pp = "(" ++ r1.pp ++ "&" ++ r2.pp ++ ")";
  top.nullable = r1.nullable && r2.nullable;
}

production regexOpt
top::Regex ::= r::Regex
{ top.pp = r.pp ++ "?";
  forwards to regexAlt(^r, regexEps()); }

production regexPlus
top::Regex ::= r::Regex
{ top.pp = r.pp ++ "+";
  forwards to regexCat(^r, regexStar(^r)); }
