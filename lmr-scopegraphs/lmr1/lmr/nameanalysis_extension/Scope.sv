grammar lmr1:lmr:nameanalysis_extension;

--

imports silver:compiler:extension:scopegraphs2;

--

production datumLex
top::Datum ::=
{}

production datumVar
top::Datum ::= name::String ty::Type
{}

production datumMod
top::Datum ::= name::String
{}

--

-- should be generated:

global deadScope::Decorated Scope with LMGraph = 
  decorate scope(datumLex()) with { lex = []; var = []; mod = []; imp = []; };