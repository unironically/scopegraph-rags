grammar statix_translate:translation;

--------------------------------------------------

attribute ag_expr {- ::AG_Expr -} occurs on Matcher;

attribute ag_decls {- ::[AG_Decl] -} occurs on Matcher;
propagate ag_decls on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{
  local lam_name::String = "lambda_" ++ toString(genInt());

  top.ag_expr = nameExpr(lam_name);

  top.ag_decls <- [
    functionDecl (lam_name, [boolType()], body)
  ];

  local body::[AG_Eq] =
    case wc of 
      nilWhereClause()    -> c.equations
    | withWhereClause(gl) -> error("lambda.body - withWhereClause TODO")
    end;
}

--------------------------------------------------

synthesized attribute ag_pattern::Decorated AG_Pattern occurs on Pattern;

aspect production labelPattern
top::Pattern ::= lab::Label
{
  top.ag_pattern = agPatternApp(lab.name, []);
}

aspect production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{
  top.ag_pattern = agPatternApp(lab.name, [p.ag_pattern]);
}

aspect production edgePattern
top::Pattern ::= p1::Pattern p2::Pattern p3::Pattern
{
  top.ag_pattern = agPatternApp("edge", 
                                [p1.ag_pattern, p2.ag_pattern, p3.ag_pattern]);
}

aspect production endPattern
top::Pattern ::= p::Pattern
{
  top.ag_pattern = agPatternApp("end", [p.ag_pattern]);
}

aspect production namePattern
top::Pattern ::= name::String ty::TypeAnn
{
  top.ag_pattern = agPatternName(name);
}

aspect production constructorPattern
top::Pattern ::= name::String ps::PatternList
{
  top.ag_pattern = agPatternApp(name, ps.ag_patterns);
}

aspect production consPattern
top::Pattern ::= p1::Pattern p2::Pattern
{
  top.ag_pattern = agPatternCons(p1.ag_pattern, p2.ag_pattern);
}

aspect production nilPattern
top::Pattern ::=
{
  top.ag_pattern = agPatternNil();
}

aspect production tuplePattern
top::Pattern ::= ps::PatternList
{
  top.ag_pattern = agPatternTuple(ps.ag_patterns);
}

aspect production underscorePattern
top::Pattern ::=
{
  top.ag_pattern = agPatternUnderscore();
}

--------------------------------------------------

synthesized attribute ag_patterns::[Decorated AG_Pattern] occurs on PatternList;

aspect production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{
  top.ag_patterns = p.ag_pattern :: ps.ag_patterns;
}

aspect production patternListNil
top::PatternList ::=
{
  top.ag_patterns = [];
}

--------------------------------------------------