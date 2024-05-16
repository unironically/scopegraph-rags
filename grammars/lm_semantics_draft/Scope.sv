grammar lm_semantics_4:nameanalysis;

--------------------------------------------------

abstract production mkScopeReal
top::Scope ::=
  datum::Maybe<Datum>
{
  top.datum = datum;
}

--------------------------------------------------

aspect production mkScope
top::Scope ::=
{
  forwards to mkScopeReal(nothing());
}

abstract production mkScopeMod
top::Scope ::=
  datum::String
{
  forwards to mkScopeReal(just(datumMod(datum)));
}

abstract production mkScopeVar
top::Scope ::=
  datum::(String, Type)
{
  forwards to mkScopeReal(just(datumVar(fst(datum), snd(datum))));
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

--------------------------------------------------

abstract production mkRef
top::Ref ::= 
  id::String 
  s::Decorated Scope 
  resFun::([Decorated Scope] ::= Decorated Scope String)
{
  top.id = id;
  top.res = resFun(s, id);
}