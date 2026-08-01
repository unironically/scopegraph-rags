grammar ocaml:abstractsyntax;

--

nonterminal TypeExpr with errs, type, s, location;

production typeExprName
top::TypeExpr ::= t::String
{
  local types::[Decorated Scope with Labs] =
    query(`lex* `ty, isName(t), top.s);

  top.errs :=
    case types of
    | _::[] -> []
    | _::_  -> [err("ambiguous type reference " ++ t, top.location)]
    | []    -> [err("unresolvable type reference " ++ t, top.location)]
    end;

  top.type =
    if null(top.errs)
    then nameType(t)
    else errType();
}

{-
production typeExprUnderscore
top::TypeExpr ::=
{
  propagate errs;
}

production typeExprVar
top::TypeExpr ::= t::String
{}
-}

--

{-
nonterminal TypeExprs with s;

production typeExprsCons
top::TypeExprs ::= te::TypeExpr ts::TypeExprs
{
  te.s = top.s;

  ts.s = top.s;
}

production typeExprsOne
top::TypeExprs ::= te::TypeExpr
{
  te.s = top.s;
}
-}
