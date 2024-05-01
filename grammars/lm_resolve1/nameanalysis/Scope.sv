grammar lm_resolve1:nameanalysis;

nonterminal Scope;

synthesized attribute lexEdge::Maybe<Decorated Scope> occurs on Scope;
synthesized attribute varEdges::[Decorated Scope] occurs on Scope;
synthesized attribute modEdges::[Decorated Scope] occurs on Scope;
synthesized attribute impEdge::Maybe<Decorated Scope> occurs on Scope;

synthesized attribute datum::Maybe<Datum> occurs on Scope;

synthesized attribute id::Integer occurs on Scope;
synthesized attribute pp::String occurs on Scope;

abstract production mkScope
top::Scope ::=
  lex::Maybe<Decorated Scope>
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::Maybe<Decorated Scope>
  datum::Maybe<Datum>
{
  top.id = genInt();
  top.lexEdge = lex;
  top.varEdges = var;
  top.modEdges = mod;
  top.impEdge = imp;
  top.datum = datum;
  top.pp = genPrint(top);
}

abstract production mkScopeGlobal
top::Scope ::=
  var::[Decorated Scope]
  mod::[Decorated Scope]
{
  forwards to mkScope (nothing (), var, mod, nothing (), nothing ());
}


abstract production mkScopeParVar
top::Scope ::=
  decl::Decorated ParBind
{
  forwards to mkScope (nothing (), [], [], nothing (), just(datumVar (decl)));
}

abstract production mkScopeSeqVar
top::Scope ::=
  decl::Decorated SeqBind
{
  forwards to mkScope (nothing (), [], [], nothing (), just(datumLetVar (decl)));
}

abstract production mkScopeArgVar
top::Scope ::=
  decl::Decorated ArgDecl
{
  forwards to mkScope (nothing (), [], [], nothing (), just(datumArgVar (decl)));
}


abstract production mkScopeMod
top::Scope ::=
  lex::Decorated Scope
  var::[Decorated Scope]
  mod::[Decorated Scope]
  decl::Decorated Decl
{
  forwards to mkScope (just(lex), var, mod, nothing (), just(datumMod (decl)));
}

abstract production mkLookupScope
top::Scope ::=
  lex::Decorated Scope
  imp::Maybe<Decorated Scope>
{
  forwards to mkScope (just(lex), [], [], imp, nothing());
}

abstract production mkScopeSeqBind
top::Scope ::=
  lex::Decorated Scope
  var::[Decorated Scope]
{
  forwards to mkScope (just(lex), var, [], nothing(), nothing());
}

--------------------------------------------------

nonterminal Datum;

synthesized attribute datumId::String occurs on Datum;
synthesized attribute nameEq::(Boolean ::= String) occurs on Datum;

abstract production datumVar
top::Datum ::= d::Decorated ParBind
{
  top.datumId = 
    case d of
    | parBindUntyped (x, _) -> x
    | parBindTyped (_, x, _) -> x
    end;
  top.nameEq = \s::String -> s == top.datumId;
}

abstract production datumLetVar
top::Datum ::= d::Decorated SeqBind
{
  top.datumId = 
    case d of
    | seqBindUntyped (x, _) -> x
    | seqBindTyped (_, x, _) -> x
    end;
  top.nameEq = \s::String -> s == top.datumId;
}

abstract production datumArgVar
top::Datum ::= d::Decorated ArgDecl
{
  top.datumId = 
    case d of
    | argDecl (x, _) -> x
    end;
  top.nameEq = \s::String -> s == top.datumId;
}


abstract production datumMod
top::Datum ::= d::Decorated Decl
{
  top.datumId = 
    case d of
    | declModule (x, _) -> x
    | _ -> ""
    end;
  top.nameEq = \s::String -> s == top.datumId;
}

--------------------------------------------------

function genPrint
String ::=
  s::Decorated Scope
{

  local lexEdge::String = 
    case s.lexEdge of
    | just(par) -> " -[ `LEX ]-> " ++ toString(par.id)
    | nothing() -> ""
    end;
  
  local varEdges::[String] = 
    map ((\tgt::Decorated Scope -> " -[ `VAR ]-> " ++ toString(tgt.id)), s.varEdges);

  local modEdges::[String] = 
    map ((\tgt::Decorated Scope -> " -[ `MOD ]-> " ++ toString(tgt.id)), s.modEdges);

  local impEdge::String = 
    case s.impEdge of
    | just(imp) -> " -[ `IMP ]-> " ++ toString(imp.id)
    | nothing() -> ""
    end;

  local edgesPrint::[String] = map ((\s::String -> s ++ "\t"), [lexEdge] ++ varEdges ++ modEdges ++ [impEdge]);

  return "- Scope " ++ toString(s.id) ++ "\n" ++ implode("\n", edgesPrint);

}