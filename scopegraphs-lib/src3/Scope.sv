grammar src3;

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
{ top.datum = ^datum; }

-- Data:

nonterminal Datum with name;

production datumNone
top::Datum ::=
{ top.name = ""; }

production datumJust
top::Datum ::= name::String
{ top.name = name ++ "_" ++ toString(genInt()); }

-- Label:

nonterminal Label<(i::InhSet)> with name, demand <i>;

synthesized attribute name::String;
synthesized attribute demand<(i::InhSet)>::([Decorated Scope with i] ::= Decorated Scope with i);

production label
top::Label<(i::InhSet)> ::=
{ top.demand = error("label.demand");
  top.name = error("label.name"); }

instance Eq Label<(i::InhSet)> {
  eq = \left::Label<(i::InhSet)> right::Label<(i::InhSet)> -> left.name == right.name;
}