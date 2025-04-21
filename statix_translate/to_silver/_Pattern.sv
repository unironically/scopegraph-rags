grammar statix_translate:to_silver;

--------------------------------------------------

synthesized attribute silver_pattern::String occurs on AG_Pattern;

attribute knownProds occurs on AG_Pattern;
propagate knownProds on AG_Pattern;

synthesized attribute localsSyn::[(String, AG_Type)] occurs on AG_Pattern;

aspect production agPatternUnderscore
top::AG_Pattern ::=
{
  top.silver_pattern = "_";
  top.localsSyn = [];
}

aspect production agPatternName
top::AG_Pattern ::= name::String
{
  top.silver_pattern = name;
  top.localsSyn = [];
}

aspect production agPatternApp
top::AG_Pattern ::= name::String ps::[AG_Pattern]
{
  top.silver_pattern = preProd ++ name ++ "(" ++ 
                         implode(", ", map((.silver_pattern), ps)) ++ 
                       ")";

  top.localsSyn =
    let prod::AG_Decl = lookupProd(name, top.knownProds) in
      case prod of
      | productionDecl(_, _, args, _) -> 
          let argTysOnly::[AG_Type] = map(snd, args) in
          let zipped::[(AG_Pattern, AG_Type)] = zip(ps, argTysOnly) in
            filterMap(
              (\p::(AG_Pattern, AG_Type) ->
                  case p.1 of
                  | agPatternName(n) -> just((n, p.2))
                  | _ -> nothing()
                  end
              ),
              zipped
            )
          end end
      | _ -> error("agPatternApp.localsSyn 2")
      end
    end;
}

aspect production agPatternCons
top::AG_Pattern ::= h::AG_Pattern t::AG_Pattern
{
  top.silver_pattern = h.silver_pattern ++ "::" ++ t.silver_pattern;
  top.localsSyn = h.localsSyn ++ t.localsSyn;

}

aspect production agPatternNil
top::AG_Pattern ::=
{
  top.silver_pattern = "[]";
  top.localsSyn = [];
}

aspect production agPatternTuple
top::AG_Pattern ::= ps::[AG_Pattern]
{
  top.silver_pattern = "(" ++ implode(", ", map((.silver_pattern), ps)) ++ ")";
  top.localsSyn = concat(map((.localsSyn), map((\p::AG_Pattern -> decorate p with {knownProds = top.knownProds;}), ps)));
}