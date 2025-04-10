grammar statix_translate:to_silver;

--------------------------------------------------

nonterminal AG_Expr;

attribute pp occurs on AG_Expr;

abstract production trueExpr
top::AG_Expr ::=
{
  top.pp = "trueExpr()";
}

abstract production falseExpr
top::AG_Expr ::=
{
  top.pp = "falseExpr()";
}

abstract production intExpr
top::AG_Expr ::= i::Integer
{
  top.pp = "intExpr(" ++ toString(i) ++ ")";
}

abstract production stringExpr
top::AG_Expr ::= s::String
{
  top.pp = "stringExpr(" ++ s ++ ")";
}

abstract production eqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.pp = "eqExpr(" ++ l.pp ++ ", " ++ r.pp ++ ")";
}

abstract production neqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.pp = "neqExpr(" ++ l.pp ++ ", " ++ r.pp ++ ")";
}

abstract production appExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{
  top.pp = "appExpr(" ++ name ++ ", [" ++ implode(", ", map((.pp), args)) ++ "])";
}

abstract production nameExpr
top::AG_Expr ::= name::String
{
  top.pp = "nameExpr(" ++ name ++ ")";
}

abstract production qualExpr
top::AG_Expr ::= pre::AG_Expr name::String
{
  top.pp = "qualExpr(" ++ pre.pp ++ ", " ++ name ++ ")";
}

abstract production andExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.pp = "andExpr(" ++ l.pp ++ ", " ++ r.pp ++ ")";
}

abstract production caseExpr
top::AG_Expr ::= e::AG_Expr cases::AG_Cases
{
  top.pp = "caseExpr(" ++ e.pp ++ ", " ++ cases.pp ++ ")";
}

abstract production demandExpr
top::AG_Expr ::= lhs::AG_LHS attr::String
{
  top.pp = "demandExpr(" ++ lhs.pp ++ ", " ++ attr ++ ")";
}

abstract production lambdaExpr
top::AG_Expr ::= args::[(String, AG_Type)] body::AG_Expr
{
  top.pp = "lambdaExpr([" ++ implode(", ", map(\p::(String, AG_Type) -> "(" ++ p.1 ++ ", " ++ p.2.pp ++ ")", args)) ++ "], " ++ body.pp ++ ")";
}

abstract production tupleExpr
top::AG_Expr ::= es::[AG_Expr]
{
  top.pp = "tupleExpr([" ++ implode(", ", map((.pp), es)) ++ "])";
}

abstract production consExpr
top::AG_Expr ::= h::AG_Expr  t::AG_Expr
{
  top.pp = "consExpr(" ++ h.pp ++ ", " ++ t.pp ++ ")";
}

abstract production nilExpr
top::AG_Expr ::=
{
  top.pp = "nilExpr()";
}

abstract production tupleSectionExpr
top::AG_Expr ::= tup::AG_Expr i::Integer
{
  top.pp = "tupleSectionExpr(" ++ tup.pp ++ ", " ++ toString(i) ++ ")";
}

abstract production termExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{
  top.pp = "termExpr(" ++ name ++ ", [" ++ implode(", ", map((.pp), args)) ++ "])";
}

--------------------------------------------------

nonterminal AG_Exprs;

attribute pp occurs on AG_Exprs;

abstract production consExprs
top::AG_Exprs ::= hd::AG_Expr tl::AG_Exprs
{
  top.pp = "consExprs(" ++ hd.pp ++ ", " ++ tl.pp ++ ")";
}

abstract production nilExprs
top::AG_Exprs ::=
{
  top.pp = "nilExprs()";
}