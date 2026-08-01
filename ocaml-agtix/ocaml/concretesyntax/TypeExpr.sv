grammar ocaml:concretesyntax;

-- https://ocaml.org/manual/5.4/types.html

--------
-- Rules

nonterminal TypeExpr_c with ast<TypeExpr>, location;

--concrete production typeExprArrow_c
--top::TypeExpr_c ::= te1::TypeExprApp_c '->' te2::TypeExpr_c
--{ top.ast = typeExprArrow(te1.ast, te2.ast); }

concrete production typeExprApp_c
top::TypeExpr_c ::= te::TypeExprApp_c
{ top.ast = te.ast; }

--

nonterminal TypeExprApp_c with ast<TypeExpr>, location;

--concrete production typeExprParensConstr_c
--top::TypeExprApp_c ::= '(' t1::TypeExpr_c ',' ts::TypeExprs_c ')' App_t t::Identifier_t
--{ top.ast = typeExprConstr(typeExprsCons(t1.ast, ts.ast), t.lexeme); }

--concrete production typeExprConstr_c
--top::TypeExprApp_c ::= {-te::TypeExprAtom_c App_t-} t::Identifier_t
--{ top.ast = typeExprConstr({-typeExprsOne(te.ast),-} t.lexeme); }

concrete production typeExpr_c
top::TypeExprApp_c ::= te::TypeExprAtom_c
{ top.ast = te.ast; }

--

nonterminal TypeExprAtom_c with ast<TypeExpr>, location;

concrete production typeExprName_c
top::TypeExprAtom_c ::= t::Identifier_t
{ top.ast = typeExprName(t.lexeme, location=top.location); }

--concrete production typeExprUnderscore_c
--top::TypeExprAtom_c ::= '_'
--{ top.ast = typeExprUnderscore(); }

concrete production typeExprParens_c
top::TypeExprAtom_c ::= '(' te::TypeExpr_c ')'
{ top.ast = te.ast; }

--concrete production typeExprVar_c
--top::TypeExprAtom_c ::= Tick_t t::Identifier_t
--{ top.ast = typeExprVar(t.lexeme); }

--

{-
nonterminal TypeExprs_c with ast<TypeExprs>;

concrete production typeExprsCons_c
top::TypeExprs_c ::= te::TypeExpr_c ',' ts::TypeExprs_c
{ top.ast = typeExprsCons(te.ast, ts.ast); }

concrete production typeExprsOne_c
top::TypeExprs_c ::= te::TypeExpr_c
{ top.ast = typeExprsOne(te.ast); }
-}