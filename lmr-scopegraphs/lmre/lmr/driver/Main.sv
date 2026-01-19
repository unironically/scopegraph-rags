grammar lmre:lmr:driver;

imports lmre:lmr:syntax;
imports lmre:lmr:nameanalysis_map;

--

parser parse :: Main_c {
  lmre:lmr:syntax;
}

--

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
                res::Integer <- programOk(ast.ok);
                return res;
              }
              else do {
                print("[✗] Expected an input file of form [file name].lm\n");
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
}

fun programOk IO<Integer> ::= ok::Boolean = do {
  print(if ok then "[✔] Semantic check successful\n" else "[✗] Semantic check failed\n");
  return if ok then 0 else -1;
};
