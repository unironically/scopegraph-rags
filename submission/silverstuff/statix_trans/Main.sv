grammar statix_trans;

function main
IO<Integer> ::= largs::[String]
{
  return do {

    ret::Integer <-
      if testCase.ok
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

global testCase::Nt_main = simple_add_term;

-- empty program
global trivial_term::Nt_main = pf_Program (
  pf_DeclsNil()
);

-- def a = 1 + 1
global simple_add_term::Nt_main = pf_Program (
  pf_DeclsCons (
    pf_DeclDef (
      pf_DefBindPar (
        "a",
        pf_ExprAdd (
          pf_ExprInt("1"),
          pf_ExprInt("1")
        )
      )
    ),
    pf_DeclsNil()
  )
);

-- def a = true + 1
global bad_simple_add_term::Nt_main = pf_Program (
  pf_DeclsCons (
    pf_DeclDef (
      pf_DefBindPar (
        "a",
        pf_ExprAdd (
          pf_ExprTrue(),
          pf_ExprInt("1")
        )
      )
    ),
    pf_DeclsNil()
  )
);

-- module A { def x = 1; }
-- module B { import A; def y = x; }
global circ_import::Nt_main = pf_Program (
  pf_DeclsCons(
    pf_DeclModule(
      "A",
      pf_DeclsCons(
        pf_DeclDef (
          pf_DefBindPar(
            "x",
            pf_ExprInt("1")
          )
        ),
        pf_DeclsNil()
      )
    ),
    pf_DeclsCons(
      pf_DeclModule(
        "B",
        pf_DeclsCons(
          pf_DeclImport(
            pf_ModRef(
              "A"
            )
          ),
          --pf_DeclDef(
          --  pf_DefBindPar(
          --    "x",
          --    pf_ExprInt("1")
          --  )
          --),
          pf_DeclsCons(
            pf_DeclDef(
              pf_DefBindPar(
                "y",
                pf_ExprVar (
                  pf_VarRef (
                    "x"
                  )
                )
              )
            ),
            pf_DeclsNil()
          )
        )
        
      ),
      pf_DeclsNil()
    )
  )
);