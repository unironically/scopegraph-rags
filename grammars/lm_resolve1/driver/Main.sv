grammar lm_resolve1:driver;

imports lm:driver;
imports lm:lang:concretesyntax;
imports lm:lang:abstractsyntax;

imports lm_resolve1:nameanalysis;

-- java -jar resolve1.driver.jar ../lmr/inputs/module-simple.lmr

function main
IO<Integer> ::= largs::[String]
{
  return do {
  
    -- Parse LMR
    let filePath :: String = head(largs);
    file :: String <- readFile(filePath);
    let result :: ParseResult<Main_c> = lm:driver:parse (file, filePath);
    let ast :: Main = result.parseTree.ast;

    
    if result.parseSuccess
      then do {
        --writeFile("StatixConstraints.md", implode("\n", ast.statixConstraints));
        writeStatixConstraints(filePath, file, ast.statixConstraints);
        writeSilverEquations(filePath, file, ast.silverEquations);
        print ("Success!\n" ++ ast.statix ++ "\n");
        printBinds (ast.binds);
        --printSg (ast.allScopes);
        return 0;
      }
      else do {print ("Failure!\n"); return -1;};

    return 0;
  };
}

fun writeStatixConstraints IO<Integer> ::= fname::String code::String cs::[String] = do {
  let toWrite::[String] =
    ("## Statix core constraints for " ++ fname ++ "\n") ::
    ("### Input program:\n```\n" ++ code ++ "\n```\n") ::
    ("### Constraints:\n```\n") ::
    (cs ++ ["\n```\n"]);
  writeFile("StatixConstraints.md", implode ("\n", toWrite));
};

fun writeSilverEquations IO<Integer> ::= fname::String code::String es::[String] = do {
  let toWrite::[String] =
    ("## Silver equations for " ++ fname ++ "\n") ::
    ("### Input program:\n```\n" ++ code ++ "\n```\n") ::
    ("### Equations:\n```\n") ::
    (es ++ ["\n```\n"]);
  writeFile("SilverEquations.md", implode ("\n", toWrite));
};



fun printBinds IO<Integer> ::= binds::[(String, String)] = do {
  let bindEachStr::[String] = map ((\p::(String, String) -> " - " ++ fst(p) ++ " |-> " ++ snd(p)), binds);
  let bindsStr::String = implode ("\n", bindEachStr);
  print("Bindings:\n" ++ bindsStr ++ "\n");
};


fun printSg IO<Integer> ::= scopes::[Decorated Scope] = do {
  print(implode("\n", map((.pp), scopes)) ++ "\n");
};