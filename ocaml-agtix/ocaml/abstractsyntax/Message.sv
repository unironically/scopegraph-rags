grammar ocaml:abstractsyntax;

imports silver:langutil;

--

synthesized attribute pp::String;

--

nonterminal Message with pp;

production err
top::Message ::= s::String l::Location
{
  top.pp = "error: " ++ l.unparse ++ ": " ++ s ++ "\n";
}
