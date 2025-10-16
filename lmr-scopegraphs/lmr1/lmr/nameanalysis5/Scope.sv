grammar lmr1:lmr:nameanalysis5;

imports sg_lib3:src;

--

type LMScope = Decorated Scope with ScopeInhs;
type ScopeInhs = {lex, var, mod, imp};

inherited attribute lex::[LMScope] occurs on Scope;
inherited attribute var::[LMScope] occurs on Scope;
inherited attribute mod::[LMScope] occurs on Scope;
inherited attribute imp::[LMScope] occurs on Scope;
--

production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

production scopeVar
top::Scope ::= name::String ty::Type
{ forwards to scope(datumVar(name, ^ty)); }

production scopeMod
top::Scope ::= name::String
{ forwards to scope(datumMod(name)); }

--

production datumVar
top::Datum ::= name::String ty::Type
{ forwards to datumJust(name); }

production datumMod
top::Datum ::= name::String
{ forwards to datumJust(name); }

--

production labelLEX
top::Label<ScopeInhs> ::=
{ top.name = "LEX";
  top.demand = \s::LMScope -> s.lex;
  forwards to label(); }

production labelVAR
top::Label<ScopeInhs> ::=
{ top.name = "VAR";
  top.demand = \s::LMScope -> s.var;
  forwards to label(); }

production labelMOD
top::Label<ScopeInhs> ::=
{ top.name = "MOD";
  top.demand = \s::LMScope -> s.mod;
  forwards to label(); }

production labelIMP
top::Label<ScopeInhs> ::=
{ top.name = "IMP";
  top.demand = \s::LMScope -> s.imp;
  forwards to label(); }

--

fun labelOrd Boolean ::= left::Label<i> right::Label<i> =
  case left, right of
  | labelVAR(), _ -> true | _, labelVAR() -> false -- VAR < *
  | labelMOD(), _ -> true | _, labelMOD() -> false -- MOD < *
  | labelIMP(), _ -> true | _, labelIMP() -> false -- IMP < LEX
  | _, _ -> false
  end
;

--

production regexLEX
top::Regex<ScopeInhs> ::=
{ forwards to regexLabel(labelLEX()); }

production regexVAR
top::Regex<ScopeInhs> ::=
{ forwards to regexLabel(labelVAR()); }

production regexMOD
top::Regex<ScopeInhs> ::=
{ forwards to regexLabel(labelMOD()); }

production regexIMP
top::Regex<ScopeInhs> ::=
{ forwards to regexLabel(labelIMP()); }

--

global varRx::Regex<ScopeInhs> = 
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

global modRx::Regex<ScopeInhs> = 
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

--

fun isName Predicate ::= name::String =
  \d::Datum ->
    case d of
    | datumVar(n, _) -> n == name
    | datumMod(n)    -> n == name
    | datumJust(n)   -> n == name 
    | _ -> false
    end
;