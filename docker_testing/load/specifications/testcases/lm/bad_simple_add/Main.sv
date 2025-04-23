grammar statix_trans;

function main
IO<Integer> ::= largs::[String]
{
  return do {

    ret::Integer <-
      if bad_simple_add.ok
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

-- def a = 1 + true
global bad_simple_add::Nt_main = pf_Program (
  pf_DeclsCons (
    pf_DeclDef (
      pf_DefBindPar (
        "a",
        pf_ExprAdd (
          pf_ExprInt("1"),
          pf_ExprTrue()
        )
      )
    ),
    pf_DeclsNil()
  )
);