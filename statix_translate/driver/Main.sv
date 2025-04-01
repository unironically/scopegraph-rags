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
            writeFile ("out/trans_testing.txt",
              implode("\n\n", [
                "ord pp:\n" ++ lmOrd.ag_decl.pp,
                "exists pp:\n" ++ implode("\n", map((.pp), exists.equations)),
                "edge pp:\n" ++ implode("\n", map((.pp), edge.equations)),
                "funappTgt pp:\n" ++ implode("\n", map((.pp), funAppTgt.equations)),
                "funappExtend pp:\n" ++ implode("\n", map((.pp), funAppExtend.equations)),
                "funAppGiveNewScope pp:\n" ++ implode("\n", map((.pp), funAppGiveNewScope.equations))
              ])
            );

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

global funAppTgt::Decorated Constraint =
  decorate
    applyConstraint (
      "tgt",
      refNameListCons("p'", refNameListOne("s'"))
    )
  with { nameTyDecls = [];
         predsInh    = [
           funPredInfo ("tgt", [("p", nameType("path"), 0)], [("s", nameType("scope"), 1)])
         ];
       };

global funAppExtend::Decorated Constraint =
  decorate
    applyConstraint (
      "extend",
      refNameListOne("s")
    )
  with { nameTyDecls = [];
         predsInh    = [
           funPredInfo ("extend", [("s1", nameType("scope"), 0)], [])
         ];
       };

global funAppGiveNewScope::Decorated Constraint =
  decorate
    applyConstraint (
      "give-new-scope",
      refNameListCons("s_glob", refNameListOne("s_new"))
    )
  with { nameTyDecls = [];
         predsInh    = [
           funPredInfo ("give-new-scope", 
                        [("s", nameType("scope"), 0)], 
                        [("s'", nameType("scope"), 1)])
         ];
       };

global exists::Decorated Constraint = 
  decorate
    existsConstraint(
      nameListCons (
        nameUntagged (
          "a",
          nameType("scope")
        ),
        nameListCons (
          nameUntagged (
            "b",
            listType(nameType("datum"))
          ),
          nameListNil()
        )
      ),
      conjConstraint(
        trueConstraint(),
        eqConstraint(
          nameTerm("a"),
          nameTerm("b")
        )
      )
    )
  with { nameTyDecls = []; 
         predsInh    = []; 
       };

global edge::Decorated Constraint =
  decorate
    edgeConstraint (
      "s",
      labelTerm(label("VAR")),
      "s_var"
    )
  with { nameTyDecls = []; 
         predsInh    = []; 
       };