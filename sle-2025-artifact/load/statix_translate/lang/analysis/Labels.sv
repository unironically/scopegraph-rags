grammar statix_translate:lang:analysis;

--------------------------------------------------

-- TODO:
-- - cleanup occurs decls

--------------------------------------------------

monoid attribute labelsSyn::[Label] with [], union;

inherited attribute knownLabels::[Label];

--------------------------------------------------

attribute labelsSyn occurs on Module;

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{
  local allLabels::[Label] = union(ords.labelsSyn, preds.labelsSyn);
  ords.knownLabels  = allLabels;
  preds.knownLabels = allLabels;
  top.labelsSyn := allLabels;
}
 
--------------------------------------------------

attribute labelsSyn occurs on Orders;
propagate labelsSyn on Orders;

attribute knownLabels occurs on Orders;
propagate knownLabels on Orders;

--------------------------------------------------

attribute labelsSyn occurs on Predicates;
propagate labelsSyn on Predicates;

attribute knownLabels occurs on Predicates;
propagate knownLabels on Predicates;

--------------------------------------------------

attribute labelsSyn occurs on Predicate;
propagate labelsSyn on Predicate;

attribute knownLabels occurs on Predicate;
propagate knownLabels on Predicate;

--------------------------------------------------

attribute labelsSyn occurs on ProdBranch;
propagate labelsSyn on ProdBranch;

attribute knownLabels occurs on ProdBranch;
propagate knownLabels on ProdBranch;

--------------------------------------------------

attribute labelsSyn occurs on ProdBranchList;
propagate labelsSyn on ProdBranchList;

attribute knownLabels occurs on ProdBranchList;
propagate knownLabels on ProdBranchList;

--------------------------------------------------

attribute labelsSyn occurs on Term;
propagate labelsSyn on Term excluding labelTerm;

attribute knownLabels occurs on Term;
propagate knownLabels on Term;

aspect production labelTerm
top::Term ::= lab::Label
{
  top.labelsSyn := [^lab];
}

aspect production labelArgTerm
top::Term ::= lab::Label t::Term
{
  -- todo, consider args
  top.labelsSyn <- [^lab];
}

--------------------------------------------------

attribute labelsSyn occurs on TermList;
propagate labelsSyn on TermList;

attribute knownLabels occurs on TermList;
propagate knownLabels on TermList;

--------------------------------------------------

attribute labelsSyn occurs on Constraint;
propagate labelsSyn on Constraint;

attribute knownLabels occurs on Constraint;
propagate knownLabels on Constraint;

--------------------------------------------------

attribute labelsSyn occurs on Matcher;
propagate labelsSyn on Matcher;

attribute knownLabels occurs on Matcher;
propagate knownLabels on Matcher;

--------------------------------------------------

attribute labelsSyn occurs on Pattern;
propagate labelsSyn on Pattern excluding labelPattern;

attribute knownLabels occurs on Pattern;
propagate knownLabels on Pattern;

aspect production labelPattern
top::Pattern ::= lab::Label
{
  top.labelsSyn := [^lab];
}

aspect production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{
  -- todo, consider args
  top.labelsSyn <- [^lab];
}

--------------------------------------------------

attribute labelsSyn occurs on PatternList;
propagate labelsSyn on PatternList;

attribute knownLabels occurs on PatternList;
propagate knownLabels on PatternList;

--------------------------------------------------

attribute labelsSyn occurs on WhereClause;
propagate labelsSyn on WhereClause;

attribute knownLabels occurs on WhereClause;
propagate knownLabels on WhereClause;

--------------------------------------------------

attribute labelsSyn occurs on Guard;
propagate labelsSyn on Guard;

attribute knownLabels occurs on Guard;
propagate knownLabels on Guard;

--------------------------------------------------

attribute labelsSyn occurs on GuardList;
propagate labelsSyn on GuardList;

attribute knownLabels occurs on GuardList;
propagate knownLabels on GuardList;

--------------------------------------------------

attribute labelsSyn occurs on Branch;
propagate labelsSyn on Branch;

attribute knownLabels occurs on Branch;
propagate knownLabels on Branch;

--------------------------------------------------

attribute labelsSyn occurs on BranchList;
propagate labelsSyn on BranchList;

attribute knownLabels occurs on BranchList;
propagate knownLabels on BranchList;

--------------------------------------------------

attribute labelsSyn occurs on Lambda;
propagate labelsSyn on Lambda;

attribute knownLabels occurs on Lambda;
propagate knownLabels on Lambda;

--------------------------------------------------

attribute labelsSyn occurs on Regex;
propagate labelsSyn on Regex excluding regexLabel;

attribute knownLabels occurs on Regex;
propagate knownLabels on Regex;

aspect production regexLabel
top::Regex ::= lab::Label
{
  top.labelsSyn := [^lab];
}

--------------------------------------------------

attribute labelsSyn occurs on PathComp;
propagate labelsSyn on PathComp;

attribute knownLabels occurs on PathComp;
propagate knownLabels on PathComp;

--------------------------------------------------

attribute labelsSyn occurs on LabelLTs;
propagate labelsSyn on LabelLTs;

attribute knownLabels occurs on LabelLTs;
propagate knownLabels on LabelLTs;

aspect production labelLTsCons
top::LabelLTs ::= l1::Label l2::Label lts::LabelLTs
{
  top.labelsSyn <- [^l1, ^l2];
}

aspect production labelLTsOne
top::LabelLTs ::= l1::Label l2::Label 
{
  top.labelsSyn <- [^l1, ^l2];
}