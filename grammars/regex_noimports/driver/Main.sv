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

    -- Program bindings
    print ("Bindings: " ++ printBinds (ast.binds) ++ "\n");

    return 0;
  };
}

function printBinds
String ::= binds::[(VarRef, Bind)]
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