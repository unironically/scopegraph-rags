grammar lmr1:lmr:nameanalysis_extension;

--------------------------------------------------

-- { scopeAttributeExample }
scope labels lex, var, mod, imp as LMLabels;

scope attribute s occurs on Decls, Decl, Bind, 
  Module, ParBinds, SeqBinds, Expr, VarRef, ModRef;
-- { scopeAttributeExample }

scope attribute s_def;
attribute s_def occurs on ParBinds, Bind, Decl, ModRef;

scope attribute s_last;
attribute s_last occurs on SeqBinds;

scope attribute s_module;
attribute s_module occurs on Decls, Decl, Module;

--------------------------------------------------

synthesized attribute msgs::[Message] occurs on Main, Decls, Decl, 
  Module, Bind, Expr, VarRef, SeqBinds, ParBinds, ModRef;

synthesized attribute type::Type occurs on Expr, VarRef;

synthesized attribute ocaml::String occurs on
  Main, Decls, Decl, Module, Expr, SeqBinds, ParBinds, Bind, Type, ModRef, VarRef;

--------------------------------------------------

nonterminal Main with location;

production program
top::Main ::= ds::Decls
{
  newScope glob -> datumLex();

  ds.s = glob;
  ds.s_module = glob;

  top.msgs = ds.msgs;

  top.ocaml = ds.ocaml;
}

--------------------------------------------------

nonterminal Decls with location;

production declsCons
top::Decls ::= d::Decl ds::Decls
{
  newScope seqScope -> datumLex();

  seqScope -[ lex ]-> top.s;

  d.s = top.s;
  d.s_def = seqScope;
  d.s_module = top.s_module;

  ds.s = seqScope;
  ds.s_module = top.s_module;

  top.msgs = d.msgs ++ ds.msgs;

  top.ocaml = 
    d.ocaml ++ "\n" ++
    ds.ocaml;
}

production declsNil
top::Decls ::=
{
  top.msgs = [];

  top.ocaml = "";
}

--------------------------------------------------

nonterminal Decl with location;

production declModule
top::Decl ::= m::Module
{
  m.s = top.s;
  m.s_module = top.s_module;

  top.msgs = m.msgs;

  top.ocaml = m.ocaml;
}

production declImport
top::Decl ::= mr::ModRef
{
  mr.s = top.s;
  mr.s_def = top.s_def;

  top.msgs = mr.msgs;

  top.ocaml = mr.ocaml;
}

production declDef
top::Decl ::= b::Bind
{
  b.s = top.s;
  b.s_def = top.s_module;

  top.msgs = b.msgs;

  b.isRecLet = false;

  top.ocaml = "let " ++ b.ocaml;
}

--------------------------------------------------

nonterminal Module with location;

-- { moduleDeclExample }
production module
top::Module ::= x::String ds::Decls
{
  newScope modScope -> datumMod(x, top);

  modScope -[ lex ]-> top.s;
  top.s_module -[ mod ]-> modScope;

  ds.s = modScope;
  ds.s_module = modScope;

  top.msgs = ds.msgs;
  top.ocaml = "module Mod_" ++ x ++ " = struct " ++
              ds.ocaml ++ "end";
}
-- { moduleDeclExample }

--------------------------------------------------


nonterminal Expr with location;

production exprFloat
top::Expr ::= f::Float
{
  top.type = tFloat();

  top.msgs = [];

  top.ocaml = toString(f);
}

production exprInt
top::Expr ::= i::Integer
{
  top.type = tInt();

  top.msgs = [];

  top.ocaml = toString(i);
}

production exprTrue
top::Expr ::=
{
  top.type = tBool();

  top.msgs = [];

  top.ocaml = "true";
}

production exprFalse
top::Expr ::=
{
  top.type = tBool();

  top.msgs = [];

  top.ocaml = "false";
}

production exprVar
top::Expr ::= r::VarRef
{
  r.s = top.s;

  top.type = r.type;

  top.msgs = r.msgs;

  top.ocaml = r.ocaml;
}

-- { addExample }
production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  local msgLeft::[Message] =
    if ty1 == tInt() || ty1 == tFloat() || ty1 == tErr()
    then []
    else [err(
      "addition left operand must be int or float, " ++
      "but an expression was given of type " ++ ty1.pp,
      top.location
    )];

  local msgRight::[Message] =
    if ty2 == tInt() || ty2 == tFloat() || ty2 == tErr()
    then []
    else [err(
      "addition right operand must be int or float, " ++
      "expression was given of type " ++ ty2.pp,
      top.location
    )];


  top.msgs = msgLeft ++ msgRight ++ e1.msgs ++ e2.msgs;
  top.type = 
    if null(top.msgs)
    then (if e1.type == tFloat() || e2.type == tFloat() then tFloat() else tInt())
    else tErr();

  top.ocaml =
    "(" ++
      case e1.type, e2.type of
      | tFloat(), tFloat() ->
          e1.ocaml ++ " +. " ++ e2.ocaml
      | tFloat(), tInt() ->
          e1.ocaml ++ " +. (float_of_int " ++ e2.ocaml ++ ")"
      | tInt(), tFloat() ->
          "(float_of_int " ++ e1.ocaml ++ ") +. " ++ e2.ocaml
      | _, _ ->
          e1.ocaml ++ " + " ++ e2.ocaml
      end ++
    ")";
}
-- { addExample }

production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  local ok::([Message], Type) = andOk(ty1, ty2, top.location);

  top.msgs = ok.1 ++ e1.msgs ++ e2.msgs;
  top.type = ok.2;

  top.ocaml = "(" ++ e1.ocaml ++ " && " ++ e2.ocaml ++ ")";
}

production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  local msgLeft::[Message] =
    if ty1 == tInt() || ty1 == tFloat() || ty1 == tBool()
    then []
    else [err(
      "equality expects left operand to be of type int or float or bool, " ++
      "but an expression was given of type " ++ ty1.pp,
      top.location
    )];
  
  local msgRight::[Message] =
    if !null(msgLeft) || ty1 == ty2
    then []
    else [err(
      "equality expects right operand to be of type " ++ ty1.pp ++ ", but an " ++
      "expression was given of type " ++ ty2.pp,
      top.location
    )];

  top.msgs = if !null(msgLeft) then msgLeft else msgRight
             ++ e1.msgs ++ e2.msgs;
  top.type = tBool();

  top.ocaml = "(" ++ e1.ocaml ++ " = " ++ e2.ocaml ++ ")";
}

production exprFun
top::Expr ::= b::Bind e::Expr
{
  newScope s_fun -> datumLex();

  s_fun -[ lex ]-> top.s;

  b.s = top.s;
  b.s_def = s_fun;

  nondecorated local ty1::Type = b.type;

  e.s = s_fun;
  nondecorated local ty2::Type = e.type;

  top.type = tFun(ty1, ty2);

  top.msgs = b.msgs ++ e.msgs;

  b.isRecLet = false;
  
  top.ocaml = "(" ++ b.ocaml ++ " -> " ++ e.ocaml ++ ")"; 
}

production exprApp
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
    else [err("application expects left operand to be of function type, " ++
                       "but an expression was given of type " ++ ty1.pp,
                       top.location)];

  local msgRight::[Message] =
    if !null(msgLeft) || ty2 == ty3
    then []
    else [err(
      "application expects right operand to be of type " ++ ty3.pp ++ ", but an " ++
      "expression was given of type " ++ ty2.pp,
      top.location
    )];

  top.msgs = if !null(msgLeft) then msgLeft else msgRight
             ++ e1.msgs ++ e2.msgs;
  top.type = ty4;

  top.ocaml = "(" ++ e1.ocaml ++ " " ++ e2.ocaml ++ ")";
}

production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  e3.s = top.s;
  nondecorated local ty3::Type = e3.type;

  local msgs1::[Message] =
    if ty1 == tBool()
    then []
    else [err(
      "conditional expects first operand to be of type bool, but an expression " ++
      "was given of type " ++ ty1.pp,
      top.location
    )];
  
  local msgs2::[Message] =
    if ty2 == ty3
    then []
    else [err(
      "conditional expects else branch to be of type " ++ ty2.pp ++ ", but an expression " ++
      "was given of type " ++ ty3.pp,
      top.location
    )];

  top.type = if ty1 == tBool() && ty2 == ty3 then ty2 else tErr();

  top.msgs = msgs1 ++ msgs2 ++ e1.msgs ++ e2.msgs ++ e3.msgs;

  top.ocaml = "if " ++ e1.ocaml ++ 
                    " then " ++ e2.ocaml ++
                    " else " ++ e3.ocaml;
}

production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  newScope s_let -> datumLex();

  s_let -[ lex ]-> top.s;

  bs.s = s_let;
  bs.s_def = s_let;

  e.s = s_let;

  top.type = e.type;

  top.msgs = bs.msgs ++ e.msgs;

  top.ocaml = bs.ocaml ++ e.ocaml;

  bs.isFirst = true;
}

production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  newScope s_let -> datumLex();

  s_let -[ lex ]-> top.s;

  bs.s = top.s;
  bs.s_def = s_let;

  e.s = s_let;

  top.type = e.type;

  top.msgs = bs.msgs ++ e.msgs;

  top.ocaml = error("exprLetPar.ocaml TODO");

  bs.isFirst = true;
}

--------------------------------------------------

inherited attribute isRecLet::Boolean;

-- { exprLetExample }
production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  existsScope s_let;

  bs.s = top.s;
  bs.s_last = s_let;

  e.s = s_let;

  top.type = e.type;
  top.msgs = bs.msgs ++ e.msgs;
  top.ocaml = bs.ocaml ++ e.ocaml;
}

production seqBindsLast
top::SeqBinds ::= s::Bind
{
  newScope top.s_last -> datumLex();

  top.s_last -[ lex ]-> top.s;

  s.s = top.s;
  s.s_def = top.s_last;
  s.isRecLet = false;

  top.msgs = s.msgs;
  top.ocaml = "let " ++ s.ocaml ++ " in ";
}

attribute isRecLet occurs on Bind;
attribute type occurs on Bind;

production bindUntyped
top::Bind ::= x::String e::Expr
{
  newScope s_dcl -> datumVar(x, top);

  top.s_def -[ var ]-> s_dcl;

  e.s = top.s;

  top.type = e.type;
  top.msgs = e.msgs;
  top.ocaml = x ++ " = " ++
    if top.isRecLet then "lazy (" ++ e.ocaml ++ ")"
                 else e.ocaml;
}
-- { exprLetExample }

nonterminal SeqBinds with location;

production seqBindsCons
top::SeqBinds ::= s::Bind ss::SeqBinds
{
  newScope s_next -> datumLex();
  s_next -[ lex ]-> top.s;

  s.s = top.s;
  s.s_def = s_next;

  ss.s = s_next;
  ss.s_last = top.s_last;

  top.msgs = s.msgs ++ ss.msgs;

  s.isRecLet = false;

  top.ocaml = "let " ++ s.ocaml ++ " in " ++ ss.ocaml;
}

production seqBindsNil
top::SeqBinds ::=
{
  newScope top.s_last -> datumLex();

  top.s_last -[ lex ]-> top.s;

  top.msgs = [];

  top.ocaml = "";
}

--------------------------------------------------


nonterminal ParBinds with location;

inherited attribute isFirst::Boolean occurs on ParBinds;

production parBindsNil
top::ParBinds ::=
{
  top.msgs = [];

  top.ocaml = "";
}

production parBindsOne
top::ParBinds ::= s::Bind
{
  s.s = top.s;
  s.s_def = top.s_def;

  top.msgs = s.msgs;

  s.isRecLet = true;

  top.ocaml =
    (if top.isFirst then "let " else " and ") ++
    s.ocaml ++ " in ";
}

production parBindsCons
top::ParBinds ::= s::Bind ss::ParBinds
{
  s.s = top.s;
  s.s_def = top.s_def;

  ss.s = top.s;
  ss.s_def = top.s_def;

  top.msgs = s.msgs ++ ss.msgs;

  s.isRecLet = true;

  top.ocaml = 
    (if top.isFirst then "let rec " else " and ") ++
    s.ocaml ++ ss.ocaml;

  ss.isFirst = false;
}

--------------------------------------------------

nonterminal Bind with location;

production bindTyped
top::Bind ::= tyann::Type x::String e::Expr
{
  newScope s_dcl -> datumVar(x, top);

  top.s_def -[ var ]-> s_dcl;

  nondecorated local ty1::Type = ^tyann;

  nondecorated local ty2::Type = e.type;
  e.s = top.s;

  top.type = ^tyann;

  top.msgs =
    if ty1 == ty2 || e.type == tErr()
    then e.msgs
    else err(
            "variable " ++ x ++ " declared with type " ++ ty1.pp ++ ", but its " ++
            "definition has type " ++ ty2.pp,
            top.location
         )::e.msgs;

  top.ocaml = 
    x ++ ": " ++ tyann.ocaml ++ " = " ++ 
    if top.isRecLet
    then "lazy (" ++ e.ocaml ++ ")"
    else e.ocaml;
}

production bindArgDcl
top::Bind ::= x::String tyann::Type
{
  newScope s_dcl -> datumVar(x, top);

  top.s -[ var ]-> s_dcl;

  top.type = ^tyann;

  top.msgs = [];

  top.ocaml = "fun " ++ x ++ ":" ++ tyann.ocaml;
}

--------------------------------------------------

nonterminal Type;

attribute pp occurs on Type;

production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  top.pp =
    case tyann1 of
    | tFun(_, _) -> "(" ++ tyann1.pp ++ ") -> " ++ tyann2.pp
    | _ -> tyann1.pp ++ " -> " ++ tyann2.pp
    end;
  
  top.ocaml =
    case tyann1 of
    | tFun(_, _) -> "(" ++ tyann1.ocaml ++ ") -> " ++ tyann2.ocaml
    | _ -> tyann1.ocaml ++ " -> " ++ tyann2.ocaml
    end;
}

production tFloat
top::Type ::=
{
  top.pp = "float";
  top.ocaml = top.pp;
}

production tInt
top::Type ::=
{
  top.pp = "int";
  top.ocaml = top.pp;
}

production tBool
top::Type ::=
{
  top.pp = "bool";
  top.ocaml = top.pp;
}

production tErr
top::Type ::=
{
  top.pp = "<err>";
  top.ocaml = error("tErr.ocaml demanded");
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
  -- does ministatix query, filter and min-refs constraints
  local mods::[Decorated Scope with LMLabels] =
    query(
      `lex*`imp?`mod,
      \d::Datum -> case d of datumMod(dx, _) -> x == dx | _ -> false end,
      top.s
    );
  
  local s_res::Decorated Scope with LMLabels =
    if length(mods) == 1 then head(mods) else deadScope;

  top.s_def -[ imp ]-> s_res;

  top.msgs = 
    case mods of
    | h::[] -> []
    | _::_ -> [err("ambiguous module reference " ++ x, top.location)]
    | [] -> [err("unresolvable module reference " ++ x, top.location)]
    end;

  top.ocaml = "open Mod_" ++ x;
}

--------------------------------------------------

nonterminal VarRef with location;

-- { varRefExample }
production varRef
top::VarRef ::= x::String
{
  local vars::[Decorated Scope with LMLabels] =
    query(`lex*`imp?`var, isDatumVar(x), top.s);

  local bindNode::Decorated Bind with {s, isRecLet} =
    if length(vars) == 1 
    then getDecoratedBind(head(vars))
    else defaultErrorBind;

  top.type = bindNode.type;
  top.ocaml = if bindNode.isRecLet
              then "(Lazy.force " ++ x ++ ")"
              else x;
  top.msgs = case vars of
             | [h]  -> []
             | []   -> [err(x ++ " unresolvable",
                            top.location)]
             | _::_ -> [err(x ++ " ambiguous",
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

fun getDecoratedBind Decorated Bind with {s, isRecLet} ::= s::Decorated Scope with LMLabels =
  case s.datum of
  | datumVar(_, n) -> n
  | _ -> error("Used extractBind on a scope not using datumVar!")
  end
;

global defaultErrorBind::Decorated Bind with {s, isRecLet} =
  decorate bindArgDcl("", tErr(), location=bogusLoc()) with {s=deadScope; isRecLet=false;};