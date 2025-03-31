grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute name::String occurs on Label;

aspect production label
top::Label ::= label::String
{
  top.name = label;
}