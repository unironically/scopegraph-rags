grammar statix_translate:translation_two;


--------------------------------------------------


-- knowing what name definitions are for scopes
synthesized attribute scopeDefNames::[String];
synthesized attribute scopeDefNamesInh::[String];

--------------------------------------------------

attribute scopeDefNames occurs on NameList;
attribute scopeDefNamesInh occurs on NameList;

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{
  top.scopeDefNames = name.scopeDefNames ++ names.scopeDefNames;
  top.scopeDefNamesInh = name.scopeDefNamesInh ++ names.scopeDefNamesInh;
}

aspect production nameListOne
top::NameList ::= name::Name
{
  top.scopeDefNames = name.scopeDefNames;
  top.scopeDefNamesInh = name.scopeDefNamesInh;
}

aspect production nameListNil
top::NameList ::=
{
  top.scopeDefNames = [];
  top.scopeDefNamesInh = [];
}


--------------------------------------------------

attribute scopeDefNames occurs on Name;
attribute scopeDefNamesInh occurs on Name;

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{
  top.scopeDefNames = case ty of scopeType() -> [name] | _ -> [] end;
  top.scopeDefNamesInh = [];
}

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{
  top.scopeDefNames = case ty of scopeType() -> [name] | _ -> [] end;
  top.scopeDefNamesInh = case ty of scopeType() -> [name] | _ -> [] end;
}

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{
  top.scopeDefNames = case ty of scopeType() -> [name] | _ -> [] end;
  top.scopeDefNamesInh = [];
}

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{
  top.scopeDefNames = case ty of scopeType() -> [name] | _ -> [] end;
  top.scopeDefNamesInh = [];
}