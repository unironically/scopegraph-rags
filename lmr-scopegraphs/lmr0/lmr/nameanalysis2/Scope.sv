grammar lmr0:lmr:nameanalysis2;

--------------------------------------------------
-- Scopes

abstract production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

abstract production scopeVar
top::Scope ::= id::String ty::Type
{ forwards to scope(datumVar(id, ^ty)); }

--------------------------------------------------
-- Edges

abstract production lexEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("LEX", tgt); }

abstract production varEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("VAR", tgt); }

--------------------------------------------------
-- Data

abstract production datumVar
top::Datum ::= id::String ty::Type
{ forwards to datumName(id); }

--------------------------------------------------
-- Regexes

global varRx::Regex =
  regexCat(
    regexStar(
      regexLab("LEX")
    ),
    regexLab("VAR")
  );

--------------------------------------------------
-- Predicates

fun isName (Boolean ::= Datum) ::= name::String = 
  \d::Datum -> 
    case d of
    | datumVar(dName, _) -> name == dName
    | _ -> false
    end 
;