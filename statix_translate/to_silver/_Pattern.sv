grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_pattern::String occurs on AG_Pattern;

aspect production agPatternUnderscore
top::AG_Pattern ::=
{
  top.silver_pattern = "_";
}

aspect production agPatternName
top::AG_Pattern ::= name::String
{
  top.silver_pattern = name;
}

aspect production agPatternApp
top::AG_Pattern ::= name::String ps::[AG_Pattern]
{
  top.silver_pattern = preProd ++ name ++ "(" ++ 
                         implode(", ", map((.silver_pattern), ps)) ++ 
                       ")";
}

aspect production agPatternCons
top::AG_Pattern ::= h::AG_Pattern t::AG_Pattern
{
  top.silver_pattern = h.silver_pattern ++ "::" ++ t.silver_pattern;
}

aspect production agPatternNil
top::AG_Pattern ::=
{
  top.silver_pattern = "[]";
}

aspect production agPatternTuple
top::AG_Pattern ::= ps::[AG_Pattern]
{
  top.silver_pattern = "(" ++ implode(", ", map((.silver_pattern), ps)) ++ ")";
}