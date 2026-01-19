grammar lmr2:lmr:nameanalysis5;

imports sg_lib3:src;

--

type LMScope = Decorated Scope with ScopeInhs;
type ScopeInhs = {lex, var, mod, imp};

inherited attribute lex::[LMScope] occurs on Scope;
inherited attribute var::[LMScope] occurs on Scope;
inherited attribute mod::[LMScope] occurs on Scope;
inherited attribute imp::[LMScope] occurs on Scope;

-- for graphviz
global allLabs::[Label<ScopeInhs>] = [
  labelLEX(), labelVAR(), labelMOD(), labelIMP()
];

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
  top.col = "red";
  top.demand = \s::LMScope -> s.var;
  forwards to label(); }

production labelMOD
top::Label<ScopeInhs> ::=
{ top.name = "MOD";
  top.col = "green3";
  top.demand = \s::LMScope -> s.mod;
  forwards to label(); }

production labelIMP
top::Label<ScopeInhs> ::=
{ top.name = "IMP";
  top.col = "blue";
  top.demand = \s::LMScope -> s.imp;
  forwards to label(); }

--

fun labelOrd Integer ::= left::Label<ScopeInhs> right::Label<ScopeInhs> =
  case left, right of

  | labelVAR(), labelLEX() -> -1 | labelLEX(), labelVAR() -> 1 -- VAR < LEX
  | labelVAR(), labelIMP() -> -1 | labelIMP(), labelVAR() -> 1 -- VAR < IMP

  | labelMOD(), labelLEX() -> -1 | labelLEX(), labelMOD() -> 1 -- MOD < LEX
  | labelMOD(), labelIMP() -> -1 | labelIMP(), labelMOD() -> 1 -- MOD < IMP

  | labelIMP(), labelLEX() -> -1 | labelLEX(), labelIMP() -> 1 -- IMP < LEX
  
  | _, _ -> 0 -- VAR = VAR, LEX = LEX, MOD = MOD, IMP = IMP
  
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
  \d::Decorated Datum ->
    case d of
    | datumVar(n, _) -> n == name
    | datumMod(n)    -> n == name
    | datumJust(n)   -> n == name 
    | _ -> false
    end
;