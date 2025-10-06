grammar lmr2:lmr:nameanalysis2;

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

-- scope some_scope -> id
abstract production scopeMod
top::Scope ::= id::String
{ forwards to scope(datumMod(id)); }

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

-- id
abstract production datumMod
top::Datum ::= id::String
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

global modRx::Regex =
  regexCat(
    regexStar(
      regexLab("LEX")
    ),
    regexCat(
      regexOpt(
        regexLab("IMP")
      ),
      regexLab("MOD")
    )
  );

--------------------------------------------------
-- Predicates

fun isName (Boolean ::= Datum) ::= name::String = 
  \d::Datum -> 
    case d of
    | datumVar(dName, _) -> name == dName
    | datumMod(dName) -> name == dName
    | _ -> false
    end 
;