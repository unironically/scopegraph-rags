grammar lmre:lmr:syntax;

exports syntax:lmr0:lmr:abstractsyntax;

--

-- orphaned production, mwda turned off
abstract production declMod
top::Decl ::= id::String ds::Decls
{
  top.statix = "todo";
  top.flattened = ["todo"];
}

-- orphaned production, mwda turned off
abstract production declImp
top::Decl ::= id::String
{
  top.statix = "todo";
  top.flattened = ["todo"];
}