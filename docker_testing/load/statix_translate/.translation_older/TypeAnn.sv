grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute typeTrans::String occurs on TypeAnn;

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