grammar lm_semantics_3:nameanalysis;

abstract production mkScopeLet
top::Scope ::=
  lex::Decorated Scope
  var::[Decorated Scope]
{
  forwards to mkScope(just(lex), var, [], [], nothing(), location=top.location);
}

abstract production mkScopeGlobal
top::Scope ::=
  var::[Decorated Scope]
  mod::[Decorated Scope]
{
  forwards to mkScope(nothing(), var, mod, [], nothing(), location=top.location);
}

abstract production mkScopeMod
top::Scope ::=
  lex::Decorated Scope
  var::[Decorated Scope]
  mod::[Decorated Scope]
  datum::String
{
  forwards to mkScope(just(lex), var, mod, [], just(datumMod(datum, top, location=top.location)), location=top.location);
}

abstract production mkScopeImpLookup
top::Scope ::=
  lex::Decorated Scope
  imp::Maybe<Decorated Scope>
{
  forwards to mkScope(just(lex), [], [], if imp.isJust then [imp.fromJust] else [], nothing(), location=top.location);
}


abstract production mkScopeVar
top::Scope ::=
  datum::(String, Type)
{
  forwards to mkScope(nothing(), [], [], [], just(datumVar(fst(datum), snd(datum), location=top.location)), location=top.location);
}

abstract production mkScopeSeqBind
top::Scope ::=
  lex::Decorated Scope
  var::[Decorated Scope]
{
  forwards to mkScope(just(lex), var, [], [], nothing(), location=top.location);
}

--------------------------------------------------


abstract production datumMod
top::Datum ::= id::String ty::Decorated Scope
{
  local datumPrint::String = id;
  forwards to datumId(id, datumPrint, location=top.location);
}

abstract production datumVar
top::Datum ::= id::String ty::Type
{
  local datumPrint::String = id ++ " : " ++ ty.statix;
  forwards to datumId(id, datumPrint, location=top.location);
}