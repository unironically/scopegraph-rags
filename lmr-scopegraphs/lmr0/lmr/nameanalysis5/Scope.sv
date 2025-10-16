grammar lmr0:lmr:nameanalysis5;

imports sg_lib3:src;

--

type LMScope = Decorated Scope with ScopeInhs;
type ScopeInhs = {lex, var};

inherited attribute lex::[LMScope] occurs on Scope;
inherited attribute var::[LMScope] occurs on Scope;

--

production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

production scopeVar
top::Scope ::= name::String ty::Type
{ forwards to scope(datumVar(name, ^ty)); }

--

production datumVar
top::Datum ::= name::String ty::Type
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

--

fun labelOrd Boolean ::= left::Label<i> right::Label<i> =
  case left, right of
  | labelVAR(), _ -> true -- VAR < *
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

--

global varRx::Regex<ScopeInhs> = 
  regexCat(
    regexStar(
      regexLEX()
    ),
    regexVAR()
  );

--

fun isName Predicate ::= name::String =
  \d::Datum ->
    case d of
    | datumVar(n, _) -> n == name
    | datumJust(n)   -> n == name 
    | _ -> false
    end
;