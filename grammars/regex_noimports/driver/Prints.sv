grammar regex_noimports:driver;

{- Program bindings -}

function printBinds
String ::= binds::[(Either<VarRef ModRef>, Bind)]
{
  return
    case binds of
      [] -> ""
    | b::[] -> "\t" ++ printBind (b)
    | b::t -> "\t" ++ printBind (b) ++ "\n" ++ printBinds (t)
    end;
}

function printBind
String ::= bind::(Either<VarRef ModRef>, Bind)
{
  return 
    "ref " ++ (case fst(bind) of left(v) -> v.label | right(v) -> v.label end) ++ 
    " resolves to decl " ++ snd(bind).label;
}

{- Automaton -}

function printNFATrans
String ::= trans::[(Integer, Maybe<Label>, Integer)]
{
  return
    case trans of
      (start, nothing(), final)::t -> "\t(" ++ toString (start) ++ ", " ++ "eps, " ++ toString (final) ++ "), " ++ printNFATrans (t)
    | (start, just(l), final)::t -> "(" ++ toString (start) ++ ", " ++ l.pp ++ ", " ++ toString (final) ++ "), " ++ printNFATrans (t)
    | [] -> ""
    end;
}

function printDFATrans
String ::= trans::[(Integer, Label, Integer)]
{
  return
    printNFATrans (map ((\p::(Integer, Label, Integer) -> (fst(p), just (fst(snd(p))), snd(snd(p))) ), trans));
}

function printIntLst
String ::= ints::[Integer]
{
  return 
    "[" ++ concat (map ((\i::Integer -> toString(i) ++ ","), ints)) ++ "]";
}