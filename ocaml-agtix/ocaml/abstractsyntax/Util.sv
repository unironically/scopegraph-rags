grammar ocaml:abstractsyntax;

--

fun isName (Boolean ::= Datum) ::= s::String =
  \d::Datum ->
    case d of
    | datumTypeDef(name, _) -> s == name
    | datumConstructor(name, _, _) -> s == name
    | datumPatternVar(name, _) -> s == name
    | datumLetVar(name, _) -> s == name
    | _ -> false
    end
;

fun getName String ::= s::Decorated Scope with Labs =
    case s.datum of
    | datumTypeDef(name, _) -> name
    | datumConstructor(name, _, _) -> name
    | datumPatternVar(name, _) -> name
    | datumLetVar(name, _) -> name
    | _ -> error("getName with unnamed datum")
    end
;

fun getLoc Location ::= s::Decorated Scope with Labs =
    case s.datum of
    | datumTypeDef(_, node) -> node.location
    | datumConstructor(_, _, node) -> node.location
    | datumPatternVar(_, node) -> node.location
    | datumLetVar(_, node) -> bogusLoc()
    | _ -> error("getLoc with unnamed datum")
    end
;

fun any (Boolean ::= Datum) ::= = \_ -> true;

fun genPattVarResMsg String ::= x::String ss::[Decorated Scope with Labs] =
  "Resolved " ++ x ++ " to pattern variables:\n" ++
  implode("\n", map(\s::Decorated Scope with Labs ->"- " ++ x ++ " at " ++ getLoc(s).unparse, ss)) ++
  "\n"
;

fun allPatternVar Boolean ::= vars::[Decorated Scope with Labs] = 
  foldr(\s::Decorated Scope with Labs acc::Boolean -> acc &&
          case s.datum of datumPatternVar(_, _) -> true | _ -> false end,
        true, vars);

fun allSameType Boolean ::= vars::[Decorated Scope with Labs] =
  length(nub(map(\s::Decorated Scope with Labs ->
                    case s.datum of
                      datumPatternVar(_, node) -> node.patternType
                    | _ -> error("Impossible")
                    end, vars))) == 1;