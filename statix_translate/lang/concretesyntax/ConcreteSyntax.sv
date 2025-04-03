grammar statix_translate:lang:concretesyntax;

imports statix_translate:lang:abstractsyntax;

--------------------------------------------------

synthesized attribute ast<a> :: a;

--------------------------------------------------

nonterminal Module_c with ast<Module>, location;

concrete production module_c
top::Module_c ::= ds::Imports_c ords::Orders_c preds::Predicates_c
{ top.ast = module(ds.ast, ords.ast, preds.ast, location=top.location); }
 
--------------------------------------------------

nonterminal Orders_c with ast<Orders>, location;

concrete production ordersCons_c
top::Orders_c ::= ord::Order_c ords::Orders_c
{ top.ast = ordersCons(ord.ast, ords.ast, location=top.location); }

concrete production ordersNil_c
top::Orders_c ::= 
{ top.ast = ordersNil(location=top.location); }

--------------------------------------------------

nonterminal Order_c with ast<Order>, location;

concrete production order_c
top::Order_c ::= 'order' name::Name_t pathComp::PathComp_c
{ top.ast = order(name.lexeme, pathComp.ast, location=top.location); }

--------------------------------------------------

nonterminal Imports_c with ast<Imports>, location;

concrete production importsCons_c
top::Imports_c ::= imp::Import_c imps::Imports_c
{ top.ast = importsCons(imp.ast, imps.ast, location=top.location); }

concrete production importsNil_c
top::Imports_c ::=
{ top.ast = importsNil(location=top.location); }

--------------------------------------------------

nonterminal Import_c with ast<Import>, location;

concrete production imp_c
top::Import_c ::= 'import' qual::QualName_c
{ top.ast = imp(qual.ast, location=top.location); }

--------------------------------------------------

nonterminal Predicates_c with ast<Predicates>, location;

concrete production predicatesCons_c
top::Predicates_c ::= pred::Predicate_c preds::Predicates_c
{ top.ast = predicatesCons(pred.ast, preds.ast, location=top.location); }

concrete production predicatesNil_c
top::Predicates_c ::= 
{ top.ast = predicatesNil(location=top.location); }

--------------------------------------------------

nonterminal Predicate_c with ast<Predicate>, location;

{- syntactic requirement that syntaxPredicates only contain a match on the 
 - syntax term argument
 -}
concrete production syntaxPredicate_c 
top::Predicate_c ::= '@' 'syntax' name::Name_t '(' nameLst::NameList_c ')'
                     LeftArr_t t::Name_t 'match' '{' bs::ProdBranchList_c '}' '.'
{ top.ast = syntaxPredicate(name.lexeme, nameLst.ast, t.lexeme, bs.ast, location=top.location); }

concrete production functionalPredicate_c 
top::Predicate_c ::= name::Name_t '(' nameLst::NameList_c ')'
                     LeftArr_t const::Constraint_c '.'
{ top.ast = functionalPredicate(name.lexeme, nameLst.ast, const.ast, location=top.location); }

--------------------------------------------------

nonterminal ProdBranch_c with ast<ProdBranch>, location;

concrete production prodBranchNil_c
top::ProdBranch_c ::= name::Constructor_t '(' ')' '->' c::Constraint_c
{ top.ast = prodBranch(name.lexeme, nameListNil(location=top.location), c.ast, location=top.location); }

concrete production prodBranch_c
top::ProdBranch_c ::= name::Constructor_t '(' nl::NameList_c ')' '->' c::Constraint_c
{ top.ast = prodBranch(name.lexeme, nl.ast, c.ast, location=top.location); }

--------------------------------------------------

nonterminal ProdBranchList_c with ast<ProdBranchList>, location;

concrete production prodBranchListCons_c
top::ProdBranchList_c ::= b::ProdBranch_c '|' bs::ProdBranchList_c
{ top.ast = prodBranchListCons(b.ast, bs.ast, location=top.location); }

concrete production prodBranchListOne_c
top::ProdBranchList_c ::= b::ProdBranch_c
{ top.ast = prodBranchListOne(b.ast, location=top.location); }

--------------------------------------------------

nonterminal NameList_c with ast<NameList>, location;

concrete production nameListCons_c
top::NameList_c ::= name::Name_c ',' names::NameList_c
{ top.ast = nameListCons(name.ast, names.ast, location=top.location); }

concrete production nameListOnc_c
top::NameList_c ::= name::Name_c
{ top.ast = nameListCons(name.ast, nameListNil(location=top.location), location=top.location); }

--------------------------------------------------

nonterminal Name_c with ast<Name>, location;

concrete production nameSyn_c
top::Name_c ::= '@' 'syn' name::Name_t ':' ty::TypeAnn_c
{ top.ast = nameSyn(name.lexeme, ty.ast, location=top.location); }

concrete production nameInh_c
top::Name_c ::= '@' 'inh' name::Name_t ':' ty::TypeAnn_c
{ top.ast = nameInh(name.lexeme, ty.ast, location=top.location); }

concrete production nameRet_c
top::Name_c ::= '@' 'ret' name::Name_t ':' ty::TypeAnn_c
{ top.ast = nameRet(name.lexeme, ty.ast, location=top.location); }

concrete production nameUntagged_c
top::Name_c ::= name::Name_t ':' ty::TypeAnn_c
{ top.ast = nameUntagged(name.lexeme, ty.ast, location=top.location); }

--------------------------------------------------

nonterminal TypeAnn_c with ast<TypeAnn>, location;

concrete production nameType_c
top::TypeAnn_c ::= name::Name_t
{ top.ast = nameType(name.lexeme, location=top.location); }

concrete production listType_c
top::TypeAnn_c ::= '[' ty::TypeAnn_c ']'
{ top.ast = listType(ty.ast, location=top.location); }

concrete production setType_c
top::TypeAnn_c ::= '{' ty::TypeAnn_c '}'
{ top.ast = setType(ty.ast, location=top.location); }

--------------------------------------------------

nonterminal Term_c with ast<Term>, location;

concrete production labelTerm_c
top::Term_c ::= lab::Label_c
{ top.ast = labelTerm(lab.ast, location=top.location); }

concrete production labelArgTerm_c
top::Term_c ::= lab::Label_c '(' t::Term_c ')'
{ top.ast = labelArgTerm(lab.ast, t.ast, location=top.location); }

concrete production constructorTermEmpty_c
top::Term_c ::= name::Constructor_t '(' ')'
{ top.ast = constructorTerm(name.lexeme, termListNil(location=top.location), location=top.location); }

concrete production constructorTerm_c
top::Term_c ::= name::Constructor_t '(' ts::TermList_c ')'
{ top.ast = constructorTerm(name.lexeme, ts.ast, location=top.location); }

concrete production nameTerm_c
top::Term_c ::= name::Name_t
{ top.ast = nameTerm(name.lexeme, location=top.location); }

concrete production consTerm_c
top::Term_c ::= t1::Term_c '::' t2::Term_c
{ top.ast = consTerm(t1.ast, t2.ast, location=top.location); }

concrete production nilTerm_c
top::Term_c ::= '[' ']'
{ top.ast = nilTerm(location=top.location); }

concrete production tupleTerm_c
top::Term_c ::= '(' t::Term_c ',' ts::TermList_c ')'
{ top.ast = tupleTerm(termListCons(t.ast, ts.ast, location=top.location), location=top.location); }

concrete production parenTerm_c
top::Term_c ::= '(' t::Term_c ')'
{ top.ast = t.ast; }

concrete production stringTerm_c
top::Term_c ::= s::String_t
{ top.ast = stringTerm(s.lexeme, location=top.location); }

--------------------------------------------------

nonterminal TermList_c with ast<TermList>, location;

concrete production termListCons_c
top::TermList_c ::= t::Term_c ',' ts::TermList_c
{ top.ast = termListCons(t.ast, ts.ast, location=top.location); }

concrete production termListOne_c
top::TermList_c ::= t::Term_c
{ top.ast = termListCons(t.ast, termListNil(location=top.location), location=top.location); }

--------------------------------------------------

nonterminal Label_c with ast<Label>, location;

concrete production label_c
top::Label_c ::= '`' lab::Constructor_t
{ top.ast = label(lab.lexeme, location=top.location); }

--------------------------------------------------

nonterminal Constraint_c with ast<Constraint>, location;

concrete production trueConstraint_c
top::Constraint_c ::= 'true'
{ top.ast = trueConstraint(location=top.location); }

concrete production falseConstraint_c
top::Constraint_c ::= 'false'
{ top.ast = falseConstraint(location=top.location); }

concrete production conjConstraint_c
top::Constraint_c ::= c1::Constraint_c ',' c2::Constraint_c
{ top.ast = conjConstraint(c1.ast, c2.ast, location=top.location); }

concrete production existsConstraint_c
top::Constraint_c ::= '{' names::NameList_c '}' c::Constraint_c
{ top.ast = existsConstraint(names.ast, c.ast, location=top.location); }

{- our addition -}
concrete production defConstraint_c
top::Constraint_c ::= name::Name_t ':=' t::Term_c
{ top.ast = defConstraint(name.lexeme, t.ast, location=top.location); }

concrete production eqConstraint_c
top::Constraint_c ::= t1::Term_c '==' t2::Term_c
{ top.ast = eqConstraint(t1.ast, t2.ast, location=top.location); }

concrete production neqConstraint_c
top::Constraint_c ::= t1::Term_c '!=' t2::Term_c
{ top.ast = neqConstraint(t1.ast, t2.ast, location=top.location); }

concrete production newConstraintDatum_c
top::Constraint_c ::= 'new' name::Name_t RightArr_t t::Term_c
{ top.ast = newConstraintDatum(name.lexeme, t.ast, location=top.location); }

concrete production newConstraint_c
top::Constraint_c ::= 'new' name::Name_t
{ top.ast = newConstraint(name.lexeme, location=top.location); }

concrete production dataConstraint_c
top::Constraint_c ::= name::Name_t RightArr_t d::Name_t
{ top.ast = dataConstraint(name.lexeme, d.lexeme, location=top.location); }

concrete production edgeConstraint_c
top::Constraint_c ::= src::Name_t '-[' lab::Term_c ']->' tgt::Name_t
{ top.ast = edgeConstraint(src.lexeme, lab.ast, tgt.lexeme, location=top.location); }

concrete production queryConstraint_c
top::Constraint_c ::= 'query' src::Name_t r::Regex_c 'as' res::Name_t
{ top.ast = queryConstraint(src.lexeme, r.ast, res.lexeme, location=top.location); }

concrete production oneConstraint_c
top::Constraint_c ::= 'only' '(' name::Name_t ',' out::Name_t ')'
{ top.ast = oneConstraint(name.lexeme, out.lexeme, location=top.location); }

concrete production nonEmptyConstraint_c
top::Constraint_c ::= 'inhabited' '(' name::Name_t ')'
{ top.ast = nonEmptyConstraint(name.lexeme, location=top.location); }

concrete production minConstraint_c
top::Constraint_c ::= 'min' set::Name_t pc::PathComp_c res::Name_t
{ top.ast = minConstraint(set.lexeme, pc.ast, res.lexeme, location=top.location); }

{- Restrict predicate applications so that only variables are allowed as args -}
concrete production applyConstraint_c
top::Constraint_c ::= name::Name_t '(' vs::RefNameList_c ')'
{ top.ast = applyConstraint(name.lexeme, vs.ast, location=top.location); }

concrete production everyConstraint_c
top::Constraint_c ::= 'every' name::Name_t lam::Lambda_c
{ top.ast = everyConstraint(name.lexeme, lam.ast, location=top.location); }

concrete production filterConstraint_c
top::Constraint_c ::= 'filter' set::Name_t '(' m::Matcher_c ')' res::Name_t
{ top.ast = filterConstraint(set.lexeme, m.ast, res.lexeme, location=top.location); }

concrete production matchConstraint_c
top::Constraint_c ::= t::Term_c 'match' '{' bs::BranchList_c '}'
{ top.ast = matchConstraint(t.ast, bs.ast, location=top.location); }

concrete production parenConstraint_c
top::Constraint_c ::= '(' c::Constraint_c ')'
{ top.ast = c.ast; }

--------------------------------------------------

nonterminal RefNameList_c with ast<RefNameList>, location;

concrete production refNameListCons_c
top::RefNameList_c ::= name::Name_t ',' names::RefNameList_c
{ top.ast = refNameListCons(name.lexeme, names.ast, location=top.location); }

concrete production refNameListOne_c
top::RefNameList_c ::= name::Name_t
{ top.ast = refNameListCons(name.lexeme, refNameListNil(location=top.location), location=top.location); }

--------------------------------------------------

nonterminal Matcher_c with ast<Matcher>, location;

concrete production matcher_c
top::Matcher_c ::= p::Pattern_c wc::WhereClause_c
{ top.ast = matcher(p.ast, wc.ast, location=top.location); }

--------------------------------------------------

nonterminal Pattern_c with ast<Pattern>, location;

concrete production labelPattern_c
top::Pattern_c ::= lab::Label_c
{ top.ast = labelPattern(lab.ast, location=top.location); }

concrete production labelArgsPattern_c
top::Pattern_c ::= lab::Label_c '(' p::Pattern_c ')'
{ top.ast = labelArgsPattern(lab.ast, p.ast, location=top.location); }

concrete production edgePattern_c
top::Pattern_c ::= 'Edge' '(' p1::Pattern_c ',' p2::Pattern_c ',' p3::Pattern_c ')'
{ top.ast = edgePattern(p1.ast, p2.ast, p3.ast, location=top.location); }

concrete production endPattern_c
top::Pattern_c ::= 'End' '(' p::Pattern_c ')'
{ top.ast = endPattern(p.ast, location=top.location); }

concrete production namePattern_c
top::Pattern_c ::= name::Name_t ':' ty::TypeAnn_c
{ top.ast = namePattern(name.lexeme, ty.ast, location=top.location); }

concrete production constructorPatternEmpty_c
top::Pattern_c ::= name::Constructor_t '(' ')' ':' ty::TypeAnn_c
{ top.ast = constructorPattern(name.lexeme, patternListNil(location=top.location), ty.ast, location=top.location); }

concrete production constructorPatternPlus_c
top::Pattern_c ::= name::Constructor_t '(' ps::PatternList_c ')' ':' ty::TypeAnn_c
{ top.ast = constructorPattern(name.lexeme, ps.ast, ty.ast, location=top.location); }

concrete production consPattern_c
top::Pattern_c ::= p1::Pattern_c '::' p2::Pattern_c
{ top.ast = consPattern(p1.ast, p2.ast, location=top.location); }

concrete production nilPattern_c
top::Pattern_c ::= '[' ']'
{ top.ast = nilPattern(location=top.location); }

concrete production tuplePattern_c
top::Pattern_c ::= '(' p::Pattern_c ',' ps::PatternList_c ')'
{ top.ast = tuplePattern(patternListCons(p.ast, ps.ast, location=top.location), location=top.location); }

concrete production underscorePattern_c
top::Pattern_c ::= '_' ':' ty::TypeAnn_c
{ top.ast = underscorePattern(ty.ast, location=top.location); }

concrete production parensPattern_c
top::Pattern_c ::= '(' p::Pattern_c ')'
{ top.ast = p.ast; }

--------------------------------------------------

nonterminal PatternList_c with ast<PatternList>, location;

concrete production patternListCons_c
top::PatternList_c ::= p::Pattern_c ',' ps::PatternList_c
{ top.ast = patternListCons(p.ast, ps.ast, location=top.location); }

concrete production patternListOne_c
top::PatternList_c ::= p::Pattern_c
{ top.ast = patternListCons(p.ast, patternListNil(location=top.location), location=top.location); }

--------------------------------------------------

nonterminal WhereClause_c with ast<WhereClause>, location;

concrete production nilWhereClause_c
top::WhereClause_c ::=
{ top.ast = nilWhereClause(location=top.location); }

concrete production withWhereClause_c
top::WhereClause_c ::= 'where' gl::GuardList_c
{ top.ast = withWhereClause(gl.ast, location=top.location); }

--------------------------------------------------

nonterminal Guard_c with ast<Guard>, location;

concrete production eqGuard_c
top::Guard_c ::= t1::Term_c '==' t2::Term_c
{ top.ast = eqGuard(t1.ast, t2.ast, location=top.location); }

concrete production neqGuard_c
top::Guard_c ::= t1::Term_c '!=' t2::Term_c
{ top.ast = neqGuard(t1.ast, t2.ast, location=top.location); }

--------------------------------------------------

nonterminal GuardList_c with ast<GuardList>, location;

concrete production guardListCons_c
top::GuardList_c ::= g::Guard_c ',' gl::GuardList_c
{ top.ast = guardListCons(g.ast, gl.ast, location=top.location); }

concrete production guardListOne_c
top::GuardList_c ::= g::Guard_c
{ top.ast = guardListOne(g.ast, location=top.location); }

--------------------------------------------------

nonterminal Branch_c with ast<Branch>, location;

concrete production branch_c
top::Branch_c ::= m::Matcher_c '->' c::Constraint_c
{ top.ast = branch(m.ast, c.ast, location=top.location); }

--------------------------------------------------

nonterminal BranchList_c with ast<BranchList>, location;

concrete production branchListCons_c
top::BranchList_c ::= b::Branch_c '|' bs::BranchList_c
{ top.ast = branchListCons(b.ast, bs.ast, location=top.location); }

concrete production branchListOne_c
top::BranchList_c ::= b::Branch_c
{ top.ast = branchListOne(b.ast, location=top.location); }

--------------------------------------------------

nonterminal Lambda_c with ast<Lambda>, location;

{- in mstx examples lambda args are only ever variable names,
 - despite use of nt Pattern in the syntax spec which allows
 - unification of lambda args. We make the reasonable restriction
 - that the lambda arg must be a name.
 -}
concrete production lambda_c
top::Lambda_c ::= '(' name::Name_t ':' ty::TypeAnn_c wc::WhereClause_c '->' c::Constraint_c ')'
{ top.ast = lambda(name.lexeme, ty.ast, wc.ast, c.ast, location=top.location); }

--------------------------------------------------

nonterminal Regex_c with ast<Regex>, location;

concrete production regexLabel_c
top::Regex_c ::= lab::Label_c
{ top.ast = regexLabel(lab.ast, location=top.location); }

concrete production regexSeq_c
top::Regex_c ::= r1::Regex_c Concat_t r2::Regex_c
{ top.ast = regexSeq(r1.ast, r2.ast, location=top.location); }

concrete production regexAlt_c
top::Regex_c ::= r1::Regex_c '|' r2::Regex_c
{ top.ast = regexAlt(r1.ast, r2.ast, location=top.location); }

concrete production regexAnd_c
top::Regex_c ::= r1::Regex_c '&' r2::Regex_c
{ top.ast = regexAnd(r1.ast, r2.ast, location=top.location); }

concrete production regexStar_c
top::Regex_c ::= r::Regex_c '*'
{ top.ast = regexStar(r.ast, location=top.location); }

concrete production regexAny_c
top::Regex_c ::= '.'
{ top.ast = regexAny(location=top.location); }

concrete production regexPlus_c
top::Regex_c ::= r::Regex_c '+'
{ top.ast = regexPlus(r.ast, location=top.location); }

concrete production regexOptional_c
top::Regex_c ::= r::Regex_c '?'
{ top.ast = regexOptional(r.ast, location=top.location); }

concrete production regexNeg_c
top::Regex_c ::= '~' r::Regex_c
{ top.ast = regexNeg(r.ast, location=top.location); }

concrete production regexEps_c
top::Regex_c ::= 'e'
{ top.ast = regexEps(location=top.location); }

concrete production regexParens_c
top::Regex_c ::= '(' r::Regex_c ')'
{ top.ast = regexParens(r.ast, location=top.location); }

--------------------------------------------------

nonterminal PathComp_c with ast<PathComp>, location;

concrete production lexicoPathComp_c
top::PathComp_c ::= 'lexico' '(' lts::LabelLTs_c ')'
{ top.ast = lexicoPathComp(lts.ast, location=top.location); }

concrete production revLexicoPathComp_c
top::PathComp_c ::= 'reverse-lexico' '(' lts::LabelLTs_c ')'
{ top.ast = revLexicoPathComp(lts.ast, location=top.location); }

concrete production scalaPathComp_c
top::PathComp_c ::= 'scala'
{ top.ast = scalaPathComp(location=top.location); }

concrete production namedPathComp_c
top::PathComp_c ::= '@' name::Name_t
{ top.ast = namedPathComp(name.lexeme, location=top.location); }

--------------------------------------------------

nonterminal LabelLTs_c with ast<LabelLTs>, location;

concrete production labelLTsCons_c
top::LabelLTs_c ::= l1::Label_c '<' l2::Label_c ',' lts::LabelLTs_c
{ top.ast = labelLTsCons(l1.ast, l2.ast, lts.ast, location=top.location); }

concrete production labelLTsOne_c
top::LabelLTs_c ::= l1::Label_c '<' l2::Label_c 
{ top.ast = labelLTsOne(l1.ast, l2.ast, location=top.location); }

--------------------------------------------------

nonterminal QualName_c with ast<QualName>, location;

concrete production qualNameDot_c
top::QualName_c ::= qn::QualName_c '.' name::Name_t
{ top.ast = qualNameDot(qn.ast, name.lexeme, location=top.location); }

concrete production qualNameName_c
top::QualName_c ::= name::Name_t
{ top.ast = qualNameName(name.lexeme, location=top.location); }