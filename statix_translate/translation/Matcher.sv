grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute matcherTrans::String occurs on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{
  top.matcherTrans = error("matcher.matcherTrans TODO");
}