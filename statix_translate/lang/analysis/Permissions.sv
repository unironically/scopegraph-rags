grammar statix_translate:lang:analysis;

--------------------------------------------------

-- todo: Cite Fig. 11, Knowing When to Ask

--------------------------------------------------

monoid attribute requires::[String] with [], union;
monoid attribute provides::[String] with [], union;

monoid attribute requiresNoApp::[String] with [], union;
monoid attribute providesNoApp::[String] with [], union;

--------------------------------------------------

attribute requires, requiresNoApp occurs on ProdBranch;
propagate requires, requiresNoApp on ProdBranch;

attribute provides, providesNoApp occurs on ProdBranch;
propagate provides, providesNoApp on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{}

--------------------------------------------------

attribute requires, requiresNoApp occurs on ProdBranchList;
propagate requires, requiresNoApp on ProdBranchList;

attribute provides, providesNoApp occurs on ProdBranchList;
propagate provides, providesNoApp on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{}

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{}

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
}

aspect production newConstraint
top::Constraint ::= name::String
{
  -- WF-NODE-VAR
  top.provides      := [name];
  top.providesNoApp := [name];
}

aspect production dataConstraint
top::Constraint ::= name::String d::String
{}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{
  -- WF-EDGE
  top.requires      := [src];
  top.requiresNoApp := [src];
}

aspect production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{}

aspect production oneConstraint
top::Constraint ::= name::String out::String
{}

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{}

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{}

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{
  -- no such predicate error already handled in VariableAnalysis
  local pred::PredInfo = 
    lookupPred(name, top.predsInh).fromJust;

  top.requiresNoApp := [];
  top.providesNoApp := [];

  local getPermsFromArgs::([String] ::= [String]) = \ss::[String] ->
    let positions::[Integer] = map(pred.getPositionForParam(_), ss) in
      map(vs.nthName(_), positions)
    end;

  -- WF-APP
  top.requires := getPermsFromArgs(pred.requires);
  top.provides := getPermsFromArgs(pred.provides);
}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{
  -- WF-MATCH
  top.requires      := foldr(union, [], bs.eachBranchRequires);
  top.requiresNoApp := foldr(union, [], bs.eachBranchRequiresNoApp);
  top.provides      := foldr(intersect, [], bs.eachBranchProvides);
  top.providesNoApp := foldr(intersect, [], bs.eachBranchProvidesNoApp);
}

aspect production defConstraint
top::Constraint ::= name::String t::Term
{}

--------------------------------------------------

attribute provides, providesNoApp occurs on Branch;
propagate provides, providesNoApp on Branch;

attribute requires, requiresNoApp occurs on Branch;
propagate requires, requiresNoApp on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{}

--------------------------------------------------

synthesized attribute eachBranchRequires::[[String]] occurs on BranchList;
synthesized attribute eachBranchRequiresNoApp::[[String]] occurs on BranchList;

synthesized attribute eachBranchProvides::[[String]] occurs on BranchList;
synthesized attribute eachBranchProvidesNoApp::[[String]] occurs on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{
  top.eachBranchProvides      = b.provides :: bs.eachBranchProvides;
  top.eachBranchProvidesNoApp = b.providesNoApp :: bs.eachBranchProvidesNoApp;
  top.eachBranchRequires      = b.requires :: bs.eachBranchRequires;
  top.eachBranchRequiresNoApp = b.requiresNoApp :: bs.eachBranchRequiresNoApp;
}

aspect production branchListOne
top::BranchList ::= b::Branch
{
  top.eachBranchProvides      = [b.provides];
  top.eachBranchProvidesNoApp = [b.providesNoApp];
  top.eachBranchRequires      = [b.requires];
  top.eachBranchRequiresNoApp = [b.requiresNoApp];
}

--------------------------------------------------

attribute provides, providesNoApp occurs on Lambda;
propagate provides, providesNoApp on Lambda;

attribute requires, requiresNoApp occurs on Lambda;
propagate requires, requiresNoApp on Lambda;

aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{}