grammar lmr0:lmr:nameanalysis2;

--------------------------------------------------
-- Scopes

-- scope some_scope
abstract production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

-- scope some_scope -> (id, ty)
abstract production scopeVar
top::Scope ::= id::String ty::Type
{ forwards to scope(datumVar(id, ^ty)); }

--------------------------------------------------
-- Edges

-- some_scope -[ LEX ]-> tgt
abstract production lexEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("LEX", tgt); }

-- some_scope -[ VAR ]-> tgt
abstract production varEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("VAR", tgt); }

--------------------------------------------------
-- Data

-- (id, ty)
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