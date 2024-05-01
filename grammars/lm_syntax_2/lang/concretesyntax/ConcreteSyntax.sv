grammar lm_syntax_2:lang:concretesyntax;

imports lm_syntax_2:lang:abstractsyntax;

--------------------------------------------------

synthesized attribute ast<a> :: a;

--------------------------------------------------

nonterminal Main_c with ast<Main>;

concrete production program_c
top::Main_c ::= ds::Decls_c
{
  top.ast = program(ds.ast);
}

--------------------------------------------------

nonterminal Decls_c with ast<Decls>;

concrete production declsCons_c
top::Decls_c ::= d::Decl_c ds::Decls_c
{
  top.ast = declsCons(d.ast, ds.ast);
}

concrete production declsNil_c
top::Decls_c ::= 
{
  top.ast = declsNil();
}

--------------------------------------------------

nonterminal Decl_c with ast<Decl>;

concrete production declModule_c
top::Decl_c ::= 'module' id::ModId_t '{' ds::Decls_c '}'
{
  top.ast = declModule(id.lexeme, ds.ast);
}

concrete production declImport_c
top::Decl_c ::= 'import' r::ModRef_c
{
  top.ast = declImport(r.ast);
}

concrete production declDef_c
top::Decl_c ::= 'def' b::ParBind_c
{
  top.ast = declDef(b.ast);
}

--------------------------------------------------

nonterminal Expr_c with ast<Expr>;

concrete production exprInt_c
top::Expr_c ::= i::Int_t
{
  top.ast = exprInt(toInteger(i.lexeme));
}

concrete production exprTrue_c
top::Expr_c ::= 'true'
{
  top.ast = exprTrue();
}

concrete production exprFalse_c
top::Expr_c ::= 'false'
{
  top.ast = exprFalse();
}

concrete production exprVar_c
top::Expr_c ::= r::VarRef_c
{
  top.ast = exprVar (r.ast);
}

concrete production exprAdd_c
top::Expr_c ::= e1::Expr_c '+' e2::Expr_c
{
  top.ast = exprAdd (e1.ast, e2.ast);
}

concrete production exprSub_c
top::Expr_c ::= e1::Expr_c '-' e2::Expr_c
{
  top.ast = exprSub (e1.ast, e2.ast);
}

concrete production exprMul_c
top::Expr_c ::= e1::Expr_c '*' e2::Expr_c
{
  top.ast = exprMul (e1.ast, e2.ast);
}

concrete production exprDiv_c
top::Expr_c ::= e1::Expr_c '/' e2::Expr_c
{
  top.ast = exprDiv (e1.ast, e2.ast);
}

concrete production exprAnd_c
top::Expr_c ::= e1::Expr_c '&' e2::Expr_c
{
  top.ast = exprAnd (e1.ast, e2.ast);
}

concrete production exprOr_c
top::Expr_c ::= e1::Expr_c '|' e2::Expr_c
{
  top.ast = exprOr (e1.ast, e2.ast);
}

concrete production exprEq_c
top::Expr_c ::= e1::Expr_c '==' e2::Expr_c
{
  top.ast = exprEq (e1.ast, e2.ast);
}

concrete production exprApp_c
top::Expr_c ::= e1::Expr_c App_t e2::Expr_c
{
  top.ast = exprApp (e1.ast, e2.ast);
}

concrete production exprIf_c
top::Expr_c ::= 'if' e1::Expr_c 'then' e2::Expr_c 'else' e3::Expr_c
{
  top.ast = exprIf (e1.ast, e2.ast, e3.ast);
}

concrete production exprFun_c
top::Expr_c ::= 'fun' '(' d::ArgDecl_c ')' '{' e::Expr_c '}'
{
  top.ast = exprFun (d.ast, e.ast);
}

concrete production exprLet_c
top::Expr_c ::= 'let' bs::SeqBinds_c 'in' e::Expr_c
{
  top.ast = exprLet (bs.ast, e.ast);
}

concrete production exprLetRec_c
top::Expr_c ::= 'letrec' bs::ParBinds_c 'in' e::Expr_c
{
  top.ast = exprLetRec (bs.ast, e.ast);
}

concrete production exprLetPar_c
top::Expr_c ::= 'letpar' bs::ParBinds_c 'in' e::Expr_c
{
  top.ast = exprLetPar (bs.ast, e.ast);
}

concrete production exprParens_c
top::Expr_c ::= '(' e::Expr_c ')'
{
  top.ast = e.ast;
}

--------------------------------------------------

nonterminal SeqBinds_c with ast<SeqBinds>;

concrete production seqBindsNil_c
top::SeqBinds_c ::=
{
  top.ast = seqBindsNil();
}

concrete production seqBindsOne_c
top::SeqBinds_c ::= s::SeqBind_c
{
  top.ast = seqBindsOne(s.ast);
}

concrete production seqBindsCons_c
top::SeqBinds_c ::= s::SeqBind_c ',' ss::SeqBinds_c
{
  top.ast = seqBindsCons(s.ast, ss.ast);
}

--------------------------------------------------

nonterminal SeqBind_c with ast<SeqBind>;

concrete production seqBindUntyped_c
top::SeqBind_c ::= id::VarId_t '=' e::Expr_c
{
  top.ast = seqBindUntyped(id.lexeme, e.ast);
}

concrete production seqBindTyped_c
top::SeqBind_c ::= ty::Type_c ':' id::VarId_t '=' e::Expr_c
{
  top.ast = seqBindTyped(ty.ast, id.lexeme, e.ast);
}

--------------------------------------------------

nonterminal ParBinds_c with ast<ParBinds>;

concrete production parBindsNil_c
top::ParBinds_c ::=
{
  top.ast = parBindsNil();
}

concrete production parBindsCons_c
top::ParBinds_c ::= s::ParBind_c ',' ss::ParBinds_c
{
  top.ast = parBindsCons(s.ast, ss.ast);
}

--------------------------------------------------

nonterminal ParBind_c with ast<ParBind>;

concrete production parBindUntyped_c
top::ParBind_c ::= id::VarId_t '=' e::Expr_c
{
  top.ast = parBindUntyped(id.lexeme, e.ast);
}

concrete production parBindTyped_c
top::ParBind_c ::= ty::Type_c ':' id::VarId_t '=' e::Expr_c
{
  top.ast = parBindTyped(ty.ast, id.lexeme, e.ast);
}

--------------------------------------------------

nonterminal ArgDecl_c with ast<ArgDecl>;

concrete production argDecl_c
top::ArgDecl_c ::= id::VarId_t ':' ty::Type_c
{
  top.ast = argDecl (id.lexeme, ty.ast);
}

--------------------------------------------------

nonterminal Type_c with ast<Type>;

concrete production tInt_c
top::Type_c ::= 'int'
{
  top.ast = tInt ();
}

concrete production tBool_c
top::Type_c ::= 'bool'
{
  top.ast = tBool ();
}

concrete production tArrow_c
top::Type_c ::= tyann1::Type_c '->' tyann2::Type_c
{
  top.ast = tArrow (tyann1.ast, tyann2.ast);
}

concrete production typeParens_c
top::Type_c ::= '(' t::Type_c ')'
{
  top.ast = t.ast;
}

--------------------------------------------------

nonterminal ModRef_c with ast<ModRef>;

concrete production modRef_c
top::ModRef_c ::= x::ModId_t
{
  top.ast = modRef (x.lexeme);
}

concrete production modQRef_c
top::ModRef_c ::= r::ModRef_c '.' x::ModId_t
{
  top.ast = modQRef (r.ast, x.lexeme);
}

--------------------------------------------------

nonterminal VarRef_c with ast<VarRef>;

concrete production varRef_c
top::VarRef_c ::= x::VarId_t
{
  top.ast = varRef (x.lexeme);
}

concrete production varQRef_c
top::VarRef_c ::= r::ModRef_c '.' x::VarId_t
{
  top.ast = varQRef (r.ast, x.lexeme);
}