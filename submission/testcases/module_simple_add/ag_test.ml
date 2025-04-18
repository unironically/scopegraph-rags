open Ag_syntax
open Ag_lm_spec

let mod_local_term: term =
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclModule", [
        String("A");
        TermE(TermT("DeclsCons", [
          TermE(TermT("DeclDef", [TermE(TermT("DefBindPar", [String("x"); TermE(TermT("ExprInt", [Int(1)]))]))]));
          TermE(TermT("DeclsCons", [
            TermE(TermT("DeclDef", [
              TermE(TermT("DefBindPar", [
                String("y"); 
                TermE(TermT("ExprAdd", [
                  TermE(TermT("ExprInt", [Int(1)])); 
                 TermE(TermT("ExprVar", [TermE(TermT("VarRef", [String("x")]))]))
                ]))
              ]))
            ]));
            TermE(TermT("DeclsNil", []))
          ]))
        ]))
      ]));
      TermE(TermT("DeclsNil", []))
    ]))
  ])

let () = assert(AG_Full.okTrueState mod_local_term)