grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute moduleTrans::String occurs on Module;

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{
  top.moduleTrans = implode ("\n", preds.lambdas ++ preds.predicatesTrans);
  preds.knownFuncPreds = preds.functionalPreds;
  preds.knownNonterminals = preds.nonterminals;
}

--------------------------------------------------

monoid attribute predicatesTrans::[String] with [], ++ occurs on Predicates;
propagate predicatesTrans on Predicates;

attribute lambdas occurs on Predicates;
propagate lambdas on Predicates;

-- functional predicate name and arg/ret type declarations
attribute functionalPreds occurs on Predicates;
propagate functionalPreds on Predicates;

inherited attribute knownFuncPreds::[(String, [(String, Boolean, TypeAnn)])] occurs on Predicates;
propagate knownFuncPreds on Predicates;

attribute nonterminals occurs on Predicates;
propagate nonterminals on Predicates;

inherited attribute knownNonterminals::[Decorated AGNont] occurs on Predicates;
propagate knownNonterminals on Predicates;

--

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{
  top.predicatesTrans <- [pred.predicateTrans];
}

aspect production predicatesNil
top::Predicates ::= 
{}