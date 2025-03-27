grammar statix_translate:translation;

--------------------------------------------------

nonterminal AGNont with name, termPos, syns, inhs;

synthesized attribute name::String;
synthesized attribute termPos::Integer;
synthesized attribute syns::[(String, Integer, TypeAnn)];
synthesized attribute inhs::[(String, Integer, TypeAnn)];

abstract production mkNont
top::AGNont ::= 
  name::String
  termPos::Integer
  syns::[(String, Integer, TypeAnn)]
  inhs::[(String, Integer, TypeAnn)]
{
  top.name = name;
  top.termPos = termPos;
  top.syns = syns;
  top.inhs = inhs;
}

--------------------------------------------------

monoid attribute nonterminals::[Decorated AGNont] with [], ++ occurs on Predicate;

attribute knownNonterminals occurs on Predicate;
propagate knownNonterminals on Predicate;

--

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::BranchList
{
  top.functionalPreds := [];

  local ntName::String = upperFirstChar(name);
  local nont::AGNont = mkNont(ntName, nameLst.untaggedPos, nameLst.syns, nameLst.inhs);

  top.nonterminals := [nont];

  bs.namesInScope = nameLst.nameListDefs;

  -- tell the branch list that it is not a functional pred
  bs.isFunctionalPred = false;
  bs.expRetTys = [];

  -- predicate translation
  local ntDecl::String = "nonterminal " ++ ntName ++ ";";
  local occursDecls::[String] = 
    map((\inh::(String, Integer, TypeAnn) -> 
           "attribute " ++ inh.1 ++ " occurs on " ++ ntName ++ ";"), 
        nont.inhs ++ nont.syns);

  top.predicateTrans = implode("\n", ntDecl::(occursDecls ++ bs.prods));

  bs.prodTy = just(nont);
}

--------------------------------------------------

attribute syns, inhs occurs on NameList;

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{
  top.syns = case name of nameSyn(s, t) -> (s, top.size, ^t)::names.syns | _ -> names.syns end;
  top.inhs = case name of nameInh(s, t) -> (s, top.size, ^t)::names.inhs | _ -> names.inhs end;
}

aspect production nameListOne
top::NameList ::= name::Name
{
  top.syns = case name of nameSyn(s, t) -> [(s, top.size, ^t)] | _ -> [] end;
  top.inhs = case name of nameInh(s, t) -> [(s, top.size, ^t)] | _ -> [] end;
}

--------------------------------------------------