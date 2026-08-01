grammar ocaml:abstractsyntax;

--

inherited attribute expectExprType::Type;

--

nonterminal Constant with type, pp, location;

production intConstant
top::Constant ::= i::Integer
{
  top.type = nameType("int");
  top.pp = toString(i);
}

production stringConstant
top::Constant ::= s::String
{
  top.type = nameType("string");
  top.pp = s;
}

production boolConstant
top::Constant ::= b::Boolean
{
  top.type = nameType("bool");
  top.pp = toString(b);
}

--

nonterminal Expr with errs, expectExprType, type, s, location;
propagate expectExprType on Expr excluding matchExpr, constructorAppExpr, commaExpr;

production letExpr
top::Expr ::= lb::LetBinding e::Expr
{
  existsScope s_lb;
  s_lb -[ `lex ]-> top.s;

  lb.s = top.s;
  lb.s_let = s_lb;

  e.s = s_lb;

  top.errs :=
    if !null(lb.errs)
    then lb.errs
    else e.errs;

  top.type = e.type;
}

production matchExpr
top::Expr ::= c::Expr ps::Cases
{
  c.s = top.s;
  c.expectExprType = errType();

  ps.s = top.s;
  ps.expectExprType = top.expectExprType;
  ps.patternType = c.type;

  top.errs :=
    if !null(c.errs) then c.errs
    else if top.type != top.expectExprType
    then [err("match expression has type " ++ top.type.pp ++
              " but an expression was expected of type " ++
              top.expectExprType.pp, top.location)]
    else ps.errs;
  
  top.type = ps.type;
}

production nameExpr
top::Expr ::= name::String
{
  -- Resolve name to variable declarations, may be let binds or pattern variables
  local vars::[Decorated Scope with Labs] =
    query(`lex* (`comma|`or)* `var,    -- query regex
          `var = `comma = `or < `lex,  -- label ordering - lex is least preferred
          isName(name),                -- resolution predicate
          top.s);                      -- start scope

  top.errs :=
    let resErrs::[Message] =
      case vars of
      | [_] -> []
      | _::_ -> if allPatternVar(vars)  -- ok to have multiple declarations, if all are pattern vars
                then if allSameType(vars)
                     then []
                     else [err("Mismatching types for resolution of " ++ name,
                               top.location)]
                else [err("Ambiguous value " ++ name, top.location)]
      | [] -> [err("Unresolvable value " ++ name, top.location)]
      end
    in
      if !null(resErrs) then resErrs
      else if top.type != top.expectExprType then
        [err("The value " ++ name ++ " has type " ++ top.type.pp ++
             " but an expression was expected of type " ++
             top.expectExprType.pp, top.location)]
      else []
    end;

  top.type =
    if !null(vars)
    then case head(vars).datum of
           datumPatternVar(_, node) -> node.patternType
         | datumLetVar(_, t) -> ^t
         | _ -> errType()
         end
    else errType();
}

production constantExpr
top::Expr ::= c::Constant
{
  top.errs :=
    if top.type != top.expectExprType
    then [err("The constant " ++ c.pp ++ " has type " ++ c.type.pp ++
              " but an expression was expected of type " ++
              top.expectExprType.pp, top.location)]
    else [];

  top.type = c.type;
}

production constructorAppExpr
top::Expr ::= c::String e::Expr
{
  local constructors::[Decorated Scope with Labs] =
    query(`lex* `ty `con, isName(c), top.s);

  nondecorated local conTy::Type = 
    if length(constructors) == 1
    then case head(constructors).datum of
           datumConstructor(_, _, node) -> node.type
         | _ -> errType()
         end
    else errType();

  e.s = top.s;
  e.expectExprType = conTy;

  local unresolvedErr::Maybe<Message> =
    case constructors of
    | []    -> just(err("This expression is expected to have type " ++
                        top.expectExprType.pp ++
                        " but there is no constructor " ++ c ++
                        " within type " ++ top.expectExprType.pp, top.location))
    | _::_ -> nothing()
    end;

  top.errs :=
    if unresolvedErr.isJust then [unresolvedErr.fromJust]
    else if top.type != top.expectExprType
    then [err("This constructor has type " ++ top.type.pp ++
              " but an expression was expected of type " ++
              top.expectExprType.pp, top.location)]
    else e.errs;

  top.type = 
    if !null(constructors)
    then case head(constructors).datum of
           datumConstructor(_, tname, _) -> nameType(tname)
         | _ -> errType()
         end
    else errType(); 
}

production commaExpr
top::Expr ::= e1::Expr e2::Expr
{
  local tupleTyErr::Maybe<Message> = 
    if top.type != top.expectExprType
    then just(err("This expression has type " ++ top.type.pp ++
                  " but an expression was expected of type " ++
                  top.expectExprType.pp, top.location))
    else nothing();
    
  local branchTys::(Type, Type) =
    case top.expectExprType of
    | tupleType(t1, t2) -> (^t1, ^t2)
    | _ -> (errType(), errType())
    end;

  e1.s = top.s;
  e1.expectExprType = branchTys.1;

  e2.s = top.s;
  e2.expectExprType = branchTys.2;

  top.errs :=
    if tupleTyErr.isJust then [tupleTyErr.fromJust]
    else if !null(e1.errs) then e1.errs
    else e2.errs;

  top.type = tupleType(e1.type, e2.type);
}
