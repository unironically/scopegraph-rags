grammar lmr1:lmr:nameanalysis_extension;

--

imports silver:compiler:extension:scopegraphs;

--

production datumVar
top::Datum ::= name::String b::Decorated Bind with {s, isSeqLet}
{}

production datumMod
top::Datum ::= name::String m::Decorated Module
{}

--

global deadScope::Decorated Scope with LMLabels = 
  decorate scope(datumDefault()) with { lex = []; var = []; mod = []; imp = []; };
