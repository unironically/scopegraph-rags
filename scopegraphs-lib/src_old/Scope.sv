grammar src_old;

fun main IO<Integer> ::= args::[String] = pure(0);

nonterminal Foo;
type InhSet = {bar};
inherited attribute bar::[Decorated Foo with {bar}];
