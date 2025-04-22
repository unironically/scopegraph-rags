grammar statix_trans;

function main
IO<Integer> ::= largs::[String]
{
  return do {

    ret::Integer <-
      if bad_module_simple_add.ok
      then do {
        print("Done with outer.ok = true\n");
        return 0;
      }
      else do {
        print("Done with outer.ok = false\n");
        return 0;
      };

    return ret;

  };

}

-- mod A { def y = true + 1 }
global bad_module_simple_add::Nt_main =
  pf_Program (
    pf_DeclsCons(
      pf_DeclModule(
        "A",
        pf_DeclsCons(
          pf_DeclDef(
            pf_DefBindPar("y", 
              pf_ExprAdd(
                pf_ExprTrue(),
                pf_ExprInt("1")
              )
            )
          ),
          pf_DeclsNil()
        )
      ),
      pf_DeclsNil()
    )
  );