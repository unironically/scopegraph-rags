grammar statix_translate:translation;


--------------------------------------------------


aspect production labelTerm
top::Term ::= lab::Label
{}

aspect production labelArgTerm
top::Term ::= lab::Label t::Term
{}

aspect production constructorTerm
top::Term ::= name::String ts::TermList
{}

aspect production nameTerm
top::Term ::= name::String
{}

aspect production consTerm
top::Term ::= t1::Term t2::Term
{}

aspect production nilTerm
top::Term ::=
{}

aspect production tupleTerm
top::Term ::= ts::TermList
{}

aspect production stringTerm
top::Term ::= s::String
{}


--------------------------------------------------


aspect production termListCons
top::TermList ::= t::Term ts::TermList
{}

aspect production termListNil
top::TermList ::=
{}


--------------------------------------------------

nonterminal EqUnifyResult with eqOkNames, eqVars, eqTrans;

synthesized attribute eqOkNames::[String];
synthesized attribute eqVars::[(String, TypeAnn)];
synthesized attribute eqTrans::String;

abstract production eqUnifyResult
top::EqUnifyResult ::= okNames::[String] vars::[(String, TypeAnn)] trans::String
{
  top.eqOkNames = okNames;
  top.eqVars = vars;
  top.eqTrans = trans;
}


function getTermFreeVars
EqUnifyResult ::= t1::Term t2::Term predEnv::PredicateEnv
{
  return
    case ^t1, ^t2 of
    
    | nameTerm(n1), nameTerm(n2) when n1 != n2 -> 
        let okName::String = "ok_" ++ toString(genInt()) in
          eqUnifyResult([okName], [], "let " ++ okName ++ "::Boolean = " ++ n1 ++ " == " ++ n2 ++ " in " ++ okName ++ " end")
        end
    
    | nameTerm(n1), constructorTerm(n2, ts) -> 
        let 
          lookupRes::Maybe<PredicateEnvItem> = lookupEnv(n2, ^predEnv)
        in
        let 
          listRes::EqUnifyResult = getTermFreeVarsList(^ts, lookupRes.fromJust.fromRight.params)
        in
        let
          letName::String = "let_" ++ toString(genInt())
        in
          eqUnifyResult (
            [letName ++ ".1"],
            listRes.eqVars,
            "let " ++ letName ++ "::(" ++ "Boolean" ++ implode(", ", map((\p::(String, TypeAnn) -> p.2.typeTrans), listRes.eqVars)) ++ ") = " ++
              "case " ++ n1 ++ " of " ++
                "| " ++ "t2.termTrans TODO" ++ " -> " ++ "(" ++ implode ("&& ", listRes.eqOkNames) ++ ", " ++ implode (", ", map((\p::(String, TypeAnn) -> p.1), listRes.eqVars)) ++ ")" ++
                "| _ -> false" ++
              "end" ++
            "in" ++ letName ++ "end"
          )
        end end end

    
    | constructorTerm(n1, ts), nameTerm(n2) -> getTermFreeVars(^t2, ^t1, ^predEnv) -- use case above
    
    --| constructorTerm(n1, ts1), constructorTerm(n2, ts2) -> getTermFreeVarsList(ts1, ts2)
    
    | _, _ -> error ("no matching case in Term.getTermFreeVars, probably TODO")

    end;
}


function getTermFreeVarsList
EqUnifyResult ::= tl::TermList nl::NameList
{
  return
    case ^tl, ^nl of

    | termListNil(), nameListNil() -> eqUnifyResult([], [], "")

    | termListCons(nameTerm(n1), ts), nameListCons(n2, ns) ->
        let 
          restRes::EqUnifyResult = getTermFreeVarsList(^ts, ^ns) 
        in
          eqUnifyResult("true"::restRes.eqOkNames, (n1, n2.ty)::restRes.eqVars, n1)
        end

    | _, _ -> error ("no matching case in Term.getTermFreeVarsList, probably TODO")

    end;
}