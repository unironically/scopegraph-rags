grammar sg_lib;

--------------------------------------------------

nonterminal Node with location;

synthesized attribute id::Integer occurs on Node;
synthesized attribute datum::Maybe<Datum> occurs on Node;

inherited attribute lex::[Decorated Node] occurs on Node;
inherited attribute var::[Decorated Node] occurs on Node;
inherited attribute mod::[Decorated Node] occurs on Node;
inherited attribute imp::[Decorated Node] occurs on Node;

abstract production mkNode
top::Node ::=
  datum::Maybe<Datum>
{
  top.id = genInt();
  top.datum = datum;
}

--------------------------------------------------

type Scope = Node;

abstract production mkScope
top::Scope ::=
{ forwards to mkNode(nothing()); }

--------------------------------------------------

type Decl = Scope;

abstract production mkDeclMod
top::Decl ::=
  name::String
{ forwards to mkNode(datumMod(name)); }

abstract production mkDeclVar
top::Decl ::=
  name::String
{ forwards to mkNode(datumVar(name)); }

--------------------------------------------------

synthesized attribute name::String;

nonterminal Ref with name, lex, location;

abstract production mkRefVar
top::Ref ::= name::String
{
  local dfa::DFA = varRefDFA();
  top.decls = dfa.decls(top, head(top.lex));
}

abstract production mkRefMod
top::Ref ::= name::String
{
  local dfa::DFA = modRefDFA();
  top.decls = dfa.decls(top, head(top.lex));
}

--------------------------------------------------

synthesized attribute match::(Boolean ::= Ref);

nonterminal Datum with name, nameEq, location;

--synthesized attribute str::String occurs on Datum;

{-abstract production datumId
top::Datum ::= id::String str::String
{
  top.datumId = id;
  top.nameEq = \s::String -> s == id;
  top.str = str;
}-}

abstract production datumMod
top::Datum ::= name::String
{
  top.name = name;
  top.match = \r::Ref -> r.name == top.name;
}

abstract production datumVar
top::Datum ::= name::String ty::Type
{
  top.name = name;
  top.match = \r::Ref -> r.name == top.name;
}

--------------------------------------------------