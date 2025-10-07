grammar lmr0:lmr:nameanalysis1;

--------------------------------------------------

abstract production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

abstract production scopeVar
top::Scope ::= name::String ty::Type
{ forwards to scope(datumVar(name, ^ty)); }

--------------------------------------------------

abstract production datumVar
top::Datum ::= name::String ty::Type
{ forwards to datum(name); }
