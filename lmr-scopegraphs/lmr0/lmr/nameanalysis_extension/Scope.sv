grammar lmr0:lmr:nameanalysis_extension;

--

imports silver:compiler:extension:scopegraphs;

--

production datumLex
top::Datum ::=
{}

production datumVar
top::Datum ::= name::String ty::Type
{}

--

global deadScope::Decorated Scope with LMGraph = 
  decorate scope(datumLex()) with { lex = []; var = []; };