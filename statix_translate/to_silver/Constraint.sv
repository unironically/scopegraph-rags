grammar statix_translate:translation;

--------------------------------------------------

fun topDotLHS AG_LHS ::= String = \s::String -> qualLHS(nameLHS("top"), s);
fun topDotExpr AG_Expr ::= String = \s::String -> qualExpr(nameExpr("top"), s);

synthesized attribute equations::[AG_Eq] occurs on Constraint;

--------------------------------------------------

aspect production trueConstraint
top::Constraint ::=
{
  -- top.ok <- [true];
  top.equations = [
    contributionEq(
      topDotLHS("ok"), 
      trueExpr()
    )
  ];
}

aspect production falseConstraint
top::Constraint ::=
{
  -- top.ok <- [false];
  top.equations = [
    contributionEq(
      topDotLHS("ok"), 
      falseEq()
    )
  ];
}

aspect production conjConstraint
top::Constraint ::= c1::Constraint c2::Constraint
{
  -- combination of equations from both
  top.equations = c1.equations ++ c2.equations;
}

aspect production existsConstraint
top::Constraint ::= names::NameList c::Constraint
{
  -- local n::ty; for all (n, ty) in names, then equations from body
  top.equations = map ((.localDeclEq), names) ++ c.equations;
}

aspect production eqConstraint
top::Constraint ::= t1::Term t2::Term
{
  -- top.ok <- t1 == t2; t1 and t2 must be ground
  top.equations = [
    contributionEq(
      topDotLHS("ok"), 
      eqExpr(t1.ag_expr, t2.ag_expr)
    )
  ];
}

aspect production neqConstraint
top::Constraint ::= t1::Term t2::Term
{
  -- top.ok <- t1 != t2; t1 and t2 must be ground
  top.equations = [
    contributionEq(
      topDotLHS("ok"), 
      neqExpr(t1.ag_expr, t2.ag_expr)
    )
  ];
}

aspect production newConstraintDatum
top::Constraint ::= name::String t::Term
{
  -- name = mkScope(t);
  top.equations = [
    defineEq (
      nameLHS(name),
      appExpr("mkScope", [t.ag_expr])
    )
  ];
}

aspect production newConstraint
top::Constraint ::= name::String
{
  -- name = mkScope();
  top.equations = [
    defineEq (
      nameLHS(name),
      appExpr("mkScope", [])
    )
  ];
}

aspect production dataConstraint
top::Constraint ::= name::String t::Term
{
  -- t = name.datum;
  top.equations = [
    defineEq (
      topDotLHS(t.to_str),
      demandEq(topDotLHS(name), "datum")
    )
  ];
}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{
  -- top.s_lab <- [tgt];
  top.equations = [
    contributionEq(
      topDotLHS("src_" ++ lab.to_str),
      trueExpr()
    )
  ];
}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{
  -- top.res = query(top.src, r);
  top.equations = [
    defineEq (
      topDotLHS(res),
      app(
        "query",
        [topDotExpr(src), r.dfaName]
      )
    )
  ];
}

aspect production oneConstraint
top::Constraint ::= name::String out::String
{
  -- top.out = one(top.name);
  top.equations = [
    defineEq (
      topDotLHS(out),
      app(
        "one",
        [topDotExpr(name)]
      )
    )
  ];
}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{
  -- top.ok <- inhabited(top.name);
  top.equations = [
    contributionEq (
      topDotLHS("ok"),
      app(
        "inhabited",
        [topDotExpr(name)]
      )
    )
  ];
}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{
  -- top.res = min(top.set, pc)
  top.equations = [
    defineEq (
      topDotLHS(res),
      appExpr (
        "min",
        [topDotExpr(name), pc.as_lambda]
      )
    )
  ];
}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{
  -- top.ok <- every(top.name, lam)
  top.equations = [
    contributionEq (
      topDotLHS("ok"),
      appExpr (
        "every",
        [topDotExpr(name), lam.as_lambda]
      )
    )
  ];
}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{
  -- top.res = filter(top.set, m)
  top.equations = [
    defineEq (
      topDotLHS(res),
      appExpr (
        "filter",
        [topDotExpr(set), m.as_lambda]
      )
    )
  ];
}

aspect production defConstraint
top::Constraint ::= name::String t::Term
{
  -- top.name = t
  top.equations = [
    defineEq (
      topDotLHS(name),
      t.ag_expr
    )
  ];
}

--------------------------------------------------

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{
  -- todo
  top.equations = [];
}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{
  -- todo
  top.equations = [];
}