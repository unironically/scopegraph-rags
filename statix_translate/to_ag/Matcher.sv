grammar statix_translate:to_ag;

--------------------------------------------------

attribute ag_expr {- ::AG_Expr -} occurs on Matcher;

attribute ag_funs occurs on Matcher;
propagate ag_funs on Matcher;

attribute ag_pattern occurs on Matcher;
attribute ag_whereClause occurs on Matcher;

attribute nonAttrs occurs on Matcher;

monoid attribute nonAttrsSyn::[String] with [], ++ occurs on Matcher;
propagate nonAttrsSyn on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{
  local arg_name::String = "lambda_" ++ toString(genInt()) ++ "_arg";

  local ag_case::AG_Expr = 
    caseExpr(
      nameExpr(arg_name),
      agCasesCons(
        agCase (p.ag_pattern, wc.ag_whereClause, trueExpr()),             -- match
        agCasesCons(
          agCase(agPatternUnderscore(), nilWhereClauseAG(), falseExpr()), -- no match
          agCasesNil()
        )
      )
    );

  top.ag_expr = lambdaExpr ([(arg_name, p.ag_type)], ^ag_case);
  top.ag_pattern = p.ag_pattern;
  top.ag_whereClause = wc.ag_whereClause;

  wc.nonAttrs = top.nonAttrs ++ p.nonAttrsSyn;
}

--------------------------------------------------

synthesized attribute ag_pattern::AG_Pattern occurs on Pattern;
attribute ag_type {- :: AG_Type -} occurs on Pattern;

attribute nonAttrsSyn occurs on Pattern;
propagate nonAttrsSyn on Pattern;

aspect production labelPattern
top::Pattern ::= lab::Label
{
  top.ag_pattern = agPatternApp(lab.name, []);
  top.ag_type = nameTypeAG("Label");
}

aspect production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{
  top.ag_pattern = agPatternApp(lab.name, [p.ag_pattern]);
  top.ag_type = nameTypeAG("Label");
}

aspect production namePattern
top::Pattern ::= name::String ty::TypeAnn
{
  top.ag_pattern = agPatternName(name);
  top.ag_type = ty.ag_type;
  top.nonAttrsSyn <- [name];
}

aspect production constructorPattern
top::Pattern ::= name::String ps::PatternList ty::TypeAnn
{
  top.ag_pattern = agPatternApp(name, ps.ag_patterns);
  top.ag_type = ty.ag_type;
}

aspect production consPattern
top::Pattern ::= p1::Pattern p2::Pattern
{
  top.ag_pattern = agPatternCons(p1.ag_pattern, p2.ag_pattern);
  top.ag_type = listTypeAG(p1.ag_type);
}

aspect production nilPattern
top::Pattern ::=
{
  top.ag_pattern = agPatternNil();
  top.ag_type = listTypeAG(varTypeAG());
}

aspect production tuplePattern
top::Pattern ::= ps::PatternList
{
  top.ag_pattern = agPatternTuple(ps.ag_patterns);
  top.ag_type = tupleTypeAG(ps.ag_types);
}

aspect production underscorePattern
top::Pattern ::= ty::TypeAnn
{
  top.ag_pattern = agPatternUnderscore();
  top.ag_type = ty.ag_type;
}

--------------------------------------------------

synthesized attribute ag_patterns::[AG_Pattern] occurs on PatternList;
synthesized attribute ag_types::[AG_Type] occurs on PatternList;

attribute nonAttrsSyn occurs on PatternList;
propagate nonAttrsSyn on PatternList;

aspect production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{
  top.ag_patterns = p.ag_pattern :: ps.ag_patterns;
  top.ag_types = p.ag_type :: ps.ag_types;
}

aspect production patternListNil
top::PatternList ::=
{
  top.ag_patterns = [];
  top.ag_types = [];
}