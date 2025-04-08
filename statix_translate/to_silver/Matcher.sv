grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_expr {- ::AG_Expr -} occurs on Matcher;

attribute ag_decls {- ::[AG_Decl] -} occurs on Matcher;
propagate ag_decls on Matcher;

attribute ag_pattern occurs on Matcher;
attribute ag_whereClause occurs on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{
  -- (DatumVar(x':string, _)::datum where x' == x)

  local arg_name::String = "x";
  local lam_name::String = "lambda_" ++ toString(genInt());

  top.ag_expr = nameExpr(lam_name);

  top.ag_decls <- [
    -- todo, ag_decl
    functionDecl (lam_name, nameTypeAG("Boolean"), [(arg_name, p.ag_type)], [returnEq(^ag_case)])
  ];

  -- todo, types and prods for below
  local ag_case::AG_Expr = 
    caseExpr(
      nameExpr(arg_name),
      agCasesCons(
        agCase (p.ag_pattern, wc.ag_whereClause, trueExpr()),
        agCasesCons(
          agCase(agPatternUnderscore(), nilWhereClauseAG(), falseExpr()),
          agCasesNil()
        )
      )
    );

  top.ag_pattern = p.ag_pattern;
  top.ag_whereClause = wc.ag_whereClause;
}

--------------------------------------------------

synthesized attribute ag_pattern::AG_Pattern occurs on Pattern;
attribute ag_type {- :: AG_Type -} occurs on Pattern;

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

aspect production edgePattern
top::Pattern ::= p1::Pattern p2::Pattern p3::Pattern
{
  top.ag_pattern = agPatternApp("edge", 
                                [p1.ag_pattern, p2.ag_pattern, p3.ag_pattern]);
  top.ag_type = nameTypeAG("Edge");
}

aspect production endPattern
top::Pattern ::= p::Pattern
{
  top.ag_pattern = agPatternApp("end", [p.ag_pattern]);
  top.ag_type = nameTypeAG("Edge");
}

aspect production namePattern
top::Pattern ::= name::String ty::TypeAnn
{
  top.ag_pattern = agPatternName(name);
  top.ag_type = ty.ag_type;
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