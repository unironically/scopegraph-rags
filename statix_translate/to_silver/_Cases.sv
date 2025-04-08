grammar statix_translate:to_silver;

--------------------------------------------------

nonterminal AG_Cases;

attribute pp occurs on AG_Cases;

abstract production agCasesCons
top::AG_Cases ::= c::AG_Case cs::AG_Cases
{
  top.pp = "agCasesCons(" ++ c.pp ++ ", " ++ cs.pp ++ ")";
}

abstract production agCasesOne
top::AG_Cases ::= c::AG_Case
{
  top.pp = "agCasesOne(" ++ c.pp ++ ")";
}

abstract production agCasesNil
top::AG_Cases ::=
{
  top.pp = "agCasesNil()";
}

--------------------------------------------------

nonterminal AG_Case;

attribute pp occurs on AG_Case;

abstract production agCase
top::AG_Case ::= pat::AG_Pattern wc::AG_WhereClause body::AG_Expr
{
  top.pp = "agCase(" ++
    pat.pp ++ ", " ++
    wc.pp ++ ", " ++
    body.pp ++
  ")";
}