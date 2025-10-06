grammar lmr0:lmr:nameanalysis1;

--------------------------------------------------

abstract production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

abstract production scopeVar
top::Scope ::= name::String ty::Type
{ forwards to scope(datumVar(name, ^ty)); }

abstract production scopeMod
top::Scope ::= name::String
{ forwards to scope(datumMod(name)); }

--------------------------------------------------

abstract production datumVar
top::Datum ::= name::String ty::Type
{ forwards to datum(name); }

abstract production datumMod
top::Datum ::= name::String
{ forwards to datum(name); }
