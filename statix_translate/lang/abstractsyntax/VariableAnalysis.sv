grammar statix_translate:lang:abstractsyntax;

--------------------------------------------------

monoid attribute freeVarsDefined::[(String, TypeAnn)] with [], 
  unionBy((\l::(String, TypeAnn) r::(String, TypeAnn) -> l.1 == r.1), _, _);

monoid attribute names::[String] with [], ++;

monoid attribute predsSyn::[PredInfo] with [], ++;
inherited attribute predsInh::[PredInfo];

monoid attribute inhs::[(String, TypeAnn, Integer)] with [], ++;
monoid attribute syns::[(String, TypeAnn, Integer)] with [], ++;

inherited attribute nameTyDecls::[(String, TypeAnn)];

function lookup
Maybe<(String, TypeAnn)> ::= name::String decls::[(String, TypeAnn)]
{
  return nothing(); -- todo
}

--------------------------------------------------

nonterminal PredInfo;

synthesized attribute predName::String occurs on PredInfo;
attribute syns occurs on PredInfo;
attribute inhs occurs on PredInfo;

abstract production synPredInfo
top::PredInfo ::= 
  name::String
  term::(String, TypeAnn, Integer)
  inhs::[(String, TypeAnn, Integer)]
  syns::[(String, TypeAnn, Integer)]
{
  top.predName = name;
  top.syns := inhs;
  top.inhs := syns;
}

abstract production funPredInfo
top::PredInfo ::= 
  name::String
  args::[(String, TypeAnn, Integer)]
  rets::[(String, TypeAnn, Integer)]
{
  top.predName = name;
  top.syns := args;
  top.inhs := rets;
}

--------------------------------------------------

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{
  preds.predsInh = preds.predsSyn;
}

--------------------------------------------------

attribute predsSyn occurs on Predicates;
propagate predsSyn on Predicates;

attribute predsInh occurs on Predicates;
propagate predsInh on Predicates;

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{}

aspect production predicatesNil
top::Predicates ::= 
{}

--------------------------------------------------

attribute predsSyn occurs on Predicate;

attribute predsInh occurs on Predicate;
propagate predsInh on Predicate;

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{
  nameLst.nameListPos = 0;
  top.predsSyn := [ synPredInfo(name, head(nameLst.unlabelled), nameLst.syns, nameLst.inhs) ];
  bs.nameTyDecls = nameLst.nameTyDeclsSyn;
}

aspect production functionalPredicate
top::Predicate ::= name::String nameLst::NameList const::Constraint
{
  nameLst.nameListPos = 0;
  top.predsSyn := [ funPredInfo(name, nameLst.syns, nameLst.unlabelled) ];
  const.nameTyDecls = nameLst.nameTyDeclsSyn;
}

--------------------------------------------------

attribute predsInh occurs on ProdBranch;
propagate predsInh on ProdBranch;

attribute nameTyDecls occurs on ProdBranch;
propagate nameTyDecls on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{
  params.nameListPos = 0;
}

--------------------------------------------------

attribute predsInh occurs on ProdBranchList;
propagate predsInh on ProdBranchList;

attribute nameTyDecls occurs on ProdBranchList;
propagate nameTyDecls on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{}

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{}

--------------------------------------------------

attribute names occurs on NameList;
propagate names on NameList;

attribute inhs occurs on NameList;
propagate inhs on NameList;

attribute syns occurs on NameList;
propagate syns on NameList;

monoid attribute unlabelled::[(String, TypeAnn, Integer)] with [], ++ occurs on NameList;
propagate unlabelled on NameList;

inherited attribute nameListPos::Integer occurs on NameList;

monoid attribute nameTyDeclsSyn::[(String, TypeAnn)] with [], ++ occurs on NameList;
propagate nameTyDeclsSyn on NameList;

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{
  name.nameListPos  = top.nameListPos;
  names.nameListPos = top.nameListPos + 1;
}

aspect production nameListOne
top::NameList ::= name::Name
{
  name.nameListPos = top.nameListPos;
}

aspect production nameListNil
top::NameList ::=
{}

--------------------------------------------------

attribute names occurs on Name;

attribute inhs occurs on Name;
propagate inhs on Name;

attribute syns occurs on Name;
propagate syns on Name;

attribute unlabelled occurs on Name;
propagate unlabelled on Name;

attribute nameListPos occurs on Name;

attribute nameTyDeclsSyn occurs on Name;
propagate nameTyDeclsSyn on Name;

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.syns  <- [(name, ^ty, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ^ty)];
}

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.inhs  <- [(name, ^ty, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ^ty)];
}

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.syns  <- [(name, ^ty, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ^ty)];
}

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.unlabelled  <- [(name, ^ty, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ^ty)];
}

--------------------------------------------------

attribute freeVarsDefined occurs on Constraint;
propagate freeVarsDefined on Constraint excluding existsConstraint;

attribute predsInh occurs on Constraint;
propagate predsInh on Constraint;

attribute nameTyDecls occurs on Constraint;
propagate nameTyDecls on Constraint;

aspect production trueConstraint
top::Constraint ::=
{}

aspect production falseConstraint
top::Constraint ::=
{}

aspect production conjConstraint
top::Constraint ::= c1::Constraint c2::Constraint
{}

aspect production existsConstraint
top::Constraint ::= names::NameList c::Constraint
{
  top.freeVarsDefined := 
    removeAllBy((\l::(String, TypeAnn) r::(String, TypeAnn) -> l.1 == r.1), 
                names.nameTyDeclsSyn, c.freeVarsDefined);
}

aspect production eqConstraint
top::Constraint ::= t1::Term t2::Term
{}

aspect production neqConstraint
top::Constraint ::= t1::Term t2::Term
{}

aspect production newConstraintDatum
top::Constraint ::= name::String t::Term
{
  top.freeVarsDefined <- [(name, nameType("scope"))];
}

aspect production newConstraint
top::Constraint ::= name::String
{
  top.freeVarsDefined <- [(name, nameType("scope"))];
}

aspect production dataConstraint
top::Constraint ::= name::String d::String
{
  top.freeVarsDefined <- [(d, lookup(d, top.nameTyDecls).fromJust.2)];
}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex out::String
{
  top.freeVarsDefined <- [(out, lookup(out, top.nameTyDecls).fromJust.2)];
}

aspect production oneConstraint
top::Constraint ::= name::String out::String
{
  top.freeVarsDefined <- [(out, lookup(out, top.nameTyDecls).fromJust.2)];
}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp out::String
{
  top.freeVarsDefined <- [(out, lookup(out, top.nameTyDecls).fromJust.2)];
}

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{
  local pred::PredInfo = 
    head(dropWhile((\p::PredInfo -> p.predName != name), top.predsInh));

  vs.index = 0;
  vs.predSyns = pred.syns;
}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher out::String
{
  top.freeVarsDefined <- [(out, lookup(out, top.nameTyDecls).fromJust.2)];
}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{}

aspect production defConstraint
top::Constraint ::= name::String t::Term
{
  top.freeVarsDefined <- [(name, lookup(name, top.nameTyDecls).fromJust.2)];
}

--------------------------------------------------

attribute freeVarsDefined occurs on RefNameList;
propagate freeVarsDefined on RefNameList;

inherited attribute index::Integer occurs on RefNameList;
inherited attribute predSyns::[(String, TypeAnn, Integer)] occurs on RefNameList;

aspect production refNameListCons
top::RefNameList ::= name::String names::RefNameList
{
  local found::Boolean = !null(top.predSyns) && head(top.predSyns).3 == top.index;

  top.freeVarsDefined <- if found then [(name, head(top.predSyns).2)] else [];

  names.index = top.index + 1;
  names.predSyns = if found then tail(top.predSyns) else top.predSyns;
}

aspect production refNameListOne
top::RefNameList ::= name::String
{
  local found::Boolean = !null(top.predSyns) && head(top.predSyns).3 == top.index;
  top.freeVarsDefined <- if found then [] else [(name, head(top.predSyns).2)];
}

aspect production refNameListNil
top::RefNameList ::=
{}

--------------------------------------------------

attribute freeVarsDefined occurs on Branch;
propagate freeVarsDefined on Branch;

attribute predsInh occurs on Branch;
propagate predsInh on Branch;

attribute nameTyDecls occurs on Branch;
propagate nameTyDecls on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{}

--------------------------------------------------

attribute freeVarsDefined occurs on BranchList;
propagate freeVarsDefined on BranchList;

attribute predsInh occurs on BranchList;
propagate predsInh on BranchList;

attribute nameTyDecls occurs on BranchList;
propagate nameTyDecls on BranchList;


aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{}

aspect production branchListOne
top::BranchList ::= b::Branch
{}

--------------------------------------------------

attribute freeVarsDefined occurs on Lambda;
propagate freeVarsDefined on Lambda;

attribute predsInh occurs on Lambda;
propagate predsInh on Lambda;

attribute nameTyDecls occurs on Lambda;
propagate nameTyDecls on Lambda;

aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{}