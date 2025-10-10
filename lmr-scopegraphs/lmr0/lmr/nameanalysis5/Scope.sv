grammar lmr0:lmr:nameanalysis5;

imports sg_lib3:src; -- use of sg_lib3 requires sg_lib3 exporting this grammar

--------------------------------------------------

flowtype Scope = decorate {lex, var};

inherited attribute lex::[Decorated Scope] occurs on Scope;
inherited attribute var::[Decorated Scope] occurs on Scope;

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
{ forwards to datumJust(name); }

--------------------------------------------------

production labelLEX
top::Label ::=
{ top.name = "LEX";
  top.demand = \s::Decorated Scope -> s.lex;
  forwards to label(); }

production labelVAR
top::Label ::=
{ top.name = "VAR";
  top.demand = \s::Decorated Scope -> s.var;
  forwards to label(); }

--------------------------------------------------

-- descending path preference order: VAR < IMP < LEX
global labelOrd::[Label] = [labelVAR(), labelLEX()];

--------------------------------------------------

production regexLEX
top::Regex ::=
{ forwards to regexLabel(labelLEX()); }

production regexVAR
top::Regex ::=
{ forwards to regexLabel(labelVAR()); }

--------------------------------------------------

global varRx::Regex = 
  regexCat(
    regexStar(
      regexLEX()
    ),
    regexVAR()
  );

--------------------------------------------------

fun isName (Boolean ::= Datum) ::= name::String =
  \d::Datum ->
    case d of
    | datumVar(n, _) -> n == name
    | _ -> error("isName fell off for " ++ name)
    end;
