grammar statix_translate:translation_two;

--------------------------------------------------

synthesized attribute labelTrans::String occurs on Label;

aspect production label
top::Label ::= label::String
{
  top.labelTrans = label;
}