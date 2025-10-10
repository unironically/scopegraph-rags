grammar lmr1:lmr:nameanalysis5;

imports sg_lib3:src; -- use of sg_lib3 requires sg_lib3 exporting this grammar

--------------------------------------------------

flowtype Scope = decorate {lex, var, mod, imp};

inherited attribute lex::[Decorated Scope] occurs on Scope;
inherited attribute var::[Decorated Scope] occurs on Scope;
inherited attribute mod::[Decorated Scope] occurs on Scope;
inherited attribute imp::[Decorated Scope] occurs on Scope;

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
{ forwards to datumJust(name); }

abstract production datumMod
top::Datum ::= name::String
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

production labelMOD
top::Label ::=
{ top.name = "MOD";
  top.demand = \s::Decorated Scope -> s.mod;
  forwards to label(); }

production labelIMP
top::Label ::=
{ top.name = "IMP";
  top.demand = \s::Decorated Scope -> s.imp;
  forwards to label(); }

--------------------------------------------------

-- descending path preference order: VAR < IMP < LEX
global labelOrd::[Label] = [labelVAR(), labelMOD(), labelIMP(), labelLEX()];

--------------------------------------------------

production regexLEX
top::Regex ::=
{ forwards to regexLabel(labelLEX()); }

production regexVAR
top::Regex ::=
{ forwards to regexLabel(labelVAR()); }

production regexMOD
top::Regex ::=
{ forwards to regexLabel(labelMOD()); }

production regexIMP
top::Regex ::=
{ forwards to regexLabel(labelIMP()); }

--------------------------------------------------

global varRx::Regex = 
  regexCat(
    regexStar(
      regexLEX()
    ),
    regexCat(
      regexMaybe(
        regexIMP()
      ),
      regexVAR()
    )
  );

global modRx::Regex = 
  regexCat(
    regexStar(
      regexLEX()
    ),
    regexCat(
      regexMaybe(
        regexIMP()
      ),
      regexMOD()
    )
  );

--------------------------------------------------

fun isName (Boolean ::= Datum) ::= name::String =
  \d::Datum ->
    case d of
    | datumVar(n, _) -> n == name
    | datumMod(n) -> n == name
    | _ -> error("isName fell off for " ++ name)
    end;
