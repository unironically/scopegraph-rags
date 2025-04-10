grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_expr occurs on Term;
synthesized attribute labelName::Maybe<String> occurs on Term;

attribute nonAttrs occurs on Term;
propagate nonAttrs on Term;

aspect production labelTerm
top::Term ::= lab::Label
{
  top.ag_expr = termExpr(lab.name, []);
  top.labelName = just(lab.name);
}

aspect production labelArgTerm
top::Term ::= lab::Label t::Term
{
  top.ag_expr = termExpr(lab.name, [t.ag_expr]);
  top.labelName = just(lab.name);
}

aspect production constructorTerm
top::Term ::= name::String ts::TermList
{
  top.ag_expr = termExpr(name, ts.ag_exprs);
  top.labelName = nothing();
}

aspect production nameTerm
top::Term ::= name::String
{
  top.ag_expr = if contains(name, top.nonAttrs) then nameExpr(name) 
                                                else topDotExpr(name);
  top.labelName = nothing();
}

aspect production consTerm
top::Term ::= t1::Term t2::Term
{
  top.ag_expr = consExpr(t1.ag_expr, t2.ag_expr);
  top.labelName = nothing();
}

aspect production nilTerm
top::Term ::=
{
  top.ag_expr = nilExpr();
  top.labelName = nothing();
}

aspect production tupleTerm
top::Term ::= ts::TermList
{
  top.ag_expr = tupleExpr(ts.ag_exprs);
  top.labelName = nothing();
}

aspect production stringTerm
top::Term ::= s::String
{
  top.ag_expr = stringExpr(s);
  top.labelName = nothing();
}


--------------------------------------------------

synthesized attribute ag_exprs::[AG_Expr] occurs on TermList;

attribute nonAttrs occurs on TermList;
propagate nonAttrs on TermList;

aspect production termListCons
top::TermList ::= t::Term ts::TermList
{
  top.ag_exprs = t.ag_expr :: ts.ag_exprs;
}

aspect production termListNil
top::TermList ::=
{
  top.ag_exprs = [];
}