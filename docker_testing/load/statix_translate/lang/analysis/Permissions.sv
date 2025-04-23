grammar statix_translate:lang:analysis;

--------------------------------------------------

-- todo: Cite Fig. 11, Knowing When to Ask

--------------------------------------------------

monoid attribute requires::[String] with [], union;
monoid attribute provides::[String] with [], union;

monoid attribute requiresNoApp::[String] with [], union;
monoid attribute providesNoApp::[String] with [], union;

monoid attribute defs::[String] with [], ++;

--------------------------------------------------

aspect production syntaxPredicate
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{
  local pred::PredInfo = head(top.predsSyn);
  local synsNames::[String] = map(fst, nameLst.syns);

  local branchDefs::[[String]] = map(nub, bs.defsAllBranches);
  local uniqueBranchDefLists::[[String]] = nub(branchDefs);
  local defsAllSame::Boolean = length(uniqueBranchDefLists) == 1;

  top.errs <- if defsAllSame
              then []
              else [ branchDefsError(top.location) ];

  local collectedDefs::[String] = if defsAllSame
                                  then head(uniqueBranchDefLists)
                                  else [];

  top.errs <- checkSynsDefined(name, synsNames, collectedDefs, top.location);
}

aspect production functionalPredicate
top::Predicate ::= name::String nameLst::NameList const::Constraint
{
  local pred::PredInfo = head(top.predsSyn);
  local retsNames::[String] = map(fst, nameLst.syns);

  top.errs <- checkSynsDefined(name, retsNames, const.defs, top.location);

  top.errs <- makeMultipleDefErrors(const.defs, top.location);
}

function checkSynsDefined
[Error] ::= predName::String syns::[String] defs::[String] loc::Location
{
  return
    foldr (
      (\var::String errs::[Error] ->
         if !contains(var, defs)
         then undefinedSynError(var, predName, loc) :: errs
         else []),
      [],
      syns
    );
}

--------------------------------------------------

attribute requires, requiresNoApp occurs on ProdBranch;
propagate requires, requiresNoApp on ProdBranch;

attribute provides, providesNoApp occurs on ProdBranch;
propagate provides, providesNoApp on ProdBranch;

attribute defs occurs on ProdBranch;
propagate defs on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{
  top.errs <- makeMultipleDefErrors(c.defs, top.location);
}

function makeMultipleDefErrors
[Error] ::= defs::[String] loc::Location
{
  return
    case defs of
      h::t  -> if contains(h, t) then multiDefError(h, loc) ::
                                      makeMultipleDefErrors(t, loc)
                                 else makeMultipleDefErrors(t, loc)
    | []    -> []
    end;
}

--------------------------------------------------

attribute requires, requiresNoApp occurs on ProdBranchList;
propagate requires, requiresNoApp on ProdBranchList;

attribute provides, providesNoApp occurs on ProdBranchList;
propagate provides, providesNoApp on ProdBranchList;

attribute defsAllBranches occurs on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{
  top.defsAllBranches = b.defs :: bs.defsAllBranches;
}

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{
  top.defsAllBranches = [b.defs];
}

--------------------------------------------------

attribute requires, requiresNoApp occurs on Constraint;
propagate requires, requiresNoApp on Constraint excluding 
  existsConstraint,   -- WF-EXISTS
  edgeConstraint,     -- WF-EDGE
  applyConstraint,    -- WF-APP [todo]
  matchConstraint;    -- WF-MATCH [todo]

attribute provides, providesNoApp occurs on Constraint;
propagate provides, providesNoApp on Constraint excluding
  existsConstraint,   -- WF-EXISTS
  newConstraint,      -- WF-NODE-VAR
  newConstraintDatum, -- WF-NOFE-VAR
  applyConstraint,    -- WF-APP [todo]
  matchConstraint;    -- WF-MATCH [todo]

attribute defs occurs on Constraint;
propagate defs on Constraint excluding existsConstraint, newConstraintDatum, 
  newConstraint, dataConstraint, queryConstraint, oneConstraint, 
  filterConstraint, minConstraint, applyConstraint, matchConstraint, defConstraint;

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
  -- WF-EXISTS
  local requiredButNotProvided::[String] = 
    foldr (
      \existsName::String errNames::[String] ->
        if contains(existsName, c.requires) && !contains(existsName, c.provides)
        then existsName :: errNames
        else [],
      [], names.names);

  top.errs <-
    if !null(requiredButNotProvided)
    then map(permissionError(_, top.location), requiredButNotProvided)
    else [];

  top.requires := removeAll(names.names, c.requires);
  top.provides := removeAll(names.names, c.provides);

  top.requiresNoApp := removeAll(names.names, c.requiresNoApp);
  top.providesNoApp := removeAll(names.names, c.providesNoApp);

  top.defs := removeAll(names.names, c.defs);
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
  -- WF-NODE-VAR
  top.provides      := [name];
  top.providesNoApp := [name];

  top.defs := [name];
}

aspect production newConstraint
top::Constraint ::= name::String
{
  -- WF-NODE-VAR
  top.provides      := [name];
  top.providesNoApp := [name];

  top.defs := [name];
}

aspect production dataConstraint
top::Constraint ::= name::String d::String
{
  top.defs := [d];
}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{
  -- WF-EDGE
  top.requires      := [src];
  top.requiresNoApp := [src];
}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{
  top.defs := [res];
}

aspect production oneConstraint
top::Constraint ::= name::String out::String
{
  top.defs := [out];
}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{
  top.defs := [res];
}

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{
  local predMaybe::Maybe<PredInfo> = lookupPred(name, top.predsInh);
  local pred::PredInfo = predMaybe.fromJust;

  local getArgPerms::([String] ::= [String]) = \ss::[String] ->
    let positions::[Integer] = map(pred.getPositionForParam(_), ss) in
      map(vs.nthName(_), positions)
    end;

  top.requiresNoApp := [];
  top.providesNoApp := [];

  -- WF-APP
  top.requires := if predMaybe.isJust then getArgPerms(pred.requires) else [];
  top.provides := if predMaybe.isJust then getArgPerms(pred.provides) else [];

  top.defs := if predMaybe.isJust then getArgPerms(map(fst, pred.syns)) else [];
}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{
  top.defs := [res];
}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{
  -- WF-MATCH
  top.requires      := foldr(union, [], bs.eachBranchRequires);
  top.requiresNoApp := foldr(union, [], bs.eachBranchRequiresNoApp);
  top.provides      := foldr(intersect, [], bs.eachBranchProvides);
  top.providesNoApp := foldr(intersect, [], bs.eachBranchProvidesNoApp);

  local branchDefs::[[String]] = map(nub, bs.defsAllBranches);
  local uniqueBranchDefLists::[[String]] = nub(branchDefs);

  top.errs <- if(length(uniqueBranchDefLists)) != 1
              then [ branchDefsError(top.location) ]
              else [];

  top.defs := if length(uniqueBranchDefLists) == 1
              then head(uniqueBranchDefLists)
              else foldr(intersect, [], uniqueBranchDefLists);
}

aspect production defConstraint
top::Constraint ::= name::String t::Term
{
  top.defs := [name];
}

--------------------------------------------------

attribute provides, providesNoApp occurs on Branch;
propagate provides, providesNoApp on Branch;

attribute requires, requiresNoApp occurs on Branch;
propagate requires, requiresNoApp on Branch;

attribute defs occurs on Branch;
propagate defs on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{}

--------------------------------------------------

synthesized attribute eachBranchRequires::[[String]] occurs on BranchList;
synthesized attribute eachBranchRequiresNoApp::[[String]] occurs on BranchList;

synthesized attribute eachBranchProvides::[[String]] occurs on BranchList;
synthesized attribute eachBranchProvidesNoApp::[[String]] occurs on BranchList;

synthesized attribute defsAllBranches::[[String]] occurs on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{
  top.eachBranchProvides      = b.provides :: bs.eachBranchProvides;
  top.eachBranchProvidesNoApp = b.providesNoApp :: bs.eachBranchProvidesNoApp;
  top.eachBranchRequires      = b.requires :: bs.eachBranchRequires;
  top.eachBranchRequiresNoApp = b.requiresNoApp :: bs.eachBranchRequiresNoApp;

  top.defsAllBranches = b.defs :: bs.defsAllBranches;
}

aspect production branchListOne
top::BranchList ::= b::Branch
{
  top.eachBranchProvides      = [b.provides];
  top.eachBranchProvidesNoApp = [b.providesNoApp];
  top.eachBranchRequires      = [b.requires];
  top.eachBranchRequiresNoApp = [b.requiresNoApp];

  top.defsAllBranches = [b.defs];
}

--------------------------------------------------

attribute provides, providesNoApp occurs on Lambda;
propagate provides, providesNoApp on Lambda;

attribute requires, requiresNoApp occurs on Lambda;
propagate requires, requiresNoApp on Lambda;

attribute defs occurs on Lambda;
propagate defs on Lambda;

aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{}