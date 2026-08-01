grammar ocaml:abstractsyntax;

--

inherited attribute tyname::String;

--

nonterminal Def with errs, s, s_def, location;

production defTypeDef
top::Def ::= d::TypeDef
{
  propagate errs;

  d.s = top.s;
  d.s_def = top.s_def;
}

production defLetRecDef
top::Def ::= name::String ps::Patterns ty::TypeExpr rhs::Expr 
{
  propagate errs;

  newScope letRecScope -> datumLetVar(name, ty.type);

  top.s_def -[ `var ]-> letRecScope;
  letRecScope -[ `lex ]-> top.s_def;

  ps.s = letRecScope;

  ty.s = top.s;

  rhs.s = letRecScope;
  rhs.expectExprType = ty.type;
}

--

nonterminal Patterns with location, errs, s;

production patternsCons
top::Patterns ::= p::Pattern ps::Patterns
{
  propagate errs;

  p.s = top.s;
  p.patternType = errType();

  ps.s = top.s;
}

production patternsNil
top::Patterns ::=
{
  propagate errs;
}

--

nonterminal TypeDef with errs, s, s_def, location;

production typeDef
top::TypeDef ::= {-ps::MaybeTypeParams-} t::String i::TypeDefRHS
{
  propagate errs;

  newScope typeScope -> datumTypeDef(t, top);

  top.s -[ `ty ]-> typeScope;

  i.s = top.s;
  i.s_def = typeScope;
  i.tyname = t;
}

production typeDefBuiltin
top::TypeDef ::= t::String
{
  propagate errs;
}

--

{-
nonterminal MaybeTypeParams;

production maybeTypeParamsOne
top::MaybeTypeParams ::= t::String
{}

production maybeTypeParamsSome
top::MaybeTypeParams ::= ps::TypeParams
{}

production maybeTypeParmsNone
top::MaybeTypeParams ::=
{}

--

nonterminal TypeParams;

production typeParamsCons
top::TypeParams ::= t::String rest::TypeParams
{}

production typeParamsOne
top::TypeParams ::= t::String
{}
-}

--

nonterminal TypeDefRHS with errs, s, s_def, tyname, location;

--production typeInfoEquation
--top::TypeDefRHS ::= te::TypeExpr
--{}

production typeInfoConstructor
top::TypeDefRHS ::= cd::ConstructorDeclList
{
  propagate errs;

  cd.s = top.s;
  cd.s_def = top.s_def;
  cd.tyname = top.tyname;
}

production typeInfoBuiltin
top::TypeDefRHS ::=
{
  propagate errs;
}

--

nonterminal ConstructorDeclList with errs, s, s_def, tyname, location;

production constructorDclListCons
top::ConstructorDeclList ::= c::ConstructorDecl rest::ConstructorDeclList
{
  propagate errs;

  c.s = top.s;
  c.s_def = top.s_def;
  c.tyname = top.tyname;

  rest.s = top.s;
  rest.s_def = top.s_def;
  rest.tyname = top.tyname;
}

production constructorDclListNil
top::ConstructorDeclList ::=
{
  propagate errs;
}

--

nonterminal ConstructorDecl with errs, s, s_def, tyname, type, location;

production constructorDecl
top::ConstructorDecl ::= t::String ca::ConstructorArgs
{
  propagate errs;

  newScope constructorScope -> datumConstructor(t, top.tyname, top);

  top.s_def -[ `con ]-> constructorScope;

  ca.s = top.s;

  top.type = ca.type;
}

--

nonterminal ConstructorArgs with errs, s, type, location;

production constructorArgsCons
top::ConstructorArgs ::= te::TypeExpr ca::ConstructorArgs
{
  propagate errs;

  te.s = top.s;

  ca.s = top.s;

  top.type =  
    case ca of 
      constructorArgsNil() -> te.type
    | _ -> tupleType(te.type, ca.type)
    end;
}

production constructorArgsNil
top::ConstructorArgs ::=
{
  propagate errs;

  top.type = error("impossible (constructorArgsNil.type)");
}

--

scope attribute s_let;

nonterminal LetBinding with errs, s, s_let, location;

production letBindingParamsTy
top::LetBinding ::= x::String {-p::Params-} te::TypeExpr e::Expr
{
  newScope top.s_let;

  --p.s = top.s;
  --p.s_let = top.s_let;

  newScope s_lb -> datumLetVar(x, te.type);
  top.s_let -[ `var ]-> s_lb;

  te.s = top.s;

  e.s = top.s;
  e.expectExprType = te.type;

  top.errs := if !null(te.errs) then te.errs else e.errs;--if !null(p.errs) then p.errs else if !null(te.errs) then te.errs else e.errs;
}

--

{-
nonterminal Params with errs, s, s_let, location;

production paramsCons
top::Params ::= s::String te::TypeExpr ps::Params
{
  newScope s_param -> datumLetVar(s, te.type);
  top.s_let -[ `var ]-> s_param;
  
  te.s = top.s;

  ps.s = top.s;
  ps.s_let = top.s_let;

  top.errs := if !null(te.errs) then te.errs else ps.errs;
}

production paramsNil
top::Params ::=
{
  propagate errs;
}
-}