grammar statix_translate:to_ocaml;

--------------------------------------------------

synthesized attribute ocaml_pattern::String occurs on AG_Pattern;

aspect production agPatternUnderscore
top::AG_Pattern ::=
{
  top.ocaml_pattern = "UnderscoreP";
}

aspect production agPatternName
top::AG_Pattern ::= name::String
{
  top.ocaml_pattern = "VarP(\"" ++ name ++ "\")";
}

aspect production agPatternApp
top::AG_Pattern ::= name::String ps::[AG_Pattern]
{
  top.ocaml_pattern = "TermP(\"" ++ name ++ "\", [" ++
    implode("; ", map((.ocaml_pattern), ps)) ++
  "])";
}

aspect production agPatternCons
top::AG_Pattern ::= h::AG_Pattern t::AG_Pattern
{
  top.ocaml_pattern = 
    "ConsP(" ++ 
      h.ocaml_pattern ++ ", " ++ 
      t.ocaml_pattern ++ 
    ")";
}

aspect production agPatternNil
top::AG_Pattern ::=
{
  top.ocaml_pattern = "NilP";
}

aspect production agPatternTuple
top::AG_Pattern ::= ps::[AG_Pattern]
{
  top.ocaml_pattern = 
    "TupleP([" ++ implode("; ", map((.ocaml_pattern), ps)) ++ "])";
}