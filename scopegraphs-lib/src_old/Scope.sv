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

nonterminal Label with name, demand;

synthesized attribute name::String;
synthesized attribute demand::([Decorated Scope] ::= Decorated Scope);

production label
top::Label ::=
{ top.demand = error("label.demand");
  top.name = error("label.name"); }

instance Eq Label {
  eq = \left::Label right::Label -> left.name == right.name;
}