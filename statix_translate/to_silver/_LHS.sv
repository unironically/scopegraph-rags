grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_lhs::String occurs on AG_LHS;

aspect production nameLHS
top::AG_LHS ::= name::String
{
  top.silver_lhs = name;
}

aspect production qualLHS
top::AG_LHS ::= pre::AG_LHS name::String
{
  top.silver_lhs = pre.silver_lhs ++ "." ++ name;
}