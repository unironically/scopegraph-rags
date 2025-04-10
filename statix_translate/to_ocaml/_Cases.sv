grammar statix_translate:to_ocaml;

--------------------------------------------------

monoid attribute ocaml_cases::[String] with [], ++ occurs on AG_Cases;
propagate ocaml_cases on AG_Cases;

aspect production agCasesCons
top::AG_Cases ::= c::AG_Case cs::AG_Cases
{
}

aspect production agCasesOne
top::AG_Cases ::= c::AG_Case
{
}

aspect production agCasesNil
top::AG_Cases ::=
{
}

--------------------------------------------------

attribute ocaml_cases occurs on AG_Case;

aspect production agCase
top::AG_Case ::= pat::AG_Pattern wc::AG_WhereClause body::AG_Expr
{
  -- wc todo
  top.ocaml_cases := [
    "(" ++ 
      pat.ocaml_pattern ++ ", " ++
      body.ocaml_expr ++
    ")"
  ];
}