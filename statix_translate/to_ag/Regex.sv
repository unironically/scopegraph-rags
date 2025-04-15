grammar statix_translate:to_ag;

--------------------------------------------------

attribute ag_expr occurs on Regex;

aspect production regexLabel
top::Regex ::= lab::Label
{
  top.ag_expr = termExpr ("regexLabel", [termExpr(labTermName(lab.name), [])]);
}

aspect production regexSeq
top::Regex ::= r1::Regex r2::Regex
{
  top.ag_expr = termExpr ("regexSeq", [r1.ag_expr, r2.ag_expr]);
}

aspect production regexAlt
top::Regex ::= r1::Regex r2::Regex
{
  top.ag_expr = termExpr ("regexAlt", [r1.ag_expr, r2.ag_expr]);
}

aspect production regexAnd
top::Regex ::= r1::Regex r2::Regex
{
  top.ag_expr = termExpr ("regexAnd", [r1.ag_expr, r2.ag_expr]);
}

aspect production regexStar
top::Regex ::= r::Regex
{
  top.ag_expr = termExpr ("regexStar", [r.ag_expr]);
}

aspect production regexAny
top::Regex ::=
{
  top.ag_expr = termExpr ("regexAny", []);
}

aspect production regexPlus
top::Regex ::= r::Regex
{
  top.ag_expr = termExpr("regexSeq", [
    r.ag_expr,
    termExpr ("regexStar", [r.ag_expr])
  ]);
}

aspect production regexOptional
top::Regex ::= r::Regex
{
  top.ag_expr = termExpr("regexAlt", [
    r.ag_expr,
    termExpr ("regexEps", [])
  ]);
}

aspect production regexNeg
top::Regex ::= r::Regex
{
  top.ag_expr = termExpr ("regexNeg", [r.ag_expr]);
}

aspect production regexEps
top::Regex ::=
{
  top.ag_expr = termExpr ("regexEps", []);
}

aspect production regexParens
top::Regex ::= r::Regex
{
  top.ag_expr = r.ag_expr;
}