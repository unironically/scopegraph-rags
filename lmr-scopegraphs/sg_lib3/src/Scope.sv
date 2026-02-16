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

closed nonterminal Datum with name;

aspect default production top::Datum ::=
{ top.name = ""; }
--

closed nonterminal Label<(i::InhSet)> with name, demand <i>;

synthesized attribute demand<(i::InhSet)>::([DecScope<i>] ::= DecScope<i>);

aspect default production top::Label<i> ::=
{ top.col = "black"; }

instance Eq Label<(i::InhSet)> {
  eq = \left::Label<(i::InhSet)> right::Label<(i::InhSet)> -> left.name == right.name;
}