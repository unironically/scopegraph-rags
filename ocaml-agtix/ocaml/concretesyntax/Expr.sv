grammar ocaml:concretesyntax;

-- https://ocaml.org/manual/5.4/expr.html

--------
-- Rules

nonterminal Constant_c with ast<Constant>, location;

concrete production constantInt_c
top::Constant_c ::= t::Int_t
{ top.ast = intConstant(toInteger(t.lexeme), location=top.location); }

concrete production constantString_c
top::Constant_c ::= t::String_t
{ top.ast = stringConstant(t.lexeme, location=top.location); }

concrete production constantTrue_c
top::Constant_c ::= t::True_t
{ top.ast = boolConstant(true, location=top.location); }

concrete production constantFalse_c
top::Constant_c ::= t::False_t
{ top.ast = boolConstant(false, location=top.location); }

--

nonterminal Expr_c with ast<Expr>, location;

concrete production exprLet_c
top::Expr_c ::= 'let' lb::LetBinding_c 'in' e::Expr_c
{ top.ast = letExpr(lb.ast, e.ast, location=top.location); }

concrete production exprMatch_c
top::Expr_c ::= 'match' c::Expr_c 'with' ps::PatternListRoot_c
{ top.ast = matchExpr(c.ast, ps.ast, location=top.location); }

--concrete production exprIf_c
--top::Expr_c ::= 'if' c::Expr_c 'then' t::Expr_c 'else' e::Expr_c
--{ top.ast = ifExpr(c.ast, t.ast, e.ast); }

concrete production exprName_c
top::Expr_c ::= t::Identifier_t
{ top.ast = nameExpr(t.lexeme, location=top.location); }

concrete production exprConstant_c
top::Expr_c ::= c::Constant_c
{ top.ast = constantExpr(c.ast, location=top.location); }

--concrete production exprListLiteral_c
--top::Expr_c ::= '[' es::Exprs_c ']'
--{ top.ast = listExpr(es.ast); }

concrete production exprConstructorApp_c
top::Expr_c ::= t::IdentifierUpper_t App_t e::Expr_c
{ top.ast = constructorAppExpr(t.lexeme, e.ast, location=top.location); }

concrete production exprComma_c
top::Expr_c ::= e1::Expr_c ',' e2::Expr_c
{ top.ast = commaExpr(e1.ast, e2.ast, location=top.location); }

concrete production exprParens_c
top::Expr_c ::= '(' e::Expr_c ')'
{ top.ast = e.ast; }

--

{-
nonterminal Exprs_c with ast<Exprs>;

concrete production exprListCons_c
top::Exprs_c ::= e::Expr_c ';' es::Exprs_c
{ top.ast = consExprs(e.ast, es.ast); }

concrete production exprListOne_c
top::Exprs_c ::= e::Expr_c
{ top.ast = oneExprs(e.ast); }

concrete production exprListNil_c
top::Exprs_c ::=
{ top.ast = nilExprs(); }
-}
