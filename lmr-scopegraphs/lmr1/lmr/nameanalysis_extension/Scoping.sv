grammar lmr1:lmr:nameanalysis_extension;

--------------------------------------------------

attribute s occurs on Decls, Decl, Module, ParBinds, ModRef;

attribute s_def occurs on ParBinds, Module, Decl, ModRef;

scope attribute s_module;
attribute s_module occurs on Decls, Decl, Module;

--------------------------------------------------

attribute errs occurs on Main, Decls, Decl, 
  Module, ParBinds, ModRef;

attribute ocaml occurs on
  Main, Decls, Decl, Module, ParBinds, Type, ModRef;

--------------------------------------------------

-- { nonterminalsAttrs }
nonterminal Expr; nonterminal Type;  ^\label{line:nts-start}^
nonterminal Bind; nonterminal Binds; ^\label{line:nts-end}^

synthesized @attribute@ errs::[String];                   ^\label{line:attr-errs}^
synthesized @attribute@ ocaml::String;                    ^\label{line:attr-ocaml}^
inherited @attribute@ inSeqLet::Boolean                   ^\label{line:attr-inSeqLet}^
@attribute@ errs, ocaml @occurs on@ Expr, Binds, Bind;      ^\label{line:occ-errs-ocaml}^
@attribute@ inSeqLet @occurs on@ Bind;                      ^\label{line:occ-inSeqLet}^

synthesized @attribute@ type::Type @occurs on@ Expr, Bind; ^\label{line:attr-type}^

scope labels lex, var, mod, imp as LMLabels;            ^\label{line:scope-labels}^
scope &attribute& s &occurs on& Expr, Binds, Bind;          ^\label{line:scope-attribute-s}^
scope &attribute& s_last &occurs on& Binds;                 ^\label{line:scope-attribute-last}^
scope &attribute& s_dcl &occurs on& Bind;                   ^\label{line:scope-attribute-dcl}^
-- { nonterminalsAttrs }

--------------------------------------------------

nonterminal Main with location;

production program
top::Main ::= ds::Decls
{
  scope glob;
  scope deadScope;

  ds.s = glob;
  ds.s_module = deadScope;

  top.errs = ds.errs;

  top.ocaml = ds.ocaml;
}

--------------------------------------------------

nonterminal Decls with location;

production declsCons
top::Decls ::= d::Decl ds::Decls
{
  scope seqScope;

  seqScope -[ lex ]-> top.s;

  d.s = top.s;
  d.s_def = seqScope;
  d.s_module = top.s_module;

  ds.s = seqScope;
  ds.s_module = top.s_module;

  top.errs = d.errs ++ ds.errs;

  top.ocaml = 
    d.ocaml ++ "\n" ++
    ds.ocaml;
}

production declsNil
top::Decls ::=
{
  top.errs = [];

  top.ocaml = "";
}

--------------------------------------------------

nonterminal Decl with location;

production declModule
top::Decl ::= m::Module
{
  m.s = top.s;
  m.s_def = top.s_def;
  m.s_module = top.s_module;

  top.errs = m.errs;

  top.ocaml = m.ocaml;
}

production declImport
top::Decl ::= mr::ModRef
{
  mr.s = top.s;
  mr.s_def = top.s_def;

  top.errs = mr.errs;

  top.ocaml = mr.ocaml;
}

production declDef
top::Decl ::= b::Bind
{
  exists scope s_dcl;

  b.s = top.s;
  b.s_def = top.s_module;
  b.s_dcl = s_dcl;

  top.s_module -[ var ]-> s_dcl;

  top.errs = b.errs;

  b.inSeqLet = true;

  top.ocaml = "let " ++ b.ocaml;
}

--------------------------------------------------

nonterminal Module with location;

-- { moduleDeclExample }
production module
top::Module ::= x::String ds::Decls
{
  scope modScope -> datumMod(x, top);

  modScope -[ lex ]-> top.s;
  top.s_def    -[ mod ]-> modScope;
  top.s_module -[ mod ]-> modScope;

  ds.s = modScope;
  ds.s_module = modScope;

  top.errs = ds.errs;
  top.ocaml = "module Mod_" ++ x ++ " = struct " ++
              ds.ocaml ++ "end";
}
-- { moduleDeclExample }

--------------------------------------------------

annotation location occurs on Expr;

production exprFloat
top::Expr ::= f::Float
{
  top.type = tFloat();

  top.errs = [];

  top.ocaml = toString(f);
}

production exprInt
top::Expr ::= i::Integer
{
  top.type = tInt();

  top.errs = [];

  top.ocaml = toString(i);
}

production exprTrue
top::Expr ::=
{
  top.type = tBool();

  top.errs = [];

  top.ocaml = "true";
}

production exprFalse
top::Expr ::=
{
  top.type = tBool();

  top.errs = [];

  top.ocaml = "false";
}

production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.s = top.s;
  nondecorated local ty1::Type = e1.type;
  
  e2.s = top.s;
  nondecorated local ty2::Type = e2.type;

  local ok::([String], Type) = andOk(ty1, ty2, top.location);

  top.errs = ok.1 ++ e1.errs ++ e2.errs;
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

  local msgLeft::[String] =
    if ty1 == tInt() || ty1 == tFloat() || ty1 == tBool()
    then []
    else [err(
      "equality expects left operand to be of type int or float or bool, " ++
      "but an expression was given of type " ++ ty1.pp,
      top.location
    )];
  
  local msgRight::[String] =
    if !null(msgLeft) || ty1 == ty2
    then []
    else [err(
      "equality expects right operand to be of type " ++ ty1.pp ++ ", but an " ++
      "expression was given of type " ++ ty2.pp,
      top.location
    )];

  top.errs = if !null(msgLeft) then msgLeft else msgRight
             ++ e1.errs ++ e2.errs;
  top.type = tBool();

  top.ocaml = "(" ++ e1.ocaml ++ " = " ++ e2.ocaml ++ ")";
}

production exprFun
top::Expr ::= b::Bind e::Expr
{
  exists scope s_dcl;

  scope s_fun;

  s_fun -[ lex ]-> top.s;

  b.s = top.s;
  b.s_def = s_fun;
  b.s_dcl = s_dcl;

  nondecorated local ty1::Type = b.type;

  e.s = s_fun;
  nondecorated local ty2::Type = e.type;

  top.type = tFun(ty1, ty2);

  top.errs = b.errs ++ e.errs;

  b.inSeqLet = true;
  
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

  local msgLeft::[String] =
    if ty3and4.1
    then []
    else [err("application expects left operand to be of function type, " ++
                       "but an expression was given of type " ++ ty1.pp,
                       top.location)];

  local msgRight::[String] =
    if !null(msgLeft) || ty2 == ty3
    then []
    else [err(
      "application expects right operand to be of type " ++ ty3.pp ++ ", but an " ++
      "expression was given of type " ++ ty2.pp,
      top.location
    )];

  top.errs = if !null(msgLeft) then msgLeft else msgRight
             ++ e1.errs ++ e2.errs;
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

  local msgs1::[String] =
    if ty1 == tBool()
    then []
    else [err(
      "conditional expects first operand to be of type bool, but an expression " ++
      "was given of type " ++ ty1.pp,
      top.location
    )];
  
  local msgs2::[String] =
    if ty2 == ty3
    then []
    else [err(
      "conditional expects else branch to be of type " ++ ty2.pp ++ ", but an expression " ++
      "was given of type " ++ ty3.pp,
      top.location
    )];

  top.type = if ty1 == tBool() && ty2 == ty3 then ty2 else tErr();

  top.errs = msgs1 ++ msgs2 ++ e1.errs ++ e2.errs ++ e3.errs;

  top.ocaml = "if " ++ e1.ocaml ++ 
                    " then " ++ e2.ocaml ++
                    " else " ++ e3.ocaml;
}

production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  scope s_let;

  s_let -[ lex ]-> top.s;

  bs.s = s_let;
  bs.s_def = s_let;

  e.s = s_let;

  top.type = e.type;

  top.errs = bs.errs ++ e.errs;

  top.ocaml = bs.ocaml ++ e.ocaml;

  bs.isFirst = true;
}

production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  scope s_let;

  s_let -[ lex ]-> top.s;

  bs.s = top.s;
  bs.s_def = s_let;

  e.s = s_let;

  top.type = e.type;

  top.errs = bs.errs ++ e.errs;

  top.ocaml = error("exprLetPar.ocaml TODO");

  bs.isFirst = true;
}

--------------------------------------------------

-- { exprLetExample }
production exprAdd top::Expr ::= e1::Expr e2::Expr                              ^\label{line:prod-exprAdd}^
{ e1.s = top.s; e2.s = top.s;                                                   ^\label{line:s-exprAdd}^
  local msgLeft::[String] = assert(addable(e1.type),                            ^\label{line:msgLeft-exprAdd}^
    "(+) LHS type not int/float, is " ++ e1.type.pp);                     
  local msgRight::[String] = assert(addable(e2.type),                           ^\label{line:msgRight-exprAdd}^
    "(+) RHS type not int/float, is " ++ e2.type.pp);
  top.errs = msgLeft ++ msgRight ++ e1.errs ++ e2.errs;                         ^\label{line:errs-exprAdd}^
  top.ocaml = "(" ++                                                            ^\label{line:ocaml-exprAdd}^
    case e1.type, e2.type of
    | tFloat(), tFloat() -> e1.ocaml ++ " +. " ++ e2.ocaml
    | tFloat(), tInt() ->
      e1.ocaml ++ " +. (float_of_int " ++ e2.ocaml ++ ")"
    | tInt(), tFloat() ->
      "(float_of_int " ++ e1.ocaml ++ ") +. " ++ e2.ocaml
    | _, _ -> e1.ocaml ++ " + " ++ e2.ocaml
    end ++ ")";                                                                 ^\label{line:ocaml-exprAdd-end}^
  top.type = castAdd(e1.type, e2.type); }
production exprVar top::Expr ::= x::String                                      ^\label{line:prod-exprVar}^
{ local exact::[Scope] =                                 ^\label{line:vars-exprVar}^
    query(`lex*`imp?`var,                                                       ^\label{line:query-exprVar-1}^ ^\label{line:regex-exprVar}^
          `lex > `imp, `lex > `var, `imp > `var,                                ^\label{line:order-exprVar}^
          isVarCalled(x), top.s);                                               ^\label{line:predicate-exprVar}^ ^\label{line:query-exprVar-1-end}^
  local close::[Scope] =
    query(`lex*imp?(`var|`mod),                                                 ^\label{line:query-exprVar-2}^
          `lex > `imp, `lex > `var, `lex > mod,                                 ^\label{line:order-exprVar-2}^
          `imp > `var, `imp > `mod,                                             ^\label{line:order-exprVar-2-end}^
          editDistanceAtMost(1, x), top.s);                                     ^\label{line:query-exprVar-2-end}^
  local bindNode::Decorated Bind with {s, inSeqLet} =                           ^\label{line:bindNode-exprVar}^
    if singleton(exact) then getBind(head(exact))
                        else defaultErrBind;
  local closeNames::[String] = getDclNames(close);
  top.errs = case exact, closeNames of                                               ^\label{line:exprVar-errs}^
             | [_], [] -> []
             | _::_, _ -> [x ++ " ambiguous"]
             | [], [] -> [x ++ " unresolvable"]
             | _, cs -> [x ++ " unresolvable, close to: "                       ^\label{line:exprVar-errs-close}^
                         ++ implode(", ", cs)] end;                             ^\label{line:exprVar-errs-end}^
  top.ocaml = if !bindNode.inSeqLet                                             ^\label{line:bindNode-inSeqLet-exprVar}^
              then "(Lazy.force " ++ x ++ ")" else x;                           ^\label{line:bindNode-inSeqLet-exprVar-end}^
  top.type = bindNode.type; }                                                   ^\label{line:bindNode-type-exprVar}^

production exprLet top::Expr ::= bs::Binds e::Expr                              ^\label{line:prod-exprLet}^
{ exists scope s_let;                                                            ^\label{line:s_let-exprLet}^
  bs.s = top.s; bs.s_last = s_let; 
  e.s = s_let;                                                                  ^\label{line:s-exprLet}^
  top.errs = bs.errs ++ e.errs;
  top.ocaml = bs.ocaml ++ e.ocaml;
  top.type = e.type; }

production seqBindsCons top::Binds ::= b::Bind bs::Binds
{ exists scope s_dcl;
  scope s_next;                                                              ^\label{line:snext-seqBindsCons}^
  edge s_next -[ lex ]-> top.s;                                              ^\label{line:edge-lex-seqBindsCons}^
  edge s_next -[ var ]-> s_dcl;                                              ^\label{line:edge-var-bind}^
  b.inSeqLet = true;                                                           ^\label{line:inSeqLet-seqBindsCons}^
  b.s = top.s;  b.s_dcl = s_dcl;
  bs.s = s_next; bs.s_last = top.s_last;
  top.errs = b.errs ++ bs.errs;
  top.ocaml = "let " ++ b.ocaml ++ " in " ++ bs.ocaml; }
production seqBindsLast top::Binds ::= b::Bind
{ exists scope s_dcl;
  scope top.s_last;                                                          ^\label{line:s_last-seqBindsLast}^
  edge top.s_last -[ lex ]-> top.s;                                          ^\label{line:edge-lex-seqBindsLast}^
  edge top.s_last -[ var ]-> s_dcl;                                          ^\label{line:edge-var-seqBindsLast}^
  b.inSeqLet = true;                                                           ^\label{line:inSeqLet-seqBindsLast}^
  b.s = top.s; b.s_dcl = s_dcl; 
  top.errs = b.errs;
  top.ocaml = "let " ++ b.ocaml ++ " in "; }

production bind top::Bind ::= x::String  e::Expr
{ scope top.s_dcl -> datumVar(x, top);                                       ^\label{line:sdcl-bind}^
  e.s = top.s;
  top.type = e.type;                                                         ^\label{line:type-bind}^
  top.errs = assert(anno == e.type, "bad type of " ++ x)
             ++ e.errs;
  top.ocaml = x ++ " = " ++
    if top.inSeqLet
    then e.ocaml else "lazy (" ++ e.ocaml ++ ")"; }
-- { exprLetExample }

annotation location occurs on Binds;

production seqBindsNil
top::Binds ::=
{
  scope top.s_last;

  top.s_last -[ lex ]-> top.s;

  top.errs = [];

  top.ocaml = "";
}

--------------------------------------------------


nonterminal ParBinds with location;

inherited attribute isFirst::Boolean occurs on ParBinds;

production parBindsNil
top::ParBinds ::=
{
  top.errs = [];

  top.ocaml = "";
}

production parBindsOne
top::ParBinds ::= s::Bind
{
  exists scope s_dcl;

  s.s = top.s;
  s.s_def = top.s_def;
  s.s_dcl = s_dcl;

  top.errs = s.errs;

  s.inSeqLet = false;

  top.ocaml =
    (if top.isFirst then "let " else " and ") ++
    s.ocaml ++ " in ";
}

production parBindsCons
top::ParBinds ::= s::Bind ss::ParBinds
{
  exists scope s_dcl;

  s.s = top.s;
  s.s_def = top.s_def;
  s.s_dcl = s_dcl;

  ss.s = top.s;
  ss.s_def = top.s_def;

  top.errs = s.errs ++ ss.errs;

  s.inSeqLet = false;

  top.ocaml = 
    (if top.isFirst then "let rec " else " and ") ++
    s.ocaml ++ ss.ocaml;

  ss.isFirst = false;
}

--------------------------------------------------

annotation location occurs on Bind;

production bindTyped
top::Bind ::= tyann::Type x::String e::Expr
{
  scope top.s_dcl -> datumVar(x, top);

  top.s_def -[ var ]-> top.s_dcl;

  nondecorated local ty1::Type = ^tyann;

  nondecorated local ty2::Type = e.type;
  e.s = top.s;

  top.type = ^tyann;

  top.errs =
    if ty1 == ty2 || e.type == tErr()
    then e.errs
    else err(
            "variable " ++ x ++ " declared with type " ++ ty1.pp ++ ", but its " ++
            "definition has type " ++ ty2.pp,
            top.location
         )::e.errs;

  top.ocaml = 
    x ++ ": " ++ tyann.ocaml ++ " = " ++ 
    if !top.inSeqLet
    then "lazy (" ++ e.ocaml ++ ")"
    else e.ocaml;
}

production bindArgDcl
top::Bind ::= x::String tyann::Type
{
  scope top.s_dcl -> datumVar(x, top);

  top.s_def -[ var ]-> top.s_dcl;

  top.type = ^tyann;

  top.errs = [];

  top.ocaml = "fun " ++ x ++ ":" ++ tyann.ocaml;
}

--------------------------------------------------

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

  top.errs = 
    case mods of
    | h::[] -> []
    | _::_ -> [err("ambiguous module reference " ++ x, top.location)]
    | [] -> [err("unresolvable module reference " ++ x, top.location)]
    end;

  top.ocaml = "open Mod_" ++ x;
}

--------------------------------------------------

fun isDatumVar (Boolean ::= Datum) ::= x::String =
  \d::Datum ->
    case d of
    | datumVar(dx, _) -> x == dx
    | _ -> false
    end
;

fun getDecoratedBind Decorated Bind with {s, inSeqLet} ::= s::Decorated Scope with LMLabels =
  case s.datum of
  | datumVar(_, n) -> n
  | _ -> error("Used extractBind on a scope not using datumVar!")
  end
;

global defaultErrorBind::Decorated Bind with {s, inSeqLet} =
  decorate bindArgDcl("", tErr(), location=bogusLoc()) with {s=deadScope; inSeqLet=true;};

fun addable Boolean ::= t::Type =
  t == tInt() || t == tFloat() || t == tErr()
;
