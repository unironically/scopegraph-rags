grammar lmr1:lmr:driver;

imports syntax:lmr1:lmr:driver;
imports syntax:lmr1:lmr:concretesyntax;
imports syntax:lmr1:lmr:abstractsyntax;

imports sg_lib3:src;
imports lmr1:lmr:nameanalysis5;

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

        --let viz::String = graphvizScopes(ast.allScopes);
        
        --print("----------\n");
        --print(viz);
        --print("----------\n");

        if result.parseSuccess
          then do {
            if length(fileNameExplode) >= 2 && last(fileNameExplode) == "lm"
              then do {
                print("[✔] Parse success\n");
                res::Integer <- programOk(ast.ok);
                let viz::String = vizStr(allLabs, ast.allScopes);
                mkdir("out");
                system("echo '" ++ viz ++ "' | dot -Tsvg > out/" ++ fileName ++ ".svg");
                --writeStatixConstraints(filePath, file, ast.flattened, "StatixConstraints");
                --writeSilverEquations(filePath, file, ast.equations, "SilverEquations");
                --writeSilverEquations(filePath, file, ast.equationsSolvedCopies, "SilverEquationsSolvedCopies");
                --writeJastEquations(filePath, file, ast.jastEquations);
                --writeStatixAterm(fileName, ast.statix);
                return res;
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
  mkdir("out");
  writeFile("out/" ++ fileN ++ ".aterm", aterm ++ "\n");
  print("[✔] See out/" ++ fileN ++ ".aterm for the resulting Ministatix term\n");
};

fun writeStatixConstraints IO<Unit> ::= fname::String code::String cs::[String] outFName::String = do {
  mkdir("out");
  let nonCommentList::[String] = filter((\s::String -> !startsWith("--", s)), cs);
  let numberedLines::[String] = snd(foldr(eqsNumbered, (length(nonCommentList), []), cs));
  let toWrite::[String] =
    ("## Statix core constraints for " ++ fname ++ "\n") ::
    ("### Input program:\n```" ++ code ++ "```\n") ::
    ("### Constraints:\n```") ::
    (numberedLines ++ ["```\n"]);
  writeFile("out/" ++ outFName ++ ".md", implode("\n", toWrite));
  print("[✔] See out/" ++ outFName ++ ".md for the resulting flattened Statix constraints\n");
};

fun writeGraphViz IO<Unit> ::= fname::String vizStr::String = do {
  mkdir("out");
  system("echo '" ++ vizStr ++ "' | dot -Tsvg > out/" ++ fname ++ ".svg");
  return ();
};

fun writeSilverEquations IO<Unit> ::= fname::String code::String es::[String] outFName::String = do {
  mkdir("out");
  let nonCommentList::[String] = filter((\s::String -> !startsWith("--", s)), es);
  let numberedLines::[String] = snd(foldr(eqsNumbered, (length(nonCommentList), []), es));
  let toWrite::[String] =
    ("## Silver equations for " ++ fname ++ "\n") ::
    ("### Input program:\n```" ++ code ++ "```\n") ::
    ("### Equations:\n```") ::
    (numberedLines ++ ["```\n"]);
  writeFile("out/" ++ outFName ++ ".md", implode("\n", toWrite));
  print("[✔] See out/" ++ outFName ++ ".md for the resulting flattened Silver equations\n");
};

{-fun writeJastEquations IO<Integer> ::= fname::String code::String es::[String] = do {
  mkdir("out");
  let numberedLines::[String] = snd(foldr(eqsNumbered, (length(es), []), es));
  let toWrite::[String] =
    ("## Jast equations for " ++ fname ++ "\n") ::
    ("### Input program:\n```\n" ++ code ++ "\n```\n") ::
    ("### Equations:\n```\n") ::
    (numberedLines ++ ["\n```\n"]);
  writeFile("out/JastEquations.md", implode("\n", toWrite));
  print("[✔] See out/JastEquations.md for the resulting flattened Silver equations\n");
};-}

fun printBinds IO<Integer> ::= binds::[(String, String)] = do {
  let bindEachStr::[String] = map((\p::(String, String) -> "\t" ++ fst(p) ++ "\t-[binds to]->\t" ++ snd(p)), binds);
  let bindsStr::String = implode("\n", bindEachStr);
  let anyUnfound::Boolean = length(filter((\p::(String, String) -> snd(p) == "?"), binds)) != 0;
  print("[" ++ (if anyUnfound then "✗" else "✔") ++ "] Resulting program bindings:\n" ++ bindsStr ++ "\n");
  return if anyUnfound then -1 else 0;
};

fun programOk IO<Integer> ::= ok::Boolean = do {
  print(if ok then "[✔] Semantic check successful\n" else "[✗] Semantic check failed\n");
  return if ok then 0 else -1;
};

fun eqsNumbered(Integer, [String]) ::= line::String acc::(Integer, [String]) =
  if startsWith("--", line)
  then
    (fst(acc), ("     " ++ line)::snd(acc))
  else
    let num::Integer = fst(acc) in
    let numStr::String = toString(fst(acc)) in
    let numPad::String = 
      (if num < 10 
      then "00" ++ numStr 
      else if num < 100 
      then "0" ++ numStr
      else numStr)
    in
      (num - 1, (numPad ++ ": " ++ line)::snd(acc))
    end end end;