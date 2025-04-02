grammar statix_translate:driver;

imports statix_translate:lang:concretesyntax;
imports statix_translate:lang:abstractsyntax;

imports statix_translate:lang:analysis;

imports statix_translate:to_ministatix;
imports statix_translate:to_silver;

parser parse :: Module_c { statix_translate:lang:concretesyntax; }

function main
IO<Integer> ::= largs::[String]
{
  return
    if !null(largs)
      then do {
        let filePath :: String = head(largs);
        file :: String <- readFile(head(largs));

        let result :: ParseResult<Module_c> = parse(file, filePath);
        let ast :: Module = result.parseTree.ast;

        let fileNameExt::String = last(explode("/", filePath));
        let fileNameExplode::[String] = explode(".", fileNameExt);
        let fileName::String = head(fileNameExplode);

        if result.parseSuccess
          then do {
            --print("[✔] Parse success\n");
            --print(ast.pp);
            --writeFile("ag.sv", ast.moduleTrans);

            code::Integer <-
              if (null(ast.errs))
              then do {
                return 0;
              }
              else do {
                printErrs(ast.errs);
               return -1;
              };
            
            --hasOutDir::Boolean <- isDirectory("out");
            --mkdirSucc::Boolean <- if hasOutDir then do {return true;} else mkdir("out");
            --writeFile("out/statix-spec.mstx", ast.mstxPP);

            --return 0; 

            return code;
          }
          else do {
            print("[✗] Parse failure\n");
            print(result.parseErrors);
            return -1;
          };
      }
      else do {
        print("[✗] No input file given\n");
            return -1;
      };
}

function printErrs
IO<Unit> ::= msgs::[Error]
{
  return print (
    implode ("\n", map ((.msg), msgs)) ++ "\n"
  );
}