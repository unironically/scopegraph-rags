grammar lmr1:lmr:nameanalysis_kastenswaite;

--------------------------------------------------

synthesized attribute pp::String;
synthesized attribute ok::Boolean;

--------------------------------------------------

nonterminal Main with location, ok;

production program
top::Main ::= ds::Decls
{
  top.ok = true;
}

--------------------------------------------------

nonterminal Decls with location;

production declsCons
top::Decls ::= d::Decl ds::Decls
{
}

production declsNil
top::Decls ::=
{
}

--------------------------------------------------

nonterminal Decl with location;

production declModule
top::Decl ::= m::Module
{
}

production declImport
top::Decl ::= mr::ModRef
{
}

production declDef
top::Decl ::= b::Bind
{
}

--------------------------------------------------

nonterminal Module with location;

production module
top::Module ::= x::String ds::Decls
{
}

--------------------------------------------------

nonterminal Expr with location;

production exprVar
top::Expr ::= r::VarRef
{
}

production exprFloat
top::Expr ::= f::Float
{
}

production exprInt
top::Expr ::= i::Integer
{
}

production exprTrue
top::Expr ::=
{
}

production exprFalse
top::Expr ::=
{
}

production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
}

production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
}

production exprEq
top::Expr ::= e1::Expr e2::Expr
{
}

production exprFun
top::Expr ::= b::Bind e::Expr
{
}

production exprApp
top::Expr ::= e1::Expr e2::Expr
{
}

production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
}

production exprLet
top::Expr ::= bs::Binds e::Expr
{
}

production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
}

production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
}

--------------------------------------------------

nonterminal Binds with location;

production seqBindsCons
top::Binds ::= b::Bind bs::Binds
{
}

production seqBindsLast
top::Binds ::= b::Bind
{
}

production seqBindsNil
top::Binds ::=
{
}

--------------------------------------------------

nonterminal ParBinds with location;

production parBindsCons
top::ParBinds ::= b::Bind bs::ParBinds
{
}

production parBindsLast
top::ParBinds ::= b::Bind
{
}

production parBindsNil
top::ParBinds ::=
{
}

--------------------------------------------------

nonterminal Bind with location;

production bindTyped
top::Bind ::= tyann::Type x::String e::Expr
{
}

production bind
top::Bind ::= x::String e::Expr
{
}

production bindArgDcl
top::Bind ::= x::String tyann::Type
{
}

--------------------------------------------------

nonterminal Type with pp;

production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  top.pp =
    case tyann1 of
    | tFun(_, _) -> "(" ++ tyann1.pp ++ ") -> " ++ tyann2.pp
    | _ -> tyann1.pp ++ " -> " ++ tyann2.pp
    end;
}

production tFloat
top::Type ::=
{
  top.pp = "float";
}

production tInt
top::Type ::=
{
  top.pp = "int";
}

production tBool
top::Type ::=
{
  top.pp = "bool";
}

production tErr
top::Type ::=
{
  top.pp = "<err>";
}

fun eqType Boolean ::= t1::Type t2::Type =
  case t1, t2 of
  | tFloat(), tFloat() -> true
  | tInt(), tInt() -> true
  | tBool(), tBool() -> true
  | tFun(t1_1, t1_2), tFun(t2_1, t2_2) -> eqType(^t1_1, ^t2_1) && eqType(^t1_2, ^t2_2)
  | tErr(), tErr() -> true
  | _, _ -> false
  end;

instance Eq Type {
  eq = eqType;
}

--------------------------------------------------

nonterminal ModRef with location;

production modRef
top::ModRef ::= x::String
{
}

--------------------------------------------------

nonterminal VarRef with location;

production varRef
top::VarRef ::= x::String
{
}