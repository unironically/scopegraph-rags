grammar regex_noimports:driver;

imports regex_noimports:resolution;

imports lmr:driver;
imports lmr:lang;

-- java -jar regex_noimports.driver.jar ../lmr/inputs/module-simple.lmr

function main
IO<Integer> ::= largs::[String]
{
  return do {
  
    -- Parse LMR
    let filePath :: String = head(largs);
    file :: String <- readFile(filePath);
    let result :: ParseResult<Program_c> = lmr:driver:parse (file, filePath);
    let ast :: Program = result.parseTree.ast;

    -- Program bindings
    print ("Bindings (name_line_col):\n" ++ printBinds (ast.binds) ++ "\n\n" ++ ast.pp);

    writeFile ("equations.md", implode ("\n", ("# Equations for " ++ filePath)::"### Program:\n```"::file::"\n```\n### AST:\n```"::ast.pp::"```\n"::"### Constraints:"::ast.constraints));

    return 0;
  };
}