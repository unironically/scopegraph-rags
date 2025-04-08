grammar statix_translate:to_silver;

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

aspect production refNameListCons
top::RefNameList ::= name::String names::RefNameList
{
  top.names = name :: names.names;
}

aspect production refNameListOne
top::RefNameList ::= name::String
{
  top.names = [name];
}

aspect production refNameListNil
top::RefNameList ::=
{
  top.names = [];
}