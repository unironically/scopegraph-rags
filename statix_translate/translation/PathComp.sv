grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute pathCompTrans::String occurs on PathComp;

aspect production lexicoPathComp
top::PathComp ::= lts::LabelLTs
{
  top.pathCompTrans = error("lexicoPathComp.pathCompTrans TODO");
}

aspect production revLexicoPathComp
top::PathComp ::= lts::LabelLTs
{
  top.pathCompTrans = error("revLexicoPathComp.pathCompTrans TODO");
}

aspect production scalaPathComp
top::PathComp ::=
{
  top.pathCompTrans = error("scalaPathComp.pathCompTrans TODO");
}

aspect production namedPathComp
top::PathComp ::= name::String
{
  top.pathCompTrans = error("namedPathComp.pathCompTrans TODO");
}