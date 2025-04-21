grammar statix_translate:to_silver;

--------------------------------------------------

monoid attribute silver_cases::[String] with [], ++ occurs on AG_Cases;
propagate silver_cases on AG_Cases;

attribute knownLocals occurs on AG_Cases;
propagate knownLocals on AG_Cases;

attribute knownProds occurs on AG_Cases;
propagate knownProds on AG_Cases;

aspect production agCasesCons
top::AG_Cases ::= c::AG_Case cs::AG_Cases
{
}

aspect production agCasesOne
top::AG_Cases ::= c::AG_Case
{
}

aspect production agCasesNil
top::AG_Cases ::=
{
}

--------------------------------------------------

attribute silver_cases occurs on AG_Case;

attribute knownLocals occurs on AG_Case;

attribute knownProds occurs on AG_Case;
propagate knownProds on AG_Case;

aspect production agCase
top::AG_Case ::= pat::AG_Pattern wc::AG_WhereClause body::AG_Expr
{
  top.silver_cases := [
      pat.silver_pattern ++ " -> " ++
      body.silver_expr
  ];

  body.knownLocals = pat.localsSyn ++ top.knownLocals;
}