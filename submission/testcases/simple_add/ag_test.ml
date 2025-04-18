open Ag_syntax
open Ag_lm_spec

let simple_add: term =
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclDef", [
        TermE(TermT("DefBindPar", [
          String("a");
          TermE(TermT("ExprAdd", [
            TermE(TermT("ExprInt", [Int(1)]));
            TermE(TermT("ExprInt", [Int(1)]))
          ]))
        ]))
      ]));
      TermE(TermT("DeclsNil", []))
    ]))
  ])

let () = assert(AG_Full.okTrueState simple_add)