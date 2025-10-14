grammar src2;

--------------------------------------------------------------------------------
-- Testing ---------------------------------------------------------------------

fun main IO<Integer> ::= args::[String] = do {
  return 0;
};

-- Scope

nonterminal Scope<a>;

synthesized attribute datum::Datum occurs on Scope<a>;

production scope
top::Scope<a> ::= datum::Datum
{
  top.datum = ^datum;
}

-- Data:

nonterminal Datum with name;

production datumNone
top::Datum ::=
{ top.name = ""; }

production datumJust
top::Datum ::= name::String
{ top.name = name ++ "_" ++ toString(genInt()); }

-- Label:

nonterminal Label<a> with name, demand<a>;

synthesized attribute name::String;
synthesized attribute demand<a>::([a] ::= a);

production label
top::Label<a> ::=
{
  top.name = error("label.name");
  top.demand = error("label.demand");
}

instance Eq Label<a> {
  eq = \left::Label<a> right::Label<a> -> left.name == right.name;
}

-- Edge:

{-nonterminal Edge;

production edge
top::Edge ::= lab::String tgt::Decorated Scope<a>
{}-}