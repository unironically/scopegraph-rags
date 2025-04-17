grammar statix_translate:to_ocaml;

--------------------------------------------------

synthesized attribute ocaml_expr::String occurs on AG_Expr;

aspect production trueExpr
top::AG_Expr ::=
{
  top.ocaml_expr = "Bool(true)";
}

aspect production falseExpr
top::AG_Expr ::=
{
  top.ocaml_expr = "Bool(false)";
}

aspect production intExpr
top::AG_Expr ::= i::Integer
{
  top.ocaml_expr = "Int(" ++ toString(i) ++ ")";
}

aspect production stringExpr
top::AG_Expr ::= s::String
{
  top.ocaml_expr = "String(\"" ++ s ++ "\")";
}

aspect production eqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.ocaml_expr = "Equal(" ++ l.ocaml_expr ++ ", " ++ r.ocaml_expr ++ ")";
}

aspect production neqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.ocaml_expr = "NotEqual(" ++ l.ocaml_expr ++ ", " ++ r.ocaml_expr ++ ")";
}

aspect production appExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{
  top.ocaml_expr =
    "AttrRef(TermE(" ++
        "TermT(" ++ str(name) ++ ", [" ++
          implode("; ", map((.ocaml_expr), args)) ++
        "])), \"ret\")";
}

aspect production nameExpr
top::AG_Expr ::= name::String
{
  top.ocaml_expr = "VarE(" ++ str(name) ++ ")";
}

aspect production andExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.ocaml_expr = "And(" ++ l.ocaml_expr ++ ", " ++ r.ocaml_expr ++ ")";
}

aspect production caseExpr
top::AG_Expr ::= e::AG_Expr cases::AG_Cases
{
  top.ocaml_expr = "Case(" ++
    e.ocaml_expr ++ ", [" ++
    implode("; ", cases.ocaml_cases) ++
  "])";
}

aspect production demandExpr
top::AG_Expr ::= lhs::AG_Expr attr::String
{
  top.ocaml_expr = "AttrRef(" ++ lhs.ocaml_expr ++ ", " ++ str(attr) ++ ")"; 
}

aspect production lambdaExpr
top::AG_Expr ::= args::[(String, AG_Type)] body::AG_Expr
{
  top.ocaml_expr = 
    foldr((\arg::(String, AG_Type) accOcaml::String ->
             "Fun(" ++ str(arg.1) ++ ", " ++ accOcaml ++ ")"),
          body.ocaml_expr, args);
}

aspect production tupleExpr
top::AG_Expr ::= es::[AG_Expr]
{
  top.ocaml_expr = "Tuple([" ++ implode("; ", map((.ocaml_expr), es)) ++ "])";
}

aspect production consExpr
top::AG_Expr ::= h::AG_Expr  t::AG_Expr
{
  top.ocaml_expr = "Cons(" ++ h.ocaml_expr ++ ", " ++ t.ocaml_expr ++ ")";
}

aspect production nilExpr
top::AG_Expr ::=
{
  top.ocaml_expr = "Nil";
}

aspect production tupleSectionExpr
top::AG_Expr ::= tup::AG_Expr i::Integer
{

  top.ocaml_expr = "TupleSec(" ++ tup.ocaml_expr ++ ", " ++ toString(i) ++ ")";

}

aspect production termExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{
  top.ocaml_expr = "TermE(TermT(" ++ str(name) ++ ", [" ++ implode("; ", map((.ocaml_expr), args)) ++ "]))";
}

aspect production abortExpr
top::AG_Expr ::= msg::String
{
  top.ocaml_expr = "Abort(" ++ str(msg) ++ ")";
}

aspect production letExpr
top::AG_Expr ::= name::String bind::AG_Expr body::AG_Expr
{
  top.ocaml_expr = "Let(" ++ str(name) ++ ", " ++ bind.ocaml_expr ++ ", " ++ body.ocaml_expr ++ ")";
}

aspect production ifExpr
top::AG_Expr ::= c::AG_Expr e1::AG_Expr e2::AG_Expr
{
  top.ocaml_expr = "If(" ++ c.ocaml_expr ++ ", " ++ e1.ocaml_expr ++ ", " ++ e2.ocaml_expr ++ ")";
}

--------------------------------------------------

synthesized attribute ocaml_exprs::[String] occurs on AG_Exprs;

aspect production consExprs
top::AG_Exprs ::= hd::AG_Expr tl::AG_Exprs
{
  top.ocaml_exprs = hd.ocaml_expr :: tl.ocaml_exprs;
}

aspect production nilExprs
top::AG_Exprs ::=
{
  top.ocaml_exprs = [];
}