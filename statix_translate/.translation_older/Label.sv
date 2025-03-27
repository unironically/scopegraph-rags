grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute labelTrans::String occurs on Label;

aspect production label
top::Label ::= label::String
{
  top.labelTrans = label;
}