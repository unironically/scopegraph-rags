grammar statix_translate:lang:analysis;

--------------------------------------------------

-- collect all constructor terms, check for conflicts

--------------------------------------------------

monoid attribute constructorsSyn::[ConstructorInfo] with [], union;

inherited attribute knownConstructors::[ConstructorInfo];

synthesized attribute termTy::Maybe<Type>;
synthesized attribute termTys::[Maybe<Type>];

--------------------------------------------------

function lookupConstructor
Maybe<ConstructorInfo> ::= name::String decls::[ConstructorInfo]
{
  return
    case decls of
    | constructor(n, _, _, _)::_ when name == n -> just(head(decls)) 
    | _::t -> lookupConstructor(name, t)
    | [] -> nothing()
    end;
}

global edgeConstructor::ConstructorInfo = constructor (
  "Edge", nameType("path"), 
  [nameType("scope"), nameType("label"), nameType("path")],
  bogusLoc()
);

global endConstructor::ConstructorInfo = constructor (
  "End", nameType("path"), 
  [nameType("scope")],
  bogusLoc()
);

--------------------------------------------------

nonterminal ConstructorInfo;

attribute name occurs on ConstructorInfo;
synthesized attribute constructorType::Type occurs on ConstructorInfo;
synthesized attribute constructorArgTys::[Type] occurs on ConstructorInfo;
synthesized attribute constructorLoc::Location occurs on ConstructorInfo;

abstract production constructor
top::ConstructorInfo ::=
  name::String
  ty::Type
  argTys::[Type]
  loc::Location
{
  top.name = name;
  top.constructorType = ^ty;
  top.constructorArgTys = argTys;
  top.constructorLoc = loc;
}

instance Eq ConstructorInfo {
  eq = \l::ConstructorInfo r::ConstructorInfo ->
    l.name == r.name &&
    eqType(l.constructorType, r.constructorType) &&
    length(l.constructorArgTys) == length(r.constructorArgTys) &&
    all(map(eqTypePair, zip(l.constructorArgTys, r.constructorArgTys)));
}

function constructorStr
String ::= c::ConstructorInfo
{
  return
    c.name ++ ": " ++ typeStr(c.constructorType) ++ " ::= " ++
    implode(" ", map(typeStr, c.constructorArgTys));

}

function duplConstructorErrs
[Error] ::= cs::[ConstructorInfo]
{
  return
    case cs of
    | []   -> []
    | h::t -> if containsBy(\l::ConstructorInfo r::ConstructorInfo -> l.name == r.name, h, t)
              then [ duplicateConstructorError(h.name, h.constructorLoc) ] -- don't continue looking
              else duplConstructorErrs(t)
    end;
}

--------------------------------------------------

aspect production module
top::Module ::= ds::Imports ords::Orders preds::Predicates
{
  preds.knownConstructors = preds.constructorsSyn;-- ++ [edgeConstructor, endConstructor];

  top.errs <- duplConstructorErrs(preds.knownConstructors);
}
 
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

attribute constructorsSyn occurs on Predicates;
propagate constructorsSyn on Predicates;

attribute knownConstructors occurs on Predicates;
propagate knownConstructors on Predicates;

aspect production predicatesCons
top::Predicates ::= pred::Predicate preds::Predicates
{}

aspect production predicatesNil
top::Predicates ::= 
{}

--------------------------------------------------

attribute constructorsSyn occurs on Predicate;
propagate constructorsSyn on Predicate;

attribute knownConstructors occurs on Predicate;
propagate knownConstructors on Predicate;

aspect production syntaxPredicate 
top::Predicate ::= name::String nameLst::NameList t::String bs::ProdBranchList
{}

aspect production functionalPredicate
top::Predicate ::= name::String nameLst::NameList const::Constraint
{} 

--------------------------------------------------

attribute constructorsSyn occurs on ProdBranch;
propagate constructorsSyn on ProdBranch;

attribute knownConstructors occurs on ProdBranch;
propagate knownConstructors on ProdBranch;

aspect production prodBranch
top::ProdBranch ::= name::String params::NameList c::Constraint
{
  top.constructorsSyn <- [
    constructor(name, top.prodTyAnn.termTy.fromJust, map(snd, params.nameTyDeclsSyn), top.location)
  ];
}

--------------------------------------------------

attribute constructorsSyn occurs on ProdBranchList;
propagate constructorsSyn on ProdBranchList;

attribute knownConstructors occurs on ProdBranchList;
propagate knownConstructors on ProdBranchList;

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

attribute constructorsSyn occurs on Term;
propagate constructorsSyn on Term;

attribute knownConstructors occurs on Term;
propagate knownConstructors on Term;

attribute termTy occurs on Term;

aspect production labelTerm
top::Term ::= lab::Label
{
  top.termTy = just(nameType("label"));
}

aspect production labelArgTerm
top::Term ::= lab::Label t::Term
{
  top.termTy = just(nameType("label"));
}

aspect production constructorTerm
top::Term ::= name::String ts::TermList
{
  local constrMaybe::Maybe<ConstructorInfo> = lookupConstructor(name, top.knownConstructors);

  top.termTy = case constrMaybe of
               | just(c) -> just(c.constructorType)
               | _ -> nothing()
               end;

  top.errs <- case constrMaybe of
              | just(c) -> []
              | nothing() -> [ noSuchConstructorError(name, top.location) ]
              end;

  top.errs <- case constrMaybe of
              | just(c) ->
                  let argTys::[Type] = c.constructorArgTys in
                    if eqTys(argTys, ts.termTys)
                    then []
                    else [ badConstructorArgsError(name, top.location) ]
                  end
              | nothing() -> []
              end;
}

aspect production nameTerm
top::Term ::= name::String
{
  local nameMaybe::Maybe<(String, Type)> = lookupVar(name, top.nameTyDecls);

  top.termTy = case nameMaybe of
               | just((s, t)) -> just(t)
               | _ -> nothing()
               end;
}

aspect production consTerm
top::Term ::= t1::Term t2::Term
{
  top.termTy = case t1.termTy, t2.termTy of
               | just(t1ty), just(listType(t2ty)) when eqType(t1ty, ^t2ty) -> just(listType(t1ty))
               | _, _ -> nothing()
               end;

  top.errs <- case t1.termTy, t2.termTy of
               | just(t1ty), just(lt) -> 
                    case lt of 
                      listType(t2ty) -> if eqType(t1ty, ^t2ty)
                                        then []
                                        else [ consTypeError(t1ty, lt, top.location) ]
                    | _ -> [ consTypeError(t1ty, lt, top.location) ]
                    end
               | nothing(), _ -> []
               | _, nothing() -> []
               end;
}

aspect production nilTerm
top::Term ::=
{
  top.termTy = just(listType(varType()));
}

aspect production tupleTerm
top::Term ::= ts::TermList
{
  top.termTy = if all(map((.isJust), ts.termTys))
               then just(tupleType(map((.fromJust), ts.termTys)))
               else nothing();
}

aspect production stringTerm
top::Term ::= s::String
{
  top.termTy = just(nameType("string"));
}

--------------------------------------------------

attribute constructorsSyn occurs on TermList;
propagate constructorsSyn on TermList;

attribute knownConstructors occurs on TermList;
propagate knownConstructors on TermList;

attribute termTys occurs on TermList;

aspect production termListCons
top::TermList ::= t::Term ts::TermList
{
  top.termTys = t.termTy :: ts.termTys;
}

aspect production termListNil
top::TermList ::=
{
  top.termTys = [];
}

--------------------------------------------------

aspect production label
top::Label ::= label::String
{}

--------------------------------------------------

attribute constructorsSyn occurs on Constraint;
propagate constructorsSyn on Constraint;

attribute knownConstructors occurs on Constraint;
propagate knownConstructors on Constraint;

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

attribute constructorsSyn occurs on Matcher;
propagate constructorsSyn on Matcher;

attribute knownConstructors occurs on Matcher;
propagate knownConstructors on Matcher;

aspect production matcher
top::Matcher ::= p::Pattern wc::WhereClause
{}

--------------------------------------------------

attribute constructorsSyn occurs on Pattern;
propagate constructorsSyn on Pattern;

attribute knownConstructors occurs on Pattern;
propagate knownConstructors on Pattern;

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

aspect production namePattern
top::Pattern ::= name::String ty::TypeAnn
{
  top.termTy = just(toType(^ty));
}

aspect production constructorPattern
top::Pattern ::= name::String ps::PatternList ty::TypeAnn
{
  top.constructorsSyn <- [constructor(name, ty.termTy.fromJust, map((.fromJust), ps.termTys), top.location)];
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

attribute constructorsSyn occurs on PatternList;
propagate constructorsSyn on PatternList;

attribute knownConstructors occurs on PatternList;
propagate knownConstructors on PatternList;

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

attribute constructorsSyn occurs on WhereClause;
propagate constructorsSyn on WhereClause;

attribute knownConstructors occurs on WhereClause;
propagate knownConstructors on WhereClause;

aspect production nilWhereClause
top::WhereClause ::=
{}

aspect production withWhereClause
top::WhereClause ::= gl::GuardList
{}

--------------------------------------------------

attribute constructorsSyn occurs on Guard;
propagate constructorsSyn on Guard;

attribute knownConstructors occurs on Guard;
propagate knownConstructors on Guard;

aspect production eqGuard
top::Guard ::= t1::Term t2::Term
{}

aspect production neqGuard
top::Guard ::= t1::Term t2::Term
{}

--------------------------------------------------

attribute constructorsSyn occurs on GuardList;
propagate constructorsSyn on GuardList;

attribute knownConstructors occurs on GuardList;
propagate knownConstructors on GuardList;

aspect production guardListCons
top::GuardList ::= g::Guard gl::GuardList
{}

aspect production guardListOne
top::GuardList ::= g::Guard
{}

--------------------------------------------------

attribute constructorsSyn occurs on Branch;
propagate constructorsSyn on Branch;

attribute knownConstructors occurs on Branch;
propagate knownConstructors on Branch;

aspect production branch
top::Branch ::= m::Matcher c::Constraint
{}

--------------------------------------------------

attribute constructorsSyn occurs on BranchList;
propagate constructorsSyn on BranchList;

attribute knownConstructors occurs on BranchList;
propagate knownConstructors on BranchList;

aspect production branchListCons
top::BranchList ::= b::Branch bs::BranchList
{}

aspect production branchListOne
top::BranchList ::= b::Branch
{}

--------------------------------------------------

attribute constructorsSyn occurs on Lambda;
propagate constructorsSyn on Lambda;

attribute knownConstructors occurs on Lambda;
propagate knownConstructors on Lambda;

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