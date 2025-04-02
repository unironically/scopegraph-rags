grammar statix_translate:lang:analysis;

-- todo: Cite Fig. 11, Knowing When to Ask

--------------------------------------------------

monoid attribute requires::[String] with [], union;
monoid attribute provides::[String] with [], union;

monoid attribute requiresNoApp::[String] with [], union;
monoid attribute providesNoApp::[String] with [], union;

--------------------------------------------------

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{}
 
--------------------------------------------------

aspect production ordersCons
top::Orders ::= ord::Order ords::Orders
{}

aspect production ordersNil
top::Orders ::= 
{}

aspect production order
top::Order ::= name::String pathComp::PathComp
{}

--------------------------------------------------

aspect production importsCons
top::Imports ::= imp::Import imps::Imports
{}

aspect production importsNil
top::Imports ::=
{}

aspect production imp
top::Import ::= qual::QualName
{}

--------------------------------------------------

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{}

aspect production predicatesNil
top::Predicates ::= 
{}

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{}

aspect production functionalPredicate
top::Predicate ::= name::String nameLst::NameList const::Constraint
{}

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

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{}

aspect production nameListOne
top::NameList ::= name::Name
{}

aspect production nameListNil
top::NameList ::=
{}

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{}

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{}

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{}

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{}

--------------------------------------------------

aspect production nameType
top::TypeAnn ::= name::String
{}

aspect production listType
top::TypeAnn ::= ty::TypeAnn
{}

aspect production setType
top::TypeAnn ::= ty::TypeAnn
{}

--------------------------------------------------

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
{}

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

aspect production termListCons
top::TermList ::= t::Term ts::TermList
{}

aspect production termListNil
top::TermList ::=
{}

aspect production label
top::Label ::= label::String
{

}

--------------------------------------------------

attribute requires, requiresNoApp occurs on Constraint;
propagate requires, requiresNoApp on Constraint excluding 
  existsConstraint,   -- WF-EXISTS
  edgeConstraint,     -- WF-EDGE
  applyConstraint;    -- WF-APP [todo]

attribute provides, providesNoApp occurs on Constraint;
propagate provides, providesNoApp on Constraint excluding
  existsConstraint,   -- WF-EXISTS
  newConstraint,      -- WF-NODE-VAR
  newConstraintDatum, -- WF-NOFE-VAR
  applyConstraint;    -- WF-APP [todo]

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
        if  contains(existsName, c.requires) &&
           !contains(existsName, c.provides)
        then existsName :: errNames
        else [],
      [], names.names);

  top.errs <-
    if !null(requiredButNotProvided)
    then map(permissionError(_, bogusLoc()), requiredButNotProvided)
    else [];

  top.requires := removeAll(names.names, c.requires);
  top.provides := removeAll(names.names, c.provides);

  top.requiresNoApp := top.requires;
  top.providesNoApp := top.provides;
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
  top.provides := [name];
  top.providesNoApp := top.provides;
}

aspect production newConstraint
top::Constraint ::= name::String
{
  -- WF-NODE-VAR
  top.provides := [name];
  top.providesNoApp := top.provides;
}

aspect production dataConstraint
top::Constraint ::= name::String d::String
{}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{
  -- WF-EDGE
  top.requires := [src];
  top.requiresNoApp := top.requires;
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
  local pred::PredInfo = 
    unsafeTracePrint(lookupPred(name, top.predsInh).fromJust, "called " ++ name ++ "\n");  -- not found already handled in VariableAnalysis
  top.requires := pred.requires; -- predLookup.requires;
  top.provides := pred.provides; -- predLookup.provides;

  top.requiresNoApp := [];
  top.providesNoApp := [];
}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{
  --  todo?
}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{
  -- todo?
}

aspect production defConstraint
top::Constraint ::= name::String t::Term
{}

--------------------------------------------------

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

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{}

--------------------------------------------------

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
{}

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

aspect production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{}

aspect production patternListNil
top::PatternList ::=
{}

--------------------------------------------------

aspect production nilWhereClause
top::WhereClause ::=
{}

aspect production withWhereClause
top::WhereClause ::= gl::GuardList
{}

--------------------------------------------------

aspect production eqGuard
top::Guard ::= t1::Term t2::Term
{}

aspect production neqGuard
top::Guard ::= t1::Term t2::Term
{}

aspect production guardListCons
top::GuardList ::= g::Guard gl::GuardList
{}

aspect production guardListOne
top::GuardList ::= g::Guard
{}

--------------------------------------------------

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{}

--------------------------------------------------

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{}

aspect production branchListOne
top::BranchList ::= b::Branch
{}

--------------------------------------------------

aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{}

--------------------------------------------------

aspect production regexLabel
top::Regex ::= lab::Label
{}

aspect production regexSeq
top::Regex ::= r1::Regex r2::Regex
{}

aspect production regexAlt
top::Regex ::= r1::Regex r2::Regex
{}

aspect production regexAnd
top::Regex ::= r1::Regex r2::Regex
{}

aspect production regexStar
top::Regex ::= r::Regex
{}

aspect production regexAny
top::Regex ::=
{}

aspect production regexPlus
top::Regex ::= r::Regex
{}

aspect production regexOptional
top::Regex ::= r::Regex
{}

aspect production regexNeg
top::Regex ::= r::Regex
{}

aspect production regexEps
top::Regex ::=
{}

aspect production regexParens
top::Regex ::= r::Regex
{}

--------------------------------------------------

aspect production lexicoPathComp
top::PathComp ::= lts::LabelLTs
{}

aspect production revLexicoPathComp
top::PathComp ::= lts::LabelLTs
{}

aspect production scalaPathComp
top::PathComp ::=
{}

aspect production namedPathComp
top::PathComp ::= name::String
{}


aspect production labelLTsCons
top::LabelLTs ::= l1::Label l2::Label lts::LabelLTs
{}

aspect production labelLTsOne
top::LabelLTs ::= l1::Label l2::Label 
{}

--------------------------------------------------

aspect production qualNameDot
top::QualName ::= qn::QualName name::String
{}

aspect production qualNameName
top::QualName ::= name::String
{}