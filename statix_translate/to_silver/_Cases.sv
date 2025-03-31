grammar statix_translate:to_silver;

--------------------------------------------------

nonterminal AG_Cases;

abstract production agCasesCons
top::AG_Cases ::= c::AG_Case cs::AG_Cases
{}

abstract production agCasesOne
top::AG_Cases ::= c::AG_Case
{}

abstract production agCasesNil
top::AG_Cases ::=
{}

--------------------------------------------------

nonterminal AG_Case;

abstract production agCase
top::AG_Case ::= pat::AG_Pattern wc::Maybe<ag_whereClause> body::AG_Expr
{}