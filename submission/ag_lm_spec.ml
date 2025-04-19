open Ag_syntax
open Ag_sig
open Ag_eval

module Spec : AG_Spec = struct

  (* label set *)
  let label_set = ["LEX"; "VAR"; "MOD"; "IMP"]

  (* nts *)
  let nt_set = [

    ("main", ["ok"]);
    ("decls", ["s"; "ok"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"]);
    ("decl", ["s"; "ok"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"]);
    ("expr", ["s"; "ok"; "ty"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"]);
    ("seq_binds", ["s"; "s_def"; "ok"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"; "s_def_VAR"; "s_def_IMP"; "s_def_MOD"; "s_def_LEX"]);
    ("seq_bind", ["s"; "s_def"; "ok"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"; "s_def_VAR"; "s_def_IMP"; "s_def_MOD"; "s_def_LEX"]);
    ("par_binds", ["s"; "s_def"; "ok"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"; "s_def_VAR"; "s_def_IMP"; "s_def_MOD"; "s_def_LEX"]);
    ("par_bind", ["s"; "s_def"; "ok"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"; "s_def_VAR"; "s_def_IMP"; "s_def_MOD"; "s_def_LEX"]);
    ("arg_decl", ["s"; "ok"; "ty"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"]);
    ("type", ["s"; "ok"; "ty"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"]);
    ("mod_ref", ["s"; "ok"; "p"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"]);
    ("var_ref", ["s"; "ok"; "p"; "s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"])

  ]

  (* prods *)
  let prod_set = [

    (* todo - generate these *)
    ("DatumVar", "Datum", ["datum_id"], [], []);
    ("DatumMod", "Datum", ["datum_id"], [], []);

    ("Program", "main", ["ds"], ["s_VAR"; "s_IMP"; "s_MOD"; "s_LEX"; "s"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("ds"), "ok"), Bool(true))); AttrEq(AttrRef(VarE("top"), "s_VAR"), AttrRef(VarE("ds"), "s_VAR")); AttrEq(AttrRef(VarE("top"), "s_IMP"), AttrRef(VarE("ds"), "s_IMP")); AttrEq(AttrRef(VarE("top"), "s_MOD"), AttrRef(VarE("ds"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_LEX"), AttrRef(VarE("ds"), "s_LEX")); AttrEq(AttrRef(VarE("s"), "VAR"), AttrRef(VarE("top"), "s_VAR")); AttrEq(AttrRef(VarE("s"), "IMP"), AttrRef(VarE("top"), "s_IMP")); AttrEq(AttrRef(VarE("s"), "MOD"), AttrRef(VarE("top"), "s_MOD")); AttrEq(AttrRef(VarE("s"), "LEX"), AttrRef(VarE("top"), "s_LEX")); AttrEq(AttrRef(VarE("top"), "s"), VarE("s")); NtaEq("s", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("ds"), "s"), AttrRef(VarE("top"), "s"))]);
    ("DeclsNil", "decls", [], [], [AttrEq(AttrRef(VarE("top"), "ok"), And(Bool(true), Bool(true))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil)]);
    ("DeclsCons", "decls", ["d"; "ds"], [], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("d"), "ok"), And(AttrRef(VarE("ds"), "ok"), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("d"), "s_VAR"), AttrRef(VarE("ds"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("d"), "s_IMP"), AttrRef(VarE("ds"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("d"), "s_MOD"), AttrRef(VarE("ds"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("d"), "s_LEX"), AttrRef(VarE("ds"), "s_LEX"))); AttrEq(AttrRef(VarE("d"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("ds"), "s"), AttrRef(VarE("top"), "s"))]);
    ("DeclModule", "decl", ["x"; "ds"], ["s_mod_VAR"; "s_mod_IMP"; "s_mod_MOD"; "s_mod_LEX"; "s_mod"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("ds"), "ok"), Bool(true))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Cons(AttrRef(VarE("top"), "s_mod"), Nil)); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "s_mod_VAR"), AttrRef(VarE("ds"), "s_VAR")); AttrEq(AttrRef(VarE("top"), "s_mod_IMP"), AttrRef(VarE("ds"), "s_IMP")); AttrEq(AttrRef(VarE("top"), "s_mod_MOD"), AttrRef(VarE("ds"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_mod_LEX"), Append(Cons(AttrRef(VarE("top"), "s"), Nil), AttrRef(VarE("ds"), "s_LEX"))); AttrEq(AttrRef(VarE("_s_mod_"), "VAR"), AttrRef(VarE("top"), "s_mod_VAR")); AttrEq(AttrRef(VarE("_s_mod_"), "IMP"), AttrRef(VarE("top"), "s_mod_IMP")); AttrEq(AttrRef(VarE("_s_mod_"), "MOD"), AttrRef(VarE("top"), "s_mod_MOD")); AttrEq(AttrRef(VarE("_s_mod_"), "LEX"), AttrRef(VarE("top"), "s_mod_LEX")); NtaEq("s_mod_datum", TermE(TermT("DatumMod", [AttrRef(VarE("top"), "x")]))); AttrEq(AttrRef(VarE("s_mod_datum"), "data"), TermE(TermT("ActualDataDatumMod", [AttrRef(VarE("top"), "s_mod")]))); AttrEq(AttrRef(VarE("top"), "s_mod"), VarE("_s_mod_")); NtaEq("_s_mod_", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("_s_mod_"), "datum"), VarE("s_mod_datum")); AttrEq(AttrRef(VarE("ds"), "s"), AttrRef(VarE("top"), "s_mod"))]);
    ("DeclImport", "decl", ["r"], ["p"; "d"; "s_mod"; "tgt_s"; "pair_0"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("r"), "ok"), And(TupleSec(AttrRef(VarE("top"), "pair_0"), 1), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), AttrRef(VarE("r"), "s_VAR")); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("r"), "s_IMP"), Cons(AttrRef(VarE("top"), "s_mod"), Nil))); AttrEq(AttrRef(VarE("top"), "s_MOD"), AttrRef(VarE("r"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_LEX"), AttrRef(VarE("r"), "s_LEX")); AttrEq(AttrRef(VarE("r"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "p"), AttrRef(VarE("r"), "p")); AttrEq(AttrRef(VarE("top"), "pair_0"), AttrRef(TermE(TermT("tgt", [AttrRef(VarE("top"), "p")])), "ret")); AttrEq(AttrRef(VarE("top"), "tgt_s"), TupleSec(AttrRef(VarE("top"), "pair_0"), 2)); AttrEq(AttrRef(VarE("top"), "d"), AttrRef(AttrRef(VarE("top"), "tgt_s"), "datum")); AttrEq(AttrRef(VarE("top"), "s_mod"), Case(AttrRef(VarE("top"), "d"), [(TermP("DatumMod", [UnderscoreP]), If(Bool(true), Let("d_lam_arg", AttrRef(VarE("top"), "d"), Let("dscope__", Case(AttrRef(VarE("d_lam_arg"), "data"), [(TermP("ActualDataDatumMod", [VarP("dscope")]), VarE("dscope")); (UnderscoreP, Abort("data match abort"))]), VarE("dscope__"))), Abort("branch case else TODO"))); (UnderscoreP, Abort("Match failure!"))]))]);
    ("DeclDef", "decl", ["b"], [], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("b"), "ok"), Bool(true))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("b"), "s_VAR"), AttrRef(VarE("b"), "s_def_VAR"))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("b"), "s_IMP"), AttrRef(VarE("b"), "s_def_IMP"))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("b"), "s_MOD"), AttrRef(VarE("b"), "s_def_MOD"))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("b"), "s_LEX"), AttrRef(VarE("b"), "s_def_LEX"))); AttrEq(AttrRef(VarE("b"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("b"), "s_def"), AttrRef(VarE("top"), "s"))]);
    ("ExprInt", "expr", ["i"], [], [AttrEq(AttrRef(VarE("top"), "ok"), Bool(true)); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("TInt", [])))]);
    ("ExprTrue", "expr", [], [], [AttrEq(AttrRef(VarE("top"), "ok"), Bool(true)); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("TBool", [])))]);
    ("ExprFalse", "expr", [], [], [AttrEq(AttrRef(VarE("top"), "ok"), Bool(true)); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("TBool", [])))]);
    ("ExprVar", "expr", ["r"], ["p"; "d"; "tgt_s"; "pair_1"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("r"), "ok"), And(TupleSec(AttrRef(VarE("top"), "pair_1"), 1), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), AttrRef(VarE("r"), "s_VAR")); AttrEq(AttrRef(VarE("top"), "s_IMP"), AttrRef(VarE("r"), "s_IMP")); AttrEq(AttrRef(VarE("top"), "s_MOD"), AttrRef(VarE("r"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_LEX"), AttrRef(VarE("r"), "s_LEX")); AttrEq(AttrRef(VarE("r"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "p"), AttrRef(VarE("r"), "p")); AttrEq(AttrRef(VarE("top"), "pair_1"), AttrRef(TermE(TermT("tgt", [AttrRef(VarE("top"), "p")])), "ret")); AttrEq(AttrRef(VarE("top"), "tgt_s"), TupleSec(AttrRef(VarE("top"), "pair_1"), 2)); AttrEq(AttrRef(VarE("top"), "d"), AttrRef(AttrRef(VarE("top"), "tgt_s"), "datum")); AttrEq(AttrRef(VarE("top"), "ty"), Case(AttrRef(VarE("top"), "d"), [(TermP("DatumVar", [UnderscoreP]), If(Bool(true), Let("d_lam_arg", AttrRef(VarE("top"), "d"), Let("dty__", Case(AttrRef(VarE("d_lam_arg"), "data"), [(TermP("ActualDataDatumVar", [VarP("dty")]), VarE("dty")); (UnderscoreP, Abort("data match abort"))]), VarE("dty__"))), Abort("branch case else TODO"))); (UnderscoreP, Abort("Match failure!"))]))]);
    ("ExprAdd", "expr", ["e1"; "e2"], ["ty1"; "ty2"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("e1"), "ok"), And(AttrRef(VarE("e2"), "ok"), And(Equal(AttrRef(VarE("top"), "ty1"), TermE(TermT("TInt", []))), And(Equal(AttrRef(VarE("top"), "ty2"), TermE(TermT("TInt", []))), Bool(true)))))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("e1"), "s_VAR"), AttrRef(VarE("e2"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("e1"), "s_IMP"), AttrRef(VarE("e2"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("e1"), "s_MOD"), AttrRef(VarE("e2"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("e1"), "s_LEX"), AttrRef(VarE("e2"), "s_LEX"))); AttrEq(AttrRef(VarE("e1"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty1"), AttrRef(VarE("e1"), "ty")); AttrEq(AttrRef(VarE("e2"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty2"), AttrRef(VarE("e2"), "ty")); AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("TInt", [])))]);
    ("ExprAnd", "expr", ["e1"; "e2"], ["ty1"; "ty2"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("e1"), "ok"), And(AttrRef(VarE("e2"), "ok"), And(Equal(AttrRef(VarE("top"), "ty1"), TermE(TermT("TBool", []))), And(Equal(AttrRef(VarE("top"), "ty2"), TermE(TermT("TBool", []))), Bool(true)))))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("e1"), "s_VAR"), AttrRef(VarE("e2"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("e1"), "s_IMP"), AttrRef(VarE("e2"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("e1"), "s_MOD"), AttrRef(VarE("e2"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("e1"), "s_LEX"), AttrRef(VarE("e2"), "s_LEX"))); AttrEq(AttrRef(VarE("e1"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty1"), AttrRef(VarE("e1"), "ty")); AttrEq(AttrRef(VarE("e2"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty2"), AttrRef(VarE("e2"), "ty")); AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("TBool", [])))]);
    ("ExprEq", "expr", ["e1"; "e2"], ["ty1"; "ty2"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("e1"), "ok"), And(AttrRef(VarE("e2"), "ok"), And(Equal(AttrRef(VarE("top"), "ty1"), AttrRef(VarE("top"), "ty2")), Bool(true))))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("e1"), "s_VAR"), AttrRef(VarE("e2"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("e1"), "s_IMP"), AttrRef(VarE("e2"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("e1"), "s_MOD"), AttrRef(VarE("e2"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("e1"), "s_LEX"), AttrRef(VarE("e2"), "s_LEX"))); AttrEq(AttrRef(VarE("e1"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty1"), AttrRef(VarE("e1"), "ty")); AttrEq(AttrRef(VarE("e2"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty2"), AttrRef(VarE("e2"), "ty")); AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("TBool", [])))]);
    ("ExprApp", "expr", ["e1"; "e2"], ["ty1"; "ty2"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("e1"), "ok"), And(AttrRef(VarE("e2"), "ok"), And(Case(AttrRef(VarE("top"), "ty1"), [(TermP("TFun", [VarP("l"); VarP("r")]), If(Bool(true), Equal(AttrRef(VarE("top"), "ty2"), VarE("l")), Abort("branch case else TODO"))); (UnderscoreP, Abort("Match failure!"))]), Bool(true))))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("e1"), "s_VAR"), AttrRef(VarE("e2"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("e1"), "s_IMP"), AttrRef(VarE("e2"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("e1"), "s_MOD"), AttrRef(VarE("e2"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("e1"), "s_LEX"), AttrRef(VarE("e2"), "s_LEX"))); AttrEq(AttrRef(VarE("e1"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty1"), AttrRef(VarE("e1"), "ty")); AttrEq(AttrRef(VarE("e2"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty2"), AttrRef(VarE("e2"), "ty")); AttrEq(AttrRef(VarE("top"), "ty"), Case(AttrRef(VarE("top"), "ty1"), [(TermP("TFun", [VarP("l"); VarP("r")]), If(Bool(true), VarE("r"), Abort("branch case else TODO"))); (UnderscoreP, Abort("Match failure!"))]))]);
    ("ExprIf", "expr", ["e1"; "e2"; "e3"], ["ty1"; "ty2"; "ty3"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("e1"), "ok"), And(AttrRef(VarE("e2"), "ok"), And(AttrRef(VarE("e3"), "ok"), And(Equal(AttrRef(VarE("top"), "ty1"), TermE(TermT("TBool", []))), And(Equal(AttrRef(VarE("top"), "ty2"), AttrRef(VarE("top"), "ty3")), Bool(true))))))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("e1"), "s_VAR"), Append(AttrRef(VarE("e2"), "s_VAR"), AttrRef(VarE("e3"), "s_VAR")))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("e1"), "s_IMP"), Append(AttrRef(VarE("e2"), "s_IMP"), AttrRef(VarE("e3"), "s_IMP")))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("e1"), "s_MOD"), Append(AttrRef(VarE("e2"), "s_MOD"), AttrRef(VarE("e3"), "s_MOD")))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("e1"), "s_LEX"), Append(AttrRef(VarE("e2"), "s_LEX"), AttrRef(VarE("e3"), "s_LEX")))); AttrEq(AttrRef(VarE("e1"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty1"), AttrRef(VarE("e1"), "ty")); AttrEq(AttrRef(VarE("e2"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty2"), AttrRef(VarE("e2"), "ty")); AttrEq(AttrRef(VarE("e3"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty3"), AttrRef(VarE("e3"), "ty")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("top"), "ty2"))]);
    ("ExprFun", "expr", ["d"; "e"], ["s_fun_VAR"; "s_fun_IMP"; "s_fun_MOD"; "s_fun_LEX"; "s_fun"; "ty1"; "ty2"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("d"), "ok"), And(AttrRef(VarE("e"), "ok"), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "s_fun_VAR"), Append(AttrRef(VarE("d"), "s_VAR"), AttrRef(VarE("e"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_fun_IMP"), Append(AttrRef(VarE("d"), "s_IMP"), AttrRef(VarE("e"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_fun_MOD"), Append(AttrRef(VarE("d"), "s_MOD"), AttrRef(VarE("e"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_fun_LEX"), Append(Cons(AttrRef(VarE("top"), "s"), Nil), Append(AttrRef(VarE("d"), "s_LEX"), AttrRef(VarE("e"), "s_LEX")))); AttrEq(AttrRef(VarE("s_fun"), "VAR"), AttrRef(VarE("top"), "s_fun_VAR")); AttrEq(AttrRef(VarE("s_fun"), "IMP"), AttrRef(VarE("top"), "s_fun_IMP")); AttrEq(AttrRef(VarE("s_fun"), "MOD"), AttrRef(VarE("top"), "s_fun_MOD")); AttrEq(AttrRef(VarE("s_fun"), "LEX"), AttrRef(VarE("top"), "s_fun_LEX")); AttrEq(AttrRef(VarE("top"), "s_fun"), VarE("s_fun")); NtaEq("s_fun", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("d"), "s"), AttrRef(VarE("top"), "s_fun")); AttrEq(AttrRef(VarE("top"), "ty1"), AttrRef(VarE("d"), "ty")); AttrEq(AttrRef(VarE("e"), "s"), AttrRef(VarE("top"), "s_fun")); AttrEq(AttrRef(VarE("top"), "ty2"), AttrRef(VarE("e"), "ty")); AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("TFun", [AttrRef(VarE("top"), "ty1"); AttrRef(VarE("top"), "ty2")])))]);
    ("ExprLet", "expr", ["bs"; "e"], ["s_let_VAR"; "s_let_IMP"; "s_let_MOD"; "s_let_LEX"; "s_let"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("bs"), "ok"), And(AttrRef(VarE("e"), "ok"), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), AttrRef(VarE("bs"), "s_VAR")); AttrEq(AttrRef(VarE("top"), "s_IMP"), AttrRef(VarE("bs"), "s_IMP")); AttrEq(AttrRef(VarE("top"), "s_MOD"), AttrRef(VarE("bs"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_LEX"), AttrRef(VarE("bs"), "s_LEX")); AttrEq(AttrRef(VarE("top"), "s_let_VAR"), Append(AttrRef(VarE("bs"), "s_def_VAR"), AttrRef(VarE("e"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_let_IMP"), Append(AttrRef(VarE("bs"), "s_def_IMP"), AttrRef(VarE("e"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_let_MOD"), Append(AttrRef(VarE("bs"), "s_def_MOD"), AttrRef(VarE("e"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_let_LEX"), Append(AttrRef(VarE("bs"), "s_def_LEX"), AttrRef(VarE("e"), "s_LEX"))); AttrEq(AttrRef(VarE("s_let"), "VAR"), AttrRef(VarE("top"), "s_let_VAR")); AttrEq(AttrRef(VarE("s_let"), "IMP"), AttrRef(VarE("top"), "s_let_IMP")); AttrEq(AttrRef(VarE("s_let"), "MOD"), AttrRef(VarE("top"), "s_let_MOD")); AttrEq(AttrRef(VarE("s_let"), "LEX"), AttrRef(VarE("top"), "s_let_LEX")); AttrEq(AttrRef(VarE("top"), "s_let"), VarE("s_let")); NtaEq("s_let", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("bs"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("bs"), "s_def"), AttrRef(VarE("top"), "s_let")); AttrEq(AttrRef(VarE("e"), "s"), AttrRef(VarE("top"), "s_let")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("e"), "ty"))]);
    ("ExprLetRec", "expr", ["bs"; "e"], ["s_let_VAR"; "s_let_IMP"; "s_let_MOD"; "s_let_LEX"; "s_let"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("bs"), "ok"), And(AttrRef(VarE("e"), "ok"), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "s_let_VAR"), Append(AttrRef(VarE("bs"), "s_VAR"), Append(AttrRef(VarE("bs"), "s_def_VAR"), AttrRef(VarE("e"), "s_VAR")))); AttrEq(AttrRef(VarE("top"), "s_let_IMP"), Append(AttrRef(VarE("bs"), "s_IMP"), Append(AttrRef(VarE("bs"), "s_def_IMP"), AttrRef(VarE("e"), "s_IMP")))); AttrEq(AttrRef(VarE("top"), "s_let_MOD"), Append(AttrRef(VarE("bs"), "s_MOD"), Append(AttrRef(VarE("bs"), "s_def_MOD"), AttrRef(VarE("e"), "s_MOD")))); AttrEq(AttrRef(VarE("top"), "s_let_LEX"), Append(Cons(AttrRef(VarE("top"), "s"), Nil), Append(AttrRef(VarE("bs"), "s_LEX"), Append(AttrRef(VarE("bs"), "s_def_LEX"), AttrRef(VarE("e"), "s_LEX"))))); AttrEq(AttrRef(VarE("s_let"), "VAR"), AttrRef(VarE("top"), "s_let_VAR")); AttrEq(AttrRef(VarE("s_let"), "IMP"), AttrRef(VarE("top"), "s_let_IMP")); AttrEq(AttrRef(VarE("s_let"), "MOD"), AttrRef(VarE("top"), "s_let_MOD")); AttrEq(AttrRef(VarE("s_let"), "LEX"), AttrRef(VarE("top"), "s_let_LEX")); AttrEq(AttrRef(VarE("top"), "s_let"), VarE("s_let")); NtaEq("s_let", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("bs"), "s"), AttrRef(VarE("top"), "s_let")); AttrEq(AttrRef(VarE("bs"), "s_def"), AttrRef(VarE("top"), "s_let")); AttrEq(AttrRef(VarE("e"), "s"), AttrRef(VarE("top"), "s_let")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("e"), "ty"))]);
    ("ExprLetPar", "expr", ["bs"; "e"], ["s_let_VAR"; "s_let_IMP"; "s_let_MOD"; "s_let_LEX"; "s_let"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("bs"), "ok"), And(AttrRef(VarE("e"), "ok"), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), AttrRef(VarE("bs"), "s_VAR")); AttrEq(AttrRef(VarE("top"), "s_IMP"), AttrRef(VarE("bs"), "s_IMP")); AttrEq(AttrRef(VarE("top"), "s_MOD"), AttrRef(VarE("bs"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_LEX"), AttrRef(VarE("bs"), "s_LEX")); AttrEq(AttrRef(VarE("top"), "s_let_VAR"), Append(AttrRef(VarE("bs"), "s_def_VAR"), AttrRef(VarE("e"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_let_IMP"), Append(AttrRef(VarE("bs"), "s_def_IMP"), AttrRef(VarE("e"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_let_MOD"), Append(AttrRef(VarE("bs"), "s_def_MOD"), AttrRef(VarE("e"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_let_LEX"), Append(Cons(AttrRef(VarE("top"), "s"), Nil), Append(AttrRef(VarE("bs"), "s_def_LEX"), AttrRef(VarE("e"), "s_LEX")))); AttrEq(AttrRef(VarE("s_let"), "VAR"), AttrRef(VarE("top"), "s_let_VAR")); AttrEq(AttrRef(VarE("s_let"), "IMP"), AttrRef(VarE("top"), "s_let_IMP")); AttrEq(AttrRef(VarE("s_let"), "MOD"), AttrRef(VarE("top"), "s_let_MOD")); AttrEq(AttrRef(VarE("s_let"), "LEX"), AttrRef(VarE("top"), "s_let_LEX")); AttrEq(AttrRef(VarE("top"), "s_let"), VarE("s_let")); NtaEq("s_let", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("bs"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("bs"), "s_def"), AttrRef(VarE("top"), "s_let")); AttrEq(AttrRef(VarE("e"), "s"), AttrRef(VarE("top"), "s_let")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("e"), "ty"))]);
    ("SeqBindsNil", "seq_binds", [], [], [AttrEq(AttrRef(VarE("top"), "ok"), Bool(true)); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_LEX"), Cons(AttrRef(VarE("top"), "s"), Nil))]);
    ("SeqBindsOne", "seq_binds", ["b"], [], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("b"), "ok"), Bool(true))); AttrEq(AttrRef(VarE("top"), "s_VAR"), AttrRef(VarE("b"), "s_VAR")); AttrEq(AttrRef(VarE("top"), "s_IMP"), AttrRef(VarE("b"), "s_IMP")); AttrEq(AttrRef(VarE("top"), "s_MOD"), AttrRef(VarE("b"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_LEX"), AttrRef(VarE("b"), "s_LEX")); AttrEq(AttrRef(VarE("top"), "s_def_VAR"), AttrRef(VarE("b"), "s_def_VAR")); AttrEq(AttrRef(VarE("top"), "s_def_IMP"), AttrRef(VarE("b"), "s_def_IMP")); AttrEq(AttrRef(VarE("top"), "s_def_MOD"), AttrRef(VarE("b"), "s_def_MOD")); AttrEq(AttrRef(VarE("top"), "s_def_LEX"), Append(Cons(AttrRef(VarE("top"), "s"), Nil), AttrRef(VarE("b"), "s_def_LEX"))); AttrEq(AttrRef(VarE("b"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("b"), "s_def"), AttrRef(VarE("top"), "s_def"))]);
    ("SeqBindsCons", "seq_binds", ["b"; "bs"], ["s_def__VAR"; "s_def__IMP"; "s_def__MOD"; "s_def__LEX"; "s_def_"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("b"), "ok"), And(AttrRef(VarE("bs"), "ok"), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), AttrRef(VarE("b"), "s_VAR")); AttrEq(AttrRef(VarE("top"), "s_IMP"), AttrRef(VarE("b"), "s_IMP")); AttrEq(AttrRef(VarE("top"), "s_MOD"), AttrRef(VarE("b"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_LEX"), AttrRef(VarE("b"), "s_LEX")); AttrEq(AttrRef(VarE("top"), "s_def_VAR"), AttrRef(VarE("bs"), "s_def_VAR")); AttrEq(AttrRef(VarE("top"), "s_def_IMP"), AttrRef(VarE("bs"), "s_def_IMP")); AttrEq(AttrRef(VarE("top"), "s_def_MOD"), AttrRef(VarE("bs"), "s_def_MOD")); AttrEq(AttrRef(VarE("top"), "s_def_LEX"), AttrRef(VarE("bs"), "s_def_LEX")); AttrEq(AttrRef(VarE("top"), "s_def__VAR"), Append(AttrRef(VarE("b"), "s_def_VAR"), AttrRef(VarE("bs"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_def__IMP"), Append(AttrRef(VarE("b"), "s_def_IMP"), AttrRef(VarE("bs"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_def__MOD"), Append(AttrRef(VarE("b"), "s_def_MOD"), AttrRef(VarE("bs"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_def__LEX"), Append(Cons(AttrRef(VarE("top"), "s"), Nil), Append(AttrRef(VarE("b"), "s_def_LEX"), AttrRef(VarE("bs"), "s_LEX")))); AttrEq(AttrRef(VarE("s_def_"), "VAR"), AttrRef(VarE("top"), "s_def__VAR")); AttrEq(AttrRef(VarE("s_def_"), "IMP"), AttrRef(VarE("top"), "s_def__IMP")); AttrEq(AttrRef(VarE("s_def_"), "MOD"), AttrRef(VarE("top"), "s_def__MOD")); AttrEq(AttrRef(VarE("s_def_"), "LEX"), AttrRef(VarE("top"), "s_def__LEX")); AttrEq(AttrRef(VarE("top"), "s_def_"), VarE("s_def_")); NtaEq("s_def_", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("b"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("b"), "s_def"), AttrRef(VarE("top"), "s_def_")); AttrEq(AttrRef(VarE("bs"), "s"), AttrRef(VarE("top"), "s_def_")); AttrEq(AttrRef(VarE("bs"), "s_def"), AttrRef(VarE("top"), "s_def"))]);
    ("DefBindSeq", "seq_bind", ["x"; "e"], ["s_var_VAR"; "s_var_IMP"; "s_var_MOD"; "s_var_LEX"; "s_var"; "ty"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("e"), "ok"), Bool(true))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(Cons(AttrRef(VarE("top"), "s_var"), Nil), AttrRef(VarE("e"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_IMP"), AttrRef(VarE("e"), "s_IMP")); AttrEq(AttrRef(VarE("top"), "s_MOD"), AttrRef(VarE("e"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_LEX"), AttrRef(VarE("e"), "s_LEX")); AttrEq(AttrRef(VarE("top"), "s_def_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_LEX"), Nil); AttrEq(AttrRef(VarE("_s_var_"), "VAR"), AttrRef(VarE("top"), "s_var_VAR")); AttrEq(AttrRef(VarE("_s_var_"), "IMP"), AttrRef(VarE("top"), "s_var_IMP")); AttrEq(AttrRef(VarE("_s_var_"), "MOD"), AttrRef(VarE("top"), "s_var_MOD")); AttrEq(AttrRef(VarE("_s_var_"), "LEX"), AttrRef(VarE("top"), "s_var_LEX")); NtaEq("s_var_datum", TermE(TermT("DatumVar", [AttrRef(VarE("top"), "x")]))); AttrEq(AttrRef(VarE("s_var_datum"), "data"), TermE(TermT("ActualDataDatumVar", [AttrRef(VarE("top"), "ty")]))); AttrEq(AttrRef(VarE("top"), "s_var"), VarE("_s_var_")); NtaEq("_s_var_", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("_s_var_"), "datum"), VarE("s_var_datum")); AttrEq(AttrRef(VarE("e"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("e"), "ty"))]);
    ("DefBindTypedSeq", "seq_bind", ["x"; "tyann"; "e"], ["s_var_VAR"; "s_var_IMP"; "s_var_MOD"; "s_var_LEX"; "s_var"; "ty"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("tyann"), "ok"), And(AttrRef(VarE("e"), "ok"), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(Cons(AttrRef(VarE("top"), "s_var"), Nil), Append(AttrRef(VarE("tyann"), "s_VAR"), AttrRef(VarE("e"), "s_VAR")))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("tyann"), "s_IMP"), AttrRef(VarE("e"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("tyann"), "s_MOD"), AttrRef(VarE("e"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("tyann"), "s_LEX"), AttrRef(VarE("e"), "s_LEX"))); AttrEq(AttrRef(VarE("top"), "s_def_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_LEX"), Nil); AttrEq(AttrRef(VarE("_s_var_"), "VAR"), AttrRef(VarE("top"), "s_var_VAR")); AttrEq(AttrRef(VarE("_s_var_"), "IMP"), AttrRef(VarE("top"), "s_var_IMP")); AttrEq(AttrRef(VarE("_s_var_"), "MOD"), AttrRef(VarE("top"), "s_var_MOD")); AttrEq(AttrRef(VarE("_s_var_"), "LEX"), AttrRef(VarE("top"), "s_var_LEX")); NtaEq("s_var_datum", TermE(TermT("DatumVar", [AttrRef(VarE("top"), "x")]))); AttrEq(AttrRef(VarE("s_var_datum"), "data"), TermE(TermT("ActualDataDatumVar", [AttrRef(VarE("top"), "ty")]))); AttrEq(AttrRef(VarE("top"), "s_var"), VarE("_s_var_")); NtaEq("_s_var_", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("_s_var_"), "datum"), VarE("s_var_datum")); AttrEq(AttrRef(VarE("tyann"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("tyann"), "ty")); AttrEq(AttrRef(VarE("e"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("e"), "ty"))]);
    ("ParBindsNil", "par_binds", [], [], [AttrEq(AttrRef(VarE("top"), "ok"), And(Bool(true), Bool(true))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_LEX"), Nil)]);
    ("ParBindsCons", "par_binds", ["b"; "ds"], [], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("b"), "ok"), And(AttrRef(VarE("bs"), "ok"), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("b"), "s_VAR"), AttrRef(VarE("bs"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("b"), "s_IMP"), AttrRef(VarE("bs"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("b"), "s_MOD"), AttrRef(VarE("bs"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("b"), "s_LEX"), AttrRef(VarE("bs"), "s_LEX"))); AttrEq(AttrRef(VarE("top"), "s_def_VAR"), Append(AttrRef(VarE("b"), "s_def_VAR"), AttrRef(VarE("bs"), "s_def_VAR"))); AttrEq(AttrRef(VarE("top"), "s_def_IMP"), Append(AttrRef(VarE("b"), "s_def_IMP"), AttrRef(VarE("bs"), "s_def_IMP"))); AttrEq(AttrRef(VarE("top"), "s_def_MOD"), Append(AttrRef(VarE("b"), "s_def_MOD"), AttrRef(VarE("bs"), "s_def_MOD"))); AttrEq(AttrRef(VarE("top"), "s_def_LEX"), Append(AttrRef(VarE("b"), "s_def_LEX"), AttrRef(VarE("bs"), "s_def_LEX"))); AttrEq(AttrRef(VarE("b"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("b"), "s_def"), AttrRef(VarE("top"), "s_def")); AttrEq(AttrRef(VarE("bs"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("bs"), "s_def"), AttrRef(VarE("top"), "s_def"))]);
    ("DefBindPar", "par_bind", ["x"; "e"], ["s_var_VAR"; "s_var_IMP"; "s_var_MOD"; "s_var_LEX"; "s_var"; "ty"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("e"), "ok"), Bool(true))); AttrEq(AttrRef(VarE("top"), "s_VAR"), AttrRef(VarE("e"), "s_VAR")); AttrEq(AttrRef(VarE("top"), "s_IMP"), AttrRef(VarE("e"), "s_IMP")); AttrEq(AttrRef(VarE("top"), "s_MOD"), AttrRef(VarE("e"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_LEX"), AttrRef(VarE("e"), "s_LEX")); AttrEq(AttrRef(VarE("top"), "s_def_VAR"), Cons(AttrRef(VarE("top"), "s_var"), Nil)); AttrEq(AttrRef(VarE("top"), "s_def_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_LEX"), Nil); AttrEq(AttrRef(VarE("_s_var_"), "VAR"), AttrRef(VarE("top"), "s_var_VAR")); AttrEq(AttrRef(VarE("_s_var_"), "IMP"), AttrRef(VarE("top"), "s_var_IMP")); AttrEq(AttrRef(VarE("_s_var_"), "MOD"), AttrRef(VarE("top"), "s_var_MOD")); AttrEq(AttrRef(VarE("_s_var_"), "LEX"), AttrRef(VarE("top"), "s_var_LEX")); NtaEq("s_var_datum", TermE(TermT("DatumVar", [AttrRef(VarE("top"), "x")]))); AttrEq(AttrRef(VarE("s_var_datum"), "data"), TermE(TermT("ActualDataDatumVar", [AttrRef(VarE("top"), "ty")]))); AttrEq(AttrRef(VarE("top"), "s_var"), VarE("_s_var_")); NtaEq("_s_var_", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("_s_var_"), "datum"), VarE("s_var_datum")); AttrEq(AttrRef(VarE("e"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("e"), "ty"))]);
    ("DefBindTypedPar", "par_bind", ["x"; "tyann"; "e"], ["s_var_VAR"; "s_var_IMP"; "s_var_MOD"; "s_var_LEX"; "s_var"; "ty"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("tyann"), "ok"), And(AttrRef(VarE("e"), "ok"), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("tyann"), "s_VAR"), AttrRef(VarE("e"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("tyann"), "s_IMP"), AttrRef(VarE("e"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("tyann"), "s_MOD"), AttrRef(VarE("e"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("tyann"), "s_LEX"), AttrRef(VarE("e"), "s_LEX"))); AttrEq(AttrRef(VarE("top"), "s_def_VAR"), Cons(AttrRef(VarE("top"), "s_var"), Nil)); AttrEq(AttrRef(VarE("top"), "s_def_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_def_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_LEX"), Nil); AttrEq(AttrRef(VarE("_s_var_"), "VAR"), AttrRef(VarE("top"), "s_var_VAR")); AttrEq(AttrRef(VarE("_s_var_"), "IMP"), AttrRef(VarE("top"), "s_var_IMP")); AttrEq(AttrRef(VarE("_s_var_"), "MOD"), AttrRef(VarE("top"), "s_var_MOD")); AttrEq(AttrRef(VarE("_s_var_"), "LEX"), AttrRef(VarE("top"), "s_var_LEX")); NtaEq("s_var_datum", TermE(TermT("DatumVar", [AttrRef(VarE("top"), "x")]))); AttrEq(AttrRef(VarE("s_var_datum"), "data"), TermE(TermT("ActualDataDatumVar", [AttrRef(VarE("top"), "ty")]))); AttrEq(AttrRef(VarE("top"), "s_var"), VarE("_s_var_")); NtaEq("_s_var_", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("_s_var_"), "datum"), VarE("s_var_datum")); AttrEq(AttrRef(VarE("tyann"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("tyann"), "ty")); AttrEq(AttrRef(VarE("e"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("e"), "ty"))]);
    ("ArgDecl", "arg_decl", ["x"; "tyann"], ["s_var_VAR"; "s_var_IMP"; "s_var_MOD"; "s_var_LEX"; "s_var"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("tyann"), "ok"), Bool(true))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("tyann"), "s_VAR"), Cons(AttrRef(VarE("top"), "s_var"), Nil))); AttrEq(AttrRef(VarE("top"), "s_IMP"), AttrRef(VarE("tyann"), "s_IMP")); AttrEq(AttrRef(VarE("top"), "s_MOD"), AttrRef(VarE("tyann"), "s_MOD")); AttrEq(AttrRef(VarE("top"), "s_LEX"), AttrRef(VarE("tyann"), "s_LEX")); AttrEq(AttrRef(VarE("top"), "s_var_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_var_LEX"), Nil); AttrEq(AttrRef(VarE("tyann"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("tyann"), "ty")); AttrEq(AttrRef(VarE("_s_var_"), "VAR"), AttrRef(VarE("top"), "s_var_VAR")); AttrEq(AttrRef(VarE("_s_var_"), "IMP"), AttrRef(VarE("top"), "s_var_IMP")); AttrEq(AttrRef(VarE("_s_var_"), "MOD"), AttrRef(VarE("top"), "s_var_MOD")); AttrEq(AttrRef(VarE("_s_var_"), "LEX"), AttrRef(VarE("top"), "s_var_LEX")); NtaEq("s_var_datum", TermE(TermT("DatumVar", [AttrRef(VarE("top"), "x")]))); AttrEq(AttrRef(VarE("s_var_datum"), "data"), TermE(TermT("ActualDataDatumVar", [AttrRef(VarE("top"), "ty")]))); AttrEq(AttrRef(VarE("top"), "s_var"), VarE("_s_var_")); NtaEq("_s_var_", TermE(TermT("mkScope", []))); AttrEq(AttrRef(VarE("_s_var_"), "datum"), VarE("s_var_datum"))]);
    ("TInt", "type", [], [], [AttrEq(AttrRef(VarE("top"), "ok"), Bool(true)); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("TInt", [])))]);
    ("TBool", "type", [], [], [AttrEq(AttrRef(VarE("top"), "ok"), Bool(true)); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("TBool", [])))]);
    ("TFun", "type", ["tyann1"; "tyann2"], ["ty1"; "ty2"], [AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("tyann1"), "ok"), And(AttrRef(VarE("tyann2"), "ok"), Bool(true)))); AttrEq(AttrRef(VarE("top"), "s_VAR"), Append(AttrRef(VarE("tyann1"), "s_VAR"), AttrRef(VarE("tyann2"), "s_VAR"))); AttrEq(AttrRef(VarE("top"), "s_IMP"), Append(AttrRef(VarE("tyann1"), "s_IMP"), AttrRef(VarE("tyann2"), "s_IMP"))); AttrEq(AttrRef(VarE("top"), "s_MOD"), Append(AttrRef(VarE("tyann1"), "s_MOD"), AttrRef(VarE("tyann2"), "s_MOD"))); AttrEq(AttrRef(VarE("top"), "s_LEX"), Append(AttrRef(VarE("tyann1"), "s_LEX"), AttrRef(VarE("tyann2"), "s_LEX"))); AttrEq(AttrRef(VarE("tyann1"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty1"), AttrRef(VarE("tyann1"), "ty")); AttrEq(AttrRef(VarE("tyann2"), "s"), AttrRef(VarE("top"), "s")); AttrEq(AttrRef(VarE("top"), "ty2"), AttrRef(VarE("tyann2"), "ty")); AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("TFun", [AttrRef(VarE("top"), "ty1"); AttrRef(VarE("top"), "ty2")])))]);
    ("ModRef", "mod_ref", ["x"], ["mods"; "xmods"; "xmods_"], [AttrEq(AttrRef(VarE("top"), "ok"), Bool(true)); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "mods"), AttrRef(TermE(TermT("query", [AttrRef(VarE("top"), "s"); TermE(TermT("regexSeq", [TermE(TermT("regexStar", [TermE(TermT("regexLabel", [TermE(TermT("labelLEX", []))]))])); TermE(TermT("regexSeq", [TermE(TermT("regexAlt", [TermE(TermT("regexLabel", [TermE(TermT("labelIMP", []))])); TermE(TermT("regexEps", []))])); TermE(TermT("regexLabel", [TermE(TermT("labelMOD", []))]))]))]))])), "ret")); AttrEq(AttrRef(VarE("top"), "xmods"), AttrRef(TermE(TermT("path_filter", [Fun("d_lam_arg", Case(VarE("d_lam_arg"), [(TermP("DatumMod", [VarP("x_")]), Equal(VarE("x_"), AttrRef(VarE("top"), "x"))); (UnderscoreP, Bool(false))])); AttrRef(VarE("top"), "mods")])), "ret")); AttrEq(AttrRef(VarE("top"), "xmods_"), AttrRef(TermE(TermT("path_min", [Fun("l", Fun("r", Case(Tuple([VarE("l"); VarE("r")]), [(TupleP([TermP("labelMOD", []); TermP("labelLEX", [])]), Int(-1)); (TupleP([TermP("labelLEX", []); TermP("labelMOD", [])]), Int(1)); (TupleP([TermP("labelMOD", []); TermP("labelIMP", [])]), Int(-1)); (TupleP([TermP("labelIMP", []); TermP("labelMOD", [])]), Int(1)); (TupleP([TermP("labelVAR", []); TermP("labelLEX", [])]), Int(-1)); (TupleP([TermP("labelLEX", []); TermP("labelVAR", [])]), Int(1)); (TupleP([TermP("labelVAR", []); TermP("labelIMP", [])]), Int(-1)); (TupleP([TermP("labelIMP", []); TermP("labelVAR", [])]), Int(1)); (TupleP([TermP("labelIMP", []); TermP("labelLEX", [])]), Int(-1)); (TupleP([TermP("labelLEX", []); TermP("labelIMP", [])]), Int(1)); (TupleP([UnderscoreP; UnderscoreP]), Int(0))]))); AttrRef(VarE("top"), "xmods")])), "ret")); AttrEq(AttrRef(VarE("top"), "p"), AttrRef(TermE(TermT("one", [AttrRef(VarE("top"), "xmods_")])), "ret"))]);
    ("VarRef", "var_ref", ["x"], ["vars"; "xvars"; "xvars_"], [AttrEq(AttrRef(VarE("top"), "ok"), Bool(true)); AttrEq(AttrRef(VarE("top"), "s_VAR"), Nil); AttrEq(AttrRef(VarE("top"), "s_IMP"), Nil); AttrEq(AttrRef(VarE("top"), "s_MOD"), Nil); AttrEq(AttrRef(VarE("top"), "s_LEX"), Nil); AttrEq(AttrRef(VarE("top"), "vars"), AttrRef(TermE(TermT("query", [AttrRef(VarE("top"), "s"); TermE(TermT("regexSeq", [TermE(TermT("regexStar", [TermE(TermT("regexLabel", [TermE(TermT("labelLEX", []))]))])); TermE(TermT("regexSeq", [TermE(TermT("regexAlt", [TermE(TermT("regexLabel", [TermE(TermT("labelIMP", []))])); TermE(TermT("regexEps", []))])); TermE(TermT("regexLabel", [TermE(TermT("labelVAR", []))]))]))]))])), "ret")); AttrEq(AttrRef(VarE("top"), "xvars"), AttrRef(TermE(TermT("path_filter", [Fun("d_lam_arg", Case(VarE("d_lam_arg"), [(TermP("DatumVar", [VarP("x_")]), Equal(VarE("x_"), AttrRef(VarE("top"), "x"))); (UnderscoreP, Bool(false))])); AttrRef(VarE("top"), "vars")])), "ret")); AttrEq(AttrRef(VarE("top"), "xvars_"), AttrRef(TermE(TermT("path_min", [Fun("l", Fun("r", Case(Tuple([VarE("l"); VarE("r")]), [(TupleP([TermP("labelMOD", []); TermP("labelLEX", [])]), Int(-1)); (TupleP([TermP("labelLEX", []); TermP("labelMOD", [])]), Int(1)); (TupleP([TermP("labelMOD", []); TermP("labelIMP", [])]), Int(-1)); (TupleP([TermP("labelIMP", []); TermP("labelMOD", [])]), Int(1)); (TupleP([TermP("labelVAR", []); TermP("labelLEX", [])]), Int(-1)); (TupleP([TermP("labelLEX", []); TermP("labelVAR", [])]), Int(1)); (TupleP([TermP("labelVAR", []); TermP("labelIMP", [])]), Int(-1)); (TupleP([TermP("labelIMP", []); TermP("labelVAR", [])]), Int(1)); (TupleP([TermP("labelIMP", []); TermP("labelLEX", [])]), Int(-1)); (TupleP([TermP("labelLEX", []); TermP("labelIMP", [])]), Int(1)); (TupleP([UnderscoreP; UnderscoreP]), Int(0))]))); AttrRef(VarE("top"), "xvars")])), "ret")); AttrEq(AttrRef(VarE("top"), "p"), AttrRef(TermE(TermT("one", [AttrRef(VarE("top"), "xvars_")])), "ret"))]);
    ("tgt", "FunResult", ["p"], ["ok"; "s"], [AttrEq(AttrRef(VarE("top"), "ok"), Bool(true)); AttrEq(AttrRef(VarE("top"), "s"), Case(AttrRef(VarE("top"), "p"), [(TermP("End", [VarP("x")]), If(Bool(true), VarE("x"), Abort("branch case else TODO"))); (TermP("Edge", [VarP("x"); VarP("l"); VarP("xs")]), If(Bool(true), AttrRef(TermE(TermT("tgt", [VarE("xs")])), "ret"), Abort("branch case else TODO"))); (UnderscoreP, Abort("Match failure!"))])); AttrEq(AttrRef(VarE("top"), "ret"), Tuple([AttrRef(VarE("top"), "ok"); AttrRef(VarE("top"), "s")]))])

]

end

module AG_Full = AG(Spec)


(****************)
(* REMOVE BELOW *)


(* empty program *)
let trivial_term: term =
  TermT("Program", [
    TermE(TermT("DeclsNil", []))
  ])

(* def a = 1 + true *)
let bad_ty_add: term =
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclDef", [
        TermE(TermT("DefBindPar", [
          String("a");
          TermE(TermT("ExprAdd", [
            TermE(TermT("ExprInt", [
              Int(1)
            ]));
            TermE(TermT("ExprTrue", []))
          ]))
        ]))
      ]));
      TermE(TermT("DeclsNil", []))
    ]))
  ])

(* def a = 1 + 2 *)
let simple_add_term: term =
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclDef", [
        TermE(TermT("DefBindPar", [
          String("a");
          TermE(TermT("ExprAdd", [
            TermE(TermT("ExprInt", [
              Int(1)
            ]));
            TermE(TermT("ExprInt", [Int(2)]))
          ]))
        ]))
      ]));
      TermE(TermT("DeclsNil", []))
    ]))
  ])

(* def a = 1 + true *)
let bad_simple_add_term: term =
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclDef", [
        TermE(TermT("DefBindPar", [
          String("a");
          TermE(TermT("ExprAdd", [
            TermE(TermT("ExprInt", [
              Int(1)
            ]));
            TermE(TermT("ExprTrue", []))
          ]))
        ]))
      ]));
      TermE(TermT("DeclsNil", []))
    ]))
  ])

(* def a = 1 + a *)
let add_term: term = 
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclDef", [
        TermE(TermT("DefBindPar", [
          String("a");
          TermE(TermT("ExprAdd", [
            TermE(TermT("ExprInt", [Int(1)]));
            TermE(TermT("ExprVar", [
              TermE(TermT("VarRef", [
                String("a")
              ]))
            ]))
          ]))
        ]))
      ]));
      TermE(TermT("DeclsNil", []))
    ]))
  ])

(* def a = a *)
let rec_add_term: term = 
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclDef", [
        TermE(TermT("DefBindPar", [
          String("a");
          TermE(TermT("ExprVar", [
              TermE(TermT("VarRef", [
                String("a")
              ]))
            ]))
        ]))
      ]));
      TermE(TermT("DeclsNil", []))
    ]))
  ])

(* def a = let x = 1 in x *)
let let_term: term =
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclDef", [
        TermE(TermT("DefBindPar", [
          String("a");
          TermE(TermT("ExprLet", [
            TermE(TermT("SeqBindsOne", [
              TermE(TermT("DefBindSeq", [
                String("x");
                TermE(TermT("ExprInt", [
                  Int(1)
                ]))
              ]))
            ]));
            TermE(TermT("ExprAdd", [ 
              TermE(TermT("ExprInt", [
                Int(1)
              ]));
              TermE(TermT("ExprVar", [
                TermE(TermT("VarRef", [
                  String("x")
                ]))
              ]))
            ]))            
          ]))
        ]))
      ]));
      TermE(TermT("DeclsNil", []))
    ]))
  ])

(* mod A { def x = 1; def y = 1 + x; } *)
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

(* mod A { def x = 1; def y = x; } 
   mod B { import A; def z = 1 + x; } 
 *)
let two_mod_imp: term =
  TermT("Program", [
    TermE(TermT("DeclsCons", [
      TermE(TermT("DeclModule", [
        String("A");
        TermE(TermT("DeclsCons", [
          TermE(TermT("DeclDef", [TermE(TermT("DefBindPar", [String("x"); TermE(TermT("ExprInt", [Int(1)]))]))]));
          TermE(TermT("DeclsCons", [
            TermE(TermT("DeclDef", [TermE(TermT("DefBindPar", [String("y"); TermE(TermT("ExprVar", [TermE(TermT("VarRef", [String("x")]))]))]))]));
            TermE(TermT("DeclsNil", []))
          ]))
        ]))
      ]));
      TermE(TermT("DeclsCons", [
        TermE(TermT("DeclModule", [
          String("B");
          TermE(TermT("DeclsCons", [

            (if false
            then
              TermE(TermT("DeclImport", [
                TermE(TermT("ModRef", [
                  String("A")
                ]))
              ]))
            else
              TermE(TermT("DeclDef", [TermE(TermT("DefBindPar", [String("x"); TermE(TermT("ExprInt", [Int(3)]))]))])));

            TermE(TermT("DeclsCons", [
              TermE(TermT("DeclDef", [
                TermE(TermT("DefBindPar", [
                  String("z");

                  TermE(TermT("ExprAdd", [
                    TermE(TermT("ExprInt", [Int(1)]));
                    TermE(TermT("ExprVar", [
                      TermE(TermT("VarRef", [
                        String("x")
                      ]))
                    ]))
                  ]))

                ]))
              ]));
              TermE(TermT("DeclsNil", []))
            ]))
          ]))
        ]));
        TermE(TermT("DeclsNil", []))
      ]))
    ]))
  ])


(* REMOVE ABOVE *)
(****************)