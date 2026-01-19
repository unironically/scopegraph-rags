grammar sg_lib3:src;

--
fun main IO<Integer> ::= args::[String] = do {
  return 0;
};

--

synthesized attribute id::Integer;
synthesized attribute name::String;
synthesized attribute datum::Datum;

--

nonterminal Scope with id, datum;

production scope
top::Scope ::= datum::Datum
{ top.id = genInt();
  top.datum = ^datum; }

--

nonterminal Datum with name;

production datumNone
top::Datum ::=
{ top.name = ""; }

production datumJust
top::Datum ::= name::String
{ top.name = name; }

--

nonterminal Label<(i::InhSet)> with name, demand <i>;

synthesized attribute demand<(i::InhSet)>::([DecScope<i>] ::= DecScope<i>);

production label
top::Label<(i::InhSet)> ::=
{ top.demand = error("label.demand");
  top.name = error("label.name"); }

instance Eq Label<(i::InhSet)> {
  eq = \left::Label<(i::InhSet)> right::Label<(i::InhSet)> -> left.name == right.name;
}