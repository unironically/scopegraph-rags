grammar statix_translate:translation;

{- Convert lambdas to top-level defined Silver functions, which we reference
 - where in the Statix spec the lambda is used.
 -}

--------------------------------------------------

synthesized attribute lambdaTrans::String occurs on Lambda;
synthesized attribute lambdaName::String occurs on Lambda;

attribute knownFuncPreds occurs on Lambda;
propagate knownFuncPreds on Lambda;

attribute knownNonterminals occurs on Lambda;
propagate knownNonterminals on Lambda;

attribute namesInScope occurs on Lambda;

attribute isFunctionalPred occurs on Lambda;
propagate isFunctionalPred on Lambda;

aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{
  c.localScopes = c.localScopesSyn;

  -- unique name for this lambda
  local lambdaName::String = "lambda_" ++ toString(genInt());

  -- defaulting to `true` if where clause guard is not satisfied
  local ret::String = 
    let oks::String = implode ("&&", c.okNames) in
      case wc.whereClauseTrans of
      | nothing() -> oks
      | just(s)   -> "(" ++ oks ++ ") || !(" ++ s ++ ")"
      end
    end;

  top.lambdaTrans =
    "function " ++ lambdaName ++ " " ++
      "Boolean ::= " ++ arg ++ "::" ++ ty.typeTrans ++ 
    "{" ++
      c.constraintTrans ++
      "return " ++ ret ++ ";" ++
    "}";

  top.lambdaName = lambdaName;

  c.namesInScope = (arg, ^ty)::top.namesInScope;
}

--------------------------------------------------

synthesized attribute whereClauseTrans::Maybe<String> occurs on WhereClause;

aspect production nilWhereClause
top::WhereClause ::=
{
  top.whereClauseTrans = nothing();
}

aspect production withWhereClause
top::WhereClause ::= gl::GuardList
{
  top.whereClauseTrans = just(implode ("&&", gl.guardTransList));
}

--------------------------------------------------

synthesized attribute guardTrans::String occurs on Guard; -- expression

aspect production eqGuard
top::Guard ::= t1::Term t2::Term
{
  top.guardTrans = t1.termTrans ++ " == " ++ t2.termTrans;
}

aspect production neqGuard
top::Guard ::= t1::Term t2::Term
{
  top.guardTrans = t1.termTrans ++ " != " ++ t2.termTrans;
}

--------------------------------------------------

synthesized attribute guardTransList::[String] occurs on GuardList;

aspect production guardListCons
top::GuardList ::= g::Guard gl::GuardList
{
  top.guardTransList = g.guardTrans :: gl.guardTransList;
}

aspect production guardListOne
top::GuardList ::= g::Guard
{
  top.guardTransList = [g.guardTrans];
}