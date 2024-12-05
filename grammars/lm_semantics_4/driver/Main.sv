grammar lm_semantics_4:driver;

imports lm_syntax_2:driver;
imports lm_syntax_2:lang:concretesyntax;
imports lm_syntax_2:lang:abstractsyntax;

imports lm_semantics_4:nameanalysis;
imports sg_lib;

function main
IO<Integer> ::= largs::[String]
{
  return
    if !null(largs)
      then do {
        let filePath :: String = head(largs);
        file :: String <- readFile(head(largs));

        let fileName::String = head(explode(".", last(explode("/", filePath))));

        let result :: ParseResult<Main_c> = lm_syntax_2:driver:parse(file, filePath);
        let ast :: Main = result.parseTree.ast;

        let fileNameExt::String = last(explode("/", filePath));
        let fileNameExplode::[String] = explode(".", fileNameExt);
        let fileName::String = head(fileNameExplode);

        let viz::String = graphvizScopes(ast.allScopes);--, ast.allRefs);

        if result.parseSuccess
          then do {
            if length(fileNameExplode) >= 2 && last(fileNameExplode) == "lm"
              then do {
                print("[✔] Parse success\n");
                mkdir("out");
                system("echo '" ++ viz ++ "' | dot -Tsvg > out/" ++ fileName ++ ".svg");
                writeStatixConstraints(filePath, file, ast.statixConstraints);
                writeStatixConstraints2(filePath, file, ast.statixConstraintsTwo);
                --writeSilverEquations(filePath, file, ast.silverEquations);
                --writeJastEquations(filePath, file, ast.jastEquations);
                writeStatixAterm(fileName, ast.statix);
                --printBinds(ast.binds);
                --programOk(ast.ok);
                writeJava(fileName, ast.java);
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

fun writeJava IO<Unit> ::= fileN::String java::[String] = do {
  let imploded::String = implode("\n", java);
  writeFile("out/java_" ++ fileN ++ ".txt", imploded ++ "\n");
  print("[✔] See out/java_" ++ fileN ++ ".txt for the resulting Java ast\n");
};


fun writeStatixConstraints IO<Unit> ::= fname::String code::String cs::[String] = do {
  let numberedLines::[String] = snd(foldr(eqsNumbered, (length(cs), []), cs));
  let toWrite::[String] =
    ("## Statix core constraints for " ++ fname ++ "\n") ::
    ("### Input program:\n```\n" ++ code ++ "\n```\n") ::
    ("### Constraints:\n```") ::
    (numberedLines ++ ["```\n"]);
  writeFile("out/StatixConstraints.md", implode("\n", toWrite));
  print("[✔] See out/SilverEquations.md for the resulting flattened Statix constraints\n");
};

fun writeStatixConstraints2 IO<Unit> ::= fname::String code::String cs::[String] = do {
  let numberedLines::[String] = snd(foldr(eqsNumbered, (length(cs), []), cs));
  let toWrite::[String] =
    ("## Statix core constraints 2 for " ++ fname ++ "\n") ::
    ("### Input program:\n```\n" ++ code ++ "\n```\n") ::
    ("### Constraints 2:\n```") ::
    (numberedLines ++ ["```\n"]);
  writeFile("out/StatixConstraints2.md", implode("\n", toWrite));
  print("[✔] See out/SilverEquations2.md for the resulting flattened Statix constraints 2\n");
};

{-fun writeSilverEquations IO<Integer> ::= fname::String code::String es::[String] = do {
  let numberedLines::[String] = snd(foldr(eqsNumbered, (length(es), []), es));
  let toWrite::[String] =
    ("## Silver equations for " ++ fname ++ "\n") ::
    ("### Input program:\n```\n" ++ code ++ "\n```\n") ::
    ("### Equations:\n```\n") ::
    (numberedLines ++ ["\n```\n"]);
  writeFile("out/SilverEquations.md", implode("\n", toWrite));
  print("[✔] See out/SilverEquations.md for the resulting flattened Silver equations\n");
};

fun writeJastEquations IO<Unit> ::= fname::String code::String es::[String] = do {
  let numberedLines::[String] = snd(foldr(eqsNumbered, (length(es), []), es));
  let toWrite::[String] =
    ("## Jast equations for " ++ fname ++ "\n") ::
    ("### Input program:\n```\n" ++ code ++ "\n```\n") ::
    ("### Equations:\n```\n") ::
    (numberedLines ++ ["\n```\n"]);
  writeFile("out/JastEquations.md", implode("\n", toWrite));
  print("[✔] See out/JastEquations.md for the resulting flattened Silver equations\n");
};-}


fun printBinds IO<Unit> ::= binds::[(String, String)] = do {
  let bindEachStr::[String] = map((\p::(String, String) -> "\t" ++ fst(p) ++ "\t-[binds to]->\t" ++ snd(p)), binds);
  let bindsStr::String = implode("\n", bindEachStr);
  let anyUnfound::Boolean = length(filter((\p::(String, String) -> snd(p) == "?"), binds)) != 0;
  print("[" ++ (if anyUnfound then "✗" else "✔") ++ "] Resulting program bindings:\n" ++ bindsStr ++ "\n");
};

fun programOk IO<Unit> ::= ok::Boolean = do {
  print(if ok then "[✔] Program is well-typed\n" else "[✗] Program is not well-typed [TODO: better messages..]\n");
};

fun eqsNumbered(Integer, [String]) ::= line::String acc::(Integer, [String]) =
  let num::Integer = fst(acc) in
  let numStr::String = toString(fst(acc)) in
  let numPad::String = if num < 10 then "0" ++ numStr else numStr in
    (num - 1, (numPad ++ ": " ++ line)::snd(acc))
  end end end;