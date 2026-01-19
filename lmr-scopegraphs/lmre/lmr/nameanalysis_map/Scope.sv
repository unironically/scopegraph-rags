grammar lmre:lmr:nameanalysis_map;

imports sg_lib4:src;

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
-- Labels

{-
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
-}

production modLabel
top::Label ::=
{
  top.name = "MOD";
  top.demand = \s::Decorated Scope -> concat(s.edges.lookup("MOD"));
  forwards to label();
}

production impLabel
top::Label ::=
{
  top.name = "IMP";
  top.demand = \s::Decorated Scope -> concat(s.edges.lookup("IMP"));
  forwards to label();
}

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
      regexLabel("LEX")
    ),
    regexLabel("VAR")
  );
-}

global newVarRx::Regex =
  regexCat(
    regexStar(
      regexLabel(lexLabel())
    ),
    regexCat(
      regexLabel(impLabel()), -- no option here, host var rx already resolves using no IMP labs
      regexLabel(varLabel())
    )
  );

global impRx::Regex =
  regexCat(
    regexStar(
      regexLabel(lexLabel())
    ),
    regexCat(
      regexMaybe(regexLabel(impLabel())), -- option here, no host import res rx exists
      regexLabel(modLabel())
    )
  );

--------------------------------------------------
-- Predicates

fun isName (Boolean ::= Datum) ::= name::String = 
  \d::Datum -> 
    case d of
    | datumVar(dName, _) -> name == dName
    | datumMod(mName) -> name == mName
    | _ -> false
    end 
;