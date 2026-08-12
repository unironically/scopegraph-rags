grammar lmr1:lmr:extension_records;

exports lmr1:lmr:nameanalysis_kastenswaite;

--------------------------------------------------

production declRecord
top::Decl ::= r::Record
{
  r.env = top.env;
  r.bindsIn = top.bindsIn;

  top.outEnv = r.outEnv;
  top.bindsOut = r.bindsOut;

  top.ok = r.ok;
}

--------------------------------------------------

nonterminal Record with location, ok, env, outEnv, fields, bindsIn, bindsOut;

production record
top::Record ::= x::String fields::Fields
{
  fields.env = top.env;
  fields.bindsIn = newEnv();

  top.outEnv = addRec(top.env, x, top);
  top.bindsOut = addRec(top.env, x, top);

  top.fields = fields.bindsOut;

  top.ok = fields.ok;
}

production recordExt
top::Record ::= x::String par::String fields::Fields
{
  top.outEnv = error("TODO recordExt.outEnv");
  top.bindsOut = error("TODO recordExt.bindsOut");

  top.fields = error("TODO recordExt.fields");

  top.ok = error("TODO recordExt.ok");
}

--------------------------------------------------

nonterminal Fields with location, ok, env, bindsIn, bindsOut;

production fieldsCons
top::Fields ::= x::String ty::Type rest::Fields
{}

production fieldsOne
top::Fields ::= x::String ty::Type
{}

--------------------------------------------------

production exprRecord
top::Expr ::= name::String flds::FieldExprs
{}

production exprRecordAccess
top::Expr ::= r::RecAccess
{}

--------------------------------------------------

nonterminal FieldExprs with location;

production fieldExprsCons
top::FieldExprs ::= x::String e::Expr rest::FieldExprs
{}

production fieldExprsOne
top::FieldExprs ::= x::String e::Expr
{}

--------------------------------------------------

nonterminal RecAccessLHS with location;

production recAccessLHSQual
top::RecAccessLHS ::= r::RecAccessLHS x::String
{}

production recAccessLHS
top::RecAccessLHS ::= x::String
{}

--

nonterminal RecAccess with location;

production recAccess
top::RecAccess ::= lhs::RecAccessLHS x::String
{}
