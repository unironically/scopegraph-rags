grammar statix_translate:translation;

--------------------------------------------------

nonterminal AG_Pattern;

abstract production agPatternUnderscore
top::AG_Pattern ::=
{}

abstract production agPatternName
top::AG_Pattern ::= name::String
{}

abstract production agPatternApp
top::AG_Pattern ::= name::String ps::[AG_Pattern]
{}

abstract production agPatternCons
top::AG_Pattern ::= ps::[AG_Pattern]
{}

abstract production agPatternNil
top::AG_Pattern ::=
{}

abstract production agPatternTuple
top::AG_Pattern ::= ps::[AG_Pattern]
{}