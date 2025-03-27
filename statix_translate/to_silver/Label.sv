grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute name::String occurs on Label;

aspect production label
top::Label ::= label::String
{
  top.name = label;
}