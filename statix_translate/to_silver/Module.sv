grammar statix_translate:to_silver;

--------------------------------------------------

attribute ag_decls occurs on Module;
propagate ag_decls on Module;

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

attribute ag_decls occurs on Predicates;
propagate ag_decls on Predicates;

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{}

aspect production predicatesNil
top::Predicates ::= 
{}

--------------------------------------------------

attribute ag_decls occurs on Predicate;
propagate ag_decls on Predicate;

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{}

aspect production functionalPredicate
top::Predicate ::= name::String nameLst::NameList const::Constraint
{} 

--------------------------------------------------

attribute ag_decls occurs on ProdBranch;
propagate ag_decls on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{}

--------------------------------------------------

attribute ag_decls occurs on ProdBranchList;
propagate ag_decls on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{}

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{}