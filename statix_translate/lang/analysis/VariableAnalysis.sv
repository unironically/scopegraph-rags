grammar statix_translate:lang:analysis;

--------------------------------------------------

global builtinTypeNames::[String] = [
  "scope", "datum", "string", "path"
];

--------------------------------------------------

monoid attribute freeVarsDefined::[(String, Type)] with [], 
  unionBy((\l::(String, Type) r::(String, Type) -> l.1 == r.1), _, _);

monoid attribute names::[String] with [], ++;

monoid attribute predsSyn::[PredInfo] with [], ++;
inherited attribute predsInh::[PredInfo];

monoid attribute inhs::[(String, Type, Integer)] with [], ++;
monoid attribute syns::[(String, Type, Integer)] with [], ++;

inherited attribute nameTyDecls::[(String, Type)];

--------------------------------------------------

function lookupVar
Maybe<(String, Type)> ::= name::String decls::[(String, Type)]
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
{ return lookupPredAux(name, preds, false); }

function lookupSyntaxPred
Maybe<PredInfo> ::= name::String preds::[PredInfo]
{ return lookupPredAux(name, preds, true); }

function lookupPredAux
Maybe<PredInfo> ::= name::String preds::[PredInfo] mustBeSyn::Boolean
{
  return 
    case preds of
      [] -> nothing()
    | funPredInfo(n, _, _, _, _, _)::_ when !mustBeSyn && name == n ->
        just(head(preds))
    | synPredInfo(n, _, _, _, _, _, _)::_ when name == n ->
        just(head(preds))
    | _::t -> lookupPredAux(name, t, mustBeSyn)
    end;
}

function lookupType
Maybe<Type> ::= name::String preds::[PredInfo]
{
  return
    if contains(name, builtinTypeNames)
    then just(nameType(name))
    else if lookupSyntaxPred(name, preds).isJust
         then just(nameType(name))
         else nothing();
}

--------------------------------------------------

nonterminal PredInfo;

synthesized attribute predName::String occurs on PredInfo;
synthesized attribute predConstraint::Constraint occurs on PredInfo;
synthesized attribute getPositionForParam::(Integer ::= String) occurs on PredInfo;
attribute syns occurs on PredInfo;
attribute inhs occurs on PredInfo;
attribute provides occurs on PredInfo;
attribute requires occurs on PredInfo;

abstract production synPredInfo
top::PredInfo ::= 
  name::String
  term::(String, Type, Integer)
  inhs::[(String, Type, Integer)]
  syns::[(String, Type, Integer)]
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
      nameTerm(term.1, location=bogusLoc())
    in
    let decBranches::Decorated ProdBranchList with {prodTyAnn} = 
      decorate ^branches with {prodTyAnn = nameTypeAnn(name, location=bogusLoc());} 
    in
      matchConstraint(pt, decBranches.toConstraintBranchList, location=bogusLoc())
    end end;

  top.getPositionForParam = getPositionForParamF(name, term::(inhs++syns), _);
}

abstract production funPredInfo
top::PredInfo ::= 
  name::String
  args::[(String, Type, Integer)]
  rets::[(String, Type, Integer)]
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
    Integer ::= predName::String args::[(String, Type, Integer)] s::String =
  let dropped::[(String, Type, Integer)] = 
    dropWhile(\tup::(String, Type, Integer) -> tup.1 != s, args)
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
  preds.predsInh = lfpPredicateInfoSynAll(preds.predsSyn);
}

--------------------------------------------------

function lfpPredicateInfoSynAll
[PredInfo] ::= acc::[PredInfo]
{
  return
    let step::[PredInfo] = map(lfpPredicateInfoSynStepOne(acc, _), acc) in
    let zippedBeforeAfter::[(PredInfo, PredInfo)] = zip(acc, step) in
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
    let body::Constraint = pred.predConstraint in
    let decBody::Decorated Constraint with {predsInh} = (decorate body with {predsInh = acc;}) in
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
      before.requires == after.requires &&
      before.provides == after.provides
    end end;
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

  bs.nameTyDecls = nameLst.nameTyDeclsSyn;
  bs.prodTyAnn = nameTypeAnn(name, location=top.location);

  top.predsSyn := [ synPredInfo(name, head(nameLst.unlabelled), 
                                nameLst.syns, nameLst.inhs, 
                                bs.requiresNoApp, bs.providesNoApp, ^bs) ];
}

aspect production functionalPredicate
top::Predicate ::= name::String nameLst::NameList const::Constraint
{
  nameLst.nameListPos = 0;

  const.nameTyDecls = nameLst.nameTyDeclsSyn;

  top.predsSyn := [ funPredInfo(name, nameLst.syns, nameLst.unlabelled, 
                                const.requiresNoApp, const.providesNoApp, 
                                ^const) ];
}

--------------------------------------------------

synthesized attribute toConstraintBranch::Branch occurs on ProdBranch;

inherited attribute prodTyAnn::TypeAnn occurs on ProdBranch;

attribute predsInh occurs on ProdBranch;
propagate predsInh on ProdBranch;

attribute nameTyDecls occurs on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{
  params.nameListPos = 0;
  top.toConstraintBranch =
    branch(
      matcher (
        constructorPattern (name, params.toPatternList, top.prodTyAnn, location=bogusLoc()),
        nilWhereClause(location=bogusLoc()),
        location=bogusLoc()
      ),
      ^c,
      location=bogusLoc()
    );

  c.nameTyDecls = params.nameTyDeclsSyn ++ top.nameTyDecls;
}

--------------------------------------------------

synthesized attribute toConstraintBranchList::BranchList occurs on ProdBranchList;

attribute predsInh occurs on ProdBranchList;
propagate predsInh on ProdBranchList;

attribute nameTyDecls occurs on ProdBranchList;
propagate nameTyDecls on ProdBranchList;

attribute prodTyAnn occurs on ProdBranchList;
propagate prodTyAnn on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{
  top.toConstraintBranchList = branchListCons(b.toConstraintBranch, 
                                              bs.toConstraintBranchList,
                                              location=bogusLoc());
}

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{
  top.toConstraintBranchList = branchListOne(b.toConstraintBranch,
                                             location=bogusLoc());
}

--------------------------------------------------

monoid attribute unlabelled::[(String, Type, Integer)] with [], ++ occurs on NameList;
propagate unlabelled on NameList;

monoid attribute nameTyDeclsSyn::[(String, Type)] with [], ++ occurs on NameList;
propagate nameTyDeclsSyn on NameList;

inherited attribute nameListPos::Integer occurs on NameList;

attribute names occurs on NameList;
propagate names on NameList;

attribute inhs occurs on NameList;
propagate inhs on NameList;

attribute syns occurs on NameList;
propagate syns on NameList;

attribute predsInh occurs on NameList;
propagate predsInh on NameList;

synthesized attribute toPatternList::PatternList occurs on NameList;

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{
  name.nameListPos  = top.nameListPos;
  names.nameListPos = top.nameListPos + 1;
  top.toPatternList = patternListCons (name.toNamePattern, names.toPatternList,
                                       location=bogusLoc());
}

aspect production nameListOne
top::NameList ::= name::Name
{
  name.nameListPos = top.nameListPos;
  top.toPatternList = patternListCons(name.toNamePattern, 
                                      patternListNil(location=bogusLoc()),
                                      location=bogusLoc());
}

aspect production nameListNil
top::NameList ::=
{
  top.toPatternList = patternListNil(location=bogusLoc());
}

--------------------------------------------------

synthesized attribute toNamePattern::Pattern occurs on Name;

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

attribute predsInh occurs on Name;
propagate predsInh on Name;

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.syns  <- [(name, ty.termTy.fromJust, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ty.termTy.fromJust)];
  top.toNamePattern = namePattern(name, ^ty, location=bogusLoc());
}

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.inhs  <- [(name, ty.termTy.fromJust, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ty.termTy.fromJust)];
  top.toNamePattern = namePattern(name, ^ty, location=bogusLoc());
}

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.syns  <- [(name, ty.termTy.fromJust, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ty.termTy.fromJust)];
  top.toNamePattern = namePattern(name, ^ty, location=bogusLoc());
}

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{
  top.names := [name];
  top.unlabelled  <- [(name, ty.termTy.fromJust, top.nameListPos)];
  top.nameTyDeclsSyn <- [(name, ty.termTy.fromJust)];
  top.toNamePattern = namePattern(name, ^ty, location=bogusLoc());
}

--------------------------------------------------

attribute predsInh occurs on TypeAnn;
propagate predsInh on TypeAnn;

aspect production nameTypeAnn
top::TypeAnn ::= name::String
{
  local nameMaybe::Maybe<Type> = lookupType(name, top.predsInh);

  top.errs <- if !nameMaybe.isJust
              then [ noSuchTypeError(name, top.location) ]
              else [];
}

aspect production listTypeAnn
top::TypeAnn ::= ty::TypeAnn
{}

aspect production setTypeAnn
top::TypeAnn ::= ty::TypeAnn
{}

--------------------------------------------------

attribute nameTyDecls occurs on Term;
propagate nameTyDecls on Term;

aspect production labelTerm
top::Term ::= lab::Label
{}

aspect production labelArgTerm
top::Term ::= lab::Label t::Term
{}

aspect production constructorTerm
top::Term ::= name::String ts::TermList
{}

aspect production nameTerm
top::Term ::= name::String
{
  local nameMaybe::Maybe<(String, Type)> = lookupVar(name, top.nameTyDecls);

  top.errs <- if !nameMaybe.isJust
              then [ noSuchNameError(name, top.location) ]
              else [];
}

aspect production consTerm
top::Term ::= t1::Term t2::Term
{}

aspect production nilTerm
top::Term ::=
{}

aspect production tupleTerm
top::Term ::= ts::TermList
{}

aspect production stringTerm
top::Term ::= s::String
{}

--------------------------------------------------

attribute nameTyDecls occurs on TermList;
propagate nameTyDecls on TermList;

aspect production termListCons
top::TermList ::= t::Term ts::TermList
{}

aspect production termListNil
top::TermList ::=
{}

--------------------------------------------------

synthesized attribute name::String occurs on Label;

aspect production label
top::Label ::= label::String
{
  top.name = label;
}

--------------------------------------------------

attribute freeVarsDefined occurs on Constraint;
propagate freeVarsDefined on Constraint excluding existsConstraint;

attribute predsInh occurs on Constraint;
propagate predsInh on Constraint;

attribute nameTyDecls occurs on Constraint;
propagate nameTyDecls on Constraint excluding existsConstraint;

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
    removeAllBy((\l::(String, Type) r::(String, Type) -> l.1 == r.1), 
                names.nameTyDeclsSyn, c.freeVarsDefined);

  c.nameTyDecls = names.nameTyDeclsSyn ++ top.nameTyDecls;
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
  local nameMaybe::Maybe<(String, Type)> = lookupVar(name, top.nameTyDecls);

  top.freeVarsDefined <- [(name, nameType("scope"))];

  top.errs <- if !nameMaybe.isJust
              then [ noSuchNameError(name, top.location) ]
              else [];
}

aspect production newConstraint
top::Constraint ::= name::String
{
  local nameMaybe::Maybe<(String, Type)> = lookupVar(name, top.nameTyDecls);

  top.freeVarsDefined <- [(name, nameType("scope"))];

  top.errs <- if !nameMaybe.isJust
              then [ noSuchNameError(name, top.location) ]
              else [];
}

aspect production dataConstraint
top::Constraint ::= name::String d::String
{
  local nameMaybe::Maybe<(String, Type)> = lookupVar(name, top.nameTyDecls);
  local dMaybe::Maybe<(String, Type)> = lookupVar(d, top.nameTyDecls);

  top.freeVarsDefined <- [(d, dMaybe.fromJust.2)];

  top.errs <- if !nameMaybe.isJust
              then [ noSuchNameError(name, top.location) ]
              else [];

  top.errs <- if !dMaybe.isJust
              then [ noSuchNameError(d, top.location) ]
              else [];
}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{
  local srcMaybe::Maybe<(String, Type)> = lookupVar(src, top.nameTyDecls);
  local tgtMaybe::Maybe<(String, Type)> = lookupVar(tgt, top.nameTyDecls);

  top.errs <- if !srcMaybe.isJust
              then [ noSuchNameError(src, top.location) ]
              else [];

  top.errs <- if !tgtMaybe.isJust
              then [ noSuchNameError(tgt, top.location) ]
              else [];
}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex out::String
{
  local srcMaybe::Maybe<(String, Type)> = lookupVar(src, top.nameTyDecls);
  local outMaybe::Maybe<(String, Type)> = lookupVar(out, top.nameTyDecls);

  top.freeVarsDefined <- [(out, outMaybe.fromJust.2)];

  top.errs <- if !srcMaybe.isJust
              then [ noSuchNameError(src, top.location) ]
              else [];

  top.errs <- if !outMaybe.isJust
              then [ noSuchNameError(out, top.location) ]
              else [];
}

aspect production oneConstraint
top::Constraint ::= name::String out::String
{
  local nameMaybe::Maybe<(String, Type)> = lookupVar(name, top.nameTyDecls);

  top.freeVarsDefined <- [(out, lookupVar(out, top.nameTyDecls).fromJust.2)];

  top.errs <- if !nameMaybe.isJust
              then [ noSuchNameError(name, top.location) ]
              else [];
}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{
  local nameMaybe::Maybe<(String, Type)> = lookupVar(name, top.nameTyDecls);

  top.errs <- if !nameMaybe.isJust
              then [ noSuchNameError(name, top.location) ]
              else [];
}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp out::String
{
  top.freeVarsDefined <- [(out, lookupVar(out, top.nameTyDecls).fromJust.2)];
}

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{
  local predMaybe::Maybe<PredInfo> = lookupPred(name, top.predsInh);

  vs.index = 0;
  vs.predSyns = case predMaybe of 
                  just(p) -> p.syns
                | _ -> error("applyConstraint for " ++ name)
                end;

  top.errs <- if !predMaybe.isJust
              then [ noSuchPredicateError(name, top.location) ]
              else [];
}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher out::String
{
  local setMaybe::Maybe<(String, Type)> = lookupVar(set, top.nameTyDecls);
  local outMaybe::Maybe<(String, Type)> = lookupVar(out, top.nameTyDecls);

  top.freeVarsDefined <- [ (out, outMaybe.fromJust.2) ];

  top.errs <- if !setMaybe.isJust
              then [ noSuchNameError(set, top.location) ]
              else [];

  top.errs <- if !outMaybe.isJust
              then [ noSuchNameError(out, top.location) ]
              else [];
}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{}

aspect production defConstraint
top::Constraint ::= name::String t::Term
{
  local nameMaybe::Maybe<(String, Type)> = lookupVar(name, top.nameTyDecls);

  top.freeVarsDefined <- [(name, lookupVar(name, top.nameTyDecls).fromJust.2)];

  top.errs <- if !nameMaybe.isJust
              then [ noSuchNameError(name, top.location) ]
              else [];

  top.errs <- case nameMaybe, t.termTy of
              | just((_, t1)), just(t2) -> if !eqType(t1, t2)
                                           then [ typeError("TODO", top.location) ]
                                           else []
              | nothing(), _ -> []
              | _, nothing() -> []
              end;
}

-------------------------------------------------- todo cleanup:

inherited attribute index::Integer occurs on RefNameList;
inherited attribute predSyns::[(String, Type, Integer)] occurs on RefNameList;

synthesized attribute nthName::(String ::= Integer) occurs on RefNameList;

attribute freeVarsDefined occurs on RefNameList;
propagate freeVarsDefined on RefNameList;

attribute nameTyDecls occurs on RefNameList;
propagate nameTyDecls on RefNameList;

aspect production refNameListCons
top::RefNameList ::= name::String names::RefNameList
{
  local nameMaybe::Maybe<(String, Type)> = lookupVar(name, top.nameTyDecls);
  local found::Boolean = !null(top.predSyns) && head(top.predSyns).3 == top.index;

  top.freeVarsDefined <- if found then [(name, head(top.predSyns).2)] else [];

  names.index = top.index + 1;
  names.predSyns = if found then tail(top.predSyns) else top.predSyns;

  top.nthName =
    \i::Integer -> if i == top.index then name else names.nthName(i);

  top.errs <- if !nameMaybe.isJust
              then [ noSuchNameError(name, top.location) ]
              else [];
}

aspect production refNameListOne
top::RefNameList ::= name::String
{
  local nameMaybe::Maybe<(String, Type)> = lookupVar(name, top.nameTyDecls);
  local found::Boolean = !null(top.predSyns) && head(top.predSyns).3 == top.index;

  top.freeVarsDefined <- if found then [] else [(name, head(top.predSyns).2)];

  top.nthName =
    \i::Integer -> if i == top.index then name else error("refNameListOne.nthName");

  top.errs <- if !nameMaybe.isJust
              then [ noSuchNameError(name, top.location) ]
              else [];
}

aspect production refNameListNil
top::RefNameList ::=
{
  top.nthName = \i::Integer -> error("refNameListNil.nthName");
}

--------------------------------------------------

attribute nameTyDecls occurs on Matcher;

attribute nameTyDeclsSyn occurs on Matcher;
propagate nameTyDeclsSyn on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{
  wc.nameTyDecls = p.nameTyDeclsSyn ++ top.nameTyDecls;
  
}

--------------------------------------------------

attribute nameTyDeclsSyn occurs on Pattern;
propagate nameTyDeclsSyn on Pattern excluding namePattern;

aspect production labelPattern
top::Pattern ::= lab::Label
{}

aspect production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{}

aspect production edgePattern
top::Pattern ::= p1::Pattern p2::Pattern p3::Pattern
{}

aspect production endPattern
top::Pattern ::= p::Pattern
{}

aspect production namePattern
top::Pattern ::= name::String ty::TypeAnn
{
  top.nameTyDeclsSyn := [(name, ty.termTy.fromJust)];
}

aspect production constructorPattern
top::Pattern ::= name::String ps::PatternList ty::TypeAnn
{}

aspect production consPattern
top::Pattern ::= p1::Pattern p2::Pattern
{}

aspect production nilPattern
top::Pattern ::=
{}

aspect production tuplePattern
top::Pattern ::= ps::PatternList
{}

aspect production underscorePattern
top::Pattern ::= ty::TypeAnn
{}

--------------------------------------------------

attribute nameTyDeclsSyn occurs on PatternList;
propagate nameTyDeclsSyn on PatternList;

aspect production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{}

aspect production patternListNil
top::PatternList ::=
{}

--------------------------------------------------

attribute nameTyDecls occurs on WhereClause;
propagate nameTyDecls on WhereClause;

aspect production nilWhereClause
top::WhereClause ::=
{}

aspect production withWhereClause
top::WhereClause ::= gl::GuardList
{}

--------------------------------------------------

attribute nameTyDecls occurs on Guard;
propagate nameTyDecls on Guard;

aspect production eqGuard
top::Guard ::= t1::Term t2::Term
{}

aspect production neqGuard
top::Guard ::= t1::Term t2::Term
{}

--------------------------------------------------

attribute nameTyDecls occurs on GuardList;
propagate nameTyDecls on GuardList;

aspect production guardListCons
top::GuardList ::= g::Guard gl::GuardList
{}

aspect production guardListOne
top::GuardList ::= g::Guard
{}

--------------------------------------------------

attribute freeVarsDefined occurs on Branch;
propagate freeVarsDefined on Branch;

attribute predsInh occurs on Branch;
propagate predsInh on Branch;

attribute nameTyDecls occurs on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{
  m.nameTyDecls = top.nameTyDecls;
  c.nameTyDecls = m.nameTyDeclsSyn ++ top.nameTyDecls;
}

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

aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{
  wc.nameTyDecls = (arg, ty.termTy.fromJust) :: top.nameTyDecls;
  c.nameTyDecls  = (arg, ty.termTy.fromJust) :: top.nameTyDecls;
}