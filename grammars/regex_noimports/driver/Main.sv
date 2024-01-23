grammar regex_noimports:driver;

imports regex_noimports:resolution;

imports lmr:driver;
imports lmr:lang;

-- java -jar regex_noimports.driver.jar ../lmr/inputs/module-simple.lmr

function main
IO<Integer> ::= largs::[String]
{
  -- return lmr:driver:main (largs);

  return do {
    
    -- Parse LMR
    let filePath :: String = head(largs);
    file :: String <- readFile(filePath);
    let result :: ParseResult<Program_c> = lmr:driver:parse (file, filePath);
    let ast :: Program = result.parseTree.ast;

    -- Test regex + DFA
    let r1::Decorated Regex = decorate regexSingle(labelLex()) with {};
    let r2::Decorated Regex = decorate regexSingle(labelVar()) with {};
    let r1star::Decorated Regex = decorate regexStar (r1) with {};
    let r2star::Decorated Regex = decorate regexStar (r2) with {};
    let regex::Decorated Regex = decorate regexCat (r1, r2star) with {};
    let dfa::DFA = regex.dfa;
    let dfaTrans::[(Integer, Label, Integer)] = fst (snd (dfa));

    -- Prints
    --print ("DFA States: " ++ toString(printIntLst(fst(dfa))) ++ "\n");
    --print ("DFA Trans: " ++ printDFATrans (dfaTrans) ++ "\n");
    --print ("DFA Start: " ++ toString(fst(snd(snd(dfa)))) ++ "\n");
    --print ("DFA End: " ++ printIntLst (snd(snd(snd(dfa)))) ++ "\n");

    --print ("Sort: " ++ printIntLst(sortBy((\i1::Integer i2::Integer -> i1 < i2), [4,2,4,51,6,3,0])));

    -- monoid attribute binds::[(VarRef, Decl)] with [], ++

    print ("Bindings: " ++ printBinds (ast.binds) ++ "\n");

    return 0;
  };
}

function printBinds
String ::= binds::[(VarRef, Decl)]
{
  return
    case binds of
      [] -> ""
    | (v,d)::t -> "(" ++ v.refname ++ ", " ++ d.defname ++ "), " ++ printBinds(t)
    end;
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