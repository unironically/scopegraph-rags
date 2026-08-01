grammar ocaml:abstractsyntax;

--

nonterminal Type with pp;

production nameType
top::Type ::= name::String
{
  top.pp = name;
}

production tupleType
top::Type ::= t1::Type t2::Type
{
  top.pp = "(" ++ t1.pp ++ " * " ++ t2.pp ++ ")";
}

production funType
top::Type ::= t1::Type t2::Type
{
  top.pp = "(" ++ t1.pp ++ ") -> " ++ t2.pp;
}

production errType
top::Type ::=
{
  top.pp = "<err>";
}

--

instance Eq Type {
  eq = eqType;
}

fun eqType Boolean ::= t1::Type t2::Type =
  case t1, t2 of
  | errType(), _ -> true
  | _, errType() -> true
  | nameType(n1), nameType(n2) -> n1 == n2
  | funType(l1, l2), funType(r1, r2) -> eqType(^l1, ^r1) && eqType(^l2, ^r2)
  | tupleType(l1, l2), tupleType(r1, r2) -> eqType(^l1, ^r1) && eqType(^l2, ^r2)
  | _, _ -> false
  end
;