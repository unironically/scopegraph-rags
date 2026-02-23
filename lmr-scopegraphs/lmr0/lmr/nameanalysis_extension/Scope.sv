grammar lmr0:lmr:nameanalysis_extension;

--

imports silver:compiler:extension:scopegraphs2;

--

production datumLex
top::Datum ::=
{}

production datumVar
top::Datum ::= name::String ty::Type
{}