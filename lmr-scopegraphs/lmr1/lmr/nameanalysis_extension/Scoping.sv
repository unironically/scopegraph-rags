grammar lmr1:lmr:nameanalysis_extension;

imports syntax:lmr1:lmr:abstractsyntax;

--------------------------------------------------

-- { scopeAttributeExample }
scopegraph LMGraph labels lex, var, mod, imp;

scope attribute LMGraph:s;
attribute s occurs on Decls, Decl;
-- { scopeAttributeExample }
attribute s occurs on Bind, Module, ParBinds, SeqBinds, Expr, VarRef, ModRef;

scope attribute LMGraph:s_def;
attribute s_def occurs on ParBinds, Bind, Decl, ModRef;

scope attribute LMGraph:s_last;
attribute s_last occurs on SeqBinds;

scope attribute LMGraph:s_module;
attribute s_module occurs on Decls, Decl, Module;

--------------------------------------------------

monoid attribute msgs::[Message] with [], ++ occurs on Main, Decls, Decl, 
  Module, Bind, Expr, VarRef, SeqBinds, ParBinds, ModRef;

propagate msgs on Main, Decls, Decl, Expr, VarRef, Bind, Module,
  SeqBinds, ParBinds, ModRef;

synthesized attribute type::Type occurs on Expr, VarRef;

--------------------------------------------------

aspect production program
top::Main ::= ds::Decls
{
  newScope glob::LMGraph -> datumLex();

  ds.s = glob;
  ds.s_module = glob;
}

--------------------------------------------------

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  newScope seqScope::LMGraph -> datumLex();

  seqScope -[ lex ]-> top.s;

  d.s = top.s;
  d.s_def = seqScope;
  d.s_module = top.s_module;

  ds.s = seqScope;
  ds.s_module = top.s_module;
}

aspect production declsNil
top::Decls ::=
{
}

--------------------------------------------------

aspect production declModule
top::Decl ::= m::Module
{
  m.s = top.s;
  m.s_module = top.s_module;
}

aspect production declImport
top::Decl ::= mr::ModRef
{
  mr.s = top.s;
  mr.s_def = top.s_def;
}

aspect production declDef
top::Decl ::= b::Bind
{
  b.s = top.s;
  b.s_def = top.s_module;
}

--------------------------------------------------

-- { moduleDeclExample }
aspect production module
top::Module ::= x::String ds::Decls
{
  newScope modScope::LMGraph -> datumMod(x, top);

  modScope -[ lex ]-> top.s;
  top.s_module -[ mod ]-> modScope;

  ds.s = modScope;
  ds.s_module = modScope;
}
-- { moduleDeclExample }

--------------------------------------------------

aspect production exprFloat
top::Expr ::= f::Float
{
  top.type = tFloat();
}

aspect production exprInt
top::Expr ::= i::Integer
{
  top.type = tInt();
}

aspect production exprTrue
top::Expr ::=
{
  top.type = tBool();
}

aspect production exprFalse
top::Expr ::=
{
  top.type = tBool();
}

aspect production exprVar
top::Expr ::= r::VarRef
{
  r.s = top.s;

  top.type = r.type;
}

-- { addExample }
aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  local msgLeft::[Message] =
    if ty1 == tInt() || ty1 == tFloat() || ty1 == tErr()
    then []
    else [errorMessage(
      "addition left operand must be int or float, " ++
      "but an expression was given of type " ++ ty1.pp,
      top.location
    )];

  local msgRight::[Message] =
    if ty2 == tInt() || ty2 == tFloat() || ty2 == tErr()
    then []
    else [errorMessage(
      "addition right operand must be int or float, " ++
      "expression was given of type " ++ ty2.pp,
      top.location
    )];


  top.msgs <- msgLeft ++ msgRight;
  top.type = 
    if null(top.msgs)
    then (if e1.type == tFloat() || e2.type == tFloat() then tFloat() else tInt())
    else tErr();
}
-- { addExample }

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  local ok::([Message], Type) = andOk(ty1, ty2, top.location);

  top.msgs <- ok.1;
  top.type = ok.2;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  local msgLeft::[Message] =
    if ty1 == tInt() || ty1 == tFloat() || ty1 == tBool()
    then []
    else [errorMessage(
      "equality expects left operand to be of type int or float or bool, " ++
      "but an expression was given of type " ++ ty1.pp,
      top.location
    )];
  
  local msgRight::[Message] =
    if !null(msgLeft) || ty1 == ty2
    then []
    else [errorMessage(
      "equality expects right operand to be of type " ++ ty1.pp ++ ", but an " ++
      "expression was given of type " ++ ty2.pp,
      top.location
    )];

  top.msgs <- if !null(msgLeft) then msgLeft else msgRight;
  top.type = tBool();
}

aspect production exprFun
top::Expr ::= b::Bind e::Expr
{
  newScope s_fun::LMGraph -> datumLex();

  s_fun -[ lex ]-> top.s;

  b.s = top.s;
  b.s_def = s_fun;

  nondecorated local ty1::Type = b.type;

  e.s = s_fun;
  nondecorated local ty2::Type = e.type;

  top.type = tFun(ty1, ty2);
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  local ty3and4::(Boolean, Type, Type) = 
    case ty1 of
    | tFun(ty3, ty4) -> (true, ^ty3, ^ty4)
    | _ -> (false, tErr(), tErr())
    end;

  nondecorated local ty3::Type = ty3and4.2;
  nondecorated local ty4::Type = ty3and4.3;

  local msgLeft::[Message] =
    if ty3and4.1
    then []
    else [errorMessage("application expects left operand to be of function type, " ++
                       "but an expression was given of type " ++ ty1.pp,
                       top.location)];

  local msgRight::[Message] =
    if !null(msgLeft) || ty2 == ty3
    then []
    else [errorMessage(
      "application expects right operand to be of type " ++ ty3.pp ++ ", but an " ++
      "expression was given of type " ++ ty2.pp,
      top.location
    )];

  top.msgs <- if !null(msgLeft) then msgLeft else msgRight;
  top.type = ty4;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  e3.s = top.s;
  nondecorated local ty3::Type = e3.type;

  top.msgs <-
    if ty1 == tBool()
    then []
    else [errorMessage(
      "conditional expects first operand to be of type bool, but an expression " ++
      "was given of type " ++ ty1.pp,
      top.location
    )];
  
  top.msgs <-
    if ty2 == ty3
    then []
    else [errorMessage(
      "conditional expects else branch to be of type " ++ ty2.pp ++ ", but an expression " ++
      "was given of type " ++ ty3.pp,
      top.location
    )];

  top.type = if ty1 == tBool() && ty2 == ty3 then ty2 else tErr();
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  newScope s_let::LMGraph -> datumLex();

  s_let -[ lex ]-> top.s;

  bs.s = s_let;
  bs.s_def = s_let;

  e.s = s_let;

  top.type = e.type;
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  newScope s_let::LMGraph -> datumLex();

  s_let -[ lex ]-> top.s;

  bs.s = top.s;
  bs.s_def = s_let;

  e.s = s_let;

  top.type = e.type;
}

--------------------------------------------------

-- { exprLetExample }
aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  existsScope LMGraph:s_let;

  bs.s = top.s;
  bs.s_last = s_let;

  e.s = s_let;

  top.type = e.type;
}

aspect production seqBindsLast
top::SeqBinds ::= s::Bind
{
  newScope top.s_last::LMGraph -> datumLex();
  top.s_last -[ lex ]-> top.s;

  s.s = top.s;
  s.s_def = top.s_last;
}
-- { exprLetExample }

aspect production seqBindsCons
top::SeqBinds ::= s::Bind ss::SeqBinds
{
  newScope s_next::LMGraph -> datumLex();
  s_next -[ lex ]-> top.s;

  s.s = top.s;
  s.s_def = s_next;

  ss.s = s_next;
  ss.s_last = top.s_last;
}

aspect production seqBindsNil
top::SeqBinds ::=
{
  newScope top.s_last::LMGraph -> datumLex();

  top.s_last -[ lex ]-> top.s;
}

--------------------------------------------------

aspect production parBindsNil
top::ParBinds ::=
{
}

aspect production parBindsOne
top::ParBinds ::= s::Bind
{
  s.s = top.s;
  s.s_def = top.s_def;
}

aspect production parBindsCons
top::ParBinds ::= s::Bind ss::ParBinds
{
  s.s = top.s;
  s.s_def = top.s_def;

  ss.s = top.s;
  ss.s_def = top.s_def;
}

--------------------------------------------------

attribute type occurs on Bind;

aspect production bindUntyped
top::Bind ::= x::String e::Expr
{
  newScope s_dcl::LMGraph -> datumVar(x, top);

  top.s_def -[ var ]-> s_dcl;

  e.s = top.s;

  top.type = e.type;
}

aspect production bindTyped
top::Bind ::= tyann::Type x::String e::Expr
{
  newScope s_dcl::LMGraph -> datumVar(x, top);

  top.s_def -[ var ]-> s_dcl;

  nondecorated local ty1::Type = ^tyann;

  nondecorated local ty2::Type = e.type;
  e.s = top.s;

  top.type = ^tyann;

  top.msgs <-
    if ty1 == ty2 || e.type == tErr()
    then []
    else [errorMessage(
            "variable " ++ x ++ " declared with type " ++ ty1.pp ++ ", but its " ++
            "definition has type " ++ ty2.pp,
            top.location
          )];
}

aspect production bindArgDcl
top::Bind ::= x::String tyann::Type
{
  newScope s_dcl::LMGraph -> datumVar(x, top);

  top.s -[ var ]-> s_dcl;

  top.type = ^tyann;
}

--------------------------------------------------

attribute pp occurs on Type;

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  top.pp = case tyann1 of
           | tFun(_, _) -> "(" ++ tyann1.pp ++ ") -> " ++ tyann2.pp
           | _ -> tyann1.pp ++ " -> " ++ tyann2.pp
           end;
}

aspect production tFloat
top::Type ::=
{
  top.pp = "float";
}

aspect production tInt
top::Type ::=
{
  top.pp = "int";
}

aspect production tBool
top::Type ::=
{
  top.pp = "bool";
}

aspect production tErr
top::Type ::=
{
  top.pp = "<err>";
}

--------------------------------------------------

aspect production modRef
top::ModRef ::= x::String
{
  -- does ministatix query, filter and min-refs constraints
  local mods::[Decorated Scope with LMGraph] =
    query(
      `lex*`imp?`mod,
      \d::Datum -> case d of datumMod(dx, _) -> x == dx | _ -> false end,
      top.s
    );
  
  local s_res::Decorated Scope with LMGraph =
    if length(mods) == 1 then head(mods) else deadScope;

  top.s_def -[ imp ]-> s_res;

  top.msgs <- 
    case mods of
    | h::[] -> []
    | _::_ -> [errorMessage("ambiguous module reference " ++ x, top.location)]
    | [] -> [errorMessage("unresolvable module reference " ++ x, top.location)]
    end;
}

--------------------------------------------------

-- { varRefExample }
aspect production varRef
top::VarRef ::= x::String
{
  local vars::[Decorated Scope with LMGraph] =
    query(`lex*`imp?`var, isDatumVar(x), top.s);

  production attribute 
    bindNode::Maybe<Decorated Bind with {s, isRec}> =
    if length(vars) == 1 
    then just(extractBind(head(vars)))
    else nothing();

  top.type = mapOrElse(tErr(), (.type), bindNode);
  top.msgs <- 
    case vars of
    | [h]  -> []
    | []   -> [errorMessage(x ++ " unresolvable",
                            top.location)]
    | _::_ -> [errorMessage(x ++ " ambiguous",
                            top.location)]
    end;
}
-- { varRefExample }

fun isDatumVar (Boolean ::= Datum) ::= x::String =
  \d::Datum ->
    case d of
    | datumVar(dx, _) -> x == dx
    | _ -> false
    end
;

fun extractBind Decorated Bind with {s, isRec} ::= s::Decorated Scope with LMGraph =
  case s.datum of
  | datumVar(_, n) -> n
  | _ -> error("Used extractBind on a scope not using datumVar!")
  end
;