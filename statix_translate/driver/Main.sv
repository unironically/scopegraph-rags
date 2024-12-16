grammar statix_translate:driver;

imports statix_translate:lang:concretesyntax;
imports statix_translate:lang:abstractsyntax;

import statix_translate:translation;
import statix_translate:to_ministatix;

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
            print(ast.moduleTrans);
            --print(ast.mstxPP);
            return 0;
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