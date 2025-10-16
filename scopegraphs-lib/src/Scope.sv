grammar src;

--
fun main IO<Integer> ::= args::[String] = do {
  return 0;
};

--

nonterminal Scope with datum;

synthesized attribute datum::Datum;

production scope
top::Scope ::= datum::Datum
{ top.datum = ^datum; }

--

nonterminal Datum with name;

synthesized attribute name::String;

production datumNone
top::Datum ::=
{ top.name = ""; }

production datumJust
top::Datum ::= name::String
{ top.name = name ++ "_" ++ toString(genInt()); }

--

nonterminal Label<(i::InhSet)> with name, demand <i>;

synthesized attribute demand<(i::InhSet)>::([Decorated Scope with i] ::= Decorated Scope with i);

production label
top::Label<(i::InhSet)> ::=
{ top.demand = error("label.demand");
  top.name = error("label.name"); }

instance Eq Label<(i::InhSet)> {
  eq = \left::Label<(i::InhSet)> right::Label<(i::InhSet)> -> 
    left.name == right.name;
}