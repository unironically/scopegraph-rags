grammar sg_lib4:src;

--

nonterminal Scope;

synthesized attribute datum::Datum occurs on Scope;
inherited attribute edges::Map<String [Decorated Scope]> with combineMap occurs on Scope;

production scope
top::Scope ::= datum::Datum
{
  top.datum = ^datum;
}

--

nonterminal Datum;

synthesized attribute name::String occurs on Datum;

production datumNone
top::Datum ::=
{
  top.name = "";
}

production datumName
top::Datum ::= x::String
{
  top.name = x;
}

--

nonterminal Label;

attribute name occurs on Label;

synthesized attribute demand::([Decorated Scope] ::= Decorated Scope) occurs on Label;

production label
top::Label ::=
{
  top.name = error("label.name");
  top.demand = error("label.demand");
}

instance Eq Label {
  eq = \l::Label r::Label -> l.name == r.name;
}
