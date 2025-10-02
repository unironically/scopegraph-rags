grammar statix_trans;

function main
IO<Integer> ::= largs::[String]
{
  return do {

    ret::Integer <-
      if imp_par_not_seq.ok
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

global imp_par_not_seq::Nt_main =
  pf_Program (
    pf_DeclsCons(
      pf_DeclModule(
        "A",
        pf_DeclsCons(
          pf_DeclDef(pf_DefBindPar("x", pf_ExprInt("1"))),
          pf_DeclsNil()
        )
      ),
      pf_DeclsCons (
        pf_DeclModule(
          "B",
          pf_DeclsCons(
            pf_DeclImport(
              pf_ModRef("A")
            ),
            pf_DeclsCons(
              pf_DeclModule(
                "A",
                pf_DeclsCons(
                  pf_DeclDef(
                    pf_DefBindPar(
                      "x",
                      pf_ExprTrue()
                    )
                  ),
                  pf_DeclsNil()
                )
              ),
              pf_DeclsCons(
                pf_DeclDef(
                  pf_DefBindPar(
                    "y",
                    pf_ExprAdd(
                      pf_ExprInt("1"),
                      pf_ExprVar(
                        pf_VarRef(
                          "x"
                        )
                      )
                    )
                  )
                ),
                pf_DeclsNil()
              )
            )
          )
        ),
        pf_DeclsNil()
      )
    )
  );