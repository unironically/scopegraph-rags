grammar statix_translate:translation;

--------------------------------------------------

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{}

--------------------------------------------------

aspect production labelPattern
top::Pattern ::= lab::Label
{}

aspect production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{}

aspect production edgePattern
top::Pattern ::= p1::Pattern p2::Pattern p3::Pattern
{}

aspect production endPattern
top::Pattern ::= p::Pattern
{}

aspect production namePattern
top::Pattern ::= name::String ty::TypeAnn
{}

aspect production constructorPattern
top::Pattern ::= name::String ps::PatternList
{}

aspect production consPattern
top::Pattern ::= p1::Pattern p2::Pattern
{}

aspect production nilPattern
top::Pattern ::=
{}

aspect production tuplePattern
top::Pattern ::= ps::PatternList
{}

aspect production underscorePattern
top::Pattern ::=
{}

--------------------------------------------------

aspect production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{}

aspect production patternListNil
top::PatternList ::=
{}

--------------------------------------------------