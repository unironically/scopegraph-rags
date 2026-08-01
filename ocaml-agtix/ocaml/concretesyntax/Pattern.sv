grammar ocaml:concretesyntax;

-- https://ocaml.org/manual/5.4/patterns.html

--------
-- Rules

nonterminal PatternListRoot_c with ast<Cases>, location;

concrete production patternListRoot1_c
top::PatternListRoot_c ::= ps::Cases_c
{ top.ast = ps.ast; }

concrete production patternListRoot2_c
top::PatternListRoot_c ::= '|' ps::Cases_c
{ top.ast = ps.ast; }

--

nonterminal Cases_c with ast<Cases>, location;

concrete production casesCons_c
top::Cases_c ::= p::Pattern_c '->' e::Expr_c '|' rest::Cases_c
{ top.ast = casesCons(p.ast, e.ast, rest.ast, location=top.location); }

concrete production casesOne_c
top::Cases_c ::= p::Pattern_c '->' e::Expr_c
{ top.ast = casesOne(p.ast, e.ast, location=top.location); }

--

nonterminal Pattern_c with ast<Pattern>, location;

concrete production patternOr_c
top::Pattern_c ::= p1::Pattern_c '|' p2::PatternComma_c
{ top.ast = patternOr(p1.ast, p2.ast, location=top.location); }

concrete production patternCommaChild_c
top::Pattern_c ::= p::PatternComma_c
{ top.ast = p.ast; }

--

nonterminal PatternComma_c with ast<Pattern>, location;

concrete production patternComma_c
top::PatternComma_c ::= p1::PatternComma_c ',' p2::PatternCons_c
{ top.ast = patternComma(p1.ast, p2.ast, location=top.location); }

concrete production patternConsChild_c
top::PatternComma_c ::= p::PatternCons_c
{ top.ast = p.ast; }

--

nonterminal PatternCons_c with ast<Pattern>, location;

--concrete production patternCons_c
--top::PatternCons_c ::= p1::PatternAtom_c '::' p2::PatternCons_c
--{ top.ast = patternCons(p1.ast, p2.ast); }

concrete production patternAppChild_c
top::PatternCons_c ::= p::PatternApp_c
{ top.ast = p.ast; }

--

nonterminal PatternApp_c with ast<Pattern>, location;

concrete production patternApp_c
top::PatternApp_c ::= t::IdentifierUpper_t App_t p::PatternAtom_c
{ top.ast = patternApp(t.lexeme, p.ast, location=top.location); }

concrete production patternAtomChild_c
top::PatternApp_c ::= p::PatternAtom_c
{ top.ast = p.ast; }

--

nonterminal PatternAtom_c with ast<Pattern>, location;

concrete production patternAny_c
top::PatternAtom_c ::= '_'
{ top.ast = patternAny(location=top.location); }

concrete production patternConstant_c
top::PatternAtom_c ::= c::Constant_c
{ top.ast = patternConstant(c.ast, location=top.location); }

concrete production patternName_c
top::PatternAtom_c ::= t::Identifier_t
{ top.ast = patternName(t.lexeme, location=top.location); }

concrete production patternParens_c
top::PatternAtom_c ::= '(' p::Pattern_c ')'
{ top.ast = p.ast; }

concrete production patternAnno_c
top::PatternAtom_c ::= '(' p::Pattern_c ':' te::TypeExpr_c ')'
{ top.ast = patternAnno(p.ast, te.ast, location=top.location); }

--concrete production patternList_c
--top::PatternAtom_c ::= '[' ps::PatternsSemiColon_c ']'
--{ top.ast = patternList(ps.ast); }

--

{-
nonterminal PatternsSemiColon_c with ast<PatternsSemiColon>;

concrete production patternSubListCons_c
top::PatternsSemiColon_c ::= p::Pattern_c ';' ps::PatternsSemiColon_c
{ top.ast = patternSubListCons(p.ast, ps.ast); }

concrete production patternSubListOne_c
top::PatternsSemiColon_c ::= p::Pattern_c
{ top.ast = patternSubListOne(p.ast); }

concrete production patternSubListNil_c
top::PatternsSemiColon_c ::=
{ top.ast = patternSubListNil(); }
-}