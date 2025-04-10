grammar statix_translate:to_ag;

--------------------------------------------------

nonterminal AG_Pattern;

attribute pp occurs on AG_Pattern;

abstract production agPatternUnderscore
top::AG_Pattern ::=
{
  top.pp = "agPatternUnderscore()";
}

abstract production agPatternName
top::AG_Pattern ::= name::String
{
  top.pp = "agPatternName(" ++ name ++ ")";
}

abstract production agPatternApp
top::AG_Pattern ::= name::String ps::[AG_Pattern]
{
  top.pp = "agPatternApp(" ++ name ++ ", [" ++ implode(", ", map((.pp), ps)) ++ "])";
}

abstract production agPatternCons
top::AG_Pattern ::= h::AG_Pattern t::AG_Pattern
{
  top.pp = "agPatternCons(" ++ h.pp ++ ", " ++ t.pp ++ ")";
}

abstract production agPatternNil
top::AG_Pattern ::=
{
  top.pp = "agPatternNil()";
}

abstract production agPatternTuple
top::AG_Pattern ::= ps::[AG_Pattern]
{
  top.pp = "agPatternTuple([" ++ implode (", ", map((.pp), ps)) ++ "])";
}