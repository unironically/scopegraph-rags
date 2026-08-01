grammar lmr3:lmr:nameanalysis_sgdsl;

--------------------------------------------------

scope attribute s::LexScope;
scope attribute s_last::RegionScope;

--------------------------------------------------

--synthesized attribute errs::[String];
synthesized attribute type::Type;

--------------------------------------------------

nonterminal Main;

abstract production program
top::Main ::= ds::Decls
{
  apply sgMkGlob;

  ds.s = sgMkGlob.glob; -- how do we talk about sending scopes down tree?
}

-- or

{-

abstract production program
top::Main ::= ds::Decls | sgMkGlob
{
  ds.s = sgMkGlob.glob;
}

-}

--------------------------------------------------

nonterminal Decls with s;
propagate s on Decl;

abstract production declsCons
top::Decls ::= d::Decl ds::Decls
{
}

abstract production declsNil
top::Decls ::=
{
}

--------------------------------------------------

nonterminal Decl with s;
propagate s on Decl;

abstract production declModule
top::Decl ::= m::Module
{
}

abstract production declImport
top::Decl ::= mr::ModRef
{
}

abstract production declDef
top::Decl ::= b::Bind
{
}

--------------------------------------------------

nonterminal Bind with name, s;

abstract production bind
top::Bind ::= x::String e::Expr | 
{
  apply sgMkVar(top.s);

  e.s =  top.s;
}

-- or

{-

abstract production bind
top::Bind ::= x::String e::Expr | sgMkVar(top.s)
{
  e.s =  top.s;
}

-}

--------------------------------------------------

nonterminal Module with name, s;

abstract production module
top::Module ::= x::String ds::Decls
{
  apply sgMkMod(top.s);

  ds.s = sgMkMod.m;
}

-- or

{-

abstract production module
top::Module ::= x::String ds::Decls | sgMkMod(top.s)
{
  ds.s = sgMkMod.m;
}

-}

--------------------------------------------------

nonterminal Expr with s;
propagate s on Expr excluding exprLet;

abstract production exprVar
top::Expr ::= r::VarRef
{ 
}

abstract production exprInt
top::Expr ::= i::Integer
{
}

abstract production exprBool
top::Expr ::= b::Boolean
{
}

abstract production exprAdd
top::Expr ::= e1::Expr e2::Expr
{ 
}

abstract production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
}

abstract production exprEq
top::Expr ::= e1::Expr e2::Expr
{
}

abstract production exprLet
top::Expr ::= bs::Binds e::Expr
{
  existScope s_last;

  bs.s = top.s;
  bs.s_last = s_last;

  e.s = s_last;
}


--------------------------------------------------

nonterminal Binds with s, s_last;

abstract production seqBindsCons
top::Binds ::= b::Bind bs::Binds
{
  apply sgMkLex(top.s);

  b.s = top.s;

  bs.s = sgMkLex.s2;
  bs.s_last = top.s_last;
}

abstract production seqBindsLast
top::Binds ::= b::Bind
{
  b.s = top.s;

  top.s_last = top.s;
}

--------------------------------------------------

nonterminal Type;

abstract production tInt
top::Type ::=
{
}

abstract production tBool
top::Type ::=
{
}

abstract production tErr
top::Type ::=
{
}

instance Eq Type {
  eq = \l::Type r::Type -> 
    case l, r of
    | tInt(), tInt() -> true | tBool(), tBool() -> true
    | tErr(), _ -> true      | _, tErr() -> true
    | _, _ -> false
    end;
}

--------------------------------------------------

nonterminal VarRef with s, type;

abstract production varRef
top::VarRef ::= x::String
{
  query queryVar2(top.s);

  -- could also have this type computation over in queryVar2 definition
  top.type = if queryVar2.only.isJust then queryVar2.only.fromJust else tErr();

  top.ok = top.type != tErr();
}

--------------------------------------------------

nonterminal ModRef with s;

abstract production modRef
top::ModRef ::= x::String
{
  query queryMod(top.s);

  local tgt::Decorated Scope =
    if length(queryMod) == 1 then head(queryMod) else globalDummyScope;

  apply sgMkImp(top.s, tgt);
  -- or
  top.s -[imp]-> tgt;
}
