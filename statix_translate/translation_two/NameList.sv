grammar statix_translate:translation_two;


--------------------------------------------------


-- knowing what name definitions are for scopes
synthesized attribute scopeDefNames::[String];
synthesized attribute scopeDefNamesInh::[String];
synthesized attribute prodChildParams::[(String, TypeAnn)];

--------------------------------------------------

attribute scopeDefNames occurs on NameList;
attribute scopeDefNamesInh occurs on NameList;
attribute prodChildParams occurs on NameList;

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{
  top.scopeDefNames = name.scopeDefNames ++ names.scopeDefNames;
  top.scopeDefNamesInh = name.scopeDefNamesInh ++ names.scopeDefNamesInh;
  top.prodChildParams = name.prodChildParams ++ names.prodChildParams;
}

aspect production nameListOne
top::NameList ::= name::Name
{
  top.scopeDefNames = name.scopeDefNames;
  top.scopeDefNamesInh = name.scopeDefNamesInh;
  top.prodChildParams = name.prodChildParams;
}

aspect production nameListNil
top::NameList ::=
{
  top.scopeDefNames = [];
  top.scopeDefNamesInh = [];
  top.prodChildParams = [];
}


--------------------------------------------------

attribute scopeDefNames occurs on Name;
attribute scopeDefNamesInh occurs on Name;
attribute prodChildParams occurs on Name;

synthesized attribute ty::TypeAnn occurs on Name;

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{
  top.scopeDefNames = case ty of scopeType() -> [name ++ "_UNDEC"] | _ -> [] end;
  top.scopeDefNamesInh = [];
  top.prodChildParams = [];
  top.ty = ^ty;
}

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{
  top.scopeDefNames = case ty of scopeType() -> [name] | _ -> [] end;
  top.scopeDefNamesInh = case ty of scopeType() -> [name] | _ -> [] end;
  top.prodChildParams = [];
  top.ty = ^ty;
}

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{
  top.scopeDefNames = case ty of scopeType() -> [name] | _ -> [] end;
  top.scopeDefNamesInh = [];
  top.prodChildParams = [];
  top.ty = ^ty;
}

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{
  top.scopeDefNames = case ty of scopeType() -> [name] | _ -> [] end;
  top.scopeDefNamesInh = [];
  top.prodChildParams = [(name, ^ty)];
  top.ty = ^ty;
}