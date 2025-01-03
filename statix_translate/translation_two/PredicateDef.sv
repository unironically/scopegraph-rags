grammar statix_translate:translation_two;


{- Definitions for predicates
 -}


--------------------------------------------------


synthesized attribute name::String;
synthesized attribute params::NameList;
synthesized attribute syns::NameList;
synthesized attribute inhs::NameList;
synthesized attribute scopesInhOrSyn::[String]; -- knowing what scopes this pred deals with in its args
synthesized attribute scopesInh::[String];
synthesized attribute scopesSyn::[String];

nonterminal SyntaxPred with name, params, syns, inhs, scopesInhOrSyn, scopesInh, scopesSyn;

production syntaxPred
top::SyntaxPred ::= name::String params::NameList
{
  top.name = name;
  top.params = ^params;
  top.syns = filterNameListFor(^params, \n::Name -> case n of nameSyn(_, _) -> true 
                                                            | _ -> false end);
  top.inhs = filterNameListFor(^params, \n::Name -> case n of nameInh(_, _) -> true 
                                                            | _ -> false end);
  top.scopesSyn = top.syns.scopeDefNames;
  top.scopesInh = top.inhs.scopeDefNames;
  top.scopesInhOrSyn = union(top.syns.scopeDefNames, top.inhs.scopeDefNames);
}


--------------------------------------------------


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


--------------------------------------------------

inherited attribute predicateEnv::PredicateEnv;

type PredicateEnv = Env<PredicateEnvItem>;
type PredicateEnvItem = Either<SyntaxPred FunctionPred>;