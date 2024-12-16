grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute matcherTrans::String occurs on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{
  top.matcherTrans = 
    p.patternTrans ++
    case wc.whereClauseTrans of
    | just(t) -> " " ++ t
    | _ -> ""
    end;
}

--------------------------------------------------

--nonterminal Pattern;

synthesized attribute patternTrans::String occurs on Pattern;

aspect production labelPattern
top::Pattern ::= lab::Label
{
  top.patternTrans = lab.labelTrans;
}

aspect production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{
  top.patternTrans = lab.labelTrans ++ "(" ++ p.patternTrans ++ ")";
}

aspect production edgePattern
top::Pattern ::= p1::Pattern p2::Pattern p3::Pattern
{
  top.patternTrans = "Edge(" ++ p1.patternTrans ++ ", " ++
                                p2.patternTrans ++ ", " ++
                                p3.patternTrans ++ ")";
}

aspect production endPattern
top::Pattern ::= p::Pattern
{
  top.patternTrans = "End(" ++ p.patternTrans ++ ")";
}

aspect production namePattern
top::Pattern ::= name::String ty::TypeAnn
{
  top.patternTrans = name;
  -- todo, handle type
}

aspect production constructorPattern
top::Pattern ::= name::String ps::PatternList
{
  top.patternTrans = name ++ "(" ++ implode(", ", ps.patternsTrans) ++ ")";
}

aspect production consPattern
top::Pattern ::= p1::Pattern p2::Pattern
{
  top.patternTrans = p1.patternTrans ++ "::" ++ p2.patternTrans;
}

aspect production nilPattern
top::Pattern ::=
{
  top.patternTrans = "[]";
}

aspect production tuplePattern
top::Pattern ::= ps::PatternList
{
  top.patternTrans = "(" ++ implode(", ", ps.patternsTrans) ++ ")";
}

aspect production underscorePattern
top::Pattern ::=
{
  top.patternTrans = "_";
}

--------------------------------------------------

--nonterminal PatternList;

synthesized attribute patternsTrans::[String] occurs on PatternList;


aspect production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{
  top.patternsTrans = p.patternTrans :: ps.patternsTrans;
}

aspect production patternListNil
top::PatternList ::=
{
  top.patternsTrans = [];
}

--------------------------------------------------