grammar regex_noimports:driver;

imports regex_noimports:resolution;
imports lmr:lang;

function main
IO<Integer> ::= largs::[String]
{
  return do {
    
    {- NFA -}

    let r1::Decorated Regex = decorate regexSingle(labelLex()) with {};
    let r2::Decorated Regex = decorate regexSingle(labelVar()) with {};
    let r1star::Decorated Regex = decorate regexStar (r1) with {};
    let regex::Decorated Regex = decorate regexCat (r1star, r2) with {};

    print ("NFA States: " ++ printIntLst (fst(regex.nfa)) ++ "\n");
    print ("NFA Trans: " ++ printNFATrans (fst(snd(regex.nfa))) ++ "\n");
    print ("NFA Start: " ++ toString (fst (snd(snd(regex.nfa)))) ++ "\n");
    print ("NFA End: " ++ toString (snd (snd(snd(regex.nfa)))) ++ "\n");

    print ("\n");

    {- DFA -}

    let dfa::DFA = nfaToDFA (regex.nfa);

    let dfaTrans::[(Integer, Label, Integer)] = fst (snd (dfa));

    print ("DFA States: " ++ toString(printIntLst(fst(dfa))) ++ "\n");
    print ("DFA Trans: " ++ printDFATrans (dfaTrans) ++ "\n");
    print ("DFA Start: " ++ toString(fst(snd(snd(dfa)))) ++ "\n");
    print ("DFA End: " ++ printIntLst (snd(snd(snd(dfa)))) ++ "\n");

    return 0;
  };
}

function printIntLst
String ::= ints::[Integer]
{
  return 
    "[" ++ concat (map ((\i::Integer -> toString(i) ++ ","), ints)) ++ "]";
}

function printNFATrans
String ::= trans::[(Integer, Maybe<Label>, Integer)]
{
  return
    case trans of
      (start, nothing(), final)::t -> "(" ++ toString (start) ++ ", " ++ "eps, " ++ toString (final) ++ "), " ++ printNFATrans (t)
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