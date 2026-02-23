grammar lmr0:lmr:nameanalysis6;

imports silver:compiler:extension:scopegraphs;


--

scope MyScope edges { lex, var, imp, mod };

fun isName Predicate ::= name::String =
  \d::Decorated Datum ->
    case d of
    | datumJust(n, _) -> n == name
    | datumNone() -> false
    end;