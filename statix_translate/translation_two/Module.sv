grammar statix_translate:translation_two;

--------------------------------------------------

monoid attribute predicateCalls::[String] with [], ++ occurs on Module;
propagate predicateCalls on Module;

monoid attribute predicateDecls::[(String, Either<SyntaxPred FunctionPred>)] with [], ++ occurs on Module;
propagate predicateDecls on Module;

synthesized attribute predsStr::String occurs on Module;

attribute prodTmpTrans occurs on Module;
propagate prodTmpTrans on Module;

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{
  preds.predicateEnv = addScope(preds.predicateDecls, baseScope());

  top.predsStr = implode("\n\n", preds.predicateCalls);

}