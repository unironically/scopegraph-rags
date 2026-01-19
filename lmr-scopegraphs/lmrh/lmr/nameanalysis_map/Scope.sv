grammar lmrh:lmr:nameanalysis_map;

imports sg_lib4:src;

--------------------------------------------------
-- Scopes

abstract production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

abstract production scopeVar
top::Scope ::= id::String ty::Type
{ forwards to scope(datumVar(id, ^ty)); }

--------------------------------------------------
-- Labels

production lexLabel
top::Label ::=
{
  top.name = "LEX";
  top.demand = \s::Decorated Scope -> concat(s.edges.lookup("LEX"));
  forwards to label();
}

production varLabel
top::Label ::=
{
  top.name = "VAR";
  top.demand = \s::Decorated Scope -> concat(s.edges.lookup("VAR"));
  forwards to label();
}

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
      regexLabel(lexLabel())
    ),
    regexLabel(varLabel())
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
