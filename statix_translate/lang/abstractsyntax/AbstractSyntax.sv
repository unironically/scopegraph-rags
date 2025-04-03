grammar statix_translate:lang:abstractsyntax;

--------------------------------------------------

nonterminal Module with location;

abstract production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{}
 
--------------------------------------------------

nonterminal Orders with location;

abstract production ordersCons
top::Orders ::= ord::Order ords::Orders
{}

abstract production ordersNil
top::Orders ::= 
{}

nonterminal Order with location;

abstract production order
top::Order ::= name::String pathComp::PathComp
{}

--------------------------------------------------

nonterminal Imports with location;

abstract production importsCons
top::Imports ::= imp::Import imps::Imports
{}

abstract production importsNil
top::Imports ::=
{}

nonterminal Import with location;

abstract production imp
top::Import ::= qual::QualName
{}

--------------------------------------------------

nonterminal Predicates with location;

abstract production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{}

abstract production predicatesNil
top::Predicates ::= 
{}

nonterminal Predicate with location;

abstract production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{}

abstract production functionalPredicate
top::Predicate ::= name::String nameLst::NameList const::Constraint
{} 

--------------------------------------------------

nonterminal ProdBranch with location;

abstract production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{}

nonterminal ProdBranchList with location;

abstract production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{}

abstract production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{}

--------------------------------------------------

nonterminal NameList with location;

abstract production nameListCons
top::NameList ::= name::Name names::NameList
{}

abstract production nameListOne
top::NameList ::= name::Name
{}

abstract production nameListNil
top::NameList ::=
{}

nonterminal Name with location;

abstract production nameSyn
top::Name ::= name::String ty::TypeAnn
{}

abstract production nameInh
top::Name ::= name::String ty::TypeAnn
{}

abstract production nameRet
top::Name ::= name::String ty::TypeAnn
{}

abstract production nameUntagged
top::Name ::= name::String ty::TypeAnn
{}

--------------------------------------------------

nonterminal TypeAnn with location;

abstract production nameType
top::TypeAnn ::= name::String
{}

abstract production listType
top::TypeAnn ::= ty::TypeAnn
{}

abstract production setType
top::TypeAnn ::= ty::TypeAnn
{}

--------------------------------------------------

nonterminal Term with location;

abstract production labelTerm
top::Term ::= lab::Label
{}

abstract production labelArgTerm
top::Term ::= lab::Label t::Term
{}

abstract production constructorTerm
top::Term ::= name::String ts::TermList
{}

abstract production nameTerm
top::Term ::= name::String
{}

abstract production consTerm
top::Term ::= t1::Term t2::Term
{}

abstract production nilTerm
top::Term ::=
{}

abstract production tupleTerm
top::Term ::= ts::TermList
{}

abstract production stringTerm
top::Term ::= s::String
{}

nonterminal TermList with location;

abstract production termListCons
top::TermList ::= t::Term ts::TermList
{}

abstract production termListNil
top::TermList ::=
{}

nonterminal Label with location;

abstract production label
top::Label ::= label::String
{

}

--------------------------------------------------

nonterminal Constraint with location;

abstract production trueConstraint
top::Constraint ::=
{}

abstract production falseConstraint
top::Constraint ::=
{}

abstract production conjConstraint
top::Constraint ::= c1::Constraint c2::Constraint
{}

abstract production existsConstraint
top::Constraint ::= names::NameList c::Constraint
{}

abstract production eqConstraint
top::Constraint ::= t1::Term t2::Term
{}

abstract production neqConstraint
top::Constraint ::= t1::Term t2::Term
{}

abstract production newConstraintDatum
top::Constraint ::= name::String t::Term
{}

abstract production newConstraint
top::Constraint ::= name::String
{}

abstract production dataConstraint
top::Constraint ::= name::String d::String
{}

abstract production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{}

abstract production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{}

{- In mstx syntax, the `out` arg can be any term, but only a variable
 - name is used in examples. We make the restriction that it can only
 - be a variable name.
 -}
abstract production oneConstraint
top::Constraint ::= name::String out::String
{}

abstract production nonEmptyConstraint
top::Constraint ::= name::String
{}

abstract production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{}

abstract production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{}

abstract production everyConstraint
top::Constraint ::= name::String lam::Lambda
{}

abstract production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{}

abstract production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{}

abstract production defConstraint
top::Constraint ::= name::String t::Term
{}

--------------------------------------------------

nonterminal RefNameList with location;

abstract production refNameListCons
top::RefNameList ::= name::String names::RefNameList
{}

abstract production refNameListOne
top::RefNameList ::= name::String
{}

abstract production refNameListNil
top::RefNameList ::=
{}

--------------------------------------------------

nonterminal Matcher with location;

abstract production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{}

--------------------------------------------------

nonterminal Pattern with location;

abstract production labelPattern
top::Pattern ::= lab::Label
{}

abstract production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{}

abstract production edgePattern
top::Pattern ::= p1::Pattern p2::Pattern p3::Pattern
{}

abstract production endPattern
top::Pattern ::= p::Pattern
{}

abstract production namePattern
top::Pattern ::= name::String ty::TypeAnn
{}

abstract production constructorPattern
top::Pattern ::= name::String ps::PatternList ty::TypeAnn
{}

abstract production consPattern
top::Pattern ::= p1::Pattern p2::Pattern
{}

abstract production nilPattern
top::Pattern ::=
{}

abstract production tuplePattern
top::Pattern ::= ps::PatternList
{}

abstract production underscorePattern
top::Pattern ::= ty::TypeAnn
{}

nonterminal PatternList with location;

abstract production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{}

abstract production patternListNil
top::PatternList ::=
{}

--------------------------------------------------

nonterminal WhereClause with location;

abstract production nilWhereClause
top::WhereClause ::=
{}

abstract production withWhereClause
top::WhereClause ::= gl::GuardList
{}

--------------------------------------------------

nonterminal Guard with location;

abstract production eqGuard
top::Guard ::= t1::Term t2::Term
{}

abstract production neqGuard
top::Guard ::= t1::Term t2::Term
{}

nonterminal GuardList with location;

abstract production guardListCons
top::GuardList ::= g::Guard gl::GuardList
{}

abstract production guardListOne
top::GuardList ::= g::Guard
{}

--------------------------------------------------

nonterminal Branch with location;

abstract production branch
top::Branch ::= m::Matcher c::Constraint
{}

nonterminal BranchList with location;

abstract production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{}

abstract production branchListOne
top::BranchList ::= b::Branch
{}

--------------------------------------------------

nonterminal Lambda with location;

abstract production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{}

--------------------------------------------------

nonterminal Regex with location;

abstract production regexLabel
top::Regex ::= lab::Label
{}

abstract production regexSeq
top::Regex ::= r1::Regex r2::Regex
{}

abstract production regexAlt
top::Regex ::= r1::Regex r2::Regex
{}

abstract production regexAnd
top::Regex ::= r1::Regex r2::Regex
{}

abstract production regexStar
top::Regex ::= r::Regex
{}

abstract production regexAny
top::Regex ::=
{}

abstract production regexPlus
top::Regex ::= r::Regex
{}

abstract production regexOptional
top::Regex ::= r::Regex
{}

abstract production regexNeg
top::Regex ::= r::Regex
{}

abstract production regexEps
top::Regex ::=
{}

abstract production regexParens
top::Regex ::= r::Regex
{}

--------------------------------------------------

nonterminal PathComp with location;

abstract production lexicoPathComp
top::PathComp ::= lts::LabelLTs
{}

abstract production revLexicoPathComp
top::PathComp ::= lts::LabelLTs
{}

abstract production scalaPathComp
top::PathComp ::=
{}

abstract production namedPathComp
top::PathComp ::= name::String
{}


nonterminal LabelLTs with location;

abstract production labelLTsCons
top::LabelLTs ::= l1::Label l2::Label lts::LabelLTs
{}

abstract production labelLTsOne
top::LabelLTs ::= l1::Label l2::Label 
{}

--------------------------------------------------

nonterminal QualName with location;

abstract production qualNameDot
top::QualName ::= qn::QualName name::String
{}

abstract production qualNameName
top::QualName ::= name::String
{}