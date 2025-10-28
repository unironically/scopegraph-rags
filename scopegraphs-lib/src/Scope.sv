grammar src;

--
fun main IO<Integer> ::= args::[String] = do {
  return 0;
};

--

synthesized attribute id::Integer;
synthesized attribute name::String;
synthesized attribute datum::Decorated Datum;

--

nonterminal Scope with datum;

production scope
top::Scope ::= datum::Datum
{ top.datum = datum; }

--

nonterminal Datum with id, name;

production datumNone
top::Datum ::=
{ top.id = genInt();
  top.name = ""; }

production datumJust
top::Datum ::= name::String
{ top.id = genInt();
  top.name = name ++ "_" ++ toString(top.id); }

--

nonterminal Label<(i::InhSet)> with name, demand <i>;

synthesized attribute demand<(i::InhSet)>::([DecScope<i>] ::= DecScope<i>);

production label
top::Label<(i::InhSet)> ::=
{ top.demand = error("label.demand");
  top.name = error("label.name"); }

instance Eq Label<(i::InhSet)> {
  eq = \left::Label<(i::InhSet)> right::Label<(i::InhSet)> -> 
    left.name == right.name;
}