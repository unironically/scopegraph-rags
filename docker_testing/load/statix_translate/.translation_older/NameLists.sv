grammar statix_translate:translation;

--------------------------------------------------

synthesized attribute refNamesList::[String] occurs on RefNameList;

attribute size occurs on RefNameList;

synthesized attribute refNamesByPosition::([String] ::= [Integer]) occurs on RefNameList;

aspect production refNameListCons
top::RefNameList ::= name::String names::RefNameList
{
  top.refNamesList = name :: names.refNamesList;
  top.size = 1 + names.size;

  top.refNamesByPosition = 
    \is::[Integer] -> if contains(top.size, is)
                      then name :: names.refNamesByPosition(is)
                      else names.refNamesByPosition(is);
}

aspect production refNameListOne
top::RefNameList ::= name::String
{
  top.refNamesList = [name];
  top.size = 1;

  top.refNamesByPosition = 
    \is::[Integer] -> if contains(top.size, is)
                      then [name]
                      else [];
}

aspect production refNameListNil
top::RefNameList ::=
{
  top.refNamesList = [];
  top.size = 0;
  top.refNamesByPosition =
    \is::[Integer] -> [];
}

--------------------------------------------------

synthesized attribute nameListDefs::[(String, TypeAnn)] occurs on NameList;

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{
  top.nameListDefs = name.nameDef :: names.nameListDefs;
}

aspect production nameListOne
top::NameList ::= name::Name
{
  top.nameListDefs = [name.nameDef];
}

aspect production nameListNil
top::NameList ::=
{
  top.nameListDefs = [];
}


synthesized attribute nameDef::(String, TypeAnn) occurs on Name;

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{
  top.nameDef = (name, ^ty);
}

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{
  top.nameDef = (name, ^ty);
}

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{
  top.nameDef = (name, ^ty);
}

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{
  top.nameDef = (name, ^ty);
}