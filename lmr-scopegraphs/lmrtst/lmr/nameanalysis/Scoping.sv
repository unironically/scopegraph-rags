grammar lmrtst:lmr:nameanalysis;

imports syntax:lmr0:lmr:abstractsyntax;
imports sg_lib2:src;

imports silver:util:treemap;

--------------------------------------------------

inherited attribute scope::Decorated Scope;
monoid attribute synEdges::[Edge] with [], ++;

synthesized attribute type::Type;
monoid attribute ok::Boolean with true, &&;

--------------------------------------------------

attribute ok occurs on Main;
propagate ok on Main;

aspect production program
top::Main ::= ds::Decls
{
  local globScope::Scope = scopeNoData();
  globScope.edges = ds.synEdges;

  ds.scope = globScope;
}

--------------------------------------------------

attribute scope, synEdges, ok occurs on Decls;
propagate scope, synEdges, ok on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{}

aspect production declsNil
top::Decls ::=
{}

--------------------------------------------------

attribute scope, synEdges, ok occurs on Decl;
propagate scope, synEdges, ok on Decl;

aspect production declDef
top::Decl ::= b::ParBind
{}

--------------------------------------------------

attribute scope, synEdges, ok, type occurs on Expr;

propagate ok on Expr;

aspect production exprInt
top::Expr ::= i::Integer
{ 
  top.synEdges := [];
  top.type = tInt();
}

aspect production exprTrue
top::Expr ::=
{ 
  top.synEdges := [];
  top.type = tBool();
}

aspect production exprFalse
top::Expr ::=
{ 
  top.synEdges := [];
  top.type = tBool();
}

aspect production exprVar
top::Expr ::= r::VarRef
{ 
  propagate scope;
  top.synEdges := []; 
  top.type = r.type;
}

aspect production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synEdges;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprSub
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synEdges;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprMul
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synEdges;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprDiv
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synEdges;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tInt(), tInt() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synEdges;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tBool(), tBool() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprOr
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synEdges;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tBool(), tBool() -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synEdges;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | t1, t2 when t1 == t2 -> (true, e1.type)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  propagate scope, synEdges;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type of
                                   | tFun(t1, t2), t3 when ^t1 == t3 -> (true, ^t2)
                                   | _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  propagate scope, synEdges;
  local okAndTy::(Boolean, Type) = case e1.type, e2.type, e3.type of
                                   | tBool(), t2, t3 when t2 == t3 -> (true, t2)
                                   | _, _, _ -> (false, tErr())
                                   end;
  top.ok <- okAndTy.1;
  top.type = okAndTy.2;
}

aspect production exprFun
top::Expr ::= d::ArgDecl e::Expr
{
  propagate synEdges;
  
  local funScope::Scope = scopeNoData();
  funScope.edges = lexEdge(top.scope) :: d.synEdges;

  d.scope = top.scope;
  e.scope = funScope;

  top.type = tFun(d.type, e.type);
}

aspect production exprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  local letScope::Decorated Scope = bs.lastScope;

  bs.scope = top.scope;
  e.scope = letScope;

  top.type = e.type;
  top.synEdges := [];
}

aspect production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = scopeNoData();
  letScope.edges = bs.synEdges;

  bs.scope = letScope;
  e.scope = letScope;

  top.type = e.type;
  top.synEdges := [];
}

aspect production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  local letScope::Scope = scopeNoData();
  letScope.edges = bs.synEdges;

  bs.scope = top.scope;
  e.scope = letScope;

  top.type = e.type;
  top.synEdges := [];
}

--------------------------------------------------

attribute ok, scope, lastScope occurs on SeqBinds;

propagate ok on SeqBinds;

synthesized attribute lastScope::Decorated Scope;

aspect production seqBindsNil
top::SeqBinds ::=
{
  top.lastScope = top.scope;
}

aspect production seqBindsOne
top::SeqBinds ::= s::SeqBind
{
  local sbScope::Scope = scopeNoData();
  sbScope.edges = lexEdge(top.scope) :: s.synEdges;

  s.scope = top.scope;

  top.lastScope = sbScope;
}

aspect production seqBindsCons
top::SeqBinds ::= s::SeqBind ss::SeqBinds
{
  local sbScope::Scope = scopeNoData();
  sbScope.edges = lexEdge(top.scope) :: s.synEdges;

  s.scope = top.scope;
  ss.scope = sbScope;

  top.lastScope = ss.lastScope;
}

--------------------------------------------------

attribute ok, scope, synEdges occurs on SeqBind;

propagate ok, scope on SeqBind;

aspect production seqBindUntyped
top::SeqBind ::= id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, e.type);
  bindScope.edges = [];

  top.synEdges := [ varEdge(bindScope) ];
}

aspect production seqBindTyped
top::SeqBind ::= ty::Type id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, ^ty);
  bindScope.edges = [];

  top.synEdges := [ varEdge(bindScope) ];

  top.ok <- ^ty == e.type;
}

--------------------------------------------------

attribute ok, scope, synEdges occurs on ParBinds;
propagate ok, scope, synEdges on ParBinds;

aspect production parBindsNil
top::ParBinds ::=
{}

aspect production parBindsCons
top::ParBinds ::= s::ParBind ss::ParBinds
{}

--------------------------------------------------

attribute ok, scope, synEdges occurs on ParBind;
propagate ok, scope on ParBind;

aspect production parBindUntyped
top::ParBind ::= id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, e.type);
  bindScope.edges = [];

  top.synEdges := [ varEdge(bindScope) ];
}

aspect production parBindTyped
top::ParBind ::= ty::Type id::String e::Expr
{
  local bindScope::Scope = scopeVar(id, ^ty);
  bindScope.edges = [];

  top.synEdges := [ varEdge(bindScope) ];

  top.ok <- ^ty == e.type;
}

--------------------------------------------------

attribute ok, scope, synEdges, type occurs on ArgDecl;
propagate ok, scope on ArgDecl;

aspect production argDecl
top::ArgDecl ::= id::String ty::Type
{
  local bindScope::Scope = scopeVar(id, ^ty);
  bindScope.edges = [];

  top.synEdges := [ varEdge(bindScope) ];

  top.type = ^ty;
}

--------------------------------------------------

aspect production tInt
top::Type ::=
{}

aspect production tBool
top::Type ::=
{}

aspect production tFun
top::Type ::= tyann1::Type tyann2::Type
{}

aspect production tErr
top::Type ::=
{}

--------------------------------------------------

attribute ok, scope, type occurs on VarRef;

aspect production varRef
top::VarRef ::= x::String
{
  production attribute vars::[Decorated Scope] with unionDecScope;
  vars := [];
  vars <- top.scope.resolve(isName(x), varRx());

  local okAndTy::(Boolean, Type) =
    if length(vars) < 1
    then unsafeTracePrint((false, tErr()), "Bad resolution of " ++ x ++ " (H: not found)\n")
    else if length(vars) > 1
    then unsafeTracePrint((false, tErr()), "Bad resolution of " ++ x ++ " (H: ambiguous)\n")
    else case head(vars).datum of
         | datumVar(_, ty) -> (true, ^ty)
         | _ -> unsafeTracePrint((false, tErr()), "Bad resolution of " ++ x ++ " (H: bad data)\n")
         end;

  top.ok := okAndTy.1;
  top.type = okAndTy.2;
}


















































--------------------------------------------------------------------------------
-- HOST SPEC

-- toy scope nonterminal and production
{-nonterminal Scp<(i::InhSet)>;
production scp1 top::Scp<i> ::= {}

-----

-- host lang SG edges, left polymorphic to allow extensions to use
inherited attribute edge1<(i::InhSet)>::[Scp<i>] occurs on Scp<(i::InhSet)>;
inherited attribute edge2<(i::InhSet)>::[Scp<i>] occurs on Scp<(i::InhSet)>;

-- host lang inh SG, left polymorphic
inherited attribute scp<(i::InhSet)>::Decorated Scp<i> with i occurs on Moo<(i::InhSet)>;

-----

nonterminal Toot;

production toot
  {edge1, edge2} subset i =>
top::Toot ::= moo::Moo<i>
{
  local glob::Scp<i> = scp1();
  glob.edge1 = [];
  glob.edge2 = [];

  moo.scp = glob;
}

nonterminal Moo<(i::InhSet)>;

production moo2
top::Moo<{edge1, edge2}> ::= l::Moo<{edge1, edge2}> r::Moo<{edge1, edge2}>
{
  l.scp = top.scp;
  r.scp = top.scp;
}

production moo1
top::Moo<{edge1, edge2}> ::= x::String
{
  production attribute res::[Scp<{edge1, edge2}>] =
    let foo::[Scp<{edge1, edge2}>] = top.scp.edge1 in
    let bar::[Scp<{edge1, edge2}>] = top.scp.edge2 in
      foo ++ bar
    end end
  ;
}


--------------------------------------------------------------------------------
-- EXTENSION SPEC

inherited attribute edge3<(i::InhSet)>::[Scp<i>] occurs on Scp<(i::InhSet)>;

aspect production toot
top::Toot ::= moo::Moo<i>
{

}-}





--------------------------------------------------------------------------------
-- HOST SPEC

fun mergeEdgeMaps
Map<String [Decorated Scp]> ::= l::Map<String [Decorated Scp]> r::Map<String [Decorated Scp]> = 
  add(toList(l), r)
;

-- toy scope nonterminal and productions
nonterminal Scp;

inherited attribute edges::Map<String [Decorated Scp]> with mergeEdgeMaps occurs on Scp;

production scp1 
top::Scp ::=
{}

production scp2
top::Scp ::= x::String
{}

-----

inherited attribute scp::Decorated Scp occurs on Moo;

synthesized attribute syn_edge1::[Decorated Scp] occurs on Moo;
synthesized attribute syn_edge2::[Decorated Scp] occurs on Moo;

-----

nonterminal Toot;

production toot
top::Toot ::= moo::Moo
{
  production attribute glob::Scp = scp1();
  glob.edges := emptyWith(compareString);
  glob.edges <- add([("EDGE1", moo.syn_edge1)], emptyWith(compareString));
  glob.edges <- add([("EDGE2", moo.syn_edge2)], emptyWith(compareString));

  moo.scp = glob;
}

nonterminal Moo;

production moo3
top::Moo ::= x::String i::Integer
{
  production attribute varScp::Scp = scp2(x);
  varScp.edges := emptyWith(compareString);

  top.syn_edge1 = [varScp];
  top.syn_edge2 = [];
}

production moo2
top::Moo ::= l::Moo r::Moo
{
  l.scp = top.scp;
  r.scp = top.scp;

  top.syn_edge1 = l.syn_edge1 ++ r.syn_edge1;
  top.syn_edge2 = l.syn_edge2 ++ r.syn_edge2;
}

production moo1
top::Moo ::= x::String
{
  production attribute res::[Decorated Scp] with ++;
  res := [];
  res <- concat(lookup("EDGE1", top.scp.edges));
  res <- concat(lookup("EDGE2", top.scp.edges));

  top.syn_edge1 = [];
  top.syn_edge2 = [];
}


--------------------------------------------------------------------------------
-- EXTENSION SPEC

synthesized attribute syn_edge3::[Decorated Scp] occurs on Moo;

aspect production toot
top::Toot ::= moo::Moo
{
  glob.edges <- add([("EDGE3", moo.syn_edge3)], emptyWith(compareString));
}

aspect production moo3
top::Moo ::= x::String i::Integer
{
  top.syn_edge3 = [];
}

aspect production moo2
top::Moo ::= l::Moo r::Moo
{
  top.syn_edge3 = l.syn_edge3 ++ r.syn_edge3;
}

aspect production moo1
top::Moo ::= x::String
{
  res <- concat(lookup("EDGE3", top.scp.edges));

  top.syn_edge3 = [];
}
