grammar statix_translate:lang:concretesyntax;

imports statix_translate:lang:abstractsyntax;

--------------------------------------------------

synthesized attribute ast<a> :: a;

--------------------------------------------------

nonterminal Module_c with ast<Module>;

concrete production module_c
top::Module_c ::= ds::Imports_c ords::Orders_c preds::Predicates_c
{ top.ast = module(ds.ast, ords.ast, preds.ast); }
 
--------------------------------------------------

nonterminal Orders_c with ast<Orders>;

concrete production ordersCons_c
top::Orders_c ::= ord::Order_c ords::Orders_c
{ top.ast = ordersCons(ord.ast, ords.ast); }

concrete production ordersNil_c
top::Orders_c ::= 
{ top.ast = ordersNil(); }

nonterminal Order_c with ast<Order>;

concrete production order_c
top::Order_c ::= 'order' name::Name_t pathComp::PathComp_c
{ top.ast = order(name.lexeme, pathComp.ast); }

--------------------------------------------------

nonterminal Imports_c with ast<Imports>;

concrete production importsCons_c
top::Imports_c ::= imp::Import_c imps::Imports_c
{ top.ast = importsCons(imp.ast, imps.ast); }

concrete production importsNil_c
top::Imports_c ::=
{ top.ast = importsNil(); }

nonterminal Import_c with ast<Import>;

concrete production imp_c
top::Import_c ::= 'import' qual::QualName_c
{ top.ast = imp(qual.ast); }

--------------------------------------------------

nonterminal Predicates_c with ast<Predicates>;

concrete production predicatesCons_c
top::Predicates_c ::= pred::Predicate_c preds::Predicates_c
{ top.ast = predicatesCons(pred.ast, preds.ast); }

concrete production predicatesNil_c
top::Predicates_c ::= 
{ top.ast = predicatesNil(); }

nonterminal Predicate_c with ast<Predicate>;

{- syntactic requirement that syntaxPredicates only contain a match on the 
 - syntax term argument
 -}
concrete production syntaxPredicate_c 
top::Predicate_c ::= 'syntax' ':' name::Name_t '(' nameLst::NameList_c ')'
                     LeftArr_t t::Name_t 'match' '{' bs::BranchList_c '}' '.'
{ top.ast = syntaxPredicate(name.lexeme, nameLst.ast, t.lexeme, bs.ast); }

concrete production functionalPredicate_c 
top::Predicate_c ::= name::Name_t '(' nameLst::NameList_c ')'
                     LeftArr_t const::Constraint_c '.'
{ top.ast = functionalPredicate(name.lexeme, nameLst.ast, const.ast); }

--------------------------------------------------

nonterminal NameList_c with ast<NameList>;

concrete production nameListCons_c
top::NameList_c ::= name::Name_c ',' names::NameList_c
{ top.ast = nameListCons(name.ast, names.ast); }

concrete production nameListOnc_c
top::NameList_c ::= name::Name_c
{ top.ast = nameListOne(name.ast); }

nonterminal Name_c with ast<Name>;

concrete production nameSyn_c
top::Name_c ::= 'syn' ':' name::Name_t '::' ty::TypeAnn_c
{ top.ast = nameSyn(name.lexeme, ty.ast); }

concrete production nameInh_c
top::Name_c ::= 'inh' ':' name::Name_t '::' ty::TypeAnn_c
{ top.ast = nameInh(name.lexeme, ty.ast); }

concrete production nameRet_c
top::Name_c ::= 'ret' ':' name::Name_t '::' ty::TypeAnn_c
{ top.ast = nameRet(name.lexeme, ty.ast); }

concrete production nameUntagged_c
top::Name_c ::= name::Name_t '::' ty::TypeAnn_c
{ top.ast = nameUntagged(name.lexeme, ty.ast); }

--------------------------------------------------

nonterminal TypeAnn_c with ast<TypeAnn>;

concrete production nameType_c
top::TypeAnn_c ::= name::Name_t
{ top.ast = nameType(name.lexeme); }

concrete production listType_c
top::TypeAnn_c ::= '[' ty::TypeAnn_c ']'
{ top.ast = listType(ty.ast); }

--------------------------------------------------


nonterminal Term_c with ast<Term>;

concrete production labelTerm_c
top::Term_c ::= lab::Label_c
{ top.ast = labelTerm(lab.ast); }

concrete production labelArgTerm_c
top::Term_c ::= lab::Label_c '(' t::Term_c ')'
{ top.ast = labelArgTerm(lab.ast, t.ast); }

concrete production constructorTermEmpty_c
top::Term_c ::= name::Constructor_t '(' ')'
{ top.ast = constructorTerm(name.lexeme, termListNil()); }

concrete production constructorTerm_c
top::Term_c ::= name::Constructor_t '(' ts::TermList_c ')'
{ top.ast = constructorTerm(name.lexeme, ts.ast); }

concrete production nameTerm_c
top::Term_c ::= name::Name_t
{ top.ast = nameTerm(name.lexeme); }

concrete production consTerm_c
top::Term_c ::= t1::Term_c ':' t2::Term_c
{ top.ast = consTerm(t1.ast, t2.ast); }

concrete production nilTerm_c
top::Term_c ::= '[' ']'
{ top.ast = nilTerm(); }

concrete production tupleTerm_c
top::Term_c ::= '(' t::Term_c ',' ts::TermList_c ')'
{ top.ast = tupleTerm(termListCons(t.ast, ts.ast)); }

concrete production parenTerm_c
top::Term_c ::= '(' t::Term_c ')'
{ top.ast = t.ast; }

concrete production stringTerm_c
top::Term_c ::= s::String_t
{ top.ast = stringTerm(s.lexeme); }

nonterminal TermList_c with ast<TermList>;

concrete production termListCons_c
top::TermList_c ::= t::Term_c ',' ts::TermList_c
{ top.ast = termListCons(t.ast, ts.ast); }

concrete production termListOne_c
top::TermList_c ::= t::Term_c
{ top.ast = termListCons(t.ast, termListNil()); }

nonterminal Label_c with ast<Label>;

concrete production label_c
top::Label_c ::= '`' lab::Constructor_t
{ top.ast = label(lab.lexeme); }

--------------------------------------------------

nonterminal Constraint_c with ast<Constraint>;

concrete production trueConstraint_c
top::Constraint_c ::= 'true'
{ top.ast = trueConstraint(); }

concrete production falseConstraint_c
top::Constraint_c ::= 'false'
{ top.ast = falseConstraint(); }

concrete production conjConstraint_c
top::Constraint_c ::= c1::Constraint_c ',' c2::Constraint_c
{ top.ast = conjConstraint(c1.ast, c2.ast); }

concrete production existsConstraint_c
top::Constraint_c ::= '{' names::RefNameList_c '}' c::Constraint_c
{ top.ast = existsConstraint(names.ast, c.ast); }

concrete production eqConstraint_c
top::Constraint_c ::= t1::Term_c '==' t2::Term_c
{ top.ast = eqConstraint(t1.ast, t2.ast); }

concrete production neqConstraint_c
top::Constraint_c ::= t1::Term_c '!=' t2::Term_c
{ top.ast = neqConstraint(t1.ast, t2.ast); }

concrete production newConstraintDatum_c
top::Constraint_c ::= 'new' name::Name_t RightArr_t t::Term_c
{ top.ast = newConstraintDatum(name.lexeme, t.ast); }

concrete production newConstraint_c
top::Constraint_c ::= 'new' name::Name_t
{ top.ast = newConstraint(name.lexeme); }

concrete production dataConstraint_c
top::Constraint_c ::= name::Name_t RightArr_t t::Term_c
{ top.ast = dataConstraint(name.lexeme, t.ast); }

concrete production edgeConstraint_c
top::Constraint_c ::= src::Name_t '-[' lab::Term_c ']->' tgt::Name_t
{ top.ast = edgeConstraint(src.lexeme, lab.ast, tgt.lexeme); }

concrete production queryConstraint_c
top::Constraint_c ::= 'query' src::Name_t r::Regex_c 'as' res::Name_t
{ top.ast = queryConstraint(src.lexeme, r.ast, res.lexeme); }

concrete production oneConstraint_c
top::Constraint_c ::= 'only' '(' name::Name_t ',' out::Name_t ')'
{ top.ast = oneConstraint(name.lexeme, out.lexeme); }

concrete production nonEmptyConstraint_c
top::Constraint_c ::= 'inhabited' '(' name::Name_t ')'
{ top.ast = nonEmptyConstraint(name.lexeme); }

concrete production minConstraint_c
top::Constraint_c ::= 'min' set::Name_t pc::PathComp_c res::Name_t
{ top.ast = minConstraint(set.lexeme, pc.ast, res.lexeme); }

{- Restrict predicate applications so that only variables are allowed as args -}
concrete production applyConstraint_c
top::Constraint_c ::= name::Name_t '(' vs::RefNameList_c ')'
{ top.ast = applyConstraint(name.lexeme, vs.ast); }

concrete production everyConstraint_c
top::Constraint_c ::= 'every' name::Name_t lam::Lambda_c
{ top.ast = everyConstraint(name.lexeme, lam.ast); }

concrete production filterConstraint_c
top::Constraint_c ::= 'filter' set::Name_t '(' m::Matcher_c ')' res::Name_t
{ top.ast = filterConstraint(set.lexeme, m.ast, res.lexeme); }

concrete production matchConstraint_c
top::Constraint_c ::= t::Term_c 'match' '{' bs::BranchList_c '}'
{ top.ast = matchConstraint(t.ast, bs.ast); }

concrete production parenConstraint_c
top::Constraint_c ::= '(' c::Constraint_c ')'
{ top.ast = c.ast; }

concrete production defConstraint_c
top::Constraint_c ::= name::Name_t '::' ty::TypeAnn_c ':=' t::Term_c
{ top.ast = defConstraint(name.lexeme, ty.ast, t.ast); }

--------------------------------------------------

nonterminal RefNameList_c with ast<RefNameList>;

concrete production refNameListCons_c
top::RefNameList_c ::= name::Name_t ',' names::RefNameList_c
{ top.ast = refNameListCons(name.lexeme, names.ast); }

concrete production refNameListOne_c
top::RefNameList_c ::= name::Name_t
{ top.ast = refNameListOne(name.lexeme); }

--------------------------------------------------

nonterminal Matcher_c with ast<Matcher>;

concrete production matcher_c
top::Matcher_c ::= p::Pattern_c wc::WhereClause_c
{ top.ast = matcher(p.ast, wc.ast); }

--------------------------------------------------

nonterminal Pattern_c with ast<Pattern>;

concrete production labelPattern_c
top::Pattern_c ::= lab::Label_c
{ top.ast = labelPattern(lab.ast); }

concrete production labelArgsPattern_c
top::Pattern_c ::= lab::Label_c '(' p::Pattern_c ')'
{ top.ast = labelArgsPattern(lab.ast, p.ast); }

concrete production edgePattern_c
top::Pattern_c ::= 'Edge' '(' p1::Pattern_c ',' p2::Pattern_c ',' p3::Pattern_c ')'
{ top.ast = edgePattern(p1.ast, p2.ast, p3.ast); }

concrete production endPattern_c
top::Pattern_c ::= 'End' '(' p::Pattern_c ')'
{ top.ast = endPattern(p.ast); }

concrete production namePattern_c
top::Pattern_c ::= name::Name_t '::' ty::TypeAnn_c
{ top.ast = namePattern(name.lexeme, ty.ast); }

concrete production constructorPatternEmpty_c
top::Pattern_c ::= name::Constructor_t '(' ')'
{ top.ast = constructorPattern(name.lexeme, patternListNil()); }

concrete production constructorPatternPlus_c
top::Pattern_c ::= name::Constructor_t '(' ps::PatternList_c ')'
{ top.ast = constructorPattern(name.lexeme, ps.ast); }

concrete production consPattern_c
top::Pattern_c ::= p1::Pattern_c ':' p2::Pattern_c
{ top.ast = consPattern(p1.ast, p2.ast); }

concrete production nilPattern_c
top::Pattern_c ::= '[' ']'
{ top.ast = nilPattern(); }

concrete production tuplePattern_c
top::Pattern_c ::= '(' p::Pattern_c ',' ps::PatternList_c ')'
{ top.ast = tuplePattern(patternListCons(p.ast, ps.ast)); }

concrete production underscorePattern_c
top::Pattern_c ::= '_'
{ top.ast = underscorePattern(); }

concrete production parensPattern_c
top::Pattern_c ::= '(' p::Pattern_c ')'
{ top.ast = p.ast; }

nonterminal PatternList_c with ast<PatternList>;

concrete production patternListCons_c
top::PatternList_c ::= p::Pattern_c ',' ps::PatternList_c
{ top.ast = patternListCons(p.ast, ps.ast); }

concrete production patternListOne_c
top::PatternList_c ::= p::Pattern_c
{ top.ast = patternListCons(p.ast, patternListNil()); }

--------------------------------------------------

nonterminal WhereClause_c with ast<WhereClause>;

concrete production nilWhereClause_c
top::WhereClause_c ::=
{ top.ast = nilWhereClause(); }

concrete production withWhereClause_c
top::WhereClause_c ::= 'where' gl::GuardList_c
{ top.ast = withWhereClause(gl.ast); }

--------------------------------------------------

nonterminal Guard_c with ast<Guard>;

concrete production eqGuard_c
top::Guard_c ::= t1::Term_c '==' t2::Term_c
{ top.ast = eqGuard(t1.ast, t2.ast); }

concrete production neqGuard_c
top::Guard_c ::= t1::Term_c '!=' t2::Term_c
{ top.ast = neqGuard(t1.ast, t2.ast); }

nonterminal GuardList_c with ast<GuardList>;

concrete production guardListCons_c
top::GuardList_c ::= g::Guard_c ',' gl::GuardList_c
{ top.ast = guardListCons(g.ast, gl.ast); }

concrete production guardListOne_c
top::GuardList_c ::= g::Guard_c
{ top.ast = guardListOne(g.ast); }

--------------------------------------------------

nonterminal Branch_c with ast<Branch>;

concrete production branch_c
top::Branch_c ::= m::Matcher_c '->' c::Constraint_c
{ top.ast = branch(m.ast, c.ast); }

nonterminal BranchList_c with ast<BranchList>;

concrete production branchListCons_c
top::BranchList_c ::= b::Branch_c '|' bs::BranchList_c
{ top.ast = branchListCons(b.ast, bs.ast); }

concrete production branchListOne_c
top::BranchList_c ::= b::Branch_c
{ top.ast = branchListOne(b.ast); }

--------------------------------------------------

nonterminal Lambda_c with ast<Lambda>;

{- in mstx examples lambda args are only ever variable names,
 - despite use of nt Pattern in the syntax spec which allows
 - unification of lambda args. We make the reasonable restriction
 - that the lambda arg must be a name.
 -}
concrete production lambda_c
top::Lambda_c ::= '(' name::Name_t '::' ty::TypeAnn_c wc::WhereClause_c '->' c::Constraint_c ')'
{ top.ast = lambda(name.lexeme, ty.ast, wc.ast, c.ast); }

--------------------------------------------------

nonterminal Regex_c with ast<Regex>;

concrete production regexLabel_c
top::Regex_c ::= lab::Label_c
{ top.ast = regexLabel(lab.ast); }

concrete production regexSeq_c
top::Regex_c ::= r1::Regex_c Concat_t r2::Regex_c
{ top.ast = regexSeq(r1.ast, r2.ast); }

concrete production regexAlt_c
top::Regex_c ::= r1::Regex_c '|' r2::Regex_c
{ top.ast = regexAlt(r1.ast, r2.ast); }

concrete production regexAnd_c
top::Regex_c ::= r1::Regex_c '&' r2::Regex_c
{ top.ast = regexAnd(r1.ast, r2.ast); }

concrete production regexStar_c
top::Regex_c ::= r::Regex_c '*'
{ top.ast = regexStar(r.ast); }

concrete production regexAny_c
top::Regex_c ::= '.'
{ top.ast = regexAny(); }

concrete production regexPlus_c
top::Regex_c ::= r::Regex_c '+'
{ top.ast = regexPlus(r.ast); }

concrete production regexOptional_c
top::Regex_c ::= r::Regex_c '?'
{ top.ast = regexOptional(r.ast); }

concrete production regexNeg_c
top::Regex_c ::= '~' r::Regex_c
{ top.ast = regexNeg(r.ast); }

concrete production regexEps_c
top::Regex_c ::= 'e'
{ top.ast = regexEps(); }

concrete production regexParens_c
top::Regex_c ::= '(' r::Regex_c ')'
{ top.ast = regexParens(r.ast); }

--------------------------------------------------

nonterminal PathComp_c with ast<PathComp>;

concrete production lexicoPathComp_c
top::PathComp_c ::= 'lexico' '(' lts::LabelLTs_c ')'
{ top.ast = lexicoPathComp(lts.ast); }

concrete production revLexicoPathComp_c
top::PathComp_c ::= 'reverse-lexico' '(' lts::LabelLTs_c ')'
{ top.ast = revLexicoPathComp(lts.ast); }

concrete production scalaPathComp_c
top::PathComp_c ::= 'scala'
{ top.ast = scalaPathComp(); }

concrete production namedPathComp_c
top::PathComp_c ::= '@' name::Name_t
{ top.ast = namedPathComp(name.lexeme); }


nonterminal LabelLTs_c with ast<LabelLTs>;

concrete production labelLTsCons_c
top::LabelLTs_c ::= l1::Label_c '<' l2::Label_c ',' lts::LabelLTs_c
{ top.ast = labelLTsCons(l1.ast, l2.ast, lts.ast); }

concrete production labelLTsOne_c
top::LabelLTs_c ::= l1::Label_c '<' l2::Label_c 
{ top.ast = labelLTsOne(l1.ast, l2.ast); }

--------------------------------------------------

nonterminal QualName_c with ast<QualName>;

concrete production qualNameDot_c
top::QualName_c ::= qn::QualName_c '.' name::Name_t
{ top.ast = qualNameDot(qn.ast, name.lexeme); }

concrete production qualNameName_c
top::QualName_c ::= name::Name_t
{ top.ast = qualNameName(name.lexeme); }