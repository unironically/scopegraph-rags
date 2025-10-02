grammar statix_translate:to_ocaml;

--------------------------------------------------

synthesized attribute ocaml_lhs::String occurs on AG_LHS;

aspect production nameLHS
top::AG_LHS ::= name::String
{
  top.ocaml_lhs = "VarE(\"" ++ name ++ "\")";
}

aspect production qualLHS
top::AG_LHS ::= pre::AG_LHS name::String
{
  top.ocaml_lhs = "AttrRef(" ++ pre.ocaml_lhs ++ ", \"" ++ name ++ "\")";
}