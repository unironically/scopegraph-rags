grammar statix_translate:translation;

--------------------------------------------------

--

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::BranchList
{
  top.predicateTrans = error("syntaxPredicate.predicateTrans TODO");
  top.functionalPreds := [];

  bs.namesInScope = nameLst.nameListDefs;

  -- tell the branch list that it is not a functional pred
  bs.isFunctionalPred = false;
  bs.expRetTys = [];
}