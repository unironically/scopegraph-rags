grammar statix_translate:lang:analysis;

--------------------------------------------------

monoid attribute freeVarsDefined::[(String, TypeAnn)] with [], 
  unionBy((\l::(String, TypeAnn) r::(String, TypeAnn) -> l.1 == r.1), _, _);

monoid attribute names::[String] with [], ++;

monoid attribute predsSyn::[PredInfo] with [], ++;
inherited attribute predsInh::[PredInfo];

monoid attribute inhs::[(String, TypeAnn, Integer)] with [], ++;
monoid attribute syns::[(String, TypeAnn, Integer)] with [], ++;

inherited attribute nameTyDecls::[(String, TypeAnn)];

--------------------------------------------------

function lookupVar
Maybe<(String, TypeAnn)> ::= name::String decls::[(String, TypeAnn)]
{
  return 
    case decls of
      [] -> nothing()
    | (n, t)::_ when name == n -> just((n, t))
    | _::t -> lookupVar(name, t)
    end;
}

function lookupPred
Maybe<PredInfo> ::= name::String preds::[PredInfo]
{
  return 
    case preds of
      [] -> nothing()
    | funPredInfo(n, _, _, _, _, _)::_    when name == n -> just(head(preds))
    | synPredInfo(n, _, _, _, _, _, _)::_ when name == n -> just(head(preds))
    | _::t -> lookupPred(name, t)
    end;
}

--------------------------------------------------

nonterminal PredInfo;

synthesized attribute predName::String occurs on PredInfo;
synthesized attribute predConstraint::Constraint occurs on PredInfo;
attribute syns occurs on PredInfo;
attribute inhs occurs on PredInfo;
attribute provides occurs on PredInfo;
attribute requires occurs on PredInfo;
synthesized attribute getPositionForParam::(Integer ::= String) occurs on PredInfo;

abstract production synPredInfo
top::PredInfo ::= 
  name::String
  term::(String, TypeAnn, Integer)
  inhs::[(String, TypeAnn, Integer)]
  syns::[(String, TypeAnn, Integer)]
  requires::[String]
  provides::[String]
  branches::ProdBranchList
{
  top.predName = name;
  top.syns := inhs;
  top.inhs := syns;
  top.requires := requires;
  top.provides := provides;

  -- rebuild syntax pred body as a single match constraint
  top.predConstraint =
    let pt::Term =
      nameTerm(term.1)
    in
    let decBranches::Decorated ProdBranchList with {prodTy} = 
      decorate ^branches with {prodTy = nameType(name);} 
    in
      matchConstraint(pt, decBranches.toConstraintBranchList)
    end end;

  top.getPositionForParam = getPositionForParamF(name, term::(inhs++syns), _);
}

abstract production funPredInfo
top::PredInfo ::= 
  name::String
  args::[(String, TypeAnn, Integer)]
  rets::[(String, TypeAnn, Integer)]
  requires::[String]
  provides::[String]
  body::Constraint
{
  top.predName = name;
  top.syns := rets;
  top.inhs := args;
  top.requires := requires;
  top.provides := provides;
  top.predConstraint = ^body;
  top.getPositionForParam = getPositionForParamF(name, args ++ rets, _);
}

fun getPositionForParamF 
    Integer ::= predName::String args::[(String, TypeAnn, Integer)] s::String =
  let dropped::[(String, TypeAnn, Integer)] = 
    dropWhile(\tup::(String, TypeAnn, Integer) -> tup.1 != s, args)
  in
    if null(dropped)
    then error("getPositionForParam(" ++ s ++ ") for predicate " ++ predName)
    else head(dropped).3
  end;

--------------------------------------------------

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{
  -- predicate information including permissions which do not take application
  -- into account, only the result of local permission analysis.
  local predsWithNoAppPerms::[PredInfo] = preds.predsSyn; 



  preds.predsInh = 
    lfpPredicateInfoSynAll(
      predsWithNoAppPerms
    );

}

--------------------------------------------------

function lfpPredicateInfoSynAll
[PredInfo] ::= acc::[PredInfo]
{
  return
    let step::[PredInfo] = map(lfpPredicateInfoSynStepOne(acc, _), acc)
    in
    let zippedBeforeAfter::[(PredInfo, PredInfo)] = zip(acc, step)
    in
      if all(map(noChangePredPerms, zippedBeforeAfter))
      then step
      else lfpPredicateInfoSynAll(step)
    end end;
}

-- do the permission analysis for one predicate body, based on known predicates
function lfpPredicateInfoSynStepOne
PredInfo ::= acc::[PredInfo] pred::PredInfo
{
  return
    let body::Constraint =
      pred.predConstraint
    in
    let decBody::Decorated Constraint with {predsInh} = 
      (decorate body with {predsInh = acc;})
    in
      case pred of
        synPredInfo(n, t, is, ss, _, _, body) ->
          synPredInfo(n, t, is, ss, decBody.requires, decBody.provides, ^body)
      | funPredInfo(n, args, rets, _, _, body) ->
          funPredInfo(n, args, rets, decBody.requires, decBody.provides, ^body)
      end
    end end;
}

-- check that one instance of a predInfo is the same as another in terms of permission
-- before/after needs to be the same predicate
function noChangePredPerms
Boolean ::= infos::(PredInfo, PredInfo)
{
  return
    let before::PredInfo = infos.1 in
    let after::PredInfo  = infos.2 in
      before.predName == after.predName &&
      before.requires == after.requires &&
      before.provides == after.provides
    end end;
}

function strPermsForPred
String ::= pred::PredInfo
{
  return
    pred.predName ++ 
      ":\n\t\trequires: [" ++ 
        implode(", ", pred.requires) ++ 
      "],\n\t\tprovides: [" ++
        implode(", ", pred.provides) ++
      "]"; 
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
  -- todo, improve head(nameLst.unlabelled)
  top.predsSyn := [ synPredInfo(name, head(nameLst.unlabelled), nameLst.syns, nameLst.inhs, bs.requiresNoApp, bs.providesNoApp, ^bs) ];
  bs.nameTyDecls = nameLst.nameTyDeclsSyn;
  bs.prodTy = nameType(name);
}

aspect production functionalPredicate
top::Predicate ::= name::String nameLst::NameList const::Constraint
{
  nameLst.nameListPos = 0;
  top.predsSyn := [ funPredInfo(name, nameLst.syns, nameLst.unlabelled, const.requiresNoApp, const.providesNoApp, ^const) ];
  const.nameTyDecls = nameLst.nameTyDeclsSyn;
}

--------------------------------------------------

attribute predsInh occurs on ProdBranch;
propagate predsInh on ProdBranch;

attribute nameTyDecls occurs on ProdBranch;
propagate nameTyDecls on ProdBranch;

synthesized attribute toConstraintBranch::Branch occurs on ProdBranch;

inherited attribute prodTy::TypeAnn occurs on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{
  params.nameListPos = 0;
  top.toConstraintBranch =
    branch(
      matcher (
        constructorPattern (
          name,
          params.toPatternList,
          top.prodTy
        ),
        nilWhereClause()
      ),
      ^c
    );
}

--------------------------------------------------

attribute predsInh occurs on ProdBranchList;
propagate predsInh on ProdBranchList;

attribute nameTyDecls occurs on ProdBranchList;
propagate nameTyDecls on ProdBranchList;

synthesized attribute toConstraintBranchList::BranchList occurs on ProdBranchList;

attribute prodTy occurs on ProdBranchList;
propagate prodTy on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{
  top.toConstraintBranchList = branchListCons(b.toConstraintBranch, bs.toConstraintBranchList);
}

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{
  top.toConstraintBranchList = branchListOne(b.toConstraintBranch);
}

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

synthesized attribute toPatternList::PatternList occurs on NameList;

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{
  name.nameListPos  = top.nameListPos;
  names.nameListPos = top.nameListPos + 1;
  top.toPatternList = 
    patternListCons (
      name.toNamePattern,
      names.toPatternList
    );
}

aspect production nameListOne
top::NameList ::= name::Name
{
  name.nameListPos = top.nameListPos;
  top.toPatternList = patternListCons(name.toNamePattern, patternListNil());
}

aspect production nameListNil
top::NameList ::=
{
  top.toPatternList = patternListNil();
}

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

synthesized attribute toNamePattern::Pattern occurs on Name;

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.syns  <- [(name, ^ty, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ^ty)];
  top.toNamePattern = namePattern(name, ^ty);
}

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.inhs  <- [(name, ^ty, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ^ty)];
  top.toNamePattern = namePattern(name, ^ty);
}

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.syns  <- [(name, ^ty, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ^ty)];
  top.toNamePattern = namePattern(name, ^ty);
}

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.unlabelled  <- [(name, ^ty, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ^ty)];
  top.toNamePattern = namePattern(name, ^ty);
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
  top.freeVarsDefined <- [(d, lookupVar(d, top.nameTyDecls).fromJust.2)];
}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex out::String
{
  top.freeVarsDefined <- [(out, lookupVar(out, top.nameTyDecls).fromJust.2)];
}

aspect production oneConstraint
top::Constraint ::= name::String out::String
{
  top.freeVarsDefined <- [(out, lookupVar(out, top.nameTyDecls).fromJust.2)];
}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp out::String
{
  top.freeVarsDefined <- [(out, lookupVar(out, top.nameTyDecls).fromJust.2)];
}

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{
  -- todo, no predicate found error

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
  top.freeVarsDefined <- [(out, lookupVar(out, top.nameTyDecls).fromJust.2)];
}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{}

aspect production defConstraint
top::Constraint ::= name::String t::Term
{
  top.freeVarsDefined <- [(name, lookupVar(name, top.nameTyDecls).fromJust.2)];
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