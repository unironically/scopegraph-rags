grammar statix_translate:to_ag;

--------------------------------------------------

nonterminal AG_Expr;

attribute pp occurs on AG_Expr;

synthesized attribute renameDatumArg::(AG_Expr ::= String String Integer Integer) occurs on AG_Expr;

abstract production trueExpr
top::AG_Expr ::=
{
  top.pp = "trueExpr()";
  top.renameDatumArg = \_ _ _ _ -> ^top;
}

abstract production falseExpr
top::AG_Expr ::=
{
  top.pp = "falseExpr()";
  top.renameDatumArg = \_ _ _ _ -> ^top;
}

abstract production intExpr
top::AG_Expr ::= i::Integer
{
  top.pp = "intExpr(" ++ toString(i) ++ ")";
  top.renameDatumArg = \_ _ _ _ -> ^top;
}

abstract production stringExpr
top::AG_Expr ::= s::String
{
  top.pp = "stringExpr(" ++ s ++ ")";
  top.renameDatumArg = \_ _ _ _ -> ^top;
}

abstract production eqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.pp = "eqExpr(" ++ l.pp ++ ", " ++ r.pp ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    eqExpr(l.renameDatumArg(dt, arg, pos, len), r.renameDatumArg(dt, arg, pos, len));
}

abstract production neqExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.pp = "neqExpr(" ++ l.pp ++ ", " ++ r.pp ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    neqExpr(l.renameDatumArg(dt, arg, pos, len), r.renameDatumArg(dt, arg, pos, len));
}

abstract production appExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{
  top.pp = "appExpr(" ++ name ++ ", [" ++ implode(", ", map((.pp), args)) ++ "])";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    appExpr(name, map(\e::AG_Expr -> e.renameDatumArg(dt, arg, pos, len), args));
}

abstract production nameExpr
top::AG_Expr ::= name::String
{
  top.pp = "nameExpr(" ++ name ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    if arg != name
    then ^top
    else letExpr(arg ++ "__", caseExpr(demandExpr(nameExpr("d_lam_arg"), "data"),
          agCasesCons(
            agCase(
              agPatternApp(
                "ActualData" ++ dt, 
                let underScorePreNum::Integer  = pos - 1 in
                let underScopePostNum::Integer = len - pos in
                let underscoresPre::[AG_Pattern] = repeat(agPatternUnderscore(), underScorePreNum) in
                let underscoresPost::[AG_Pattern] = repeat(agPatternUnderscore(), underScopePostNum) in
                  underscoresPre ++ [agPatternName(arg)] ++ underscoresPost
                end end end end
              ),
              nilWhereClauseAG(),
              nameExpr(arg)
            ),
            agCasesOne (
              agCase(agPatternUnderscore(), nilWhereClauseAG(), abortExpr("data match abort"))
            )
          )
         ),
         nameExpr(arg ++ "__"));
}

abstract production andExpr
top::AG_Expr ::= l::AG_Expr r::AG_Expr
{
  top.pp = "andExpr(" ++ l.pp ++ ", " ++ r.pp ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    andExpr(l.renameDatumArg(dt, arg, pos, len), r.renameDatumArg(dt, arg, pos, len));
}

abstract production caseExpr
top::AG_Expr ::= e::AG_Expr cases::AG_Cases
{
  top.pp = "caseExpr(" ++ e.pp ++ ", " ++ cases.pp ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    caseExpr(e.renameDatumArg(dt, arg, pos, len), cases.renameDatumArgCases(dt, arg, pos, len));
}

abstract production demandExpr
top::AG_Expr ::= lhs::AG_Expr attr::String
{
  top.pp = "demandExpr(" ++ lhs.pp ++ ", " ++ attr ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    demandExpr(lhs.renameDatumArg(dt, arg, pos, len), attr);
}

abstract production lambdaExpr
top::AG_Expr ::= args::[(String, AG_Type)] body::AG_Expr
{
  top.pp = "lambdaExpr([" ++ implode(", ", map(\p::(String, AG_Type) -> "(" ++ p.1 ++ ", " ++ p.2.pp ++ ")", args)) ++ "], " ++ body.pp ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    if length(filter(\l::(String, AG_Type) -> l.1 == arg, args)) == 0
    then ^top
    else lambdaExpr(args, body.renameDatumArg(dt, arg, pos, len));
}

abstract production tupleExpr
top::AG_Expr ::= es::[AG_Expr]
{
  top.pp = "tupleExpr([" ++ implode(", ", map((.pp), es)) ++ "])";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    tupleExpr(map(\e::AG_Expr -> e.renameDatumArg(dt, arg, pos, len), es));
}

abstract production consExpr
top::AG_Expr ::= h::AG_Expr  t::AG_Expr
{
  top.pp = "consExpr(" ++ h.pp ++ ", " ++ t.pp ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    consExpr(h.renameDatumArg(dt, arg, pos, len), t.renameDatumArg(dt, arg, pos, len));
}

abstract production nilExpr
top::AG_Expr ::=
{
  top.pp = "nilExpr()";
  top.renameDatumArg = \_ _ _ _ -> ^top;
}

abstract production tupleSectionExpr
top::AG_Expr ::= tup::AG_Expr i::Integer
{
  top.pp = "tupleSectionExpr(" ++ tup.pp ++ ", " ++ toString(i) ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    tupleSectionExpr(tup.renameDatumArg(dt, arg, pos, len), i);
}

abstract production termExpr
top::AG_Expr ::= name::String args::[AG_Expr]
{
  top.pp = "termExpr(" ++ name ++ ", [" ++ implode(", ", map((.pp), args)) ++ "])";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    termExpr(name, map(\e::AG_Expr -> e.renameDatumArg(dt, arg, pos, len), args));
}

abstract production abortExpr
top::AG_Expr ::= msg::String
{
  top.pp = "abortExpr(" ++ msg ++ ")";
  top.renameDatumArg = \_ _ _ _ -> ^top;
}

abstract production letExpr
top::AG_Expr ::= name::String bind::AG_Expr body::AG_Expr
{
  top.pp = "letExpr(" ++ name ++ ", " ++ bind.pp ++ ", " ++ body.pp ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    if name == arg
    then ^top
    else letExpr(name, bind.renameDatumArg(dt, arg, pos, len), 
                       body.renameDatumArg(dt, arg, pos, len));
}

abstract production ifExpr
top::AG_Expr ::= c::AG_Expr e1::AG_Expr e2::AG_Expr
{
  top.pp = "ifExpr(" ++ c.pp ++ ", " ++ e1.pp ++ ", " ++ e2.pp ++ ")";
  top.renameDatumArg = \dt::String arg::String pos::Integer len::Integer -> 
    ifExpr (
      c.renameDatumArg(dt, arg, pos, len),
      e1.renameDatumArg(dt, arg, pos, len),
      e2.renameDatumArg(dt, arg, pos, len)
    );
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