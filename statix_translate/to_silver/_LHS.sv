grammar statix_translate:translation;

--------------------------------------------------

nonterminal AG_LHS;

abstract production nameLHS
top::AG_LHS ::= name::String
{}

abstract production qualLHS
top::AG_LHS ::= pre::AG_LHS name::String
{}