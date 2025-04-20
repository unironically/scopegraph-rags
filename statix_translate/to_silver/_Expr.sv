grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_expr::String occurs on AG_Expr;

aspect production trueExpr
top::AG_Expr ::=
{
  top.silver_expr = "true";
}

aspect production falseExpr
top::AG_Expr ::=
{
  top.silver_expr = "false";
}

aspect production intExpr
top::AG_Expr ::= i::Integer
{
  top.silver_expr = toString(i);
}

aspect production stringExpr
top::AG_Expr ::= s::String
{
  top.silver_expr = str(s);
}

aspect production eqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.silver_expr = l.silver_expr ++ " == " ++ r.silver_expr;
}

aspect production neqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.silver_expr = l.silver_expr ++ " != " ++ r.silver_expr;
}

aspect production appExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{
  top.silver_expr = preProd ++ name ++ "(" ++ implode(", ", map((.silver_expr), args)) ++ ")";
}

aspect production nameExpr
top::AG_Expr ::= name::String
{
  top.silver_expr = name;
}

aspect production andExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.silver_expr = l.silver_expr ++ " && " ++ r.silver_expr;
}

aspect production caseExpr
top::AG_Expr ::= e::AG_Expr cases::AG_Cases
{
  top.silver_expr = "case " ++ e.silver_expr ++ " of " ++ 
                      implode(" | ", cases.silver_cases) ++
                    " end";
}

aspect production demandExpr
top::AG_Expr ::= lhs::AG_Expr attr::String
{
  top.silver_expr = lhs.silver_expr ++ "." ++ attr;
}

aspect production lambdaExpr
top::AG_Expr ::= args::[(String, AG_Type)] body::AG_Expr
{
  top.silver_expr = 
    "\\" ++ implode(" ", 
                   map(\arg::(String, AG_Type) -> arg.1 ++ "::" ++ 
                                                  arg.2.silver_type, args)) ++
    " -> " ++ body.silver_expr;
}

aspect production tupleExpr
top::AG_Expr ::= es::[AG_Expr]
{
  top.silver_expr = "(" ++ implode(", ", map((.silver_expr), es)) ++ ")";
}

aspect production consExpr
top::AG_Expr ::= h::AG_Expr  t::AG_Expr
{
  top.silver_expr = h.silver_expr ++ "::" ++ t.silver_expr;
}

aspect production nilExpr
top::AG_Expr ::=
{
  top.silver_expr = "[]";
}

aspect production tupleSectionExpr
top::AG_Expr ::= tup::AG_Expr i::Integer
{
  top.silver_expr = tup.silver_expr ++ "." ++ toString(i);
}

aspect production termExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{
  top.silver_expr = preProd ++ name ++ "(" ++ implode(", ", map((.silver_expr), args)) ++ ")";
}

aspect production abortExpr
top::AG_Expr ::= msg::String
{
  top.silver_expr = "error(\"" ++ msg ++ "\")";
}

aspect production letExpr
top::AG_Expr ::= name::String ty::AG_Type bind::AG_Expr body::AG_Expr
{
  top.silver_expr = "let " ++ name ++ "::" ++ ty.silver_type ++ 
                                      " = " ++ bind.silver_expr ++ 
                                      " in " ++ body.silver_expr ++ " end";
}

aspect production ifExpr
top::AG_Expr ::= c::AG_Expr e1::AG_Expr e2::AG_Expr
{
  top.silver_expr = "if " ++ c.silver_expr ++ " then " ++ e1.silver_expr ++ 
                                              " else " ++ e2.silver_expr;
}

--------------------------------------------------

synthesized attribute silver_exprs::[String] occurs on AG_Exprs;

aspect production consExprs
top::AG_Exprs ::= hd::AG_Expr tl::AG_Exprs
{
  top.silver_exprs = hd.silver_expr :: tl.silver_exprs;
}

aspect production nilExprs
top::AG_Exprs ::=
{
  top.silver_exprs = [];
}