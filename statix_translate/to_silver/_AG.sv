grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_ag::String occurs on AG;

aspect production ag
top::AG ::= 
  nts::AG_Decls
  globs::AG_Decls
  prods::AG_Decls
  funs::AG_Decls
  inhs::[(String, AG_Type)]
  syns::[(String, AG_Type)]
{
  top.silver_ag = 
    silverInhAttrs(inhs) ++ "\n" ++ silverSynAttrs(syns) ++
    nts.silver_decls ++ globs.silver_decls ++ 
    prods.silver_decls ++ funs.silver_decls
  ;
}

--------------------------------------------------


function silverInhAttrs
String ::= attrs::[(String, AG_Type)]
{
  return implode("\n", map((silverInhAttr(_)), attrs));
}

function silverInhAttr
String ::= attr::(String, AG_Type)
{
  return "inherited attribute " ++ attr.1 ++ "::" ++ attr.2.silver_type ++ ";";
}

function silverSynAttrs
String ::= attrs::[(String, AG_Type)]
{
  return implode("\n", map((silverSynAttr(_)), attrs));
}

function silverSynAttr
String ::= attr::(String, AG_Type)
{
  return "synthesized attribute " ++ attr.1 ++ "::" ++ attr.2.silver_type ++ ";";
}