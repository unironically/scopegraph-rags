grammar statix_translate:to_ag;

--------------------------------------------------

nonterminal AG_Cases;

attribute pp occurs on AG_Cases;

synthesized attribute renameDatumArgCases::(AG_Cases ::= String String Integer Integer) occurs on AG_Cases;

abstract production agCasesCons
top::AG_Cases ::= c::AG_Case cs::AG_Cases
{
  top.pp = "agCasesCons(" ++ c.pp ++ ", " ++ cs.pp ++ ")";
  top.renameDatumArgCases = \dt::String arg::String pos::Integer len::Integer ->
    agCasesCons(c.renameDatumArgCase(dt, arg, pos, len),
                cs.renameDatumArgCases(dt, arg, pos, len));
}

abstract production agCasesOne
top::AG_Cases ::= c::AG_Case
{
  top.pp = "agCasesOne(" ++ c.pp ++ ")";
  top.renameDatumArgCases = \dt::String arg::String pos::Integer len::Integer ->
    agCasesOne(c.renameDatumArgCase(dt, arg, pos, len));
}

abstract production agCasesNil
top::AG_Cases ::=
{
  top.pp = "agCasesNil()";
  top.renameDatumArgCases = \_ _ _ _ -> ^top;
}

--------------------------------------------------

nonterminal AG_Case;

attribute pp occurs on AG_Case;

synthesized attribute renameDatumArgCase::(AG_Case ::= String String Integer Integer) occurs on AG_Case;

abstract production agCase
top::AG_Case ::= pat::AG_Pattern wc::AG_WhereClause body::AG_Expr
{
  top.pp = "agCase(" ++
    pat.pp ++ ", " ++
    wc.pp ++ ", " ++
    body.pp ++
  ")";

  top.renameDatumArgCase = \dt::String arg::String pos::Integer len::Integer ->
    agCase(^pat, ^wc, body.renameDatumArg(dt, arg, pos, len));
}