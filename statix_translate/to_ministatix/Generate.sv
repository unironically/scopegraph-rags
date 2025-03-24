grammar statix_translate:to_ministatix;

imports statix_translate:lang:abstractsyntax;

imports silver:langutil:pp;

synthesized attribute mstxPP::String;
synthesized attribute mstx::Document;

global indentSize::Integer = 4;

fun itemDoc Document ::= acc::Document ch::Document = cat(acc, cat(line(), ch));
fun strDoc Document ::= s::String = text("\"" ++ s ++ "\"");

fun predDoc Document ::= pred::String argsDoc::Document body::Document =
    cat (
      text(pred ++ " ("),
      cat (
        argsDoc,
        cat (
          text(") :- "),
          cat (
            nest(indentSize, group(body)),
            text(".")
          )
        )
      )
    );

fun predMatchBranches Document ::= bs::Document =
  cat (
    line(),
    nest(indentSize, box(bs))
  );

--------------------------------------------------

attribute mstxPP occurs on Module;

aspect production module
top::Module ::= imps::Imports ords::Orders preds::Predicates
{ top.mstxPP = showDoc(0, cat(text("// Generated Ministatix spec"), 
                          cat(cat(line(), line()), 
                          cat(imps.mstx, cat(ords.mstx, preds.mstx))))); }
 
--------------------------------------------------

attribute mstx occurs on Orders;

aspect production ordersCons
top::Orders ::= ord::Order ords::Orders
{ top.mstx = cat(ord.mstx, cat(line(), ords.mstx)); }

aspect production ordersNil
top::Orders ::= 
{ top.mstx = line(); }

attribute mstx occurs on Order;

aspect production order
top::Order ::= name::String pc::PathComp
{ top.mstx = cat(text(name), pc.mstx); }

--------------------------------------------------

attribute mstx occurs on Imports;

aspect production importsCons
top::Imports ::= imp::Import imps::Imports
{ top.mstx = cat(imp.mstx, cat(line(), imps.mstx)); }

aspect production importsNil
top::Imports ::=
{ top.mstx = line(); }

attribute mstx occurs on Import;

aspect production imp
top::Import ::= qual::QualName
{ top.mstx = cat (text("import "), qual.mstx); }

--------------------------------------------------

attribute mstx occurs on Predicates;

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{ top.mstx = cat(pred.mstx, case preds of predicatesNil() -> text("")
                                        | _ -> cat(line(), cat(line(), preds.mstx))
                            end); }

aspect production predicatesNil
top::Predicates ::= 
{ top.mstx = text(""); }

attribute mstx occurs on Predicate;

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{ top.mstx = predDoc(name, nameLst.mstx, cat(text(t), cat(text(" match"), cat(text(" {"), cat(cat(predMatchBranches(bs.mstx), line()), text("}")))))); }

aspect production functionalPredicate 
top::Predicate ::= name::String nameLst::NameList const::Constraint
{ top.mstx = predDoc(name, nameLst.mstx, const.mstx); } 

--------------------------------------------------

attribute mstx occurs on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{ top.mstx = cat(text(name), cat(text("("), cat(params.mstx, cat(text(")"), cat(text(" -> "), 
              nest(indentSize, group(cat(line(), c.mstx)))))))); }

attribute mstx occurs on ProdBranchList;

aspect production prodBranchListCons
top::ProdBranchList ::= b::ProdBranch bs::ProdBranchList
{ top.mstx = cat(b.mstx, cat(line(), cat(text("| "), bs.mstx))); }

aspect production prodBranchListOne
top::ProdBranchList ::= b::ProdBranch
{ top.mstx = b.mstx; }

--------------------------------------------------


attribute mstx occurs on NameList;

aspect production nameListCons
top::NameList ::= name::Name names::NameList
{ 
  top.mstx = cat(name.mstx, case names of nameListNil() -> text("") 
                                        | _ -> cat(text(", "), names.mstx) end); 
}

aspect production nameListOne
top::NameList ::= name::Name
{ top.mstx = name.mstx; }

aspect production nameListNil
top::NameList ::=
{ top.mstx = text(""); }

attribute mstx occurs on Name;

aspect production nameSyn
top::Name ::= name::String ty::TypeAnn
{ top.mstx = text(name); }

aspect production nameInh
top::Name ::= name::String ty::TypeAnn
{ top.mstx = text(name); }

aspect production nameRet
top::Name ::= name::String ty::TypeAnn
{ top.mstx = text(name); }

aspect production nameUntagged
top::Name ::= name::String ty::TypeAnn
{ top.mstx = text(name); }

--------------------------------------------------

attribute mstx occurs on TypeAnn;

aspect production nameType
top::TypeAnn ::= name::String
{ top.mstx = text(""); }

aspect production listType
top::TypeAnn ::= ty::TypeAnn
{ top.mstx = text(""); }

aspect production setType
top::TypeAnn ::= ty::TypeAnn
{ top.mstx = text(""); }

--------------------------------------------------

attribute mstx occurs on Term;

aspect production labelTerm
top::Term ::= lab::Label
{ top.mstx = lab.mstx; }

aspect production labelArgTerm
top::Term ::= lab::Label t::Term
{ top.mstx = cat(lab.mstx, cat(text("("), cat(t.mstx, text(")")))); }

aspect production constructorTerm
top::Term ::= name::String ts::TermList
{ top.mstx =  cat(text(name), cat(text("("), cat(ts.mstx, text(")")))); }

aspect production nameTerm
top::Term ::= name::String
{ top.mstx = text(name); }

aspect production consTerm
top::Term ::= t1::Term t2::Term
{ top.mstx = cat(t1.mstx, cat(text(":"), t2.mstx)); }

aspect production nilTerm
top::Term ::=
{ top.mstx = text("[]"); }

aspect production tupleTerm
top::Term ::= ts::TermList
{ top.mstx = cat(text("("), cat(ts.mstx, text(")"))); }

aspect production stringTerm
top::Term ::= s::String
{ top.mstx = strDoc(s); }

attribute mstx occurs on TermList;

aspect production termListCons
top::TermList ::= t::Term ts::TermList
{ top.mstx = cat(t.mstx, case ts of termListNil() -> ts.mstx
                                  | _ -> cat(text(", "), ts.mstx) end); }

aspect production termListNil
top::TermList ::=
{ top.mstx = text(""); }

attribute mstx occurs on Label;

aspect production label
top::Label ::= label::String
{ top.mstx = text("`" ++ label); }

--------------------------------------------------

attribute mstx occurs on Constraint;

aspect production trueConstraint
top::Constraint ::=
{ top.mstx = text("true"); }

aspect production falseConstraint
top::Constraint ::=
{ top.mstx = text("false"); }

aspect production conjConstraint
top::Constraint ::= c1::Constraint c2::Constraint
{ top.mstx = cat(c1.mstx, cat(text(","), cat(line(), c2.mstx))); }

aspect production existsConstraint
top::Constraint ::= names::NameList c::Constraint
{ top.mstx = cat(
               text("{"),
               cat(
                names.mstx, 
                cat(
                  text("}"),
                  nest(indentSize, group(cat(line(), c.mstx)))
                )
              )
            );
}

aspect production eqConstraint
top::Constraint ::= t1::Term t2::Term
{ top.mstx = cat(t1.mstx, cat(text(" == "), t2.mstx)); }

aspect production neqConstraint
top::Constraint ::= t1::Term t2::Term
{ top.mstx = cat(t1.mstx, cat(text(" != "), t2.mstx)); }

aspect production newConstraintDatum
top::Constraint ::= name::String t::Term
{ top.mstx = cat(text("new "), cat(text(name), cat(text(" -> "), t.mstx))); }

aspect production newConstraint
top::Constraint ::= name::String
{ top.mstx = cat(text("new "), text(name)); }

aspect production dataConstraint
top::Constraint ::= name::String t::Term
{ top.mstx = cat(text(name), cat(text(" -> "), t.mstx)); }

aspect production edgeConstraint
top::Constraint ::= src::String lab::Term tgt::String
{ top.mstx = cat(text(src), cat(text(" -[ "), cat(lab.mstx, cat(text(" ]-> "), text(tgt))))); }

aspect production queryConstraint
top::Constraint ::= src::String r::Regex res::String
{ top.mstx = cat(text("query "), cat(text(src ++ " "), cat(r.mstx, cat(text(" as "), text(res))))); }

aspect production oneConstraint
top::Constraint ::= name::String out::String
{ top.mstx = cat(text("only"), cat(text("("), cat(text(name), cat(text(", "), cat(text(out), text(")")))))); }

aspect production nonEmptyConstraint
top::Constraint ::= name::String
{ top.mstx = cat(text("inhabited"), cat(text("("), cat(text(name), text(")")))); }

aspect production minConstraint
top::Constraint ::= set::String pc::PathComp res::String
{ top.mstx = cat(text("min "), cat(text(set), cat(text(" "), cat(pc.mstx, cat(text(" "), text(res)))))); }

aspect production applyConstraint
top::Constraint ::= name::String vs::RefNameList
{ top.mstx = cat(text(name), cat(text("("), cat(vs.mstx, text(")")))); }

aspect production everyConstraint
top::Constraint ::= name::String lam::Lambda
{ top.mstx = cat(text("every "), cat(text(name ++ " "), lam.mstx)); }

aspect production filterConstraint
top::Constraint ::= set::String m::Matcher res::String
{ top.mstx = cat(text("filter "), cat(text(set), cat(text(" ("), cat(m.mstx, cat(text(") "), text(res)))))); }

aspect production matchConstraint
top::Constraint ::= t::Term bs::BranchList
{ top.mstx = cat(t.mstx, cat(text(" match"), cat(text(" {"), cat(cat(predMatchBranches(bs.mstx), line()), text("}"))))); }

aspect production defConstraint
top::Constraint ::= name::String t::Term
{ top.mstx = cat(text(name), cat(text(" == "), t.mstx)); }

--------------------------------------------------

attribute mstx occurs on RefNameList;

aspect production refNameListCons
top::RefNameList ::= name::String names::RefNameList
{ top.mstx = cat(text(name), case names of refNameListNil() -> text("") 
                                         | _ -> cat(text(", "), names.mstx) end); }

aspect production refNameListOne
top::RefNameList ::= name::String
{ top.mstx = text(name); }

aspect production refNameListNil
top::RefNameList ::=
{ top.mstx = text(""); }

--------------------------------------------------

attribute mstx occurs on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{ top.mstx = cat(p.mstx, cat(text(" "), wc.mstx)); }

--------------------------------------------------

attribute mstx occurs on Pattern;

aspect production labelPattern
top::Pattern ::= lab::Label
{ top.mstx = lab.mstx; }

aspect production labelArgsPattern
top::Pattern ::= lab::Label p::Pattern
{ top.mstx = cat(lab.mstx, cat(text("("), cat(p.mstx, text(")")))); }

aspect production edgePattern
top::Pattern ::= p1::Pattern p2::Pattern p3::Pattern
{ top.mstx = cat(text("Edge"), cat(text("("), cat(p1.mstx, cat(text(", "), cat(p2.mstx, cat(text(", "), cat(p3.mstx, text(")")))))))); }

aspect production endPattern
top::Pattern ::= p::Pattern
{ top.mstx = cat(text("End"), cat(text("("), cat(p.mstx, text(")")))); }

aspect production namePattern
top::Pattern ::= name::String ty::TypeAnn
{ top.mstx = text(name); }

aspect production constructorPattern
top::Pattern ::= name::String ps::PatternList
{ top.mstx = cat(text(name), cat(text("("), cat(ps.mstx, text(")")))); }

aspect production consPattern
top::Pattern ::= p1::Pattern p2::Pattern
{ top.mstx = cat(p1.mstx, cat(text(":"), p2.mstx)); }

aspect production nilPattern
top::Pattern ::=
{ top.mstx = text("[]"); }

aspect production tuplePattern
top::Pattern ::= ps::PatternList
{ top.mstx = cat(text("("), cat(ps.mstx, text(")"))); }

aspect production underscorePattern
top::Pattern ::=
{ top.mstx = text("_"); }

attribute mstx occurs on PatternList;

aspect production patternListCons
top::PatternList ::= p::Pattern ps::PatternList
{ top.mstx = cat(p.mstx, case ps of patternListNil() -> ps.mstx
                                  | _ -> cat(text(", "), ps.mstx) end); }

aspect production patternListNil
top::PatternList ::=
{ top.mstx = text(""); }

--------------------------------------------------

attribute mstx occurs on WhereClause;

aspect production nilWhereClause
top::WhereClause ::=
{ top.mstx = text(""); }

aspect production withWhereClause
top::WhereClause ::= gl::GuardList
{ top.mstx = cat(text("where "), gl.mstx); }

--------------------------------------------------

attribute mstx occurs on Guard;

aspect production eqGuard
top::Guard ::= t1::Term t2::Term
{ top.mstx = cat(t1.mstx, cat(text(" == "), t2.mstx)); }

aspect production neqGuard
top::Guard ::= t1::Term t2::Term
{ top.mstx = cat(t1.mstx, cat(text(" != "), t2.mstx)); }

attribute mstx occurs on GuardList;

aspect production guardListCons
top::GuardList ::= g::Guard gl::GuardList
{ top.mstx = cat(g.mstx, cat(text(", "), gl.mstx)); }

aspect production guardListOne
top::GuardList ::= g::Guard
{ top.mstx = g.mstx; }

--------------------------------------------------

attribute mstx occurs on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{ top.mstx = cat(m.mstx, cat(text(" -> "), nest(indentSize, group(cat(line(), c.mstx))))); }

attribute mstx occurs on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{ top.mstx = cat(b.mstx, cat(line(), cat(text("| "), bs.mstx))); }

aspect production branchListOne
top::BranchList ::= b::Branch
{ top.mstx = b.mstx; }

--------------------------------------------------

attribute mstx occurs on Lambda;

aspect production lambda
top::Lambda ::= arg::String ty::TypeAnn wc::WhereClause c::Constraint
{ top.mstx = cat(text("("), cat(wc.mstx, cat(text("->"), cat(c.mstx, text(")"))))); }

--------------------------------------------------

attribute mstx occurs on Regex;

aspect production regexLabel
top::Regex ::= lab::Label
{ top.mstx = lab.mstx; }

aspect production regexSeq
top::Regex ::= r1::Regex r2::Regex
{ top.mstx = cat(r1.mstx, r2.mstx); }

aspect production regexAlt
top::Regex ::= r1::Regex r2::Regex
{ top.mstx = cat(r1.mstx, cat(text("|"), r2.mstx)); }

aspect production regexAnd
top::Regex ::= r1::Regex r2::Regex
{ top.mstx = cat(r1.mstx, cat(text("&"), r2.mstx)); }

aspect production regexStar
top::Regex ::= r::Regex
{ top.mstx = cat(r.mstx, text("*")); }

aspect production regexAny
top::Regex ::=
{ top.mstx = text("."); }

aspect production regexPlus
top::Regex ::= r::Regex
{ top.mstx = cat(r.mstx, text("+")); }

aspect production regexOptional
top::Regex ::= r::Regex
{ top.mstx = cat(r.mstx, text("?")); }

aspect production regexNeg
top::Regex ::= r::Regex
{ top.mstx = cat(text("~"), r.mstx); }

aspect production regexEps
top::Regex ::=
{ top.mstx = text("e"); }

aspect production regexParens
top::Regex ::= r::Regex
{ top.mstx = cat(text("("), cat(r.mstx, text(")"))); }

--------------------------------------------------

attribute mstx occurs on PathComp;

aspect production lexicoPathComp
top::PathComp ::= lts::LabelLTs
{ top.mstx = cat(text("lexico"), cat(text("("), cat(lts.mstx, text(")")))); }

aspect production revLexicoPathComp
top::PathComp ::= lts::LabelLTs
{ top.mstx = cat(text("reverse-lexico"), cat(text("("), cat(lts.mstx, text(")")))); }

aspect production scalaPathComp
top::PathComp ::=
{ top.mstx = text("scala"); }

aspect production namedPathComp
top::PathComp ::= name::String
{ top.mstx = cat(text("@"), text(name)); }


attribute mstx occurs on LabelLTs;

aspect production labelLTsCons
top::LabelLTs ::= l1::Label l2::Label lts::LabelLTs
{ top.mstx = cat(l1.mstx, cat(text("<"), cat(l2.mstx, cat(text(", "), lts.mstx)))); }

aspect production labelLTsOne
top::LabelLTs ::= l1::Label l2::Label 
{ top.mstx = cat(l1.mstx, cat(text("<"), l2.mstx)); }

--------------------------------------------------

attribute mstx occurs on QualName;

aspect production qualNameDot
top::QualName ::= qn::QualName name::String
{ top.mstx = cat(qn.mstx, cat(text("."), text(name))); }

aspect production qualNameName
top::QualName ::= name::String
{ top.mstx = text(name); }