grammar statix_translate:to_ag;

--------------------------------------------------

attribute ag_expr occurs on Matcher; -- only to be used by filterConstraint

attribute ag_funs occurs on Matcher;
propagate ag_funs on Matcher;

--attribute ag_pattern occurs on Matcher;
--attribute ag_whereClause occurs on Matcher;

attribute nonAttrs occurs on Matcher;

monoid attribute nonAttrsSyn::[String] with [], ++ occurs on Matcher;
propagate nonAttrsSyn on Matcher;

synthesized attribute 
  ag_pattern_and_where::(AG_Pattern, AG_Expr, Maybe<([(String, String, Integer, AG_Type)], Integer)>) 
occurs on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{
  local arg_name::String = "lambda_" ++ toString(genInt()) ++ "_arg";

  local ag_case::AG_Expr = 
    caseExpr(
      nameExpr(arg_name),
      agCasesCons(
        agCase (p.ag_pattern, nilWhereClauseAG(), wc.ag_expr),             -- match
        agCasesCons(
          agCase(agPatternUnderscore(), nilWhereClauseAG(), falseExpr()), -- no match
          agCasesNil()
        )
      )
    ); 

  top.ag_pattern_and_where = (p.ag_pattern, ^wcExprReal, p.datumInhArgs);

  top.ag_expr = lambdaExpr ([(arg_name, p.ag_type)], ^ag_case);

  wc.nonAttrs = top.nonAttrs ++ p.nonAttrsSyn;

  local wcExprReal::AG_Expr =
    case p.datumInhArgs of
    | just((lst, len)) -> foldr (
        \arg::(String, String, Integer, AG_Type) acc::AG_Expr ->
          acc.renameDatumArg(arg.1, arg.2, arg.3, len),
        wc.ag_expr,
        lst
      )
    | _ -> wc.ag_expr
    end;

  --top.ag_pattern = p.ag_pattern;
  --top.ag_whereClause = wc.ag_whereClause;
}

--------------------------------------------------

synthesized attribute ag_pattern::AG_Pattern occurs on Pattern;
attribute ag_type {- :: AG_Type -} occurs on Pattern;

attribute nonAttrsSyn occurs on Pattern;
propagate nonAttrsSyn on Pattern;

synthesized attribute datumInhArgs::Maybe<([(String, String, Integer, AG_Type)], Integer)> occurs on Pattern;

aspect production labelPattern
top::Pattern ::= lab::Label
{
  top.ag_pattern = agPatternApp(lab.name, []);
  top.ag_type = labelTypeAG();
  top.datumInhArgs = nothing();
}

aspect production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{
  top.ag_pattern = agPatternApp(lab.name, [p.ag_pattern]);
  top.ag_type = labelTypeAG();
  top.datumInhArgs = nothing();
}

aspect production namePattern
top::Pattern ::= name::String ty::TypeAnn
{
  top.ag_pattern = agPatternName(name);
  top.ag_type = ty.ag_type;
  top.nonAttrsSyn <- [name];
  top.datumInhArgs = nothing();
}

aspect production constructorPattern
top::Pattern ::= name::String ps::PatternList ty::TypeAnn
{
  top.ag_pattern = 
    case ty of 
      nameTypeAnn("datum") -> agPatternApp(name, ps.patternListHeadList.ag_patterns)
    | _ -> agPatternApp(name, ps.ag_patterns)
    end;
  
  top.ag_type = ty.ag_type;

  top.datumInhArgs =
    case ty of 
      nameTypeAnn("datum") ->
        let psTail::PatternList = ps.patternListTail 
        in
        let namesTys::[(String, Type)] = psTail.nameTyDeclsSyn
        in
        let namesTysWithPos::[(String, Integer, Type)] = 
              foldr(
                \pair::(String, Type) acc::(Integer, [(String, Integer, Type)]) -> 
                  (acc.1 + 1, (pair.1, length(namesTys) - acc.1, pair.2)::acc.2), 
                (0, []), 
                namesTys
              ).2
        in
          just (
            (
              map (
                \nty::(String, Integer, Type) -> 
                  (name, nty.1, nty.2, nty.3.ag_type), 
                namesTysWithPos
              ),
              ps.len - 1
            )
          )
        end end end
    | _ -> nothing()
    end;
}

aspect production consPattern
top::Pattern ::= p1::Pattern p2::Pattern
{
  top.ag_pattern = agPatternCons(p1.ag_pattern, p2.ag_pattern);
  top.ag_type = listTypeAG(p1.ag_type);
  top.datumInhArgs = nothing();
}

aspect production nilPattern
top::Pattern ::=
{
  top.ag_pattern = agPatternNil();
  top.ag_type = listTypeAG(varTypeAG());
  top.datumInhArgs = nothing();
}

aspect production tuplePattern
top::Pattern ::= ps::PatternList
{
  top.ag_pattern = agPatternTuple(ps.ag_patterns);
  top.ag_type = tupleTypeAG(ps.ag_types);
  top.datumInhArgs = nothing();
}

aspect production underscorePattern
top::Pattern ::= ty::TypeAnn
{
  top.ag_pattern = agPatternUnderscore();
  top.ag_type = ty.ag_type;
  top.datumInhArgs = nothing();
}

--------------------------------------------------

synthesized attribute ag_patterns::[AG_Pattern] occurs on PatternList;
synthesized attribute ag_types::[AG_Type] occurs on PatternList;

synthesized attribute patternListHeadList::PatternList occurs on PatternList;
synthesized attribute patternListTail::PatternList occurs on PatternList;

attribute nonAttrsSyn occurs on PatternList;
propagate nonAttrsSyn on PatternList;

synthesized attribute len::Integer occurs on PatternList;

aspect production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{
  top.ag_patterns = p.ag_pattern :: ps.ag_patterns;
  top.ag_types = p.ag_type :: ps.ag_types;
  top.patternListHeadList = patternListCons(^p, patternListNil(location=top.location), location=top.location);
  top.patternListTail = ^ps;
  top.len = 1 + ps.len;
}

aspect production patternListNil
top::PatternList ::=
{
  top.ag_patterns = [];
  top.ag_types = [];
  top.patternListHeadList = error("patternListNil.patternListHeadList");
  top.patternListTail = error("patternListNil.patternListTail");
  top.len = 0;
}