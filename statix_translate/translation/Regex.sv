grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute regexTrans::String occurs on Regex;

aspect production regexLabel
top::Regex ::= lab::Label
{
  top.regexTrans = error("regexLabel.regexTrans TODO");
}

aspect production regexSeq
top::Regex ::= r1::Regex r2::Regex
{
  top.regexTrans = error("regexSeq TODO");
}

aspect production regexAlt
top::Regex ::= r1::Regex r2::Regex
{
  top.regexTrans = error("regexAlt TODO");
}

aspect production regexAnd
top::Regex ::= r1::Regex r2::Regex
{
  top.regexTrans = error("regexAnd TODO");
}

aspect production regexStar
top::Regex ::= r::Regex
{
  top.regexTrans = error("regexStar TODO");
}

aspect production regexAny
top::Regex ::=
{
  top.regexTrans = error("regexAny TODO");
}

aspect production regexNeg
top::Regex ::= r::Regex
{
  top.regexTrans = error("regexNeg TODO");
}

aspect production regexEps
top::Regex ::=
{
  top.regexTrans = error("regexEps TODO");
}