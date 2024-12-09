grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute refNamesList::[String] occurs on RefNameList;

aspect production refNameListCons
top::RefNameList ::= name::String names::RefNameList
{
  top.refNamesList = name :: names.refNamesList;
}

aspect production refNameListOne
top::RefNameList ::= name::String
{
  top.refNamesList = [name];
}