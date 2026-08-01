grammar ocaml:driver;

imports ocaml:concretesyntax;
imports ocaml:abstractsyntax;

parser parse::Root_c {
  ocaml:concretesyntax;
}

fun main IO<Integer> ::= largs::[String] =
  if !null(largs)
  then do {
    let filePath :: String = head(largs);
    file :: String <- readFile(head(largs));
    let result :: ParseResult<Root_c> = parse(file, filePath);
    let ast :: Root = result.parseTree.ast;
    if result.parseSuccess
    then do {
      --print("[✔] Parse success\n");
      if null(ast.errs)
      then do {
        --print("[✔] Semantic check success\n");
        return 0;
      }
      else do {
        print("[✗] Type checking failed with the following errors:\n" ++
              concat(map((.pp), ast.errs)));
        return -1;
      };
    }
    else do {
      print("[✗] Parse failure\n" ++ result.parseErrors);
      return -1;
    };
  }
  else do {
    print("[✗] No input file given\n");
    return -1;
  };
