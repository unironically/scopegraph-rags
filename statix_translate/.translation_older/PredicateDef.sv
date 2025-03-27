grammar statix_translate:translation;


{- Definitions for predicates
 -}



--------------------------------------------------


synthesized attribute name::String;
synthesized attribute attrs::NameList;
synthesized attribute syns::NameList;
synthesized attribute inhs::NameList;

nonterminal SyntaxPred with name, attrs;

production syntaxPred
top::SyntaxPred ::= name::String attrs::NameList
{
  top.name = name;
  top.attrs = attrs;
  top.syns = filterNameListFor(attrs, \n::Name -> case n of nameSyn(_, _) -> true 
                                                          | _ -> false end);
  top.inhs = filterNameListFor(attrs, \n::Name -> case n of nameInh(_, _) -> true 
                                                          | _ -> false end);
}


--------------------------------------------------


synthesized attribute params::NameList;
synthesized attribute rets::NameList;
synthesized attribute args::NameList;

nonterminal FunctionPred with name, params, rets, args;

production functionPred
top::FunctionPred ::= name::String args::NameList
{
  top.name = name;
  top.params = args;
  top.rets = filterNameListFor(attrs, \n::Name -> case n of nameRet(_, _) -> true 
                                                          | _ -> false end);
  top.args = filterNameListFor(attrs, \n::Name -> case n of nameUntagged(_, _) -> true 
                                                          | _ -> false end);
}


--------------------------------------------------


-- filter input NameList for names which satisfy pred
fun filterNameListFor
NameList ::= input::NameList pred::(Boolean ::= Name) =
  case input of
  | nameListNil() -> input
  | nameListCons(n, rest) when pred(n) -> 
      nameListCons(n, filterNameListFor(rest, pred))
  | nameListCons(_, rest) -> 
      filterNameListFor(rest, pred)
  | _ -> error("filterNameListFor: case error")
  end;