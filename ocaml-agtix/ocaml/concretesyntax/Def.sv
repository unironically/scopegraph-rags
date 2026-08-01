grammar ocaml:concretesyntax;

-- https://ocaml.org/manual/5.4/language.html

--------
-- Rules

nonterminal Def_c with ast<Def>, location;

--concrete production defLet
--top::Def_c ::= 'let' l::LetBinding_c
--{}

--concrete production defLetRec
--top::Def_c ::= 'let' 'rec' l::LetBinding_c
--{}

concrete production defTypeDef_c
top::Def_c ::= d::TypeDef_c
{ top.ast = defTypeDef(d.ast, location=top.location); }

concrete production defLetRecDef_c
top::Def_c ::= 'let' 'rec' t::Identifier_t ps::Patterns_c ':' te::TypeExpr_c '=' e::Expr_c
{
  top.ast = defLetRecDef(t.lexeme, ps.ast, te.ast, e.ast, location=top.location);
}

--

nonterminal Patterns_c with ast<Patterns>, location;

concrete production patternsCons_c
top::Patterns_c ::= p::Pattern_c ps::Patterns_c
{
  top.ast = patternsCons(p.ast, ps.ast, location=top.location);
}

concrete production patternsNil_c
top::Patterns_c ::= 
{
  top.ast = patternsNil(location=top.location);
}

--

nonterminal TypeDef_c with ast<TypeDef>, location;

concrete production typeDef_c
top::TypeDef_c ::= 'type' {-ps::MaybeTypeParams_c-} t::Identifier_t '=' i::TypeDefRHS_c
{ top.ast = typeDef({-ps.ast,-} t.lexeme, i.ast, location=top.location); }

--


nonterminal LetBinding_c with ast<LetBinding>, location;

concrete production letBindingParamsTy_c
top::LetBinding_c ::= t::Identifier_t {-p::Params_c-} ':' te::TypeExpr_c '=' e::Expr_c
{ top.ast = letBindingParamsTy(t.lexeme, {-p.ast,-} te.ast, e.ast, location=top.location); }

--concrete production letBindingParamsNoTy_c
--top::LetBinding_c ::= t::Identifier_t p::Params_c '=' e::Expr_c
--{ top.ast = letBindingParamsNoTy(t.lexeme, p.ast, e.ast); }


--

{-
nonterminal Params_c with ast<Params>, location;

concrete production paramsCons_c
top::Params_c ::= '(' id::Identifier_t ':' te::TypeExpr_c ')' ps::Params_c
{ top.ast = paramsCons(id.lexeme, te.ast, ps.ast, location=top.location); }

concrete production paramsNil_c
top::Params_c ::=
{ top.ast = paramsNil(location=top.location); }
-}

--

{-
nonterminal MaybeTypeParams_c with ast<MaybeTypeParams>;

concrete production maybeTypeParamsOne_c
top::MaybeTypeParams_c ::= Tick_t t::Identifier_t
{ top.ast = maybeTypeParamsSome(typeParamsOne(t.lexeme)); }

concrete production maybeTypeParamsSome_c
top::MaybeTypeParams_c ::= '(' ps::TypeParams_c ')'
{ top.ast = maybeTypeParamsSome(ps.ast); }

concrete production maybeTypeParmsNone_c
top::MaybeTypeParams_c ::=
{ top.ast = maybeTypeParmsNone(); }

--

nonterminal TypeParams_c with ast<TypeParams>;

concrete production typeParamsCons_c
top::TypeParams_c ::= Tick_t t::Identifier_t ',' rest::TypeParams_c
{ top.ast = typeParamsCons(t.lexeme, rest.ast); }

concrete production typeParamsOne_c
top::TypeParams_c ::= Tick_t t::Identifier_t
{ top.ast = typeParamsOne(t.lexeme); }
-}

--

nonterminal TypeDefRHS_c with ast<TypeDefRHS>, location;

--concrete production typeInfoEquation_c
--top::TypeDefRHS_c ::= te::TypeExpr_c
--{ top.ast = typeInfoEquation(te.ast); }

concrete production typeInfoConstructor1_c
top::TypeDefRHS_c ::= c::ConstructorDecl_c cd::ConstructorDeclList_c
{ top.ast = typeInfoConstructor(constructorDclListCons(c.ast, cd.ast, location=top.location), location=top.location); }

concrete production typeInfoConstructor2_c
top::TypeDefRHS_c ::= '|' c::ConstructorDecl_c cd::ConstructorDeclList_c
{ top.ast = typeInfoConstructor(constructorDclListCons(c.ast, cd.ast, location=top.location), location=top.location); }


--

nonterminal ConstructorDeclList_c with ast<ConstructorDeclList>, location;

concrete production constructorDclListCons_c
top::ConstructorDeclList_c ::= '|' c::ConstructorDecl_c rest::ConstructorDeclList_c
{ top.ast = constructorDclListCons(c.ast, rest.ast, location=top.location); }

concrete production constructorDclListNil_c
top::ConstructorDeclList_c ::=
{ top.ast = constructorDclListNil(location=top.location); }

--

nonterminal ConstructorDecl_c with ast<ConstructorDecl>, location;

concrete production constructorDeclNoArgs_c
top::ConstructorDecl_c ::= t::IdentifierUpper_t
{ top.ast = constructorDecl(t.lexeme, constructorArgsNil(location=top.location), location=top.location); }

concrete production constructorDeclArgs_c
top::ConstructorDecl_c ::= t::IdentifierUpper_t 'of' ca::ConstructorArgs_c
{ top.ast = constructorDecl(t.lexeme, ca.ast, location=top.location); }

--

nonterminal ConstructorArgs_c with ast<ConstructorArgs>, location;

concrete production constructorArgsCons_c
top::ConstructorArgs_c ::= te::TypeExpr_c '*' ca::ConstructorArgs_c
{ top.ast = constructorArgsCons(te.ast, ca.ast, location=top.location); }

concrete production constructorArgsOne_c
top::ConstructorArgs_c ::= te::TypeExpr_c
{ top.ast = constructorArgsCons(te.ast, constructorArgsNil(location=top.location), location=top.location); }
