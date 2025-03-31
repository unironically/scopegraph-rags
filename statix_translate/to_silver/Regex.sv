grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute dfa_name::String occurs on Regex;

aspect production regexLabel
top::Regex ::= lab::Label
{
  top.dfa_name = ""; -- TODO
}

aspect production regexSeq
top::Regex ::= r1::Regex r2::Regex
{
  top.dfa_name = ""; -- TODO
}

aspect production regexAlt
top::Regex ::= r1::Regex r2::Regex
{
  top.dfa_name = ""; -- TODO
}

aspect production regexAnd
top::Regex ::= r1::Regex r2::Regex
{
  top.dfa_name = ""; -- TODO
}

aspect production regexStar
top::Regex ::= r::Regex
{
  top.dfa_name = ""; -- TODO
}

aspect production regexAny
top::Regex ::=
{
  top.dfa_name = ""; -- TODO
}

aspect production regexPlus
top::Regex ::= r::Regex
{
  top.dfa_name = ""; -- TODO
}

aspect production regexOptional
top::Regex ::= r::Regex
{
  top.dfa_name = ""; -- TODO
}

aspect production regexNeg
top::Regex ::= r::Regex
{
  top.dfa_name = ""; -- TODO
}

aspect production regexEps
top::Regex ::=
{
  top.dfa_name = ""; -- TODO
}

aspect production regexParens
top::Regex ::= r::Regex
{
  top.dfa_name = ""; -- TODO
}