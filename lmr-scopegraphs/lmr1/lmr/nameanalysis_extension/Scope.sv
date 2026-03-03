grammar lmr1:lmr:nameanalysis_extension;

--

imports silver:compiler:extension:scopegraphs;

--

production datumLex
top::Datum ::=
{}

production datumVar
top::Datum ::= name::String b::Decorated Bind with {s, isRecLet}
{}

production datumMod
top::Datum ::= name::String m::Decorated Module
{}

--

global deadScope::Decorated Scope with LMLabels = 
  decorate scope(datumLex()) with { lex = []; var = []; mod = []; imp = []; };
