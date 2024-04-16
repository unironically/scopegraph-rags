grammar lmr_scopefunctions:driver;

imports lmr_scopefunctions:resolution;

imports lmr:driver;
imports lmr:lang;

-- java -jar lmr_scopefunctions.driver.jar ../lmr/inputs/module-simple.lmr

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
    print ("Bindings (name_line_col):\n" ++ printBinds (ast.binds) ++ "\n");

    return 0;
  };
}