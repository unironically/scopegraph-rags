grammar statix_translate:driver;

imports statix_translate:lang:concretesyntax;
imports statix_translate:lang:abstractsyntax;

--import statix_translate:translation_two;
import statix_translate:to_ministatix;
import statix_translate:to_silver;

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
            print("[✔] Parse success\n");
            --print(ast.pp);
            --writeFile("ag.sv", ast.moduleTrans);
            
            hasOutDir::Boolean <- isDirectory("out");
            mkdirSucc::Boolean <- if hasOutDir then do {return true;} else mkdir("out");
            writeFile("out/statix-spec.mstx", ast.mstxPP);

            -- testing intermediate lang
            print("ord pp:\n" ++ lmOrd.ag_decl.pp ++ "\n");

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

global lmOrd::Order = 
  order(
    "lm",
    lexicoPathComp (
      labelLTsCons (
        label("VAR"), label("LEX"),
        labelLTsCons (
          label("VAR"), label("IMP"),
          labelLTsOne (
            label("IMP"),label("LEX")
          )
        )
      )
    )
  );