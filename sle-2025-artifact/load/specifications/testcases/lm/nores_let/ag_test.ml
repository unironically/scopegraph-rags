open Ocaml_ag_syntax
open Ocaml_ag_lm_spec

let nores_let: term =
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclDef", [
        TermE(TermT("DefBindPar", [
          String("a");
          TermE(TermT("ExprLet", [
            TermE(TermT("SeqBindsCons", [
              TermE(TermT("DefBindSeq", [
                String("x");
                TermE(TermT("ExprInt", [String("1")]))
              ]));
              TermE(TermT("SeqBindsOne", [
                TermE(TermT("DefBindSeq", [
                  String("y");
                  TermE(TermT("ExprAdd", [
                    TermE(TermT("ExprInt", [String("1")]));
                    TermE(TermT("ExprVar", [
                      TermE(TermT("VarRef", [
                        String("x")
                      ]))
                    ]))
                  ]))
                ]))
              ]))
            ]));
            TermE(TermT("ExprAdd", [
              TermE(TermT("ExprVar", [TermE(TermT("VarRef", [String("x")]))]));
              TermE(TermT("ExprAdd", [
                TermE(TermT("ExprVar", [TermE(TermT("VarRef", [String("y")]))]));
                TermE(TermT("ExprVar", [TermE(TermT("VarRef", [String("z")]))]))
              ]))
            ]))
          ]))
        ]))
      ]));
      TermE(TermT("DeclsNil", []))
    ]))
  ])

let () = assert(AG_Full.okFalseState nores_let)