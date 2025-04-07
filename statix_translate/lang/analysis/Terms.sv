grammar statix_translate:lang:analysis;

--------------------------------------------------

-- collect all constructor terms, check for conflicts

--------------------------------------------------

monoid attribute termsSyn::[Label] with [], union;

inherited attribute knownTerms::[Label];

synthesized attribute termTy::Maybe<Type>;
synthesized attribute termTys::[Maybe<Type>];

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

--------------------------------------------------

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

--------------------------------------------------

aspect production imp
top::Import ::= qual::QualName
{}

--------------------------------------------------

attribute termsSyn occurs on Predicates;
propagate termsSyn on Predicates;

attribute knownTerms occurs on Predicates;
propagate knownTerms on Predicates;

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{}

aspect production predicatesNil
top::Predicates ::= 
{}

--------------------------------------------------

attribute termsSyn occurs on Predicate;
propagate termsSyn on Predicate;

attribute knownTerms occurs on Predicate;
propagate knownTerms on Predicate;

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{}

aspect production functionalPredicate
top::Predicate ::= name::String nameLst::NameList const::Constraint
{} 

--------------------------------------------------

attribute termsSyn occurs on ProdBranch;
propagate termsSyn on ProdBranch;

attribute knownTerms occurs on ProdBranch;
propagate knownTerms on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{}

--------------------------------------------------

attribute termsSyn occurs on ProdBranchList;
propagate termsSyn on ProdBranchList;

attribute knownTerms occurs on ProdBranchList;
propagate knownTerms on ProdBranchList;

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

--------------------------------------------------

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

attribute termTy occurs on TypeAnn;

aspect production nameTypeAnn
top::TypeAnn ::= name::String
{
  top.termTy = just(nameType(name));
}

aspect production listTypeAnn
top::TypeAnn ::= ty::TypeAnn
{
  top.termTy = just(listType(ty.termTy.fromJust));
}

aspect production setTypeAnn
top::TypeAnn ::= ty::TypeAnn
{
  top.termTy = just(setType(ty.termTy.fromJust));
}

--------------------------------------------------

attribute termsSyn occurs on Term;
propagate termsSyn on Term;

attribute knownTerms occurs on Term;
propagate knownTerms on Term;

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

--------------------------------------------------

attribute termsSyn occurs on TermList;
propagate termsSyn on TermList;

attribute knownTerms occurs on TermList;
propagate knownTerms on TermList;

aspect production termListCons
top::TermList ::= t::Term ts::TermList
{}

aspect production termListNil
top::TermList ::=
{}

--------------------------------------------------

aspect production label
top::Label ::= label::String
{}

--------------------------------------------------

attribute termsSyn occurs on Constraint;
propagate termsSyn on Constraint;

attribute knownTerms occurs on Constraint;
propagate knownTerms on Constraint;

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
{}

aspect production eqConstraint
top::Constraint ::= t1::Term t2::Term
{}

aspect production neqConstraint
top::Constraint ::= t1::Term t2::Term
{}

aspect production newConstraintDatum
top::Constraint ::= name::String t::Term
{}

aspect production newConstraint
top::Constraint ::= name::String
{}

aspect production dataConstraint
top::Constraint ::= name::String d::String
{}

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{}

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
{}

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{}

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{}

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{}

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

attribute termsSyn occurs on Matcher;
propagate termsSyn on Matcher;

attribute knownTerms occurs on Matcher;
propagate knownTerms on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{}

--------------------------------------------------

attribute termsSyn occurs on Pattern;
propagate termsSyn on Pattern;

attribute knownTerms occurs on Pattern;
propagate knownTerms on Pattern;

attribute termTy occurs on Pattern;

aspect production labelPattern
top::Pattern ::= lab::Label
{
  top.termTy = just(nameType("label"));
}

aspect production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{
  top.termTy = just(nameType("label"));
}

aspect production edgePattern
top::Pattern ::= p1::Pattern p2::Pattern p3::Pattern
{
  top.termTy = just(nameType("path"));
}

aspect production endPattern
top::Pattern ::= p::Pattern
{
  top.termTy = just(nameType("path"));
}

aspect production namePattern
top::Pattern ::= name::String ty::TypeAnn
{
  top.termTy = just(toType(^ty));
}

aspect production constructorPattern
top::Pattern ::= name::String ps::PatternList ty::TypeAnn
{
  top.termTy = just(toType(^ty));
}

aspect production consPattern
top::Pattern ::= p1::Pattern p2::Pattern
{
  top.termTy = case p1.termTy, p2.termTy of
               | just(t1), just(listType(t2)) when eqType(t1, ^t2) -> just(listType(t1))
               | _, _ -> nothing()
               end;
}

aspect production nilPattern
top::Pattern ::=
{
  top.termTy = just(listType(varType()));
}

aspect production tuplePattern
top::Pattern ::= ps::PatternList
{
  top.termTy = if all(map((.isJust), ps.termTys))
               then just(tupleType(map((.fromJust), ps.termTys)))
               else nothing();
}

aspect production underscorePattern
top::Pattern ::= ty::TypeAnn
{
  top.termTy = just(toType(^ty));
}

--------------------------------------------------

attribute termsSyn occurs on PatternList;
propagate termsSyn on PatternList;

attribute knownTerms occurs on PatternList;
propagate knownTerms on PatternList;

attribute termTys occurs on PatternList;

aspect production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{
  top.termTys = p.termTy :: ps.termTys;
}

aspect production patternListNil
top::PatternList ::=
{
  top.termTys = [];
}

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

--------------------------------------------------

aspect production guardListCons
top::GuardList ::= g::Guard gl::GuardList
{}

aspect production guardListOne
top::GuardList ::= g::Guard
{}

--------------------------------------------------

attribute termsSyn occurs on Branch;
propagate termsSyn on Branch;

attribute knownTerms occurs on Branch;
propagate knownTerms on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{}

--------------------------------------------------

attribute termsSyn occurs on BranchList;
propagate termsSyn on BranchList;

attribute knownTerms occurs on BranchList;
propagate knownTerms on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{}

aspect production branchListOne
top::BranchList ::= b::Branch
{}

--------------------------------------------------

attribute termsSyn occurs on Lambda;
propagate termsSyn on Lambda;

attribute knownTerms occurs on Lambda;
propagate knownTerms on Lambda;

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

--------------------------------------------------

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