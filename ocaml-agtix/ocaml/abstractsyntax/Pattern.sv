grammar ocaml:abstractsyntax;

--

-- Scope of the entire case, to be given to expr RHS
scope attribute s_case;

--

-- Expected type of a pattern tree
inherited attribute patternType::Type;

--

nonterminal Cases with errs, s, patternType, expectExprType, location, type;

production casesCons
top::Cases ::= p::Pattern e::Expr rest::Cases
{
  -- Scope for this case
  newScope caseScope;
  caseScope -[ `lex ]-> top.s;

  p.s = caseScope;
  p.patternType = top.patternType;

  e.s = caseScope;
  e.expectExprType = top.expectExprType;

  rest.s = top.s;
  rest.patternType = top.patternType;
  rest.expectExprType = top.expectExprType;

  top.errs :=
    if !null(p.errs) then p.errs
    else if !null(e.errs) then e.errs
    else rest.errs;

  top.type = e.type;
}

production casesOne
top::Cases ::= p::Pattern e::Expr
{
  -- Scope for this case
  newScope caseScope;

  -- Point to lexical parent of match expression
  caseScope -[ `lex ]-> top.s;

  p.s = caseScope;
  p.patternType = top.patternType;

  e.s = caseScope;
  e.expectExprType = top.expectExprType;

  top.errs :=
    if !null(p.errs) then p.errs
    else e.errs;

  top.type = e.type;
}

--

nonterminal Pattern with errs, s, patternType, location;

production patternAny
top::Pattern ::=
{
  propagate errs;
}

production patternOr
top::Pattern ::= p1::Pattern p2::Pattern
{  
  newScope s_or1;

  top.s -[ `or ]-> s_or1;
  s_or1 -[ `plex ]-> top.s;

  local onlyOnOneSide::[String] = 
    let getNamesFromSide::([String] ::= Decorated Pattern) =
      \p::Decorated Pattern ->
        map(\s::Decorated Scope with Labs -> s.datum.name,
            query((`comma (`comma | `or)*)? `var, any(), p.s)) in
    let varsBoth::([String], [String]) = (getNamesFromSide(p1), getNamesFromSide(p2)) in
      removeAll(intersect(varsBoth.1, varsBoth.2), union(varsBoth.1, varsBoth.2))
    end end;

  p1.s = s_or1;
  p1.patternType = top.patternType;

  p2.s = top.s;
  p2.patternType = top.patternType;

  top.errs :=
    if !null(p1.errs) then p1.errs
    else if !null(p2.errs) then p2.errs
    else if !null(onlyOnOneSide)
    then [err("Variable " ++ head(onlyOnOneSide) ++
              " must occur on both sides of this | pattern", top.location)]
    else [];

}

production patternComma
top::Pattern ::= p1::Pattern p2::Pattern
{
  newScope commaLeft;
  top.s -[ `comma ]-> commaLeft;
  commaLeft -[ `plex ]-> top.s;

  newScope commaRight;
  top.s  -[ `comma ]-> commaRight;
  commaRight -[ `plex ]-> top.s;
  commaRight -[ `left ]-> commaLeft;

  local badPatternType::(Maybe<Message>, Type, Type) =
    case top.patternType of
    | tupleType(t1, t2) -> (nothing(), ^t1, ^t2)
    | _ -> (just(err("Pattern matches values of type 'a * 'b" ++
                     " but a pattern was expected which matches values of type " ++
                     top.patternType.pp, top.location)), errType(), errType())
    end;

  p1.s = commaLeft;
  p1.patternType = badPatternType.2;

  p2.s = commaRight;
  p2.patternType = badPatternType.3;

  top.errs :=
    if badPatternType.1.isJust then [badPatternType.1.fromJust]
    else if !null(p1.errs) then p1.errs
    else if !null(p2.errs) then p2.errs
    else [];
}

production patternApp
top::Pattern ::= t::String p::Pattern
{
  local constructors::[Decorated Scope with Labs] =
    query(`plex* `lex* `ty `con, isName(t), top.s);

  nondecorated local conArgsType::Type = 
    if !null(constructors)
    then case head(constructors).datum of
           datumConstructor(_, _, node) -> node.type
         | _ -> errType()
         end
    else errType();
  
  p.s = top.s;
  p.patternType = conArgsType;

  top.errs :=
    if null(constructors)
    then [err("Pattern matches values of type " ++ top.patternType.pp ++
              " but there is no constructor " ++ t ++ " within type " ++
              top.patternType.pp, top.location)]
    else p.errs;
}

production patternAnno
top::Pattern ::= p::Pattern te::TypeExpr
{
  p.s = top.s;
  p.patternType = te.type;

  te.s = top.s;

  top.errs :=
    if top.patternType != te.type
    then [err("Pattern matches values of type " ++ te.type.pp ++
              " but a pattern was expected which matches values of type " ++
              top.patternType.pp, top.location)]
    else if !null(p.errs) then p.errs
    else te.errs;  
}

production patternConstant
top::Pattern ::= c::Constant
{
  top.errs := 
    if c.type != top.patternType
    then [err("Pattern constant expected to have type " ++ top.patternType.pp ++
              ", but has type " ++ c.type.pp, top.location)]
    else [];
}

production patternName
top::Pattern ::= t::String
{
  -- scope graph declaration node for this pattern variable
  newScope s_patt -> datumPatternVar(t, top);

  -- `var edge from pattern scope
  top.s -[ `var ]-> s_patt;

  -- look for variables in other OR-pattern branch
  local orVars::[Decorated Scope with Labs] =
    query(`plex* `or (`comma (`comma | `or)*)? `var, isName(t), top.s);

  -- does variable have same type as corresponding variable in other OR branch
  local otherVarType::Maybe<Type> =
    if !null(orVars)
    then case head(orVars).datum of
           datumPatternVar(_, node) -> just(node.patternType)
         | _ -> nothing()
         end
    else nothing();

  -- is variable declared twice in same OR branch
  local multipleVarDef::Boolean =
    !null(query(`plex* `left (`comma | `or)* `var, isName(t), top.s));

  top.errs :=
    if multipleVarDef
    then [err("Variable " ++ t ++ " bound several times in this matching", top.location)]
    else if otherVarType.isJust && top.patternType != otherVarType.fromJust
    then [err("Variable " ++ t ++ " on the left-hand side of this or-pattern has type " ++
              otherVarType.fromJust.pp ++ " but on the right-hand side it has type " ++
              top.patternType.pp, top.location)]
    else [];
}
