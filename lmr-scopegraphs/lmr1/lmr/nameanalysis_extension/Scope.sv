grammar lmr1:lmr:nameanalysis_extension;

--

imports silver:compiler:extension:scopegraphs;

--

production datumLex
top::Datum ::=
{}

production datumVar
top::Datum ::= name::String b::Decorated Bind with {s, isRec}
{}

production datumMod
top::Datum ::= name::String m::Decorated Module
{}

--

-- should be generated:

global deadScope::Decorated Scope with LMGraph = 
  decorate scope(datumLex()) with { lex = []; var = []; mod = []; imp = []; };