grammar lm_syntax_2:lang:concretesyntax;

imports lm_syntax_2:lang:abstractsyntax;

--------------------------------------------------

synthesized attribute ast<a> :: a;

--------------------------------------------------

nonterminal Main_c with ast<Main>, location;

concrete production program_c
top::Main_c ::= ds::Decls_c
{
  top.ast = program(ds.ast, location=top.location);
}

--------------------------------------------------

nonterminal Decls_c with ast<Decls>, location;

concrete production declsCons_c
top::Decls_c ::= d::Decl_c ds::Decls_c
{
  top.ast = declsCons(d.ast, ds.ast, location=top.location);
}

concrete production declsNil_c
top::Decls_c ::=
{
  top.ast = declsNil(location=top.location);
}

--------------------------------------------------

nonterminal Decl_c with ast<Decl>, location;

concrete production declModule_c
top::Decl_c ::= 'module' id::ModId_t '{' ds::Decls_c '}'
{
  top.ast = declModule(id.lexeme, ds.ast, location=top.location);
}

concrete production declImport_c
top::Decl_c ::= 'import' r::ModRef_c
{
  top.ast = declImport(r.ast, location=top.location);
}

concrete production declDef_c
top::Decl_c ::= 'def' b::ParBind_c
{
  top.ast = declDef(b.ast, location=top.location);
}

--------------------------------------------------

nonterminal Expr_c with ast<Expr>, location;

concrete production exprInt_c
top::Expr_c ::= i::Int_t
{
  top.ast = exprInt(toInteger(i.lexeme), location=top.location);
}

concrete production exprTrue_c
top::Expr_c ::= 'true'
{
  top.ast = exprTrue(location=top.location);
}

concrete production exprFalse_c
top::Expr_c ::= 'false'
{
  top.ast = exprFalse(location=top.location);
}

concrete production exprVar_c
top::Expr_c ::= r::VarRef_c
{
  top.ast = exprVar(r.ast, location=top.location);
}

concrete production exprAdd_c
top::Expr_c ::= e1::Expr_c '+' e2::Expr_c
{
  top.ast = exprAdd(e1.ast, e2.ast, location=top.location);
}

concrete production exprSub_c
top::Expr_c ::= e1::Expr_c '-' e2::Expr_c
{
  top.ast = exprSub(e1.ast, e2.ast, location=top.location);
}

concrete production exprMul_c
top::Expr_c ::= e1::Expr_c '*' e2::Expr_c
{
  top.ast = exprMul(e1.ast, e2.ast, location=top.location);
}

concrete production exprDiv_c
top::Expr_c ::= e1::Expr_c '/' e2::Expr_c
{
  top.ast = exprDiv(e1.ast, e2.ast, location=top.location);
}

concrete production exprAnd_c
top::Expr_c ::= e1::Expr_c '&' e2::Expr_c
{
  top.ast = exprAnd(e1.ast, e2.ast, location=top.location);
}

concrete production exprOr_c
top::Expr_c ::= e1::Expr_c '|' e2::Expr_c
{
  top.ast = exprOr(e1.ast, e2.ast, location=top.location);
}

concrete production exprEq_c
top::Expr_c ::= e1::Expr_c '==' e2::Expr_c
{
  top.ast = exprEq(e1.ast, e2.ast, location=top.location);
}

concrete production exprApp_c
top::Expr_c ::= e1::Expr_c '$' e2::Expr_c
{
  top.ast = exprApp(e1.ast, e2.ast, location=top.location);
}

concrete production exprIf_c
top::Expr_c ::= 'if' e1::Expr_c 'then' e2::Expr_c 'else' e3::Expr_c
{
  top.ast = exprIf(e1.ast, e2.ast, e3.ast, location=top.location);
}

concrete production exprFun_c
top::Expr_c ::= 'fun' '(' d::ArgDecl_c ')' '{' e::Expr_c '}'
{
  top.ast = exprFun(d.ast, e.ast, location=top.location);
}

concrete production exprLet_c
top::Expr_c ::= 'let' bs::SeqBinds_c 'in' e::Expr_c
{
  top.ast = exprLet(bs.ast, e.ast, location=top.location);
}

concrete production exprLetRec_c
top::Expr_c ::= 'letrec' bs::ParBinds_c 'in' e::Expr_c
{
  top.ast = exprLetRec(bs.ast, e.ast, location=top.location);
}

concrete production exprLetPar_c
top::Expr_c ::= 'letpar' bs::ParBinds_c 'in' e::Expr_c
{
  top.ast = exprLetPar(bs.ast, e.ast, location=top.location);
}

concrete production exprParens_c
top::Expr_c ::= '(' e::Expr_c ')'
{
  top.ast = e.ast;
}

--------------------------------------------------

nonterminal SeqBinds_c with ast<SeqBinds>, location;

concrete production seqBindsNil_c
top::SeqBinds_c ::=
{
  top.ast = seqBindsNil(location=top.location);
}

concrete production seqBindsOne_c
top::SeqBinds_c ::= s::SeqBind_c
{
  top.ast = seqBindsOne(s.ast, location=top.location);
}

concrete production seqBindsCons_c
top::SeqBinds_c ::= s::SeqBind_c ',' ss::SeqBinds_c
{
  top.ast = seqBindsCons(s.ast, ss.ast, location=top.location);
}

--------------------------------------------------

nonterminal SeqBind_c with ast<SeqBind>, location;

concrete production seqBindUntyped_c
top::SeqBind_c ::= id::VarId_t '=' e::Expr_c
{
  top.ast = seqBindUntyped(id.lexeme, e.ast, location=top.location);
}

concrete production seqBindTyped_c
top::SeqBind_c ::= id::VarId_t ':' ty::Type_c '=' e::Expr_c
{
  top.ast = seqBindTyped(ty.ast, id.lexeme, e.ast, location=top.location);
}

--------------------------------------------------

nonterminal ParBinds_c with ast<ParBinds>, location;

concrete production parBindsNil_c
top::ParBinds_c ::=
{
  top.ast = parBindsNil(location=top.location);
}

concrete production parBindsOne_c
top::ParBinds_c ::= s::ParBind_c
{ -- QUESTION: unsure why i need ^s (i.e. "new(s)") instead of s here
  forwards to parBindsCons_c(^s, ',', parBindsNil_c(location=top.location), location=top.location);
}

concrete production parBindsCons_c
top::ParBinds_c ::= s::ParBind_c ',' ss::ParBinds_c
{
  top.ast = parBindsCons(s.ast, ss.ast, location=top.location);
}

--------------------------------------------------

nonterminal ParBind_c with ast<ParBind>, location;

concrete production parBindUntyped_c
top::ParBind_c ::= id::VarId_t '=' e::Expr_c
{
  top.ast = parBindUntyped(id.lexeme, e.ast, location=top.location);
}

concrete production parBindTyped_c
top::ParBind_c ::= id::VarId_t ':' ty::Type_c '=' e::Expr_c
{
  top.ast = parBindTyped(ty.ast, id.lexeme, e.ast, location=top.location);
}

--------------------------------------------------

nonterminal ArgDecl_c with ast<ArgDecl>, location;

concrete production argDecl_c
top::ArgDecl_c ::= id::VarId_t ':' ty::Type_c
{
  top.ast = argDecl(id.lexeme, ty.ast, location=top.location);
}

--------------------------------------------------

nonterminal Type_c with ast<Type>, location;

concrete production tInt_c
top::Type_c ::= 'int'
{
  top.ast = tInt();
}

concrete production tBool_c
top::Type_c ::= 'bool'
{
  top.ast = tBool();
}

concrete production tFun_c
top::Type_c ::= tyann1::Type_c '->' tyann2::Type_c
{
  top.ast = tFun(tyann1.ast, tyann2.ast);
}

concrete production typeParens_c
top::Type_c ::= '(' t::Type_c ')'
{
  top.ast = t.ast;
}

--------------------------------------------------

nonterminal ModRef_c with ast<ModRef>, location;

concrete production modRef_c
top::ModRef_c ::= x::ModId_t
{
  top.ast = modRef(x.lexeme, location=top.location);
}

--------------------------------------------------

nonterminal VarRef_c with ast<VarRef>, location;

concrete production varRef_c
top::VarRef_c ::= x::VarId_t
{
  top.ast = varRef(x.lexeme, location=top.location);
}