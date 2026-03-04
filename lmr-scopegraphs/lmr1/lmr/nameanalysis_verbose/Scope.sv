grammar lmr1:lmr:nameanalysis_verbose;

--

imports silver:compiler:extension:scopegraphs;

--

production datumVar
top::Datum ::= name::String b::Decorated Bind with {s, isRecLet}
{}

production datumMod
top::Datum ::= name::String m::Decorated Module
{}

--

production label_lex
top::Label ::=
{
  top.name = "lex";
  top.demand = \s::Decorated Scope with LMLabels -> s.lex;
}

--

global deadScope::Decorated Scope with LMLabels = 
  decorate scope(datumDefault()) with { lex = []; var = []; mod = []; imp = []; };
