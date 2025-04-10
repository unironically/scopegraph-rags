grammar statix_translate:to_ocaml;

--------------------------------------------------

aspect production agPatternUnderscore
top::AG_Pattern ::=
{
}

aspect production agPatternName
top::AG_Pattern ::= name::String
{
}

aspect production agPatternApp
top::AG_Pattern ::= name::String ps::[AG_Pattern]
{
}

aspect production agPatternCons
top::AG_Pattern ::= h::AG_Pattern t::AG_Pattern
{
}

aspect production agPatternNil
top::AG_Pattern ::=
{
}

aspect production agPatternTuple
top::AG_Pattern ::= ps::[AG_Pattern]
{
}