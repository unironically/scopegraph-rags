grammar statix_translate:translation_two;


{- Definitions for predicates
 -}



--------------------------------------------------


synthesized attribute name::String;
synthesized attribute attrs::NameList;
synthesized attribute syns::NameList;
synthesized attribute inhs::NameList;

nonterminal SyntaxPred with name, attrs, syns, inhs;

production syntaxPred
top::SyntaxPred ::= name::String attrs::NameList
{
  top.name = name;
  top.attrs = ^attrs;
  top.syns = filterNameListFor(^attrs, \n::Name -> case n of nameSyn(_, _) -> true 
                                                           | _ -> false end);
  top.inhs = filterNameListFor(^attrs, \n::Name -> case n of nameInh(_, _) -> true 
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
  top.params = ^args;
  top.rets = filterNameListFor(^args, \n::Name -> case n of nameRet(_, _) -> true 
                                                          | _ -> false end);
  top.args = filterNameListFor(^args, \n::Name -> case n of nameUntagged(_, _) -> true 
                                                          | _ -> false end);
}


--------------------------------------------------


-- filter input NameList for names which satisfy filt
fun filterNameListFor
NameList ::= input::NameList filt::(Boolean ::= Name) =
  case input of
  | nameListNil() -> input
  | nameListCons(n, rest) when filt(^n) -> 
      nameListCons(^n, filterNameListFor(^rest, filt))
  | nameListCons(_, rest) -> 
      filterNameListFor(^rest, filt)
  | _ -> error("filterNameListFor: case error")
  end;