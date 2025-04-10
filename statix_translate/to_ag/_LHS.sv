grammar statix_translate:to_ag;

--------------------------------------------------

nonterminal AG_LHS;

attribute pp occurs on AG_LHS;

abstract production nameLHS
top::AG_LHS ::= name::String
{
  top.pp = "nameLHS(" ++ name ++ ")";
}

abstract production qualLHS
top::AG_LHS ::= pre::AG_LHS name::String
{
  top.pp = "qualLHS(" ++ pre.pp ++ ", " ++ name ++ ")";
}