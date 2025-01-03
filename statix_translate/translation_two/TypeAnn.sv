grammar statix_translate:translation_two;

--------------------------------------------------

synthesized attribute typeTrans::String occurs on TypeAnn;

aspect production scopeType
top::TypeAnn ::=
{
  top.typeTrans = "Scope";
}

aspect production nameType
top::TypeAnn ::= name::String
{
  top.typeTrans = upperFirstChar(name);
}

aspect production listType
top::TypeAnn ::= ty::TypeAnn
{
  top.typeTrans = "[" ++ ty.typeTrans ++ "]";
}

--------------------------------------------------

fun upperFirstChar String ::= s::String =
  let chars::[Integer] = stringToChars(s) in
  let first::Integer = head(chars) in
    charsToString
      ((if first > 90 then first - 32 else first) :: tail(chars))
  end end;