grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_lhs::String occurs on AG_LHS;

attribute knownLocals occurs on AG_LHS;
propagate knownLocals on AG_LHS;

attribute knownProds occurs on AG_LHS;
propagate knownProds on AG_LHS;

aspect production nameLHS
top::AG_LHS ::= name::String
{
  top.silver_lhs = name;
}

aspect production qualLHS
top::AG_LHS ::= pre::AG_LHS name::String
{
  top.silver_lhs = 
    case pre of 
    | nameLHS(n) ->
      if n == "top" && containsBy((\l::(String, AG_Type) r::(String, AG_Type) -> 
                                     l.1 == r.1), 
                                  (name, varTypeAG()), top.knownLocals)
      then name
      else pre.silver_lhs ++ "." ++ name
    | _ -> pre.silver_lhs ++ "." ++ name
    end;
}