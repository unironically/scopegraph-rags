grammar lm_syntax_2:driver;

imports lm_syntax_2:lang:concretesyntax;
imports lm_syntax_2:lang:abstractsyntax;

parser parse :: Main_c {
  lm_syntax_2:lang:concretesyntax;
}

function main
IO<Integer> ::= largs::[String]
{
  return
    if !null(largs)
      then do {
        let filePath :: String = head(largs);
        file :: String <- readFile(head(largs));

        let fileName::String = head(explode(".", last(explode("/", filePath))));

        let result :: ParseResult<Main_c> = parse(file, filePath);
        let ast :: Main = result.parseTree.ast;

        let fileNameExt::String = last(explode("/", filePath));
        let fileNameExplode::[String] = explode(".", fileNameExt);
        let fileName::String = head(fileNameExplode);

        if result.parseSuccess
          then do {
            if length(fileNameExplode) >= 2 && last(fileNameExplode) == "lm"
              then do {
                print("[✔] Parse success\n");
                writeStatixAterm(fileName, ast.statix);
                return 0;
              }
              else do {
                print("[✗] Expected an input file of form [file name].lm\n");
                return -1;
              };
          }
          else do {
            print("[✗] Parse failure\n");
            return -1;
          };
      }
      else do {
        print("[✗] No input file given\n");
            return -1;
      };
}

fun writeStatixAterm IO<Unit> ::= fileN::String aterm::String = do {
  writeFile("out/" ++ fileN ++ ".aterm", aterm ++ "\n");
  print("[✔] See out/" ++ fileN ++ ".aterm for the resulting Ministatix term\n");
};