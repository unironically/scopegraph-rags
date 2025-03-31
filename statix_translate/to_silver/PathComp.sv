grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_expr occurs on PathComp;

aspect production lexicoPathComp
top::PathComp ::= lts::LabelLTs
{
  top.ag_expr = 
    lambdaExpr (
      [("l", nameTypeAG("Label")), ("r", nameTypeAG("Label"))],
      caseExpr (
        tupleExpr([nameExpr("l"), nameExpr("r")]),
        lts.ag_cases
      )
    );
}

aspect production namedPathComp
top::PathComp ::= name::String
{
  top.ag_expr = nameExpr(name);
}

aspect production revLexicoPathComp
top::PathComp ::= lts::LabelLTs
{
  top.ag_expr = falseExpr(); -- TODO
}

aspect production scalaPathComp
top::PathComp ::=
{
  top.ag_expr = falseExpr(); -- TODO
}

--------------------------------------------------

synthesized attribute ag_cases::AG_Cases occurs on LabelLTs;

aspect production labelLTsCons
top::LabelLTs ::= l1::Label l2::Label lts::LabelLTs
{
  top.ag_cases = bothCases(l1, l2, lts.ag_cases);
}

aspect production labelLTsOne
top::LabelLTs ::= l1::Label l2::Label 
{
  top.ag_cases = bothCases(l1, l2, agCasesNil());
}

fun bothCases 
AG_Cases ::= l1::Decorated Label l2::Decorated Label rest::AG_Cases =
  agCasesCons (
    agCase (
      agPatternTuple(
        [agPatternApp(l1.name, []), agPatternApp(l2.name, [])]
      ),
      nothing(),
      intExpr(-1)
    ),
    agCasesCons(
      agCase (
        agPatternTuple(
          [agPatternApp(l2.name, []), agPatternApp(l1.name, [])]
        ),
        nothing(),
        intExpr(1)
      ),
      rest
    )
  );