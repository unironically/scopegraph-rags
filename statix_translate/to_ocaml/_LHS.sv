grammar statix_translate:to_ocaml;

--------------------------------------------------

aspect production nameLHS
top::AG_LHS ::= name::String
{
}

aspect production qualLHS
top::AG_LHS ::= pre::AG_LHS name::String
{
}