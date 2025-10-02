grammar statix_translate:to_ag;

--------------------------------------------------

synthesized attribute ag_type::AG_Type;

--------------------------------------------------

synthesized attribute localDeclEqs::[AG_Eq] occurs on NameList;
synthesized attribute nameAGTys::[(String, AG_Type)] occurs on NameList;

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{
  top.localDeclEqs = localDeclEq(name.name, name.ag_type) :: names.localDeclEqs;
  top.nameAGTys    = name.nameAGTy :: names.nameAGTys;
}

aspect production nameListOne
top::NameList ::= name::Name
{
  top.localDeclEqs = localDeclEq(name.name, name.ag_type) :: [];
  top.nameAGTys    = name.nameAGTy :: [];
}

aspect production nameListNil
top::NameList ::=
{
  top.localDeclEqs = [];
  top.nameAGTys    = [];
}


--------------------------------------------------

attribute ag_type occurs on Name;
synthesized attribute nameAGTy::(String, AG_Type) occurs on Name;

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{
  top.ag_type = ty.ag_type;
  top.nameAGTy = (name, ty.ag_type);
}

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{
  top.ag_type = ty.ag_type;
  top.nameAGTy = (name, ty.ag_type);
}

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{
  top.ag_type = ty.ag_type;
  top.nameAGTy = (name, ty.ag_type);
}

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{
  top.ag_type = ty.ag_type;
  top.nameAGTy = (name, ty.ag_type);
}

--------------------------------------------------

synthesized attribute names::[String] occurs on RefNameList;
synthesized attribute nth::(String ::= Integer) occurs on RefNameList;
inherited attribute idx::Integer occurs on RefNameList;

aspect production refNameListCons
top::RefNameList ::= name::String names::RefNameList
{
  top.names = name :: names.names;
  names.idx = 1 + top.idx;
  top.nth = \i::Integer -> if i == top.idx then name else names.nth(i);
}

aspect production refNameListOne
top::RefNameList ::= name::String
{
  top.names = [name];
  top.nth = \i::Integer -> if i == top.idx then name else error("");
}

aspect production refNameListNil
top::RefNameList ::=
{
  top.names = [];
  top.nth = \i::Integer -> error("");
}