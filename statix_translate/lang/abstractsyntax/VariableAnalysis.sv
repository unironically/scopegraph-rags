grammar statix_translate:lang:abstractsyntax;

--------------------------------------------------

monoid attribute freeVarsDefined::[String] with [], union;

monoid attribute names::[String] with [], ++;

monoid attribute predsSyn::[PredInfo] with [], ++;
inherited attribute predsInh::[PredInfo];

monoid attribute inhs::[(String, TypeAnn, Integer)] with [], ++;
monoid attribute syns::[(String, TypeAnn, Integer)] with [], ++;

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
}

aspect production functionalPredicate
top::Predicate ::= name::String nameLst::NameList const::Constraint
{
  nameLst.nameListPos = 0;
  top.predsSyn := [ funPredInfo(name, nameLst.syns, nameLst.unlabelled) ];
}

--------------------------------------------------

attribute predsInh occurs on ProdBranch;
propagate predsInh on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{
  params.nameListPos = 0;
}

--------------------------------------------------

attribute predsInh occurs on ProdBranchList;
propagate predsInh on ProdBranchList;

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

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.syns  <- [(name, ^ty, top.nameListPos)];
}

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.inhs  <- [(name, ^ty, top.nameListPos)];
}

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.syns  <- [(name, ^ty, top.nameListPos)];
}

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.unlabelled <- [(name, ^ty, top.nameListPos)];
}

--------------------------------------------------

attribute freeVarsDefined occurs on Constraint;
propagate freeVarsDefined on Constraint excluding existsConstraint, matchConstraint;

attribute predsInh occurs on Constraint;
propagate predsInh on Constraint;

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
  top.freeVarsDefined := removeAll(names.names, c.freeVarsDefined);
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
  top.freeVarsDefined <- [name];
}

aspect production newConstraint
top::Constraint ::= name::String
{
  top.freeVarsDefined <- [name];
}

aspect production dataConstraint
top::Constraint ::= name::String d::String
{
  top.freeVarsDefined <- [d];
}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex out::String
{
  top.freeVarsDefined <- [out];
}

aspect production oneConstraint
top::Constraint ::= name::String out::String
{
  top.freeVarsDefined <- [out];
}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp out::String
{
  top.freeVarsDefined <- [out];
}

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher out::String
{
  top.freeVarsDefined <- [out];
}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{
  top.freeVarsDefined := [];
}

aspect production defConstraint
top::Constraint ::= name::String t::Term
{
  top.freeVarsDefined <- [name];
}

--------------------------------------------------

attribute freeVarsDefined occurs on RefNameList;
propagate freeVarsDefined on RefNameList;

aspect production refNameListCons
top::RefNameList ::= name::String names::RefNameList
{}

aspect production refNameListOne
top::RefNameList ::= name::String
{}

aspect production refNameListNil
top::RefNameList ::=
{}

--------------------------------------------------

attribute freeVarsDefined occurs on Branch;
propagate freeVarsDefined on Branch;

attribute predsInh occurs on Branch;
propagate predsInh on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{}

--------------------------------------------------

attribute freeVarsDefined occurs on BranchList;
propagate freeVarsDefined on BranchList;

attribute predsInh occurs on BranchList;
propagate predsInh on BranchList;

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

aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{}