open Ag_eval

let mod_local_term: term =
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclModule", [
        String("A");
        TermE(TermT("DeclsCons", [
          TermE(TermT("DeclDef", [
            TermE(TermT("DefBindPar", [
              String("a");
              TermE(TermT("ExprAdd", [
                TermE(TermT("ExprTrue", []));
                TermE(TermT("ExprInt", [Int(1)]))
              ]))
            ]))
          ]));
          TermE(TermT("DeclsNil", []))
        ]))
      ]));
      TermE(TermT("DeclsNil", []))
    ]))
  ])

let () = assert(okFalseState mod_local_term)