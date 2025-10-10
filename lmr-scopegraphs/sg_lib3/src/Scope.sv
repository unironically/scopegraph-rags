grammar sg_lib3:src;

--------------------------------------------------------------------------------
-- Testing ---------------------------------------------------------------------

fun main IO<Integer> ::= args::[String] = do {
  return 0;
};

-- Scope

nonterminal Scope;

synthesized attribute datum::Datum occurs on Scope;

production scope
top::Scope ::= datum::Datum
{
  top.datum = ^datum;
}

-- Data:

nonterminal Datum;

production datumNone
top::Datum ::=
{}

production datumJust
top::Datum ::= name::String
{}

-- Label:

nonterminal Label with name, demand;

synthesized attribute name::String;
synthesized attribute demand::([Decorated Scope] ::= Decorated Scope);

production label
top::Label ::=
{
  top.demand = error("label.demand");
  top.name = "";
}

instance Eq Label {
  eq = \left::Label right::Label -> left.name == right.name;
}