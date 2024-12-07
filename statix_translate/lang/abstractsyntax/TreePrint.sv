grammar statix_translate:lang:abstractsyntax;

imports silver:langutil:pp;

synthesized attribute doc::Document;
synthesized attribute pp::String;

global indentNo::Integer = 4;

fun itemDoc Document ::= acc::Document ch::Document =
  cat(acc, cat(line(), ch));

fun prodDoc Document ::= prod::String children::[Document] =
  let childrenDoc::Document = foldl(itemDoc, cat(line(), head(children)), 
                                             tail(children)) in
    cat (
      text (prod ++ " ("),
      if null(children)
        then text(")")
        else cat(nest(indentNo, group (childrenDoc)), cat(line(), text(")")))        
    )
  end;

--------------------------------------------------

attribute pp occurs on Module;

aspect production module
top::Module ::= imps::Imports ords::Orders preds::Predicates
{
  top.pp = showDoc(0, prodDoc("module", [imps.doc, ords.doc, preds.doc]))
           ++ "\n"; }
 
--------------------------------------------------

attribute doc occurs on Orders;

aspect production ordersCons
top::Orders ::= ord::Order ords::Orders
{ top.doc = prodDoc("ordersCons", [ord.doc, ords.doc]); }

aspect production ordersNil
top::Orders ::= 
{ top.doc = prodDoc("ordersNil", []); }

attribute doc occurs on Order;

aspect production order
top::Order ::= name::String pc::PathComp
{ top.doc = prodDoc("order", [text("\"" ++ name ++ "\""), pc.doc]); }

--------------------------------------------------

attribute doc occurs on Imports;

aspect production importsCons
top::Imports ::= imp::Import imps::Imports
{ top.doc = prodDoc("importsCons", [imp.doc, imps.doc]); }

aspect production importsNil
top::Imports ::=
{ top.doc = prodDoc("importsNil", []); }

attribute doc occurs on Import;

aspect production imp
top::Import ::= qual::QualName
{ top.doc = prodDoc("imp", [qual.doc]); }

--------------------------------------------------

attribute doc occurs on Predicates;

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{ top.doc = prodDoc("predicatesCons", [pred.doc, preds.doc]); }

aspect production predicatesNil
top::Predicates ::= 
{ top.doc = prodDoc("predicatesNil", []); }

attribute doc occurs on Predicate;

aspect production predicate 
top::Predicate ::= name::String nameLst::NameList const::Constraint
{ top.doc = prodDoc("predicate", [text("\"" ++ name ++ "\""), nameLst.doc, const.doc]); } 

attribute doc occurs on NameList;

aspect production nameListCons
top::NameList ::= name::String names::NameList
{ top.doc = prodDoc("nameListCons", [text("\"" ++ name ++ "\""), names.doc]); }

aspect production nameListOne
top::NameList ::= name::String
{ top.doc = prodDoc("nameListOne", [text("\"" ++ name ++ "\"")]); }

--------------------------------------------------

attribute doc occurs on Term;

aspect production labelTerm
top::Term ::= lab::Label
{ top.doc = prodDoc("labelTerm", [lab.doc]); }

aspect production labelArgTerm
top::Term ::= lab::Label t::Term
{ top.doc = prodDoc("labelArgTerm", [lab.doc, t.doc]); }

aspect production constructorTerm
top::Term ::= name::String ts::TermList
{ top.doc = prodDoc("constructorTerm", [text("\"" ++ name ++ "\""), ts.doc]); }

aspect production nameTerm
top::Term ::= name::String
{ top.doc = prodDoc("nameTerm", [text("\"" ++ name ++ "\"")]); }

aspect production consTerm
top::Term ::= t1::Term t2::Term
{ top.doc = prodDoc("consTerm", [t1.doc, t2.doc]); }

aspect production nilTerm
top::Term ::=
{ top.doc = prodDoc("nilTerm", []); }

aspect production tupleTerm
top::Term ::= ts::TermList
{ top.doc = prodDoc("tupleTerm", [ts.doc]); }

aspect production stringTerm
top::Term ::= s::String
{ top.doc = prodDoc("stringTerm", [text("\"" ++ s ++ "\"")]); }

attribute doc occurs on TermList;

aspect production termListCons
top::TermList ::= t::Term ts::TermList
{ top.doc = prodDoc("termListCons", [t.doc, ts.doc]); }

aspect production termListOne
top::TermList ::= t::Term
{ top.doc = prodDoc("termListOne", [t.doc]); }

attribute doc occurs on Label;

aspect production label
top::Label ::= label::String
{ top.doc = prodDoc("label", [text("\"" ++ label ++ "\"")]); }

--------------------------------------------------

attribute doc occurs on Constraint;

aspect production trueConstraint
top::Constraint ::=
{ top.doc = prodDoc("trueConstraint", []); }

aspect production falseConstraint
top::Constraint ::=
{ top.doc = prodDoc("falseConstraint", []); }

aspect production conjConstraint
top::Constraint ::= c1::Constraint c2::Constraint
{ top.doc = prodDoc("conjConstraint", [c1.doc, c2.doc]); }

aspect production existsConstraint
top::Constraint ::= names::NameList c::Constraint
{ top.doc = prodDoc("existsConstraint", [names.doc, c.doc]); }

aspect production eqConstraint
top::Constraint ::= t1::Term t2::Term
{ top.doc = prodDoc("eqConstraint", [t1.doc, t2.doc]); }

aspect production neqConstraint
top::Constraint ::= t1::Term t2::Term
{ top.doc = prodDoc("neqConstraint", [t1.doc, t2.doc]); }

aspect production newConstraintDatum
top::Constraint ::= name::String t::Term
{ top.doc = prodDoc("newConstraintDatum", [text("\"" ++ name ++ "\""), t.doc]); }

aspect production newConstraint
top::Constraint ::= name::String
{ top.doc = prodDoc("newConstraint", [text("\"" ++ name ++ "\"")]); }

aspect production dataConstraint
top::Constraint ::= name::String t::Term
{ top.doc = prodDoc("dataConstraint", [text("\"" ++ name ++ "\""), t.doc]); }

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{ top.doc = prodDoc("edgeConstraint", [text("\"" ++ src ++ "\""), lab.doc, text("\"" ++ tgt ++ "\"")]); }

aspect production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{ top.doc = prodDoc("queryConstraint", [text("\"" ++ src ++ "\""), r.doc, text("\"" ++ res ++ "\"")]); }

aspect production oneConstraint
top::Constraint ::= name::String t::Term
{ top.doc = prodDoc("oneConstraint", [text("\"" ++ name ++ "\""), t.doc]); }

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{ top.doc = prodDoc("nonEmptyConstraint", [text("\"" ++ name ++ "\"")]); }

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{ top.doc = prodDoc("minConstraint", [text("\"" ++ set ++ "\""), pc.doc, text("\"" ++ res ++ "\"")]); }

aspect production applyConstraint
top::Constraint ::= name::String ts::TermList
{ top.doc = prodDoc("queryConstraint", [text("\"" ++ name ++ "\""), ts.doc]); }

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{ top.doc = prodDoc("everyConstraint", [text("\"" ++ name ++ "\""), lam.doc]); }

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{ top.doc = prodDoc("filterConstraint", [text("\"" ++ set ++ "\""), m.doc, text("\"" ++ res ++ "\"")]); }

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{ top.doc = prodDoc("matchConstraint", [t.doc, bs.doc]); }

--------------------------------------------------

attribute doc occurs on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{ top.doc = prodDoc("matcher", [p.doc, wc.doc]); }

--------------------------------------------------

attribute doc occurs on Pattern;

aspect production labelPattern
top::Pattern ::= lab::Label
{ top.doc = prodDoc("labelPattern", [lab.doc]); }

aspect production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{ top.doc = prodDoc("labelArgsPattern", [lab.doc, p.doc]); }

aspect production edgePattern
top::Pattern ::= p1::Pattern p2::Pattern p3::Pattern
{ top.doc = prodDoc("edgePattern", [p1.doc, p2.doc, p3.doc]); }

aspect production endPattern
top::Pattern ::= p::Pattern
{ top.doc = prodDoc("endPattern", [p.doc]); }

aspect production namePattern
top::Pattern ::= name::String
{ top.doc = prodDoc("namePattern", [text("\"" ++ name ++ "\"")]); }

aspect production constructorPattern
top::Pattern ::= name::String ps::PatternList
{ top.doc = prodDoc("constructorPattern", [text("\"" ++ name ++ "\""), ps.doc]); }

aspect production consPattern
top::Pattern ::= p1::Pattern p2::Pattern
{ top.doc = prodDoc("consPattern", [p1.doc, p2.doc]); }

aspect production nilPattern
top::Pattern ::=
{ top.doc = prodDoc("nilPattern", []); }

aspect production tuplePattern
top::Pattern ::= ps::PatternList
{ top.doc = prodDoc("tuplePattern", [ps.doc]); }

aspect production underscorePattern
top::Pattern ::=
{ top.doc = prodDoc("underscorePattern", []); }

attribute doc occurs on PatternList;

aspect production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{ top.doc = prodDoc("patternListCons", [p.doc, ps.doc]); }

aspect production patternListOne
top::PatternList ::= p::Pattern
{ top.doc = prodDoc("patternListOne", [p.doc]); }

--------------------------------------------------

attribute doc occurs on WhereClause;

aspect production nilWhereClause
top::WhereClause ::=
{ top.doc = prodDoc("nilWhereClause", []); }

aspect production withWhereClause
top::WhereClause ::= gl::GuardList
{ top.doc = prodDoc("withWhereClause", [gl.doc]); }

--------------------------------------------------

attribute doc occurs on Guard;

aspect production eqGuard
top::Guard ::= t1::Term t2::Term
{ top.doc = prodDoc("eqGuard", [t1.doc, t2.doc]); }

aspect production neqGuard
top::Guard ::= t1::Term t2::Term
{ top.doc = prodDoc("neqGuard", [t1.doc, t2.doc]); }

attribute doc occurs on GuardList;

aspect production guardListCons
top::GuardList ::= g::Guard gl::GuardList
{ top.doc = prodDoc("guardListCons", [g.doc, gl.doc]); }

aspect production guardListOne
top::GuardList ::= g::Guard
{ top.doc = prodDoc("guardListOne", [g.doc]); }

--------------------------------------------------

attribute doc occurs on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{ top.doc = prodDoc("branch", [m.doc, c.doc]); }

attribute doc occurs on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{ top.doc = prodDoc("branchListCons", [b.doc, bs.doc]); }

aspect production branchListOne
top::BranchList ::= b::Branch
{ top.doc = prodDoc("eqGuard", [b.doc]); }

--------------------------------------------------

attribute doc occurs on Lambda;

aspect production lambda
top::Lambda ::= b::Branch
{ top.doc = prodDoc("lambda", [b.doc]); }

--------------------------------------------------

attribute doc occurs on Regex;

aspect production regexLabel
top::Regex ::= lab::Label
{ top.doc = prodDoc("regexLabel", [lab.doc]); }

aspect production regexSeq
top::Regex ::= r1::Regex r2::Regex
{ top.doc = prodDoc("regexSeq", [r1.doc, r2.doc]); }

aspect production regexAlt
top::Regex ::= r1::Regex r2::Regex
{ top.doc = prodDoc("regexAlt", [r1.doc, r1.doc]); }

aspect production regexAnd
top::Regex ::= r1::Regex r2::Regex
{ top.doc = prodDoc("regexAnd", [r1.doc, r1.doc]); }

aspect production regexStar
top::Regex ::= r::Regex
{ top.doc = prodDoc("regexStar", [r.doc]); }

aspect production regexAny
top::Regex ::=
{ top.doc = prodDoc("regexAny", []); }

aspect production regexNeg
top::Regex ::= r::Regex
{ top.doc = prodDoc("regexNeg", [r.doc]); }

aspect production regexEps
top::Regex ::=
{ top.doc = prodDoc("regexEps", []); }

--------------------------------------------------

attribute doc occurs on PathComp;

aspect production lexicoPathComp
top::PathComp ::= lts::LabelLTs
{ top.doc = prodDoc("lexicoPathComp", [lts.doc]); }

aspect production revLexicoPathComp
top::PathComp ::= lts::LabelLTs
{ top.doc = prodDoc("revLexicoPathComp", [lts.doc]); }

aspect production scalaPathComp
top::PathComp ::=
{ top.doc = prodDoc("scalaPathComp", []); }

aspect production namedPathComp
top::PathComp ::= name::String
{ top.doc = prodDoc("namedPathComp", [text("\"" ++ name ++ "\"")]); }


attribute doc occurs on LabelLTs;

aspect production labelLTsCons
top::LabelLTs ::= l1::Label l2::Label lts::LabelLTs
{ top.doc = prodDoc("labelLTsCons", [l1.doc, l2.doc, lts.doc]); }

aspect production labelLTsOne
top::LabelLTs ::= l1::Label l2::Label 
{ top.doc = prodDoc("labelLTsOne", [l1.doc, l2.doc]); }

--------------------------------------------------

attribute doc occurs on QualName;

aspect production qualNameDot
top::QualName ::= qn::QualName name::String
{ top.doc = prodDoc("qualNameDot", [qn.doc, text("\"" ++ name ++ "\"")]); }

aspect production qualNameName
top::QualName ::= name::String
{ top.doc = prodDoc("qualNameName", [text("\"" ++ name ++ "\"")]); }