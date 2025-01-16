grammar statix_translate:translation_two;

--------------------------------------------------

monoid attribute predicateCalls::[String] with [], ++ occurs on Module;
propagate predicateCalls on Module;

monoid attribute predicateDecls::[(String, Either<SyntaxPred FunctionPred>)] with [], ++ occurs on Module;
propagate predicateDecls on Module;

synthesized attribute predsStr::String occurs on Module;

synthesized attribute moduleTrans::String occurs on Module;

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{

  -- remove these
  local datumMod::FunctionPred = functionPred("DatumMod", nameListCons(nameUntagged("name", nameType("string")), nameListCons(nameUntagged("mod", scopeType()), nameListNil())));
  local datumVar::FunctionPred = functionPred("DatumVar", nameListCons(nameUntagged("name", nameType("string")), nameListCons(nameUntagged("type", nameType("type")), nameListNil())));

  preds.predicateEnv = addScope(("DatumMod", right(^datumMod))::("DatumVar", right(^datumVar))::preds.predicateDecls, baseScope());

  top.predsStr = implode("\n\n", preds.predicateCalls);

  top.moduleTrans = implode ("\n\n", preds.predicatesTrans);

}