grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute regexTrans::String occurs on Regex;

aspect production regexLabel
top::Regex ::= lab::Label
{
  top.regexTrans = "regexLabel(" ++ lab.labelTrans ++ ")";
}

aspect production regexSeq
top::Regex ::= r1::Regex r2::Regex
{
  top.regexTrans = "regexSeq(" ++ r1.regexTrans ++ ", " ++ r2.regexTrans ++ ")";
}

aspect production regexAlt
top::Regex ::= r1::Regex r2::Regex
{
  top.regexTrans = "regexAlt(" ++ r1.regexTrans ++ ", " ++ r2.regexTrans ++ ")";
}

aspect production regexAnd
top::Regex ::= r1::Regex r2::Regex
{
  top.regexTrans = "regexAnd(" ++ r1.regexTrans ++ ", " ++ r2.regexTrans ++ ")";
}

aspect production regexStar
top::Regex ::= r::Regex
{
  top.regexTrans = "regexStar(" ++ r.regexTrans ++ ")";
}

aspect production regexAny
top::Regex ::=
{
  top.regexTrans = "regexAny()";
}

aspect production regexPlus
top::Regex ::= r::Regex
{
  top.regexTrans = "regexPlus(" ++ r.regexTrans ++ ")";
}

aspect production regexOptional
top::Regex ::= r::Regex
{
  top.regexTrans = "regexOptional(" ++ r.regexTrans ++ ")";
}

aspect production regexNeg
top::Regex ::= r::Regex
{
  top.regexTrans = "regexNeg()";
}

aspect production regexEps
top::Regex ::=
{
  top.regexTrans = "regexEps()";
}

aspect production regexParens
top::Regex ::= r::Regex
{
  top.regexTrans = r.regexTrans;
}