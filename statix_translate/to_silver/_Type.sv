grammar statix_translate:to_silver;

--------------------------------------------------

nonterminal AG_Type;

abstract production nameTypeAG
top::AG_Type ::= name::String
{}

abstract production listTypeAG
top::AG_Type ::= ty::AG_Type
{}

abstract production tupleTypeAG
top::AG_Type ::= tys::[AG_Type]
{}

abstract production varTypeAG
top::AG_Type ::=
{}