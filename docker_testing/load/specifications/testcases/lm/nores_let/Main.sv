grammar statix_trans;

function main
IO<Integer> ::= largs::[String]
{
  return do {

    ret::Integer <-
      if nores_let.ok
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

global nores_let::Nt_main =
  pf_Program (
    pf_DeclsCons(
      pf_DeclDef(
        pf_DefBindPar(
          "a", 
          pf_ExprLet(
            pf_SeqBindsCons(
              pf_DefBindSeq(
                "x",
                pf_ExprInt("1")
              ),
              pf_SeqBindsOne(
                pf_DefBindSeq(
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
              )
            ),
            pf_ExprAdd(
              pf_ExprVar(pf_VarRef("x")),
              pf_ExprAdd(
                pf_ExprVar(pf_VarRef("y")),
                pf_ExprVar(pf_VarRef("z"))
              )
            )
          )
        )
      ),
      pf_DeclsNil()
    )
  );