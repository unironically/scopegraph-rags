grammar statix_translate:translation;

--------------------------------------------------

--

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::BranchList
{
  top.predicateTrans = error("syntaxPredicate.predicateTrans TODO");
  top.functionalPreds := [];
}