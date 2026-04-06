grammar lmr1:lmr:nameanalysis_draft;


--------------------------------------------------
-- Scope labels spec

-- 'Abstract' type for [non-buildable] declaration scopes with name attribute
-- Purpose of abstract scope types is to act as a parent for multiple different
-- scope types, which become subtypes of the abstract one
abstract scope type SGDclNode -> name::String;
-- 'Abstract' type for [non-buildable] 'region' scopes with no attributes
abstract scope type SGRegNode ->;

-- Scope type for scoping 'region' SG nodes with no attributes
-- SGLexNode is a subtype of SGRegNode, gets no new attributes
scope type (SGRegNode) => SGLexNode;

-- Scope type for variable declaration have astBind attribute
-- SGVarNode is a subtype of SGDclNode, gets name attribute
scope type (SGDclNode) => SGVarNode -> astBind::Decorated Bind;

-- Scope type for module declaration has astMod attribute
-- SGModNode is a subtype of SGDclNode, gets name attribute
-- SGModNode is a subtype of SGRegNode, gets no new attributes
scope type (SGDclNode, SGRegNode) => SGModNode -> astMod::Decorated Module;

-- Alternative way of specifying subtyping:
SGVarNode is SGDclNode
SGModNode is SGDclNode
SGModNode is SGRegNode
SGLexNode is SGRegNode

-- lex (lexical parent) edges lead to SGRegNodes
edge type -[ lex ]-> SGRegNode;
-- var (variable decl) edges lead to SGVarNodes
edge type -[ var ]-> SGVarNode;
-- mod (module decl) edges lead to SGModNodes
edge type -[ mod ]-> SGModNode;
-- imp (import) edges lead to SGModNodes
edge type -[ imp ]-> SGModNode;

-- Last label in good path for modquery is var, targetting SGVarNode. Predicate
-- type therefore must be (Boolean ::= SGVarNode). `String name` arg for this
-- query used in predicate. Args for including information query should use
query varQuery(String name) as
  regex = `lex* `imp? `var
  order = `lex > `imp, `lex > `var, `imp > `var
  predicate = \sv::SGVarNode -> sv.astBind.name == name;
                             -- sv.name == name; -- could also do this

-- Last label in good path for modquery is mod, targetting SGModNode. Predicate
-- type therefore must be (Boolean ::= SGModNode)
query modQuery(String name) as
  regex = `lex* `imp? `mod
  order = `lex > `imp, `lex > `mod, `imp > `mod
  predicate = \sm::SGModNode -> sm.astMod.name == name;
                             -- sm.name == name; -- could also do this

-- Last labels in good path for dclQuery are mod and var which target SGVarNodes
-- and SGModNodes respectively. Both are SGDclNode (closest common ancestor),
-- so this is a query for SGDclNodes. Predicate must be typed accordingly, and
-- only be able to access attributes on SGDclNode
query dclQuery(String name) as
  regex = `lex* `imp? (`mod | `var)
  order = `lex > `imp, `lex > `mod, `lex > `var, `imp > `mod, `imp > `var,
  predicate = \sd::SGDclNode -> editDistanceAtMost(1, name sd.name);


--------------------------------------------------
-- Scope (inherited) attributes

-- Scope passed down as a lookup scope for most nodes
scope attribute s::SGRegNode 
  occurs on Decls, Decl, Module, Expr, Binds, Bind, RecBinds, ModRef;

-- The enclosing module scope for a declaration, passed down so that the prod
-- for a var or mod declaration can assert an edge from s_module to the newly
-- built declaration scope graph node
scope attribute s_module::SGModNode
  occurs on Decls, Decl, Module;

-- The scope passed down to module, binder and module reference AST nodes so
-- that corresponding MOD, VAR or IMP edges can be drawn from this to the newly
-- built declaration scope graph node or resolved imported scope. For a def in a
-- module, appropriate VAR or MOD edges are drawn to the scope graph node for
-- that def from both s_module (above) and s_def. Allows an importing scope to
-- access defs in a module, and allows subsequent defs in the same module to
-- resolve to previous ones
scope attribute s_def::SGLexNode
  occurs on RecBinds, Module, Decl, ModRef;

-- The last scope built in a sequential binder list, which can then be passed
-- down to the RHS of the sequential let definition
scope attribute s_last::SGLexNode
  occurs on Binds;

-- The scope graph declaration node built for a binder, VAR edge drawn to it in
-- the declDef, seqBindsCons and seqBindsLast productions
scope attribute s_dcl::SGVarNode
  occurs on Bind;


--------------------------------------------------
-- 'Normal' attributes

-- Synthesize error messages as Strings
synthesized attribute errs::[String]
  occurs on Program, Decls, Decl, Module, Expr, Binds, RecBinds, Bind, ModRef;

-- Translation of LM programs to OCaml
synthesized attribute ocaml::String
  occurs on Program, Decls, Decl, Module, Expr, Binds, Bind, RecBinds, Type, ModRef;

-- LM type of expressions, binders
synthesized attribute type::Type
  occurs on Expr, Bind;

-- Tell a Bind whether its in a sequential let (true) or recursive let (false)
inherited attribute inSeqLet::Boolean occurs on Bind;

-- Tell a RecBinds node whether it is the first recursive binder in a recursive
-- binder list, used to generate OCaml code
inherited attribute isFirst::Boolean occurs on RecBinds;

--------------------------------------------------
-- Root nonterminal

nonterminal Program with location;

production program
top::Program ::= ds::Decls
{
  -- Global lexical scope
  scope glob::SGLexNode;

  -- Unreachable scope passed down as s_module; top-level definitions are not in
  -- a module that we can resolve to using an import reference
  scope blankScope::SGLexNode;

  -- Pass down global scope as top-level lookup scope for Decls
  ds.s = glob;
  -- Dead scope receives VAR and MOD edges from Decls, but is not reachable
  ds.s_module = blankScope;

  top.errs = ds.errs;
  top.ocaml = ds.ocaml;
}


--------------------------------------------------
-- List of declarations in a module or at top-level

nonterminal Decls with location;

production declsCons
top::Decls ::= d::Decl ds::Decls
{
  -- The next sequential scope in a nested declaration scoping structure
  scope seqScope::SGLexNode;

  -- Draw a lex edge to the previous sequential scope
  seqScope -[ lex ]-> top.s;

  -- Lookup in previous sequential scope
  d.s = top.s;
  -- Draw VAR, MOD, or IMP edges from seqScope to new declaration SG nodes
  d.s_def = seqScope;
  -- Also draw VAR and MOD edges from enclosing module scope
  d.s_module = top.s_module;

  -- Pass down the next sequential scope as the lookup scope for ds
  ds.s = seqScope;
  -- Pass down same enclosing module scope
  ds.s_module = top.s_module;

  top.errs = d.errs ++ ds.errs;
  top.ocaml = d.ocaml ++ "\n" ++ ds.ocaml;
}

production declsNil
top::Decls ::=
{
  top.errs = [];
  top.ocaml = "";
}


--------------------------------------------------
-- Declaration within a module or at top-level

nonterminal Decl with location;

production declModule
top::Decl ::= m::Module
{
  -- Propagate s, s_def, s_module
  m.s = top.s;
  m.s_def = top.s_def;
  m.s_module = top.s_module;

  top.errs = m.errs;
  top.ocaml = m.ocaml;
}

production declImport
top::Decl ::= mr::ModRef
{
  -- Propagate s, s_def
  mr.s = top.s;
  mr.s_def = top.s_def;

  top.errs = mr.errs;
  top.ocaml = mr.ocaml;
}

production declDef
top::Decl ::= b::Bind
{
  -- Assert the existence of an SG node s_dcl, that is built down in b
  -- with `scope top.s_dcl -> ...;`
  exists scope s_dcl::SGVarNode;

  -- Propagate s, s_def
  b.s = top.s;
  b.s_def = top.s_module;
  -- s_dcl for b is the same as the scope we asserted the existence of above
  b.s_dcl = s_dcl;

  b.inSeqLet = true;

  -- Draw var edge from enclosing module scope to s_dcl that we asserted above
  top.s_module -[ var ]-> s_dcl;

  top.errs = b.errs;
  top.ocaml = "let " ++ b.ocaml;
}


--------------------------------------------------
-- Module declaration

nonterminal Module with location;

production module
top::Module ::= x::String ds::Decls
{
  -- Create a new scope for a module, data points back to this AST node
  scope modScope::SGModNode -> { name = x, astBind = top };

  -- Lexical parent of the module scope is corresponding sequential Decls scope
  modScope -[ lex ]-> top.s;

  -- Both s_def and s_module get mod edges to modScope
  -- Edge from s_def is used by queries for import references that follow this
  -- module declaration in the same Decls list
  top.s_def -[ mod ]-> modScope;
  -- Edge from s_module is used by queries from other modules that have imported
  -- the module that encloses this one
  top.s_module -[ mod ]-> modScope;

  -- Queries for variable/import references inside this module should continue
  -- at top.s instead of modScope to avoid duplicate name resolutions
  ds.s = top.s;
  -- Pass down modScope as enclosing module scope
  ds.s_module = modScope;

  top.errs = ds.errs;
  top.ocaml = "module Mod_" ++ x ++ " = struct " ++ ds.ocaml ++ "end";
}


--------------------------------------------------
-- Expressions

nonterminal Expr with location;

production exprVar top::Expr ::= x::String
{ 
  r.s = top.s;

  top.type = r.type;
  top.errs = r.errs;
  top.ocaml = r.ocaml;
}

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

production exprAdd top::Expr ::= e1::Expr e2::Expr
{ 
  local addable (Boolean ::= t::Type) = \t::Type ->
    t == tInt() || t == tFloat() || t == tErr();

  local addType (Boolean ::= Type Type) \tl::Type tr::Type ->
    if tl == tFloat() || tr == tFloat() then tFloat() else tInt();

  local msgs::[String] =
    assert(addable(e1.type), "(+) LHS type not int/float, is " ++ e1.type.ocaml) ++
    assert(addable(e2.type), "(+) RHS type not int/float, is " ++ e2.type.ocaml);
    
  e1.s = top.s;
  e2.s = top.s;
  
  top.type = if null(msgs) then addType(e1.type, e2.type) else tErr();
  top.errs = msgs ++ e1.errs ++ e2.errs;
  top.ocaml =
    case e1.type, e2.type of
    | tFloat(), tFloat() -> "(" ++ e1.ocaml ++ ") +. " ++ e2.ocaml
    | tFloat(), tInt() -> "(" ++ e1.ocaml ++ ") +. (float_of_int " ++ e2.ocaml ++ ")"
    | tInt(), tFloat() -> "(float_of_int " ++ e1.ocaml ++ ") +. " ++ e2.ocaml
    | _, _ -> "(" e1.ocaml ++ ") + " ++ e2.ocaml
    end;  
}

production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  local msgs::[String] =
    assert(e1.type == tBool(), "(+) LHS type not bool, is " ++ e1.type.ocaml) ++
    assert(e2.type == tBool(), "(+) RHS type not bool, is " ++ e2.type.ocaml);

  e1.s = top.s;
  e2.s = top.s;
  
  top.type = if !null(msgs) then tBool() else tErr();
  top.errs = msgs ++ e1.errs ++ e2.errs;
  top.ocaml = "(" ++ e1.ocaml ++ ") && " ++ e2.ocaml;
}

production exprLet top::Expr ::= bs::Binds e::Expr
{ 
  -- Assert the existence of s_let (the last nested scope for a sequential let)
  -- that is built down in bs as top.s_last
  exists scope s_let::SGLexNode;
  
  -- Queries from sequential binds resolve in top.s if answer not already found
  bs.s = top.s;
  -- Scope s_let is built as the last scope in a sequental bind list
  bs.s_last = s_let;
  
  -- Pass down s_let, the last scope built down in bs
  e.s = s_let;
  
  top.type = e.type;
  top.errs = bs.errs ++ e.errs;
  top.ocaml = bs.ocaml ++ e.ocaml;
}

production exprLetRec
top::Expr ::= bs::RecBinds e::Expr
{
  -- Create new scope s_let as the recursive let binds scope
  scope s_let::SGLexNode;

  -- Lexical parent of s_let is top.s 
  s_let -[ lex ]-> top.s;

  -- Lookup all references in bs in s_let
  bs.s = s_let;
  -- Draw all var edges made in bs from s_let
  bs.s_def = s_let;

  bs.isFirst = true;

  -- Pass down s_let to the expression RHS
  e.s = s_let;

  top.type = e.type;
  top.errs = bs.errs ++ e.errs;
  top.ocaml = bs.ocaml ++ e.ocaml;
}

production exprLetPar
top::Expr ::= bs::RecBinds e::Expr
{
  -- Create new scope s_let as the parallel let binds scope
  scope s_let::SGLexNode;

  -- Lexical parent of s_let is top.s 
  s_let -[ lex ]-> top.s;

  -- Lookup all references in bs in s_let (parallel, non-recursive)
  bs.s = top.s;
  -- Draw all var edges made in bs from s_let
  bs.s_def = s_let;

  bs.isFirst = true;

  -- Pass down s_let to the expression RHS
  e.s = s_let;

  top.type = e.type;
  top.errs = bs.errs ++ e.errs;
  top.ocaml = error("exprLetPar.ocaml TODO");
}


--------------------------------------------------
-- Binder list for sequential let expressions

nonterminal Binds with location;

production seqBindsCons top::Binds ::= b::Bind bs::Binds
{ 
  -- Assert the existence of a scope s_dcl, build down in b as top.s_dcl
  exists scope s_dcl::SGVarNode;

  -- Construct new scope s_next with no data, the next scope in a sequential
  -- binding structure
  scope s_next::SGLexNode;

  -- The next scope in a sequential binding structure has the previous as its
  -- lexical parent
  edge s_next -[ lex ]-> top.s;
  -- The next scope in a sequential binding structure has a var edge to s_dcl
  edge s_next -[ var ]-> s_dcl;
  
  -- Lookup variable references in b from top.s
  b.s = top.s; 
  -- s_dcl is constructed down in b as top.s_dcl
  b.s_dcl = s_dcl;

  b.inSeqLet = true;
  
  -- Pass down next scope in sequential bind structure
  bs.s = s_next;
  -- The scope top.s_last constructed down in bs is the same as top.s_last here
  bs.s_last = top.s_last;
  
  top.errs = b.errs ++ bs.errs;
  top.ocaml = "let " ++ b.ocaml ++ " in " ++ bs.ocaml; 
}

production seqBindsLast top::Binds ::= b::Bind
{ 
  -- Assert the existence of a scope s_dcl, build down in b as top.s_dcl
  exists scope s_dcl::SGVarNode;

  -- Construct top.s_last with no data
  scope top.s_last::SGLexNode;
  
  -- Last scope in sequential binding gets lex edge to previous scope
  edge top.s_last -[ lex ]-> top.s;
  -- Last scope in sequential binding gets var edge to s_dcl
  edge top.s_last -[ var ]-> s_dcl;
  
  -- Lookup variable references in b from top.s
  b.s = top.s;
  -- s_dcl is constructed down in b as top.s_dcl
  b.s_dcl = s_dcl;

  b.inSeqLet = true; 
  
  top.errs = b.errs;
  top.ocaml = "let " ++ b.ocaml ++ " in ";
}

production seqBindsNil
top::Binds ::=
{
  -- Construct scope top.s_last with no data
  scope top.s_last::SGLexNode;

  -- Last scope in sequential binding gets lex edge to previous scope
  top.s_last -[ lex ]-> top.s;

  top.errs = [];
  top.ocaml = "";
}


--------------------------------------------------
-- Binder list for recursive let expressions

nonterminal RecBinds with location;

production recBindsNil
top::RecBinds ::=
{
  top.errs = [];
  top.ocaml = "";
}

production recBindsOne
top::RecBinds ::= b::Bind
{
  -- Assert the existence of a scope s_dcl, build down in b as top.s_dcl
  exists scope s_dcl::SGVarNode;

  -- Draw var edge from top.s_def to SG node s_dcl constructed down in b
  top.s_def -[ var ]-> s_dcl;

  -- Lookup variable references in b from the recursive binder scope
  b.s = top.s;
  -- s_dcl is the SG node constructed as top.s_dcl down in b
  b.s_dcl = s_dcl;

  b.inSeqLet = false;

  top.errs = b.errs;
  top.ocaml = (if top.isFirst then "let " else " and ") ++
              b.ocaml ++ " in ";
}

production recBindsCons
top::RecBinds ::= b::Bind bs::RecBinds
{
  -- Assert the existence of a scope s_dcl, build down in b as top.s_dcl
  exists scope s_dcl::SGVarNode;

  -- Draw var edge from top.s_def to SG node s_dcl constructed down in b
  top.s_def -[ var ]-> s_dcl;

  -- Lookup variable references in b from the recursive binder scope
  b.s = top.s;
  -- s_dcl is the SG node constructed as top.s_dcl down in b
  b.s_dcl = s_dcl;

  b.inSeqLet = false;

  -- Pass down same recursive let bind list scope
  bs.s = top.s;
  -- Pass down same SG node that is the source of var edges for recursive let binds
  bs.s_def = top.s_def;

  bs.isFirst = false;

  top.errs = b.errs ++ bs.errs;
  top.ocaml = (if top.isFirst then "let rec " else " and ") ++
              b.ocaml ++ bs.ocaml;
}


--------------------------------------------------
-- Variable binder

nonterminal Bind with location;

production bind top::Bind ::= x::String  e::Expr
{ 
  -- Construct SG node top.s_dcl with data pointing back to this AST node
  scope top.s_dcl::SGVarNode -> { name = x, astBind = top };

  -- Lookup variable references in e from top.s
  e.s = top.s;

  top.type = e.type;
  top.errs = assert(anno == e.type, "bad type of " ++ x) ++ e.errs;
  top.ocaml = x ++ " = " ++
              if top.inSeqLet then e.ocaml else "lazy (" ++ e.ocaml ++ ")";
}

production bindTyped
top::Bind ::= tyann::Type x::String e::Expr
{
  -- Construct SG node top.s_dcl with data pointing back to this AST node
  scope top.s_dcl::SGVarNode -> { name = x, astBind = top };

  -- Lookup variable references in e from top.s
  e.s = top.s;

  top.type = ^tyann;
  top.errs = if ^tyann == e.type || e.type == tErr()
             then e.errs
             else err("variable " ++ x ++ " declared with type " ++ tyann.ocaml ++
                      " but " ++ "definition has type " ++ e.type.ocaml,
                      top.location)::e.errs;
  top.ocaml = x ++ ": " ++ tyann.ocaml ++ " = " ++
              if !top.inSeqLet then "lazy (" ++ e.ocaml ++ ")" else e.ocaml;
}


--------------------------------------------------
-- LM types

nonterminal Type;

production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  top.ocaml = "(" ++ tyann1.ocaml ++ ") -> " ++ tyann2.ocaml;
}

production tFloat
top::Type ::=
{
  top.ocaml = "float";
}

production tInt
top::Type ::=
{
  top.ocaml = "int";
}

production tBool
top::Type ::=
{
  top.ocaml = "bool";
}

production tErr
top::Type ::=
{
  top.ocaml = error("tErr.ocaml demanded");
}

fun eqType Boolean ::= t1::Type t2::Type =
  case t1, t2 of
  | tFloat(), tFloat() -> true
  | tInt(), tInt() -> true
  | tBool(), tBool() -> true
  | tFun(t1l, t1r), tFun(t2l, t2r) -> eqType(^t1l, ^t2l) && eqType(^t1r, ^t2r)
  | tErr(), tErr() -> true
  | _, _ -> false
  end;

instance Eq Type {
  eq = eqType;
}


--------------------------------------------------
-- Module references

nonterminal ModRef with location;

production modRef
top::ModRef ::= x::String
{
  -- does ministatix query, filter and min-refs constraints
  local mods::[Decorated SGModNode] = top.s.modQuery(x);

  -- Draw IMP edge from top.s_def to either the scope found by successful import
  -- query, or to deadScope otherwise
  top.s_def -[ imp ]-> if length(mods) == 1 then head(mods) else deadScope;

  top.errs = case mods of
             | h::[] -> []
             | _::_  -> [err("ambiguous module reference " ++ x, top.location)]
             | []    -> [err("unresolvable module reference " ++ x, top.location)]
             end;
  top.ocaml = "open Mod_" ++ x;
}


--------------------------------------------------
-- Variable references

nonterminal VarRef with location;

production varRef
top::VarRef ::= x::String
{
  -- Find the SG nodes corresponding to variable declarations whose name matches x
  local exact::[Decorated SGVarNode] = top.s.varQuery(x);

  -- Find the SG module or variable declaration nodes whose name is close to x
  local close::[SGDclNode] = top.s.dclQuery(x);

  -- Either the Bind AST node associated with an SG declaration node resolved to
  -- with the above `exact` query, or a default error Bind node
  local bindNode::Decorated Bind =
    if length(exact) == 1 
    then head(exact).astBind
    else decorate bindTyped("", tErr(), tInt(0), location=bogusLoc())
         with { s = deadScope; inSeqLet = true; };
  
  top.type = bindNode.type;
  top.errs =
    case exact, map((.name), close) of
    | [_], [] -> []
    | _::_, _ -> [err(x ++ " ambiguous", top.location)]
    | [], []  -> [err(x ++ " unresolvable", top.location)]
    | _, cs   -> [err(x ++ " unresolvable, close to: " ++ implode(", ", cs), top.location)]
    end;
  top.ocaml = if bindNode.inSeqLet then x else "(Lazy.force " ++ x ++ ")";
}


--------------------------------------------------
-- Helpers

fun err String ::= msg::String loc::Location =
  loc.unparse ++ ": error: " ++ msg ++ "\n"; 
