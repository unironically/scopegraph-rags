grammar lmr1:lmr:nameanalysis_verbose;

--------------------------------------------------

-- { scopeAttributeExample }
type LMLabels = {lex, var, mod, imp};
type _Dec_scope = Decorated Scope with LMLabels;

inherited attribute s::_Dec_scope
occurs on Decls, Decl, Bind, Module, ParBinds,
          SeqBinds, Expr, VarRef, ModRef;

monoid attribute s_lex::[_Dec_scope] with [], ++
occurs on Decls, Decl, Bind, Module, ParBinds,
          SeqBinds, Expr, VarRef, ModRef;
monoid attribute s_var::[_Dec_scope] with [], ++
occurs on Decls, Decl, Bind, Module, ParBinds,
          SeqBinds, Expr, VarRef, ModRef;
monoid attribute s_mod::[_Dec_scope] with [], ++
occurs on Decls, Decl, Bind, Module, ParBinds,
          SeqBinds, Expr, VarRef, ModRef;
monoid attribute s_imp::[_Dec_scope] with [], ++
occurs on Decls, Decl, Bind, Module, ParBinds,
          SeqBinds, Expr, VarRef, ModRef;
monoid attribute s_undec::[_Dec_scope] with [], ++
occurs on Decls, Decl, Bind, Module, ParBinds,
          SeqBinds, Expr, VarRef, ModRef;
-- { scopeAttributeExample }


inherited attribute s_def::_Dec_scope occurs on
  ParBinds, Bind, Module, Decl, ModRef;

monoid attribute s_def_lex::[_Dec_scope] with [], ++ occurs on
  ParBinds, Bind, Module, Decl, ModRef;
monoid attribute s_def_var::[_Dec_scope] with [], ++ occurs on
  ParBinds, Bind, Module, Decl, ModRef;
monoid attribute s_def_mod::[_Dec_scope] with [], ++ occurs on
  ParBinds, Bind, Module, Decl, ModRef;
monoid attribute s_def_imp::[_Dec_scope] with [], ++ occurs on
  ParBinds, Bind, Module, Decl, ModRef;
monoid attribute s_def_undec::[_Dec_scope] with [], ++ occurs on
  ParBinds, Bind, Module, Decl, ModRef;


inherited attribute s_last::_Dec_scope occurs on SeqBinds;

monoid attribute s_last_lex::[_Dec_scope] with [], ++ occurs on
  SeqBinds;
monoid attribute s_last_var::[_Dec_scope] with [], ++ occurs on
  SeqBinds;
monoid attribute s_last_mod::[_Dec_scope] with [], ++ occurs on
  SeqBinds;
monoid attribute s_last_imp::[_Dec_scope] with [], ++ occurs on
  SeqBinds;
monoid attribute s_last_undec::[_Dec_scope] with [], ++ occurs on
  SeqBinds;


inherited attribute s_module::_Dec_scope occurs on
  Decls, Decl, Module;

monoid attribute s_module_lex::[_Dec_scope] with [], ++ occurs on
  Decls, Decl, Module;
monoid attribute s_module_var::[_Dec_scope] with [], ++ occurs on
  Decls, Decl, Module;
monoid attribute s_module_mod::[_Dec_scope] with [], ++ occurs on
  Decls, Decl, Module;
monoid attribute s_module_imp::[_Dec_scope] with [], ++ occurs on
  Decls, Decl, Module;
monoid attribute s_module_undec::[_Dec_scope] with [], ++ occurs on
  Decls, Decl, Module;


inherited attribute s_dcl occurs on Bind;

monoid attribute s_dcl_lex::[_Dec_scope] with [], ++ occurs on
  Bind;
monoid attribute s_dcl_var::[_Dec_scope] with [], ++ occurs on
  Bind;
monoid attribute s_dcl_mod::[_Dec_scope] with [], ++ occurs on
  Bind;
monoid attribute s_dcl_imp::[_Dec_scope] with [], ++ occurs on
  Bind;
monoid attribute s_dcl_undec::[_Dec_scope] with [], ++ occurs on
  Bind;


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
  local glob::Scope = scope(datumDefault());
  glob.lex := [];
  glob.var := [];
  glob.mod := [];
  glob.imp := [];

  local deadScope::Scope = scope(datumDefault());
  deadScope.lex := [];
  deadScope.var := [];
  deadScope.mod := [];
  deadScope.imp := [];

  ds.s = glob;
  glob.lex <- ds.s_lex;
  glob.var <- ds.s_var;
  glob.mod <- ds.s_mod;
  glob.imp <- ds.s_imp;

  ds.s_module = deadScope;
  deadScope.lex <- ds.s_module_lex;
  deadScope.var <- ds.s_module_var;
  deadScope.mod <- ds.s_module_mod;
  deadScope.imp <- ds.s_module_imp;

  top.msgs = ds.msgs;

  top.ocaml = ds.ocaml;
}

--------------------------------------------------

nonterminal Decls with location;

production declsCons
top::Decls ::= d::Decl ds::Decls
{
  local seqScope::Scope = scope(datumDefault());
  seqScope.lex := [];
  seqScope.var := [];
  seqScope.mod := [];
  seqScope.imp := [];

  seqScope.lex <- [top.s];

  d.s = top.s;
  top.s_lex <- d.s_lex;
  top.s_var <- d.s_var;
  top.s_mod <- d.s_mod;
  top.s_imp <- d.s_imp;
  top.s_undec <- d.s_undec;

  d.s_def = seqScope;
  seqScope.lex <- d.s_def_lex;
  seqScope.var <- d.s_def_var;
  seqScope.mod <- d.s_def_mod;
  seqScope.imp <- d.s_def_imp;

  d.s_module = top.s_module;
  top.s_module_lex <- d.s_lex;
  top.s_module_var <- d.s_var;
  top.s_module_mod <- d.s_mod;
  top.s_module_imp <- d.s_imp;
  top.s_module_undec <- d.s_undec;

  ds.s = seqScope;
  seqScope.lex <- ds.s_lex;
  seqScope.var <- ds.s_var;
  seqScope.mod <- ds.s_mod;
  seqScope.imp <- ds.s_imp;

  ds.s_module = top.s_module;
  top.s_module_lex <- ds.s_lex;
  top.s_module_var <- ds.s_var;
  top.s_module_mod <- ds.s_mod;
  top.s_module_imp <- ds.s_imp;
  top.s_module_undec <- ds.s_undec;

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

aspect production top::Decls ::=
{
  top.s_lex := [];
  top.s_var := [];
  top.s_mod := [];
  top.s_imp := [];

  top.s_module_lex := [];
  top.s_module_var := [];
  top.s_module_mod := [];
  top.s_module_imp := [];
}

--------------------------------------------------

{-
nonterminal Decl with location;

production declModule
top::Decl ::= m::Module
{
  m.s = top.s;
  m.s_def = top.s_def;
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
  existsScope s_dcl;

  b.s = top.s;
  b.s_def = top.s_module;
  b.s_dcl = s_dcl;

  top.s_module -[ var ]-> s_dcl;

  top.msgs = b.msgs;

  b.isRecLet = false;

  top.ocaml = "let " ++ b.ocaml;
}
-}

--------------------------------------------------

nonterminal Module with location;

-- { moduleDeclExample }
production module
top::Module ::= x::String ds::Decls
{
  local modScope::Scope = scope(datumMod(x, top));
  local modScope_undec::[Scope] with ++;
  modScope.lex := []; modScope.var := [];
  modScope.mod := []; modScope.imp := [];
  
  modScope.lex <- [top.s];

  top.s_def_mod <- [modScope];

  top.s_module_mod <- [modScope];

  ds.s = modScope;
  modScope.lex <- ds.s_lex;
  modScope.var <- ds.s_var;
  modScope.mod <- ds.s_mod;
  modScope.imp <- ds.s_imp;
  modScope_undec <- ds.s_undec;

  ds.s_module = modScope;
  modScope.lex <- ds.s_module_lex;
  modScope.var <- ds.s_module_var;
  modScope.mod <- ds.s_module_mod;
  modScope.imp <- ds.s_module_imp;
  modScope_undec <- ds.s_module_undec;

  top.msgs = ds.msgs;
  top.ocaml = "module Mod_" ++ x ++ " = struct " ++
              ds.ocaml ++ "end";
}
-- { moduleDeclExample }

--------------------------------------------------

{-
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
  existsScope s_dcl;

  newScope s_fun;

  s_fun -[ lex ]-> top.s;

  b.s = top.s;
  b.s_def = s_fun;
  b.s_dcl = s_dcl;

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
  newScope s_let;

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
  newScope s_let;

  s_let -[ lex ]-> top.s;

  bs.s = top.s;
  bs.s_def = s_let;

  e.s = s_let;

  top.type = e.type;

  top.msgs = bs.msgs ++ e.msgs;

  top.ocaml = error("exprLetPar.ocaml TODO");

  bs.isFirst = true;
}
-}
--------------------------------------------------

inherited attribute isRecLet::Boolean;

-- { exprLetExample }
production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local s_let::_Dec_scope = 
    let undecs::[Scope] = s_let_undec in
      case undecs of
      | h::[] -> h.datum
      |  _ -> error("Oh no! scopeExists.mkScopeExpr")
      end
    end;
  local s_let_undec::[Scope] with ++;
  s_let_undec := [];

  bs.s = top.s;
  top.s_lex <- bs.s_lex;
  top.s_var <- bs.s_var;
  top.s_mod <- bs.s_mod;
  top.s_imp <- bs.s_imp;
  top.s_undec <- bs.s_undec;

  bs.s_last = s_let;
  s_let.lex <- bs.s_last_lex;
  s_let.var <- bs.s_last_var;
  s_let.mod <- bs.s_last_mod;
  s_let.imp <- bs.s_last_imp;
  s_let_undec <- bs.s_last_undec;

  e.s = s_let;
  s_let.lex <- e.s_last_lex;
  s_let.var <- e.s_last_var;
  s_let.mod <- e.s_last_mod;
  s_let.imp <- e.s_last_imp;
  s_let_undec <- e.s_last_undec;

  top.type = e.type;
  top.msgs = bs.msgs ++ e.msgs;
  top.ocaml = bs.ocaml ++ e.ocaml;
}

production seqBindsLast
top::SeqBinds ::= s::Bind
{
  local s_dcl::_Dec_scope = 
    let undecs::[Scope] = s_dcl_undec in
      case undecs of
      | h::[] -> h.datum
      |  _ -> error("Oh no! scopeExists.mkScopeExpr")
      end
    end;
  local s_dcl_undec::[Scope] with ++;
  s_dcl_undec := [];

  top.s_last_undec <- [scope(datumDefault())];

  top.s_last_lex <- [top.s];

  s.s = top.s;
  top.s_lex <- s.s_lex;
  top.s_var <- s.s_var;
  top.s_mod <- s.s_mod;
  top.s_imp <- s.s_imp;
  top.s_undec <- s.s_undec;

  s.s_def = top.s_last;
  top.s_last_lex <- s.s_def_lex;
  top.s_last_var <- s.s_def_var;
  top.s_last_mod <- s.s_def_mod;
  top.s_last_imp <- s.s_def_imp;
  top.s_last_undec <- s.s_def_undec;

  s.s_dcl = s_dcl;
  s_dcl.lex <- s.s_dcl_lex;
  s_dcl.var <- s.s_dcl_var;
  s_dcl.mod <- s.s_dcl_mod;
  s_dcl.imp <- s.s_dcl_imp;
  s_dcl_undec <- s.s_dcl_undec;

  s.isRecLet = false;

  top.msgs = s.msgs;
  top.ocaml = "let " ++ s.ocaml ++ " in ";
}

attribute isRecLet occurs on Bind;
attribute type occurs on Bind;

production bindUntyped
top::Bind ::= x::String e::Expr
{
  top.s_dcl_undec <- [scope(datumVar(x, top))];

  top.s_def_var <- [top.s_dcl];

  e.s = top.s;
  top.s_lex <- e.s_lex;
  top.s_var <- e.s_var;
  top.s_mod <- e.s_mod;
  top.s_imp <- e.s_imp;
  top.s_undec <- e.s_undec;

  top.type = e.type;
  top.msgs = e.msgs;
  top.ocaml = x ++ " = " ++
    if top.isRecLet then "lazy (" ++ e.ocaml ++ ")"
                    else e.ocaml;
}
-- { exprLetExample }

{-
nonterminal SeqBinds with location;

production seqBindsCons
top::SeqBinds ::= s::Bind ss::SeqBinds
{
  existsScope s_dcl;

  newScope s_next;
  s_next -[ lex ]-> top.s;

  s.s = top.s;
  s.s_def = s_next;
  s.s_dcl = s_dcl;

  ss.s = s_next;
  ss.s_last = top.s_last;

  top.msgs = s.msgs ++ ss.msgs;

  s.isRecLet = false;

  top.ocaml = "let " ++ s.ocaml ++ " in " ++ ss.ocaml;
}

production seqBindsNil
top::SeqBinds ::=
{
  newScope top.s_last;

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
  existsScope s_dcl;

  s.s = top.s;
  s.s_def = top.s_def;
  s.s_dcl = s_dcl;

  top.msgs = s.msgs;

  s.isRecLet = true;

  top.ocaml =
    (if top.isFirst then "let " else " and ") ++
    s.ocaml ++ " in ";
}

production parBindsCons
top::ParBinds ::= s::Bind ss::ParBinds
{
  existsScope s_dcl;

  s.s = top.s;
  s.s_def = top.s_def;
  s.s_dcl = s_dcl;

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
  newScope top.s_dcl -> datumVar(x, top);

  top.s_def -[ var ]-> top.s_dcl;

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
  newScope top.s_dcl -> datumVar(x, top);

  top.s_def -[ var ]-> top.s_dcl;

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
  local mods::[_Dec_scope] =
    query(
      `lex*`imp?`mod,
      \d::Datum -> case d of datumMod(dx, _) -> x == dx | _ -> false end,
      top.s
    );
  
  local s_res::_Dec_scope =
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
-}
--------------------------------------------------

nonterminal VarRef with location;

-- { varRefExample }
production varRef
top::VarRef ::= x::String
{
  local vars::[_Dec_scope] =
    reachableQuery(
      regexCat(
        regexStar(regexLabel(label_lex()))
        regexCat(
          regexMaybe(regexLabel(label_imp())),
          regexLabel(label_var()))),
      isDatumVar(x),
      top.s
    );

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

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}
-- { varRefExample }
{-
fun isDatumVar (Boolean ::= Datum) ::= x::String =
  \d::Datum ->
    case d of
    | datumVar(dx, _) -> x == dx
    | _ -> false
    end
;

fun getDecoratedBind Decorated Bind with {s, isRecLet} ::= s::_Dec_scope =
  case s.datum of
  | datumVar(_, n) -> n
  | _ -> error("Used extractBind on a scope not using datumVar!")
  end
;

global defaultErrorBind::Decorated Bind with {s, isRecLet} =
  decorate bindArgDcl("", tErr(), location=bogusLoc()) with {s=deadScope; isRecLet=false;};
-}