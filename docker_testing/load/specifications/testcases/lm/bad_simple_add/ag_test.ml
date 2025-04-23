open Ocaml_ag_syntax
open Ocaml_ag_lm_spec

let bad_simple_add: term =
  TermT("Program", [
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
  ])

let () = assert(AG_Full.okFalseState bad_simple_add)