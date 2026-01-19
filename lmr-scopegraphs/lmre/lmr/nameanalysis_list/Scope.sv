grammar lmre:lmr:nameanalysis_list;

--------------------------------------------------
-- Scopes

{-
abstract production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

abstract production scopeVar
top::Scope ::= id::String ty::Type
{ forwards to scope(datumVar(id, ^ty)); }
-}

abstract production scopeMod
top::Scope ::= id::String
{ forwards to scope(datumMod(id)); }

--------------------------------------------------
-- Edges

{-
abstract production lexEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("LEX", tgt); }

abstract production varEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("VAR", tgt); }
-}

abstract production modEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("MOD", tgt); }

abstract production impEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("IMP", tgt); }

--------------------------------------------------
-- Data

{-
abstract production datumVar
top::Datum ::= id::String ty::Type
{ forwards to datumName(id); }
-}

abstract production datumMod
top::Datum ::= id::String
{ forwards to datumName(id); }

--------------------------------------------------
-- Regexes

{-
global varRx::Regex =
  regexCat(
    regexStar(
      regexLab("LEX")
    ),
    regexLab("VAR")
  );
-}

global newVarRx::Regex =
  regexCat(
    regexStar(
      regexLab("LEX")
    ),
    regexCat(
      regexOpt(regexLab("IMP")),
      regexLab("VAR")
    )
  );

global impRx::Regex =
  regexCat(
    regexStar(
      regexLab("LEX")
    ),
    regexCat(
      regexOpt(regexLab("IMP")),
      regexLab("MOD")
    )
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