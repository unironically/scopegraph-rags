let debug = false
let print_interesting_eqs = false

type node_id = string
type attr_id = string
type prod_id = string
type nt_id   = string

type expr = Int      of int
          | Bool     of bool
          | String   of string
          | NodeRef  of node_id
          | AttrRef  of expr * attr_id
          | Cons     of expr * expr
          | Nil
          | Append   of expr * expr
          | Plus     of expr * expr
          | Equal    of expr * expr
          | NotEqual of expr * expr
          | And      of expr * expr
          | Or       of expr * expr         
          | ListLit  of expr list
          | Tuple    of expr list
          | TupleSec of expr * int
          | Case     of expr * case list
          | TermE    of term
          | VarE     of string
          | Left     of expr
          | Right    of expr
          | Abort
          | Fun      of string * expr
          | App      of expr * expr
          | If       of expr * expr * expr
          | Let      of string * expr * expr

and term  = TermT of string * expr list

and case = pattern * expr

and pattern = TermP of string * pattern list
            | VarP  of string
            | StringP of string
            | ConsP of pattern * pattern
            | NilP
            | TupleP of pattern list
            | UnderscoreP

type attr_status = Complete of expr
                 | Demanded
                 | Undemanded

type node_status = Visited
                 | Unvisited

(* AttrEq(AttrRef(VarE("top"), "ok"), 
          And(TupleSec(AttrRef(VarE("top"), "pair_6"), 1), Bool(true)));  *)

type equation = AttrEq of expr * expr
              | NtaEq  of node_id * expr

type stack = equation list
type set   = equation list

type attr_item = NtaStatus of node_id * attr_status
               | AttrStatus of node_id * attr_id * attr_status

type tree_item = Node of node_id * node_status * set * attr_item list

type tree  = tree_item list

type prod_child = string
type prod = prod_id * nt_id * prod_child list * prod_child list * equation list

type nt = nt_id * attr_id list

let nt_env: nt list = [
  ("Main", ["ok"; "test_lst"; "test_lst2"; "test_lst3"; "comb_test_lsts"]);
  ("Decls", ["s"; "VAR_s"; "LEX_s"; "ok"]);
  ("Decl", ["s"; "VAR_s"; "LEX_s"; "ok"]);
  ("ParBind", ["s"; "VAR_s"; "LEX_s"; "VAR_s_def"; "LEX_s_def"; "ok"; "ty"]);
  ("Expr", ["s"; "VAR_s"; "LEX_s"; "ok"; "ty"; "datumOfResult"; "okDatumOf"; "datumPair"; "okDatumPair"; "d"]); (* todo, handle locals being only local *)
  ("VarRef", ["s"; "VAR_s"; "LEX_s"; "ok"; "p"; "vars"; "order"; "xvars"; "xvars_"; "dwf"; "onlyResult"]);

  ("SeqBinds", ["s"; "s_def"; "s_def_syn"; "VAR_s"; "LEX_s"; "VAR_s_def"; "LEX_s_def"; "ok"]);
  ("SeqBind", ["s"; "s_def"; "s_def_syn"; "VAR_s"; "LEX_s"; "VAR_s_def"; "LEX_s_def"; "ok"]);

  ("Type", []);

  ("Scope", ["LEX"; "VAR"; "IMP"; "MOD"; "datum"]);
  ("Datum", []);
  ("Edges", ["dfa"; "nwce"; "edgeLabel"]);

  ("DFA", ["paths"; "start"]);
  ("DFAState", ["paths"; "varT"; "lexT"]);

  ("FunResult", ["ret"])
]

let globalLabelList: expr = 
  Cons(
    TermE(TermT("labelLEX", [])),
    Cons (
      TermE(TermT("labelVAR", [])),
      Nil
    )
  )

let prod_env: prod list = [

  (
    "mkScope", "Scope",
    [], [],
    []
  );

  (
    "mkScopeDatum", "Scope",
    ["d"], [],
    [ AttrEq(AttrRef(VarE("top"), "datum"), VarE("d")) ]
  );

  (
    "datumVar", "FunResult", (* TODO: better way to not make a tree out of ty here, when mk_tree called on datumVar *)
    ["name"; "ty"], [],
    []
  );

  (
    "INT", "Type",
    [], [],
    []
  );

  (
    "program", "Main",
    ["ds"], [],
    [ NtaEq("s", TermE(TermT("mkScope", [])));
      AttrEq(AttrRef(VarE("s"), "LEX"), AttrRef(VarE("ds"), "LEX_s"));
      AttrEq(AttrRef(VarE("s"), "VAR"), AttrRef(VarE("ds"), "VAR_s"));
      AttrEq(AttrRef(VarE("ds"), "s"), VarE("s"));
      AttrEq(AttrRef(VarE("top"), "ok"), AttrRef(VarE("ds"), "ok"))
    ]
  );

  (
    "declsCons", "Decls",
    ["d"; "ds"], [],
    [ AttrEq(AttrRef(VarE("d"), "s"), AttrRef(VarE("top"), "s"));
      AttrEq(AttrRef(VarE("ds"), "s"), AttrRef(VarE("top"), "s"));
      AttrEq(AttrRef(VarE("top"), "VAR_s"), AttrRef(TermE(TermT("list_append", [AttrRef(VarE("d"), "VAR_s"); AttrRef(VarE("ds"), "VAR_s")])), "ret"));
      AttrEq(AttrRef(VarE("top"), "LEX_s"), AttrRef(TermE(TermT("list_append", [AttrRef(VarE("d"), "LEX_s"); AttrRef(VarE("ds"), "LEX_s")])), "ret"));
      AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("d"), "ok"), AttrRef(VarE("ds"), "ok"))) ]
  );

  (
    "declsNil", "Decls",
    [], [],
    [ AttrEq(AttrRef(VarE("top"), "VAR_s"), Nil);
      AttrEq(AttrRef(VarE("top"), "LEX_s"), Nil);
      AttrEq(AttrRef(VarE("top"), "ok"), Bool(true)) ]
  );

  (
    "declDef", "Decl",
    ["pb"], [],
    [ AttrEq(AttrRef(VarE("pb"), "s"), AttrRef(VarE("top"), "s"));
      AttrEq(AttrRef(VarE("top"), "ok"), AttrRef(VarE("pb"), "ok"));
      AttrEq(AttrRef(VarE("top"), "VAR_s"), AttrRef(TermE(TermT("list_append", [AttrRef(VarE("pb"), "VAR_s"); AttrRef(VarE("pb"), "VAR_s_def")])), "ret"));
      AttrEq(AttrRef(VarE("top"), "LEX_s"), AttrRef(TermE(TermT("list_append", [AttrRef(VarE("pb"), "LEX_s"); AttrRef(VarE("pb"), "LEX_s_def")])), "ret")) ]
  );

  (
    "parBindUntyped", "ParBind",
    ["id"; "e"], [],
    [ 
      NtaEq("s_var", TermE(TermT("mkScopeDatum", [TermE(TermT("datumVar", [VarE("id"); AttrRef(VarE("e"), "ty")]))])));
      AttrEq(AttrRef(VarE("s_var"), "LEX"), Nil);
      AttrEq(AttrRef(VarE("s_var"), "VAR"), Nil);

      AttrEq(AttrRef(VarE("e"), "s"), AttrRef(VarE("top"), "s"));
      AttrEq(AttrRef(VarE("top"), "VAR_s"), AttrRef(VarE("e"), "VAR_s"));
      AttrEq(AttrRef(VarE("top"), "LEX_s"), AttrRef(VarE("e"), "LEX_s"));
      AttrEq(AttrRef(VarE("top"), "VAR_s_def"), Cons(VarE("s_var"), Nil));
      AttrEq(AttrRef(VarE("top"), "LEX_s_def"), Nil);
      AttrEq(AttrRef(VarE("top"), "ok"), AttrRef(VarE("e"), "ok")) ]
  );

  (
    "exprAdd", "Expr",
    ["e1"; "e2"], [],
    [ AttrEq(AttrRef(VarE("e1"), "s"), AttrRef(VarE("top"), "s"));
      AttrEq(AttrRef(VarE("e2"), "s"), AttrRef(VarE("top"), "s"));
      AttrEq(AttrRef(VarE("top"), "VAR_s"), AttrRef(TermE(TermT("list_append", [AttrRef(VarE("e1"), "VAR_s"); AttrRef(VarE("e2"), "VAR_s")])), "ret"));
      AttrEq(AttrRef(VarE("top"), "LEX_s"), AttrRef(TermE(TermT("list_append", [AttrRef(VarE("e1"), "LEX_s"); AttrRef(VarE("e2"), "LEX_s")])), "ret"));
      AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("e1"), "ok"), 
                            And(AttrRef(VarE("e2"), "ok"),
                              And(Case(AttrRef(VarE("e1"), "ty"), [(TermP("INT", []), Bool(true)); (UnderscoreP, Bool(false))]),
                                  App(Fun("x", Equal(VarE("x"), TermE(TermT("INT", [])))), AttrRef(VarE("e2"), "ty"))))));
      AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("INT", []))) ]
  );

  (
    "exprLetSeq", "Expr",
    ["sbs"; "e"], [],
    [ NtaEq("s_let", AttrRef(VarE("sbs"), "s_def_syn"));

      AttrEq(AttrRef(VarE("s_let"), "VAR"), AttrRef(TermE(TermT("list_append", [AttrRef(VarE("sbs"), "VAR_s_def"); AttrRef(VarE("e"), "VAR_s")])), "ret"));
      AttrEq(AttrRef(VarE("s_let"), "LEX"), AttrRef(TermE(TermT("list_append", [AttrRef(VarE("sbs"), "LEX_s_def"); AttrRef(VarE("e"), "LEX_s")])), "ret"));

      AttrEq(AttrRef(VarE("sbs"), "s"), AttrRef(VarE("top"), "s"));
      AttrEq(AttrRef(VarE("sbs"), "s_def"), VarE("s_let"));

      AttrEq(AttrRef(VarE("e"), "s"), VarE("s_let"));

      AttrEq(AttrRef(VarE("top"), "ty"), AttrRef(VarE("e"), "ty"));
      AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("sbs"), "ok"), AttrRef(VarE("e"), "ok")));
      AttrEq(AttrRef(VarE("top"), "VAR_s"), AttrRef(VarE("sbs"), "VAR_s"));
      AttrEq(AttrRef(VarE("top"), "LEX_s"), AttrRef(VarE("sbs"), "LEX_s"));
    ]
  );

  (* SeqBinds *)

  (
    "seqBindsOne", "SeqBinds",
    ["sb"], [],
    [ AttrEq(AttrRef(VarE("sb"), "s"), AttrRef(VarE("top"), "s"));
      AttrEq(AttrRef(VarE("sb"), "s_def"), AttrRef(VarE("top"), "s_def"));

      AttrEq(AttrRef(VarE("top"), "VAR_s"), AttrRef(VarE("sb"), "VAR_s"));
      AttrEq(AttrRef(VarE("top"), "LEX_s"), AttrRef(VarE("sb"), "LEX_s"));

      AttrEq(AttrRef(VarE("top"), "VAR_s_def"), AttrRef(VarE("sb"), "VAR_s_def"));
      AttrEq(AttrRef(VarE("top"), "LEX_s_def"), Cons(AttrRef(VarE("top"), "s"), AttrRef(VarE("sb"), "LEX_s_def")));
      
      AttrEq(AttrRef(VarE("top"), "s_def_syn"), TermE(TermT("mkScope", [])));

      AttrEq(AttrRef(VarE("top"), "ok"), AttrRef(VarE("sb"), "ok")) ]
  );

  (
    "seqBindsCons", "SeqBinds",
    ["sb"; "sbs"], [],
    [ NtaEq("s_def_", TermE(TermT("mkScope", [])));
      
      AttrEq(AttrRef(VarE("s_def_"), "LEX"), Cons(AttrRef(VarE("top"), "s"), AttrRef(TermE(TermT("list_append", [AttrRef(VarE("sb"), "LEX_s_def"); AttrRef(VarE("sbs"), "LEX_s")])), "ret")));

      AttrEq(AttrRef(VarE("s_def_"), "VAR"), AttrRef(TermE(TermT("list_append", [AttrRef(VarE("sb"), "VAR_s_def"); AttrRef(VarE("sbs"), "VAR_s")])), "ret"));
      
      AttrEq(AttrRef(VarE("sb"), "s"), AttrRef(VarE("top"), "s"));
      AttrEq(AttrRef(VarE("sb"), "s_def"), AttrRef(VarE("top"), "s_def"));
      
      AttrEq(AttrRef(VarE("sbs"), "s"), VarE("s_def_"));
      AttrEq(AttrRef(VarE("sbs"), "s_def"), AttrRef(VarE("top"), "s_def"));
      
      AttrEq(AttrRef(VarE("top"), "VAR_s"), AttrRef(VarE("sb"), "VAR_s"));
      AttrEq(AttrRef(VarE("top"), "LEX_s"), AttrRef(VarE("sb"), "LEX_s"));

      AttrEq(AttrRef(VarE("top"), "VAR_s_def_"), AttrRef(VarE("sbs"), "VAR_s_def"));
      AttrEq(AttrRef(VarE("top"), "LEX_s_def_"), AttrRef(VarE("sbs"), "LEX_s_def"));

      AttrEq(AttrRef(VarE("top"), "s_def_syn"), AttrRef(VarE("sbs"), "s_def_syn"));

      AttrEq(AttrRef(VarE("top"), "ok"), And(AttrRef(VarE("sb"), "ok"), AttrRef(VarE("sbs"), "ok")))
    ]
  );

  (
    "seqBindUntyped", "SeqBind",
    ["id"; "e"], [],
    [
      NtaEq("s_var", TermE(TermT("mkScopeDatum", [TermE(TermT("datumVar", [VarE("id"); AttrRef(VarE("e"), "ty")]))])));
      AttrEq(AttrRef(VarE("s_var"), "LEX"), Nil);
      AttrEq(AttrRef(VarE("s_var"), "VAR"),  Nil);

      AttrEq(AttrRef(VarE("e"), "s"), AttrRef(VarE("top"), "s"));

      AttrEq(AttrRef(VarE("top"), "VAR_s"), AttrRef(VarE("e"), "VAR_s"));
      AttrEq(AttrRef(VarE("top"), "LEX_s"), AttrRef(VarE("e"), "LEX_s"));

      AttrEq(AttrRef(VarE("top"), "VAR_s_def"), Cons(VarE("s_var"), Nil));

      AttrEq(AttrRef(VarE("top"), "LEX_s_def"), Nil);

      AttrEq(AttrRef(VarE("top"), "ok"), AttrRef(VarE("e"), "ok")); ]
  );



  (
    "exprInt", "Expr",
    ["i"], [],
    [ AttrEq(AttrRef(VarE("top"), "ok"), Bool(true));
      AttrEq(AttrRef(VarE("top"), "ty"), TermE(TermT("INT", [])));
      AttrEq(AttrRef(VarE("top"), "VAR_s"), Nil);
      AttrEq(AttrRef(VarE("top"), "LEX_s"), Nil) ]
  );

  (
    "exprVar", "Expr",
    ["r"], [],
    [ AttrEq(AttrRef(VarE("r"), "s"), AttrRef(VarE("top"), "s"));
      AttrEq(AttrRef(VarE("top"), "VAR_s"), AttrRef(VarE("r"), "VAR_s"));
      AttrEq(AttrRef(VarE("top"), "LEX_s"), AttrRef(VarE("r"), "LEX_s"));

      AttrEq(AttrRef(VarE("top"), "datumOfResult"),
        AttrRef(
          TermE(TermT("datumOf", [AttrRef(VarE("r"), "p")])),
          "ret"
        )
      );

      AttrEq(AttrRef(VarE("top"), "okDatumOf"), 
        Case (
          AttrRef(VarE("top"), "datumOfResult"),
          [
            (TupleP([VarP("ok'"); UnderscoreP]), VarE("ok'"))
          ]
        )
      );

      AttrEq(AttrRef(VarE("top"), "d"), 
        Case (
          AttrRef(VarE("top"), "datumOfResult"),
          [
            (TupleP([UnderscoreP; VarP("d'")]), VarE("d'"))
          ]
        )
      );

      AttrEq(AttrRef(VarE("top"), "datumPair"),
        Case (
          AttrRef(VarE("top"), "d"),
          [
            (TermP("datumVar", [VarP("x"); VarP("ty'")]), Tuple([Bool(true); VarE("x"); VarE("ty'")]));
            (UnderscoreP, Tuple([Bool(false); String(""); Abort]))
          ]
        )
      );

      AttrEq(AttrRef(VarE("top"), "okDatumPair"),
        Case (
          AttrRef(VarE("top"), "datumPair"),
            [ (TupleP([VarP("ok'"); UnderscoreP; UnderscoreP]), VarE("ok'")) ]
          )
      );

      AttrEq(AttrRef(VarE("top"), "ty"),
        Case (
          AttrRef(VarE("top"), "datumPair"),
          [ (TupleP([UnderscoreP; UnderscoreP; VarP("ty'")]), VarE("ty'")) ]
        )
      );

      AttrEq(AttrRef(VarE("top"), "ok"), 
        And (
          AttrRef(VarE("r"), "ok"),
          And (
            AttrRef(VarE("top"), "okDatumOf"),
            AttrRef(VarE("top"), "okDatumPair")
          )
        )
        
      );

    ]
  );

  (
    "varRef", "VarRef",
    ["x"], ["rx"],
    [ 
      (*
      NtaEq("dfa", TermE(TermT("varRefDFA", [])));
      NtaEq("nwceNode", TermE(TermT("nwce", [AttrRef(VarE("top"), "s"); VarE("dfa")])));
      *)

      AttrEq(AttrRef(VarE("top"), "rx"),
        TermE(TermT("regexSeq", [
          TermE(TermT("regexStar", [TermE(TermT("regexLabel", [TermE(TermT("labelLEX", []))]))]));
          TermE(TermT("regexLabel", [TermE(TermT("labelVAR", []))]))
        ]))
      );

      (* LEX* VAR *)
      NtaEq("nwceNode",
        TermE(TermT("dwce", [
          AttrRef(VarE("top"), "rx");
          AttrRef(VarE("top"), "s")
        ]))
      );

      AttrEq(AttrRef(VarE("top"), "dwf"),
        Fun ("s",
          Case (
            AttrRef(VarE("s"), "datum"),
            [ (TermP("datumVar", [VarP("x'"); UnderscoreP]), Equal(VarE("x"), VarE("x'")));
              (UnderscoreP, Bool(false))
            ]
          )
        )
      );

      NtaEq("queryNode", TermE(TermT("query2", [
        AttrRef(VarE("top"), "s"); 
        AttrRef(VarE("top"), "rx")
      ])));

      (* needs cleaning, perhaps allow multiple patterns: case l, r of ...*)
      AttrEq(AttrRef(VarE("top"), "order"),
        Fun("l",
          Fun("r",
            Case (
              VarE("l"),
              [
                (TermP("pEdge", [VarP("src"); StringP("VAR"); VarP("rest")]),
                  Case (
                    VarE("r"),
                    [ (TermP("pEdge", [UnderscoreP; StringP("LEX"); UnderscoreP]), Int(-1));
                      (TermP("pEdge", [UnderscoreP; StringP("VAR"); UnderscoreP]), Int(0));
                      (TermP("pEnd", [UnderscoreP]), Int(1)) ]
                  )
                );
                (TermP("pEdge", [VarP("src"); StringP("LEX"); VarP("rest")]),
                  Case (
                    VarE("r"),
                    [ (TermP("pEdge", [UnderscoreP; StringP("LEX"); UnderscoreP]), Int(0));
                      (TermP("pEdge", [UnderscoreP; StringP("VAR"); UnderscoreP]), Int(1));
                      (TermP("pEnd", [UnderscoreP]), Int(1)) ]
                  )
                );
                (TermP("pEnd", [UnderscoreP]),
                  Case (
                    VarE("r"),
                    [
                      (TermP("pEnd", [UnderscoreP]), Int(0));
                      (UnderscoreP, Int(-1))
                    ]
                  )
                )
              ]
            )
          )
        )
      );

      AttrEq(AttrRef(VarE("top"), "vars"),
        If (
          AttrRef(VarE("nwceNode"), "ret"),
          AttrRef(VarE("queryNode"), "ret"),
          Abort
        )
      );

      AttrEq(AttrRef(VarE("top"), "xvars"),
        AttrRef(
          TermE(TermT("path_filter", [
            AttrRef(VarE("top"), "dwf");
            AttrRef(VarE("top"), "vars")
          ])), "ret"
        )
      );

      AttrEq(AttrRef(VarE("top"), "xvars_"),
        AttrRef(
          TermE(TermT("min-refs", [AttrRef(VarE("top"), "order"); AttrRef(VarE("top"), "xvars")])),
          "ret"
        )
      );

      AttrEq(AttrRef(VarE("top"), "onlyResult"),
        AttrRef(
          TermE(TermT("only", [AttrRef(VarE("top"), "xvars_")])),
          "ret"
        )
      );

      AttrEq(AttrRef(VarE("top"), "p"),
        Case (
          AttrRef(VarE("top"), "onlyResult"), [ 
            (TupleP([UnderscoreP; VarP("p'")]), VarE("p'"))
          ]
        )
      );

      AttrEq(AttrRef(VarE("top"), "ok"),
        Case (
          AttrRef(VarE("top"), "onlyResult"),
          [ (TupleP([VarP("ok'"); UnderscoreP]), VarE("ok'")) ]
        )
      );

      AttrEq(AttrRef(VarE("top"), "VAR_s"), Nil);
      AttrEq(AttrRef(VarE("top"), "LEX_s"), Nil) ]
  );

  (* QUERY *)
  (
    "resolve", "FunResult",
    ["rx"; "s"], ["wasEmptySetRx"; "wasEpsilonRx"],
    [
      (* remove *)
      AttrEq(AttrRef(VarE("top"), "wasEmptySetRx"),
        AttrRef(TermE(TermT("isEmptySet", [AttrRef(VarE("top"), "rx")])), "ret")
      );

      (* remove *)
      AttrEq(AttrRef(VarE("top"), "wasEpsilonRx"),
        AttrRef(TermE(TermT("isEpsilon", [AttrRef(VarE("top"), "rx")])), "ret")
      );

      AttrEq(AttrRef(VarE("top"), "ret"), 

        (* remove the case that encloses the if.. just for testing *)
        Case(AttrRef(VarE("top"), "wasEpsilonRx"), [(UnderscoreP, Case(AttrRef(VarE("top"), "wasEmptySetRx"), [(UnderscoreP, 
        If(AttrRef(TermE(TermT("isEmptySet", [AttrRef(VarE("top"), "rx")])), "ret"),

          Nil,

          If(AttrRef(TermE(TermT("isEpsilon", [AttrRef(VarE("top"), "rx")])), "ret"),
            
            Cons(
              TermE(TermT("pEnd", [AttrRef(VarE("top"), "s")])),
              Nil
            ),

            AttrRef(TermE(TermT("list_concat", [
              AttrRef(TermE(TermT("list_map", [ (* for every label *)
                Fun("l",

                  AttrRef(TermE(TermT("list_concat", [

                  AttrRef(TermE(TermT("list_map", [
                    Fun("s'",
                      AttrRef(TermE(TermT("resolve", [
                        AttrRef(TermE(TermT("match", [VarE("l"); AttrRef(VarE("top"), "rx")])), "ret");
                        VarE("s'");
                      ])), "ret"));
                    AttrRef(TermE(TermT("demandEdgesForLabel", [AttrRef(VarE("top"), "s"); VarE("l")])), "ret")
                  ])), "ret")

                  ])), "ret")

                );
                globalLabelList (* todo - generic *)
              ])), "ret")
            ])), "ret")

          )
        ))]))])
      )
    ]
  );

  (
    "query", "FunResult",
    ["s"; "rx"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        App(App(AttrRef(VarE("dfa"), "paths"), VarE("s")), VarE("dwf"))
      )
    ]
  );

  (
    "query2", "FunResult",
    ["s"; "rx"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        AttrRef(
          TermE(TermT("resolve", [
            AttrRef(VarE("top"), "rx"); AttrRef(VarE("top"), "s")
          ])),
          "ret"
        )
      )
    ]
  );

  (* FILTER *)

  (
    "path_filter", "FunResult",
    ["f"; "ps"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        AttrRef(
          TermE(TermT("list_fold_right", [
            Fun("p", Fun("acc",
              Let ("pTgt", AttrRef(TermE(TermT("tgt", [VarE("p")])), "ret"),
                Case(VarE("pTgt"), [
                  (TupleP([VarP("ok_"); VarP("s_")]),
                    If (App(AttrRef(VarE("top"), "f"), VarE("s_")),
                      Cons(VarE("p"), VarE("acc")),
                      VarE("acc")
                    )
                  )
                ])
              )
            ));
            AttrRef(VarE("top"), "ps");
            Nil
          ])),
          "ret"
        )
      )
    ]
  );

  (* MIN-REFS *)

  (
    "min-refs", "FunResult",
    ["f"; "lst"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case (
          VarE("lst"),
          [
            (NilP, 
              (* -> *) Nil);
            
            (ConsP(VarP("h"), NilP),
              (* -> *) Cons(VarE("h"), Nil));

            (ConsP(VarP("h"), VarP("t")), 
              (* -> *) Let (
                         "rec_res",
                         AttrRef(TermE(TermT("min-refs", [VarE("f"); VarE("t")])), "ret"),
                         Case (
                           VarE("rec_res"),
                           [
                            (ConsP(VarP("h'"), VarP("t'")),
                              Let (
                                "compare_res",
                                AttrRef(TermE(TermT("min-refs-pair", [VarE("f"); VarE("h"); VarE("h'")])), "ret"),
                                If (
                                  Equal (VarE("compare_res"), Int(-1)),
                                  Cons(VarE("h"), Nil),
                                  If (
                                    Equal (VarE("compare_res"), Int(1)),
                                    VarE("rec_res"),
                                    Cons(VarE("h"), VarE("rec_res"))
                                  )
                                )
                              )
                            )
                           ]
                         )
                       )
            );

            (ConsP(VarP("h"), VarP("t")),
              (* -> *) Let (
                         "rec_res",
                         AttrRef(TermE(TermT("min-refs", [VarE("f"); VarE("t")])), "ret"),
                         Case (
                           VarE("rec_res"),
                           [
                            (ConsP(VarP("h'"), VarP("t'")),
                              Let (
                                "compare_res",
                                AttrRef(TermE(TermT("min-refs-pair", [VarE("f"); VarE("h"); VarE("h'")])), "ret"),
                                If (
                                  Equal (VarE("compare_res"), Int(-1)),
                                  Cons(VarE("h"), Nil),
                                  If (
                                    Equal (VarE("compare_res"), Int(1)),
                                    VarE("rec_res"),
                                    Cons(VarE("h"), VarE("rec_res"))
                                  )
                                )
                              )
                            )
                           ]
                         )
                       )
            )

          ]
        )
      );
    ]
  );

  (
    "min-refs-pair", "FunResult",
    ["f"; "p1"; "p2"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"), App(App(VarE("f"), VarE("p1")), VarE("p2")))
    ]
  );

  (* ONLY *)

  (
    "only", "FunResult",
    ["lst"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case (
          VarE("lst"),
          [ (ConsP(VarP("h"), NilP), 
              (* -> *)Tuple([Bool(true); VarE("h")]));
            (UnderscoreP, 
              (* -> *) Tuple([Bool(false); Abort])) ]
        )
      )
    ]
  );

  (* TGT *)

  (
    "tgt", "FunResult",
    ["path"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case (
          VarE("path"),
          [
            (TermP("pEnd", [VarP("x")]), Tuple([Bool(true); VarE("x")]));
            (TermP("pEdge", [UnderscoreP; UnderscoreP; VarP("rest")]), AttrRef(TermE(TermT("tgt", [VarE("rest")])), "ret"))
          ]
        )
      )
    ]
  );

  (* DATUMOF *)

  (
    "datumOf", "FunResult",
    ["path"], [],
    [
      NtaEq("tgtNode", TermE(TermT("tgt", [VarE("path")])));
      
      AttrEq(AttrRef(VarE("top"), "ret"),
        Let (
          "tgtNodeRes", AttrRef(VarE("tgtNode"), "ret"),
          Case (
            VarE("tgtNodeRes"),
            [
              (TupleP([VarP("ok'"); VarP("s'")]),
                (* -> *) Tuple([VarE("ok'"); AttrRef(VarE("s'"), "datum")])
              )
            ]
          )
        )
      );
    ]
  );

  (* DWCE *)

  (
    "nullableAnd", "FunResult",
    ["r1"; "r2"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Let("r1res", AttrRef(TermE(TermT("nullable", [VarE("r1")])), "ret"),
          Let("r2res", AttrRef(TermE(TermT("nullable", [VarE("r2")])), "ret"),
            And(
              Equal(VarE("r1res"), TermE(TermT("regexEps", []))),
              Equal(VarE("r2res"), TermE(TermT("regexEps", [])))
            )
          )
        )
      )
    ]
  );

  (
    "nullableOr", "FunResult",
    ["r1"; "r2"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Let("r1res",   AttrRef(TermE(TermT("nullable", [VarE("r1")])), "ret"),
          Let("r2res", AttrRef(TermE(TermT("nullable", [VarE("r2")])), "ret"),
            Or(
              Equal(VarE("r1res"), TermE(TermT("regexEps", []))),
              Equal(VarE("r2res"), TermE(TermT("regexEps", [])))
            )
          )
        )
      )
    ]
  );

  (
    "nullable", "FunResult",
    ["r"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case(AttrRef(VarE("top"), "r"), [
          ( (* sym a *)
            TermP("regexLabel", [VarP("a")]),
            (* -> *) Bool(false)
          );
          ( (* eps *)
            TermP("regexEps", []),
            (* -> *) Bool(true)
          );
          ( (* emptyset *)
            TermP("regexEmptySet", []),
            (* -> *) Bool(false)
          );
          ( (* star *)
            TermP("regexStar", [VarP("sub")]),
            (* -> *) Bool(true)
          );
          ( (* cat *)
            TermP("regexSeq", [VarP("r1"); VarP("r2")]),
            (* -> *) AttrRef(TermE(TermT("nullableAnd", [VarE("r1"); VarE("r2")])), "ret")
          );
          ( (* and *)
            TermP("regexAnd", [VarP("r1"); VarP("r2")]),
            (* -> *) AttrRef(TermE(TermT("nullableAnd", [VarE("r1"); VarE("r2")])), "ret")
          );
          ( (* or *)
            TermP("regexAlt", [VarP("r1"); VarP("r2")]),
            (* -> *) AttrRef(TermE(TermT("nullableOr", [VarE("r1"); VarE("r2")])), "ret")
          );
          ( (* not *)
            TermP("regexNeg", [VarP("sub")]),
            (* -> *) AttrRef(TermE(TermT("nullable", [VarE("sub")])), "ret")
          )
        ])
      )
    ]
  );

  (
    "match", "FunResult",
    ["a"; "r"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"), 
        Case(AttrRef(VarE("top"), "r"), [

          ( (* sym b *)
          TermP("regexLabel", [VarP("b")]),
          (* -> *) If(Equal(VarE("a"), VarE("b")),
                    TermE(TermT("regexEps", [])),
                    TermE(TermT("regexEmptySet", [])))
          );
          ( (* eps *)
            TermP("regexEps", []),
            (* -> *) TermE(TermT("regexEmptySet", []))
          );
          ( (* emptyset *)
            TermP("regexEmptySet", []),
            (* -> *) TermE(TermT("regexEmptySet", []))
          );
          ( (* star *)
            TermP("regexStar", [VarP("sub")]),
            (* -> *) TermE(TermT("regexSeq", [
                      AttrRef(TermE(TermT("match", [VarE("a"); VarE("sub")])), "ret"); 
                      TermE(TermT("regexStar", [VarE("sub")]))
                     ]))
          );
          ( (* cat *)
            TermP("regexSeq", [VarP("r1"); VarP("r2")]),
            (* -> *) Let("r1nullable", AttrRef(TermE(TermT("nullable", [VarE("r1")])), "ret"),
                      Let("r1rec", TermE(TermT("regexSeq", [AttrRef(TermE(TermT("match", [VarE("a"); VarE("r1")])), "ret"); VarE("r2")])),
                        If(VarE("r1nullable"),
                          TermE(TermT("regexAlt", [VarE("r1rec"); AttrRef(TermE(TermT("match", [VarE("a"); VarE("r2")])), "ret")])),
                          VarE("r1rec")
                        )
                      )
                     )
          );
          ( (* and *)
            TermP("regexAnd", [VarP("r1"); VarP("r2")]),
            (* -> *) TermE(TermT("regexAnd", [
                      AttrRef(TermE(TermT("match", [VarE("a"); VarE("r1")])), "ret");
                      AttrRef(TermE(TermT("match", [VarE("a"); VarE("r2")])), "ret");
                     ]))
          );
          ( (* or *)
            TermP("regexAlt", [VarP("r1"); VarP("r2")]),
            (* -> *) TermE(TermT("regexAlt", [
                      AttrRef(TermE(TermT("match", [VarE("a"); VarE("r1")])), "ret");
                      AttrRef(TermE(TermT("match", [VarE("a"); VarE("r2")])), "ret");
                     ]))
          );
          ( (* not *)
            TermP("regexNeg", [VarP("sub")]),
            (* -> *) TermE(TermT("regexNeg", [AttrRef(TermE(TermT("match", [VarE("a"); VarE("sub")])), "ret")]))
          )

        ])
      )
    ]
  );

  ( (* builtin for LM here, but should be generated from Statix spec *)
    "demandEdgesForLabel", "FunResult",
    ["s"; "l"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case(AttrRef(VarE("top"), "l"), [
          (TermP("labelLEX", []), AttrRef(VarE("s"), "LEX"));
          (TermP("labelVAR", []), AttrRef(VarE("s"), "VAR"));
          (TermP("labelIMP", []), AttrRef(VarE("s"), "IMP"));
          (TermP("labelMOD", []), AttrRef(VarE("s"), "MOD"))
        ])
      )
    ]
  );

  (
    "isEmptySet", "FunResult",
    ["r"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case(AttrRef(VarE("top"), "r"), [
          ( (* sym a *)
            TermP("regexLabel", [VarP("a")]), (* -> *) Bool(false)
          );
          ( (* eps *)
            TermP("regexEps", []), (* -> *) Bool(false)
          );
          ( (* emptyset *)
            TermP("regexEmptySet", []), (* -> *) Bool(true)
          );
          ( (* star *)
            TermP("regexStar", [VarP("sub")]), (* -> *) 
              AttrRef(TermE(TermT("isEmptySet", [VarE("sub")])), "ret")
          );
          ( (* cat *)
            TermP("regexSeq", [VarP("r1"); VarP("r2")]),
            (* -> *) Or (
                      AttrRef(TermE(TermT("isEmptySet", [VarE("r1")])), "ret"),
                      AttrRef(TermE(TermT("isEmptySet", [VarE("r2")])), "ret")
                     )
          );
          ( (* and *)
            TermP("regexAnd", [VarP("r1"); VarP("r2")]),
            (* -> *) Or (
                      AttrRef(TermE(TermT("isEmptySet", [VarE("r1")])), "ret"),
                      AttrRef(TermE(TermT("isEmptySet", [VarE("r2")])), "ret")
                     )
          );
          ( (* or *)
            TermP("regexAlt", [VarP("r1"); VarP("r2")]),
            (* -> *) And (
                      AttrRef(TermE(TermT("isEmptySet", [VarE("r1")])), "ret"),
                      AttrRef(TermE(TermT("isEmptySet", [VarE("r2")])), "ret")
                     )
          );
          ( (* not *)
            TermP("regexNeg", [VarP("sub")]),
            (* -> *) AttrRef(TermE(TermT("isEmptySet", [VarE("sub")])), "ret")
          )
        ])
      )
    ]
  );

  (
    "isEpsilon", "FunResult",
    ["r"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case(AttrRef(VarE("top"), "r"), [
          ( (* sym a *)
            TermP("regexLabel", [VarP("a")]), (* -> *) Bool(false)
          );
          ( (* eps *)
            TermP("regexEps", []), (* -> *) Bool(true)
          );
          ( (* emptyset *)
            TermP("regexEmptySet", []), (* -> *) Bool(false)
          );
          ( (* star *)
            TermP("regexStar", [VarP("sub")]), (* -> *) Bool(false)
          );
          ( (* cat *)
            TermP("regexSeq", [VarP("r1"); VarP("r2")]),
            (* -> *) And (
                      AttrRef(TermE(TermT("isEpsilon", [VarE("r1")])), "ret"),
                      AttrRef(TermE(TermT("isEpsilon", [VarE("r2")])), "ret")
                     )
          );
          ( (* and *)
            TermP("regexAnd", [VarP("r1"); VarP("r2")]),
            (* -> *) And (
                      AttrRef(TermE(TermT("isEpsilon", [VarE("r1")])), "ret"),
                      AttrRef(TermE(TermT("isEpsilon", [VarE("r2")])), "ret")
                     )
          );
          ( (* or *)
            TermP("regexAlt", [VarP("r1"); VarP("r2")]),
            (* -> *) 
                    Let("r1Empty", AttrRef(TermE(TermT("isEmptySet", [VarE("r1")])), "ret"),    (* true *)
                      Let ("r2Empty", AttrRef(TermE(TermT("isEmptySet", [VarE("r2")])), "ret"), (* false *)

                        Or (
                          And ( (* false *)
                            AttrRef(TermE(TermT("isEpsilon", [VarE("r1")])), "ret"),
                            AttrRef(TermE(TermT("isEpsilon", [VarE("r2")])), "ret")
                          ),
                          Or (
                            And( (* true *)
                              VarE("r1Empty"),
                              AttrRef(TermE(TermT("isEpsilon", [VarE("r2")])), "ret")
                            ),
                            And ( (* false *)
                              VarE("r2Empty"),
                              AttrRef(TermE(TermT("isEpsilon", [VarE("r1")])), "ret")
                            )
                          )
                        )
                      )
                    )
          );
          ( (* not *)
            TermP("regexNeg", [VarP("sub")]),
            (* -> *) Bool(false) (* ? *)
          )
        ])
      )
    ]
  );

  (
    "dwce", "FunResult",
    ["r"; "s"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        If(AttrRef(TermE(TermT("isEmptySet", [AttrRef(VarE("top"), "r")])), "ret"),
          Bool(true),
          If(AttrRef(TermE(TermT("isEpsilon", [AttrRef(VarE("top"), "r")])), "ret"),
            Case(AttrRef(VarE("s"), "datum"), [(UnderscoreP, Bool(true))]),

            AttrRef(TermE(TermT("list_fold_right", [  (* for every label *)
              Fun("l", Fun("acc", 
                And(VarE("acc"),
                  AttrRef(TermE(TermT("list_all", [
                    AttrRef(TermE(TermT("list_map", [ (* for every target of l edge from s*)
                      Fun("s'", AttrRef(TermE(TermT("dwce", [
                        AttrRef(TermE(TermT("match", [VarE("l"); AttrRef(VarE("top"), "r")])), "ret");
                        VarE("s'")
                      ])), "ret"));
                      AttrRef(TermE(TermT("demandEdgesForLabel", [AttrRef(VarE("top"), "s"); VarE("l")])), "ret")
                    ])), "ret")
                  ])), "ret")
                )
              ));
              globalLabelList; (* todo - generic *)
              Bool(true);
            ])), "ret")

          )
        )
      )
    ]
  );

  (* NWCE *)

  (
    "nwce", "FunResult",
    ["s"; "dfa"], [],
    [ NtaEq("nwceStateNode", TermE(TermT("nwceState", [VarE("s"); AttrRef(VarE("dfa"), "start")])));
      AttrEq(AttrRef(VarE("top"), "ret"), AttrRef(VarE("nwceStateNode"), "ret")) ]
  );

  (
    "nwceState", "FunResult",
    ["s"; "dfa"], [],
    [ AttrEq(AttrRef(VarE("top"), "ret"),
        Case (VarE("dfa"), [
          (TermP("stateFinal", []), Case(AttrRef(VarE("s"), "datum"), [(UnderscoreP, Bool(true))]));
          (TermP("stateSink", []),  Bool(true));
          (TermP("stateVar", []),
             And(
              AttrRef(
                TermE(TermT("list_all", [
                  AttrRef(
                    TermE(TermT("list_map", [Fun("s", AttrRef(TermE(TermT("nwceState", [VarE("s"); AttrRef(VarE("dfa"), "varT")])), "ret"));
                                             AttrRef(VarE("s"), "VAR")])),
                    "ret"
                  )
                ])), 
                "ret"
              ),
              AttrRef(
                TermE(TermT("list_all", [
                  AttrRef(
                    TermE(TermT("list_map", [Fun("s", AttrRef(TermE(TermT("nwceState", [VarE("s"); AttrRef(VarE("dfa"), "lexT")])), "ret"));
                                             AttrRef(VarE("s"), "LEX")])),
                    "ret"
                  )
                ])), 
                "ret"
              )
            )
          )
        ])
      )

    ]
  );

  (* DFA *)

  (
    "varRefDFA", "DFA",
    [], [],
    [ NtaEq("stateStart", TermE(TermT("stateVar", [])));
      AttrEq(AttrRef(VarE("stateStart"), "lexT"), VarE("stateStart"));
      AttrEq(AttrRef(VarE("stateStart"), "varT"), VarE("stateFinal"));

      NtaEq("stateFinal", TermE(TermT("stateFinal", [])));
      AttrEq(AttrRef(VarE("stateStart"), "lexT"), VarE("stateSink"));
      AttrEq(AttrRef(VarE("stateStart"), "varT"), VarE("stateSink"));

      NtaEq("stateSink", TermE(TermT("stateSink", [])));
      AttrEq(AttrRef(VarE("stateStart"), "lexT"), VarE("stateSink"));
      AttrEq(AttrRef(VarE("stateStart"), "varT"), VarE("stateSink"));
      
      AttrEq(AttrRef(VarE("top"), "start"), VarE("stateStart"));
      AttrEq(AttrRef(VarE("top"), "paths"), AttrRef(VarE("stateStart"), "paths")) ]
  );

  (* GENERIC LIST *)

  ( (* good *)
    "list_fold_right", "FunResult",
    ["f"; "lst"; "initial"], [],
    [ AttrEq(AttrRef(VarE("top"), "ret"),
        Case (
          VarE("lst"),
          [
            (NilP, VarE("initial"));
            (ConsP(VarP("h"), VarP("t")),
              (* -> *) App(
                         App(VarE("f"), VarE("h")), 
                         AttrRef(TermE(TermT("list_fold_right", [
                           VarE("f"); VarE("t"); 
                           VarE("initial")])), 
                         "ret")
                       )
            ) 
          ]
        )
      ) ]
  );


  (
    "list_all", "FunResult",
    ["lst"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        AttrRef(
          TermE(TermT("list_fold_right", [
            Fun("item", Fun("acc", And(VarE("item"), VarE("acc"))));
            VarE("lst");
            Bool(true)
          ])),
          "ret"
        )
      )
    ]
  );

  ( (* good *)
    "list_append", "FunResult",
    ["l1"; "l2"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case (VarE("l1"),
          [
            (NilP, VarE("l2"));
            (ConsP(VarP("h"), VarP("t")), 
              (* -> *) Cons(VarE("h"), AttrRef(TermE(TermT("list_append", [VarE("t"); VarE("l2")])), "ret")))
          ]
        )
      )
    ]
  );

  ( (* good *)
    "list_map", "FunResult",
    ["f"; "lst"], [],
    [ AttrEq(AttrRef(VarE("top"), "ret"),
        AttrRef(
          TermE(TermT("list_fold_right", [
            Fun("item", Fun("acc", Cons(App(VarE("f"), VarE("item")), VarE("acc"))));
            VarE("lst");
            Nil
          ])),
          "ret"
        )
      ) ]
  );

  ( (* good *)
    "list_concat", "FunResult",
    ["lsts"], [],
    [ AttrEq(AttrRef(VarE("top"), "ret"),
        AttrRef(
          TermE(TermT("list_fold_right", [
            Fun("item", Fun("acc", 
            
              If(Equal(VarE("item"), Nil),
                VarE("acc"),
                If(Equal(VarE("acc"), Nil),
                  VarE("item"),
                  AttrRef(TermE(TermT("list_append", [VarE("item"); VarE("acc")])), "ret")
                )
              )
            
            ));
            VarE("lsts");
            Nil
          ])),
          "ret"
        )
      ) ]
  );

  ( (* good *)
    "list_length", "FunResult",
    ["lst"], [],
    [ AttrEq(AttrRef(VarE("top"), "ret"),
        AttrRef(
          TermE(TermT("list_fold_right", [
            Fun("_", Fun("acc", Plus(Int(1), VarE("acc"))));
            VarE("lst");
            Int(0)
          ])),
          "ret"
        )
      ) ]
  );

]


(********************)
(***** PRINTING *****)

let rec str_pattern (p: pattern): string =
  match p with
  | TermP(s, ps) -> s ^ "(" ^ (String.concat ", " (List.map str_pattern ps)) ^ ")"
  | VarP x -> x
  | StringP s -> "\"" ^ s ^ "\""
  | UnderscoreP -> "_"
  | TupleP(ps) -> "(" ^ (String.concat ", " (List.map str_pattern ps)) ^ ")"
  | ConsP(h, t) -> (str_pattern h) ^ "::" ^ (str_pattern t)
  | NilP -> "[]"

let rec str_expr (e: expr): string =
  let rec str_cases (cs: case list): string =
    match cs with
    | [] -> ""
    | (p, e)::[] -> (str_pattern p) ^ " -> " ^ str_expr e
    | (p, e)::t  -> (str_pattern p) ^ " -> " ^ str_expr e ^ " | " ^ str_cases t
  in
  match e with

  | Int i -> string_of_int i
  | Bool b -> string_of_bool b
  | String s -> "\"" ^ s ^ "\""
  | NodeRef n -> n
  | AttrRef (e, a) -> (str_expr e) ^ "." ^ a
  | Cons(h, t) -> (str_expr h) ^ " :: " ^ (str_expr t)
  | Nil -> "[]"
  | Append(h, t) -> (str_expr h) ^ " ++ " ^ (str_expr t)
  | Plus(h, t) -> (str_expr h) ^ " + " ^ (str_expr t)
  | Equal(h, t) -> (str_expr h) ^ " == " ^ (str_expr t)
  | NotEqual(h, t) -> (str_expr h) ^ " != " ^ (str_expr t)
  | And(h, t) -> (str_expr h) ^ " && " ^ (str_expr t)
  | Or(h, t) -> (str_expr h) ^ " || " ^ (str_expr t)
  | Tuple es -> "(" ^ (String.concat "," (List.map str_expr es)) ^ ")"
  | TupleSec(e, i) -> (str_expr e) ^ "." ^ (string_of_int i)
  | Case (e, cs) -> "case " ^ str_expr e ^ " of " ^ str_cases cs
  | TermE(t) -> str_term t
  | VarE x -> x
  | Left e -> (str_expr e) ^ ".l"
  | Right e -> (str_expr e) ^ ".r"
  | Abort         -> "ERROR"
  | Fun (x, e) -> "\\" ^ x ^ " -> " ^ str_expr e
  | App (e1, e2) -> (str_expr e1) ^ "(" ^ (str_expr e2) ^ ")"
  | If (e1, e2, e3) -> "if " ^ (str_expr e1) ^ " then " ^ (str_expr e2) ^ " else " ^ (str_expr e3)
  | Let (s, e1, e2) -> "let " ^ s ^ " = " ^ (str_expr e1) ^ " in " ^ (str_expr e2)
  
and str_term (TermT(s, es): term): string =
  s ^ "(" ^ (String.concat ", " (List.map str_expr es)) ^ ")"

let rec str_eq (e: equation): string =
  match e with
  | AttrEq(AttrRef(VarE(n), a), e) -> n ^ "." ^ a ^ " = " ^ str_expr e
  | NtaEq(n, e) -> n ^ " = " ^ str_expr e

let rec str_stack (s: stack): string =
  match s with
  | [] -> "[]\n"
  | h::t -> (str_eq h) ^ "\n:: " ^ (str_stack t)

let strlist_set (eqs: set): string list =
  let rec strlist_set_items (eqs: set): string list =
    match eqs with
    | [] -> []
    | h::[] -> [str_eq h]
    | h::t -> (str_eq h) :: (strlist_set_items t)
  in
  strlist_set_items eqs

let str_set (eqs: set): string =
  let strs: string list = strlist_set eqs in
  if List.is_empty strs
  then "[]"
  else "[" ^ (String.concat "" (List.map (fun x -> "\n  " ^ x) strs)) ^ "\n]"

let str_status (s: attr_status): string =
  match s with
  | Complete(e) -> "Complete(" ^ (str_expr e) ^ ")"
  | Demanded    -> "Demanded"
  | Undemanded  -> "Undemanded"

let rec str_tree (t: tree): string =
  let str_node_visited (ns: node_status): string =
    match ns with
    | Visited -> "Visited"
    | Unvisited -> "Unvisited"
  in
  let str_attr_status (status: attr_item): string =
    match status with
    | AttrStatus(n, a, s) -> n ^ "." ^ a ^ " = " ^ str_status s 
    | NtaStatus(n, s)     -> n ^ " = " ^ str_status s 
  in
  match t with
  | [] -> ""
  | Node(n, s, eqs, attrs)::t -> (* TODO: clean this up... *)
      "(\n  " ^ 
        "node: " ^ n ^ ",\n  " ^ 
        "status: " ^ (str_node_visited s) ^ ",\n  " ^ 
        "uninstantiated equations: [\n" ^ 
          (String.concat "" (List.map (fun x -> "    " ^ x ^ "\n") (strlist_set eqs))) ^ "  " ^ 
        "],\n  " ^
        "attributes: [\n" ^ 
          (String.concat "" (List.map (fun x -> "    " ^ x ^ "\n") 
                                      ((List.map str_attr_status attrs)))) ^ "  " ^
        "]\n" ^
      ")" ^ (if List.is_empty t then "" else ",") ^ "\n" ^
      str_tree t


(****************)
(***** UTIL *****)

let print_interesting (s: string): unit = 
  if print_interesting_eqs
  then print_endline s
  else ()

(* all: ('a -> bool) -> 'a list -> bool
 * returns true if all elements in a list satisfy the given predicate
 *)
let rec all (p: 'a -> bool) (lst: 'a list): bool =
  match lst with
  | [] -> true
  | h::t -> (p h) && all p t


(* lookup a production ID in a production environment *)
let rec lookup_prod (p: prod_id) (ps: prod list): prod option =
  match ps with
  | [] -> None
  | (p', n, cs, ls, eqs)::_ when p = p' -> Some (p', n, cs, ls, eqs)
  | _::rest -> lookup_prod p rest


(* lookup a nonterminal ID in a nonterminal environment *)
let rec lookup_nt (n: nt_id) (nts: nt list): nt option =
  match nts with
  | [] -> None
  | (id, attrs)::_ when n = id -> Some (id, attrs)
  | _::rest -> lookup_nt n rest


(* lookup the equations in the tree for a node given its ID *)
let rec lookup_eqs (n: node_id) (t: tree): equation list =
  match t with
  | [] -> []
  | Node(n', _, eqs, _)::_ when n = n' -> eqs
  | _::t -> lookup_eqs n t


(* set_node_attrs_as :: node_id -> attr_item list -> tree -> tree
 * replace the attribute list of node n with the list given as argument and
 * produce a new tree
 *)
let rec set_node_attrs_as (n: node_id) (attrs: attr_item list) (t: tree): tree =
  match t with
  | [] -> []
  | Node(n', nt, eqs, _)::t when n = n' -> Node(n, nt, eqs, attrs)::t
  | h::t -> h :: set_node_attrs_as n attrs t


(* lookup_node :: node_id -> tree -> tree_item option
 * lookup a node identifier in the tree
 *)
let rec lookup_node (n: node_id) (t: tree): tree_item option =
  match t with
  | [] -> None
  | Node(n', nt, eqs, attrs)::_ when n = n' -> Some (Node(n, nt, eqs, attrs))
  | _::t -> lookup_node n t


(**)
let rec lookup_complete_attr_set ((n, a): node_id * attr_id) (attrs: attr_item list): expr option =
  match attrs with
  | [] -> None
  | AttrStatus(n', a', Complete(e))::_ when n = n' && a = a' -> Some e
  | _::t -> lookup_complete_attr_set (n, a) t


(* instantiate_eqs :: string -> node_id -> set -> set
 * given a name, a node ID, and an equation set - substitute the name for the 
 * node ID in the equations 
 *)
let instantiate_eqs_set (name: string) (node: node_id) (eqs: set): set =
  let rec instantiate_expr (e: expr): expr =
    match e with 
    | Int(_) -> e
    | Bool(_) -> e
    | String(_) -> e
    | NodeRef n -> if n = name then NodeRef(node) else e
    | AttrRef(e, a) -> AttrRef(instantiate_expr e, a)
    | Cons(e1, e2) -> Cons(instantiate_expr e1, instantiate_expr e2)
    | Nil -> e
    | Append(e1, e2) -> Append(instantiate_expr e1, instantiate_expr e2)
    | Plus(e1, e2) -> Plus(instantiate_expr e1, instantiate_expr e2)
    | Equal(e1, e2) -> Equal(instantiate_expr e1, instantiate_expr e2)
    | NotEqual(e1, e2) -> NotEqual(instantiate_expr e1, instantiate_expr e2)
    | And(e1, e2) -> And(instantiate_expr e1, instantiate_expr e2)
    | Or(e1, e2) -> Or(instantiate_expr e1, instantiate_expr e2)
    | Tuple es -> Tuple(List.map instantiate_expr es)
    | TupleSec(e, i) -> TupleSec(instantiate_expr e, i)
    | Case(e, ps) -> Case(instantiate_expr e, List.map instantiate_case ps)
    | TermE t -> TermE (instantiate_term t)
    | VarE x -> if x = name then NodeRef node else e
    | Left e -> Left (instantiate_expr e)
    | Right e -> Right(instantiate_expr e)
    | Abort -> e
    | Fun (x, e) -> if x = name then Fun(x, e) else Fun(x, instantiate_expr e)
    | App(e1, e2) -> App(instantiate_expr e1, instantiate_expr e2)
    | If(e1, e2, e3) -> If(instantiate_expr e1, instantiate_expr e2, instantiate_expr e3)
    | Let(s, e1, e2) -> if s = name then Let(name, e1, instantiate_expr e2) 
                                    else Let(s, instantiate_expr e1, instantiate_expr e2)
  and instantiate_case ((p, e): case): case =
    (p, instantiate_expr e)
  and instantiate_term (TermT(s, es): term): term =
    TermT(s, List.map instantiate_expr es)
  in
  let instantiate_eq (eq: equation): equation =
    match eq with
    | AttrEq(AttrRef(VarE(n), a), e) -> let e_instantiated: expr = instantiate_expr e in
                         let n' = if n = name then node else n in
                         AttrEq(AttrRef(VarE(n'), a), e_instantiated)
    | NtaEq(n, e) -> let e_instantiated: expr = instantiate_expr e in
                     let n' = if n = name then node else n in
                     NtaEq(n', e_instantiated)
  in
  List.map instantiate_eq eqs


(* instantiate_eqs :: string -> node_id -> tree -> set
 * given a name and a node ID, substitute the name for the node ID in the 
 * equations for that node, found from the tree
 *)
let instantiate_eqs (name: string) (n: node_id) (t: tree): set * tree =
  let rec mark_node_visited (t: tree): tree =
    match t with
    | [] -> []
    | Node(n', s, eqs, attrs)::rest when n = n' -> Node(n, Visited, eqs, attrs)::rest
    | h::t -> h::mark_node_visited t
  in
  let eqs_for_node: set = lookup_eqs n t in
  let instantiated: set = instantiate_eqs_set name n eqs_for_node in
  let t' = mark_node_visited t in
  (instantiated, t')


(* substitute_expr :: string -> expr -> expr -> expr
 * substitute an expression for a string name in an expression
 *)
let rec substitute_expr (s: string) (e': expr) (e: expr): expr =
  let substitute_case ((p, e): case): case =
    (p, substitute_expr s e' e)
  in
  let substitute_term (TermT(termName, es): term): term =
    TermT(termName, List.map (substitute_expr s e') es)
  in
  match e with 
  | Int(_) -> e
  | Bool(_) -> e
  | String(_) -> e
  | NodeRef _ -> e
  | AttrRef(e, a) -> AttrRef(substitute_expr s e' e, a)
  | Cons(e1, e2) -> Cons(substitute_expr s e' e1, substitute_expr s e' e2)
  | Nil -> e
  | Append(e1, e2) -> Append(substitute_expr s e' e1, substitute_expr s e' e2)
  | Plus(e1, e2) -> Plus(substitute_expr s e' e1, substitute_expr s e' e2)
  | Equal(e1, e2) -> Equal(substitute_expr s e' e1, substitute_expr s e' e2)
  | NotEqual(e1, e2) -> NotEqual(substitute_expr s e' e1, substitute_expr s e' e2)
  | And(e1, e2) -> And(substitute_expr s e' e1, substitute_expr s e' e2)
  | Or(e1, e2) -> Or(substitute_expr s e' e1, substitute_expr s e' e2)
  | Tuple es -> Tuple(List.map (substitute_expr s e') es)
  | TupleSec(e, i) -> TupleSec(substitute_expr s e' e, i)
  | Case(e, ps) -> Case(substitute_expr s e' e, List.map substitute_case  ps)
  | TermE t -> TermE (substitute_term t)
  | VarE x -> if x = s then e' else e
  | Left e -> Left (substitute_expr s e' e)
  | Right e -> Right(substitute_expr s e' e)
  | Abort -> e
  | Fun (x, e) -> if x = s then Fun (x, e) else Fun (x, substitute_expr s e' e)
  | App(e1, e2) -> App(substitute_expr s e' e1, substitute_expr s e' e2)
  | If(e1, e2, e3) -> If(substitute_expr s e' e1, substitute_expr s e' e2, substitute_expr s e' e3)
  | Let(s', e1, e2) -> if s' = s then Let(s, e1, substitute_expr s e' e2)
                                 else Let(s', substitute_expr s e' e1, substitute_expr s e' e2)

(* substitute_eqs :: string -> expr -> equations -> equations
 * substitute an expression for a string name in an equation set
 *)
let substitute_eqs (s: string) (e': expr) (eqs: set): set =
  let substitute_eq (eq: equation): equation =
    match eq with
    | AttrEq(AttrRef(VarE(n), a), e) -> AttrEq(AttrRef(VarE(n), a), substitute_expr s e' e)
    | NtaEq(n, e)     -> NtaEq(n, substitute_expr s e' e)
  in
  List.map substitute_eq eqs


(* mk_node_id :: string -> string 
 * generate a new node identifier
 *)
  let mk_node_id (s: string): string =
    s ^ "_" ^ (string_of_int (Random.int 100000))


(* mk_tree :: node_id -> term -> tree
 * given a node ID and a production ID:
 * 1. find the correct production
 * 2. make new node IDs its children that are syntactic terms
 * 3. partially instantiate the equations of the production with those 
 *    names/node IDS, and substitute children otherwise (e.g. if an arg is an int)
 * 4. make node IDs for NTAs in the production, instantiate the equations with those
 * 5.1. make tree slots for attributes of this node
 * 5.2. make "intrinsic" attribute slots
 * 6. put everything created above in the tree as a new node
 * 7. recursive call on children of `t` that are terms to build the tree, giving
      the node IDs created for them in step 2
 *)
let rec mk_tree (n: node_id) (TermT(p, es): term): tree =

  (* 1. find the correct production *)
  let Some (_, nt_name, children, locals, eqs) = lookup_prod p prod_env in
  
  (* 2. make new node IDs for children of `t` that are terms *)
  let rec match_children (ch_decls: prod_child list)
                         (es: expr list): (string * expr) list =
    match ch_decls, es with
    | [], []         -> []
    | cd::cds, TermE(t)::es when nt_name <> "FunResult" -> 
        let child_node_id = mk_node_id cd in
        (cd, NodeRef(child_node_id)) :: match_children cds es
    | cd::cds, e::es -> (cd, e) :: match_children cds es
    | _, _ -> raise (Failure ("Unequal child decl/argument lists in match_children for " ^ p ^ "!"))
  in
  let matched_children: (string * expr) list = match_children children es in

  (* 3. instantiate the equations of the production with child names/node IDS,
        and substitute children otherwise *)
  let instantiate_child ((s, e): string * expr) (eqs: set): set =
    match e with
    | NodeRef(n) -> instantiate_eqs_set s n eqs
    | e          -> substitute_eqs s e eqs
  in
  let instantiated_eqs: set = 
    List.fold_right instantiate_child matched_children eqs in

  (* 4. make node IDs for NTAs *)
  let is_nta_equation (e: equation): bool =
    match e with
    | NtaEq(_, _) -> true
    | _ -> false
  in
  let nta_equations: equation list = List.filter is_nta_equation instantiated_eqs in
  let nta_names: string list = List.map (fun (NtaEq(n, _)) -> n) nta_equations in
  let instantiated_eqs: set = 
    List.fold_right (fun s eqs -> instantiate_eqs_set s (mk_node_id s) eqs) 
                    nta_names instantiated_eqs
  in

  (* 5.1. make slots for attributes (incl. locals) *)
  let Some (_, attrs) = lookup_nt nt_name nt_env in
  let attribute_slots_tree: attr_item list = 
    List.map (fun a -> AttrStatus(n, a, Undemanded)) (attrs @ locals) in

  (* 5.2. make slots for "intrinsic" attributes *)
  let rec make_child_attrs (lst: (string * expr) list): attr_item list =
    match lst with
    | [] -> []
    | (s, e)::t -> AttrStatus(n, s, Complete(e)) :: (make_child_attrs t)
  in
  let id_attr: attr_item = AttrStatus(n, "id", Complete(NodeRef(n))) in
  let prod_attr: attr_item = AttrStatus(n, "prod", Complete(String(p))) in
  let intrinsic_attrs_tree: attr_item list = 
    id_attr :: prod_attr :: make_child_attrs matched_children in

  (* 6. put node name, equations and attributes in the tree *)
  let node_eqs_tree: tree = [ Node(n, Unvisited, instantiated_eqs, intrinsic_attrs_tree @ attribute_slots_tree) ] in

  (* 7. recursive call on children that are terms *)
  let rec mk_sub_trees (es: expr list) (chs: (string * expr) list): tree list =
    match es, chs with
    | [], [] -> []
    | TermE(t)::es, (_, NodeRef(n))::chs -> (mk_tree n t)::(mk_sub_trees es chs)
    | _::es, _::chs -> mk_sub_trees es chs
    | _, _ -> raise (Failure "Unequal child decl/argument lists in term_children!")
  in
  let sub_trees: tree list = mk_sub_trees es matched_children in
  node_eqs_tree @
  List.concat sub_trees


(* unvisited_node :: node_id -> tree -> bool
 * check if a node has been visited by looking at its status in the tree
 *)
let rec unvisited_node (n: node_id) (t: tree): bool =
  match t with
  | [] -> raise (Failure ("Could not find node " ^ n ^ " in unvisited_node"))
  | Node(n', s, _, _)::_ when n = n' -> s = Unvisited
  | _::t -> unvisited_node n t


(* remove_attr_eq_for :: (node_id * attr_id) -> set -> equation option * set 
 * find from an equation set the equation whose LHS is `n.a`. return that
 * equation and the remaining equation set
 *)
let rec remove_attr_eq_for ((n, a): node_id * attr_id) (eqs: set): equation option * set =
  match eqs with
  | [] -> (None, [])
  | AttrEq(AttrRef(VarE(n'), a'), e)::rest when n = n' && a = a' -> (Some (AttrEq(AttrRef(VarE(n'), a'), e)), rest)
  | h::rest -> let (eq, eqs') = remove_attr_eq_for (n, a) rest in (eq, h::eqs')
  

(* remove_nta_eq_for :: node_id -> set -> equation option * set
 * find from an equation set the equation whose LHS is `n`. return that equation
 * and the remaning equation set
 *)
let rec remove_nta_eq_for (n: node_id) (eqs: set): equation option * set =
  match eqs with
  | [] -> (None, [])
  | NtaEq(n', e)::rest when n = n'-> (Some (NtaEq(n, e)), rest)
  | h::rest -> let (eq, eqs') = remove_nta_eq_for n rest in (eq, h::eqs')


(* attr_status :: (node_id * attr_id) -> tree -> status 
 * returns the status of attribute n.a in the tree
 *)
let attr_status ((n, a): node_id * attr_id) (t: tree): attr_status =
  let Some(Node(_, _, _, attrs)) = lookup_node n t in
  let rec get_attr_status (statuses: attr_item list): attr_status option =
    match statuses with
    | [] -> None
    | AttrStatus(_, a', s)::_ when a = a' -> Some s
    | _::t -> get_attr_status t
  in
  let Some s = get_attr_status attrs in s


(* make_complete :: (node_id * attr_id) -> expr -> tree -> tree 
 * mark an attribute as complete with an expression that should be a value
 * return the resulting tree
 *)
let make_complete ((n, a): node_id * attr_id) (e: expr) (t: tree): tree =
  let Some(Node(_, _, _, attrs)) = lookup_node n t in
  let rec complete_attr_status (statuses: attr_item list): attr_item list =
    match statuses with
    | [] -> []
    | AttrStatus(_, a', s)::t when a = a' -> AttrStatus(n, a, Complete(e))::t
    | h::t -> h :: complete_attr_status t
  in
  set_node_attrs_as n (complete_attr_status attrs) t


(* make_demanded :: (node_id * attr_id) -> tree -> tree
 * mark an attribute as Demanded in the tree
 *)
 let make_demanded ((n, a): node_id * attr_id) (t: tree): tree =
  let Some(Node(_, _, _, attrs)) = lookup_node n t in
  let rec demanded_attr_status (statuses: attr_item list): attr_item list =
    match statuses with
    | [] -> []
    | AttrStatus(_, a', s)::t when a = a' -> AttrStatus(n, a, Demanded)::t
    | h::t -> h :: demanded_attr_status t
  in
  set_node_attrs_as n (demanded_attr_status attrs) t

(* replace_first :: (node_id * attr_id) -> expr -> stack -> stack
 * find the first `n.a = e` in the stack and replace `e` with the expr given
 * as an argument
 *)
let rec replace_first ((n, a): node_id * attr_id) (e': expr) (s: stack): stack =
  match s with
  | [] -> []
  | AttrEq(AttrRef(VarE(n'), a'), e)::rest when n = n' && a = a' -> AttrEq(AttrRef(VarE(n), a), e') :: rest
  | h::t -> h :: replace_first (n, a) e' t


(* replace_first_nta :: node_id -> expr -> stack -> stack
 * similar to replace_first, but for NTA equations
 *)
let rec replace_first_nta (n: node_id) (e': expr) (s: stack): stack =
  match s with
  | [] -> []
  | NtaEq(n', e)::rest when n = n' -> NtaEq(n, e') :: rest
  | h::t -> h :: replace_first_nta n e' t


(* nta_equation_in_set :: node_id -> set -> bool
 * returns true if an equation `n = e` is in the set where `n` is the name of
 * the node given as an argument
 *)
let rec nta_equation_in_set (n: node_id) (eqs: set): bool =
  match eqs with
  | [] -> false
  | NtaEq(n', _)::_ when n = n' -> true
  | _::rest -> nta_equation_in_set n rest

(* unify_one :: pattern -> expr -> tree -> ((string * expr) list) option
 * returns `Some` over a list of bindings of pattern variables to expressions, 
 * if `e` is unifiable with `p`. Othewise, `None`.
 *)
let rec unify_one (p: pattern) (e: expr) (t: tree): ((string * expr) list) option =
  match p with
  | TermP(s, ps) -> 
      (match e with

      | TermE(TermT(s', es)) when s = s' && List.length ps == List.length es ->
          let sub_unify: (((string * expr) list) option) list =
            List.map2 (fun ps es -> unify_one ps es t) ps es
          in
          let all_some: bool =
            all Option.is_some sub_unify
          in
            if all_some
            then Some (List.concat (List.map (fun (Some lst) -> lst) sub_unify))
            else None
      
      | NodeRef(n) ->
          let Some(Node(id, _, eqs, attrs)) = lookup_node n t in
          let Some(String(prod_name)) = lookup_complete_attr_set (id, "prod") attrs in
          let Some (_, _, cs, _, _) = lookup_prod prod_name prod_env in
          let child_expr_list: expr list = List.filter_map (fun c -> lookup_complete_attr_set (id, c) attrs) cs in
          let e' = (TermE(TermT(prod_name, child_expr_list))) in
          let res = unify_one p e' t in
          res

      | _ -> None)

  | VarP x       -> Some [(x, e)]
  | StringP s    -> (match e with String(s') when s = s' -> Some [] | _ -> None)
  | UnderscoreP  -> Some []
  
  | NilP -> (match e with Nil -> Some [] 
                        | _ -> None)

  | ConsP(hp, tp) -> (match e with Cons(he, te) -> let unify_h = unify_one hp he t in
                                                   let unify_t = unify_one tp te t in
                                                   if Option.is_none unify_h ||
                                                      Option.is_none unify_t
                                                   then None
                                                   else let Some(lsth) = unify_h  in
                                                        let Some(lstt) = unify_t in
                                                        Some(lsth @ lstt)
                                 | _ -> None)

  | TupleP(ps)   -> 
      (match e with 
      | Tuple(es) -> 
          let sub_unify: (((string * expr) list) option) list =
            List.map2 (fun ps es -> unify_one ps es t) ps es in
          let all_some: bool =
            all Option.is_some sub_unify in
          if all_some
          then Some (List.concat (List.map (fun (Some lst) -> lst) sub_unify))
          else None
      | _ -> None)


(* unify_lst :: (pattern * expr) list -> expr -> tree -> (((string * expr) list) * expr) option
 * returns `Some` over a list of bindings and the expression to substitute those
 * bindings in if `e` is unifiable with some pattern in `ps`. Otherwise, `None`.
 *)
let rec unify_lst (ps: (pattern * expr) list) (e: expr) (t: tree): (((string * expr) list) * expr) option =
  match ps with
  | [] -> None
  | (p, e')::rest -> 
      let unify_binds: ((string * expr) list) option = unify_one p e t in
      (match unify_binds with
      | None -> unify_lst rest e t
      | Some bnds -> Some (bnds, e'))


(******************)
(***** VALUES *****)


(* value_expr :: expr -> bool
 * returns true if the expression given is a value
 *)
let rec value_expr (e: expr): bool =
  match e with
  | Abort -> true
  | Int(_) -> true
  | Bool(_) -> true
  | String(_) -> true
  | Fun(_, _) -> true
  | Cons(h, t) -> value_expr h && value_expr t
  | Nil -> true
  | NodeRef(_) -> true
  | Tuple(es) -> all value_expr es
  | TupleSec(_, _) -> false
  | TermE(t) -> value_term t
  | AttrRef(_, _) -> false
  | Append(_, _) -> false
  | Let(_, _, _) -> false
  | If(_, _, _) -> false
  
  | Plus(_, _) -> false
  | Case(_, _) -> false
  | App(_, _) -> false
  | And(_, _) -> false
  | Or(_, _) -> false
  | Equal(_, _) -> false
  | NotEqual(_, _) -> false
  | VarE(_) -> false
and value_term (TermT(s, es): term): bool = all value_expr es


(*******************************)
(***** EXPRESSION STEPPING *****)


(* and expr step is the relation: <e; stack; set> -> <e'; stack'; set'> *)
type expr_step_state = expr * tree * stack * set


(* expr_step :: expr_step_state -> expr_step_state
 * step on an expression with respect to an equation stack and set 
 *)
let rec expr_step (e, t, s, eqs: expr_step_state): expr_step_state =
  let rec step_first_nonvalue (es: expr list): expr list * expr_step_state =
    (* in an expression list, find the first expression that is not a value and
       then step on it *)
    match es with
    | []      -> raise (Failure "First_not_value found no non-value expression!")
    | h::rest -> if not (value_expr h) 
                 then let (h', t', s', eq's) = expr_step (h, t, s, eqs) in
                      (h' :: rest, (h', t', s', eq's))
                 else let (e', new_state) = step_first_nonvalue rest in
                      (h :: e', new_state)
  in
  match e with

  | e when value_expr e -> (e, t, s, eqs)

    (* expr-binop-right *)
  | Cons(e1, e2) when value_expr e1 -> 
      let (e2', t', s', eqs') = expr_step (e2, t, s, eqs) in
      (Cons(e1, e2'), t', s', eqs')
    (* expr-binop-left *)
  | Cons(e1, e2) -> 
      let (e1', t', s', eqs') = expr_step (e1, t, s, eqs) in
      (Cons(e1', e2), t', s', eqs')

    (* expr-plus-vals *)
  | Plus(e1, e2) when value_expr e1 && value_expr e2 ->
      let (Int(i1), Int(i2)) = (e1, e2) in
      (Int(i1 + i2), t, s, eqs)
    (* expr-binop-right *)
  | Plus(e1, e2) when value_expr e1 -> 
      let (e2', t', s', eqs') = expr_step (e2, t, s, eqs) in
      (Plus(e1, e2'), t', s', eqs')
    (* expr-binop-left *)
  | Plus(e1, e2) -> 
      let (e1', t', s', eqs') = expr_step (e1, t, s, eqs) in
      (Plus(e1', e2), t', s', eqs')

    (* expr-and-vals *)    
  | And(e1, e2) when value_expr e1 && value_expr e2 ->
      let (Bool(i1), Bool(i2)) = (e1, e2) in
      (Bool(i1 && i2), t, s, eqs)
    (* expr-and-false *)
  | And(Bool(false), _) -> (Bool(false), t, s, eqs)
    (* expr-and-true *)
  | And(Bool(true), e) -> (e, t, s, eqs)
    (* expr-binop-left*)
  | And(e1, e2) -> 
      let (e1', t', s', eqs') = expr_step (e1, t, s, eqs) in
      (And(e1', e2), t', s', eqs')

  (* expr-or-vals *)    
  | Or(e1, e2) when value_expr e1 && value_expr e2 ->
      let (Bool(i1), Bool(i2)) = (e1, e2) in
      (Bool(i1 || i2), t, s, eqs)
    (* expr-or-false *)
  | Or(Bool(false), e2) -> (e2, t, s, eqs)
    (* expr-or-true *)
  | Or(Bool(true), e)   -> (Bool(true), t, s, eqs)
    (* expr-binop-left*)
  | Or(e1, e2) -> 
      let (e1', t', s', eqs') = expr_step (e1, t, s, eqs) in
      (Or(e1', e2), t', s', eqs')

    (* expr-eq-vals *)
  | Equal(e1, e2) when value_expr e1 && value_expr e2 ->
      if e1 = e2
      then (Bool(true), t, s, eqs)
      else (Bool(false), t, s, eqs)
    (* expr-binop-right*)
  | Equal(e1, e2) when value_expr e1 ->
      let (e2', t', s', eqs') = expr_step (e2, t, s, eqs) in
      (Equal(e1, e2'), t', s', eqs')
    (* expr-binop-left *)
  | Equal(e1, e2) ->
      let (e1', t', s', eqs') = expr_step (e1, t, s, eqs) in
      (Equal(e1', e2), t', s', eqs') 

    (* expr-neq-vals - TODO *)
  | NotEqual(e1, e2) when value_expr e1 && value_expr e2 ->
      if e1 <> e2
      then (Bool(true), t, s, eqs)
      else (Bool(false), t, s, eqs)
    (* expr-binop-right*)
  | NotEqual(e1, e2) when value_expr e1 ->
      let (e2', t', s', eqs') = expr_step (e2, t, s, eqs) in
      (NotEqual(e1, e2'), t', s', eqs')
    (* expr-binop-left *)
  | NotEqual(e1, e2) ->
      let (e1', t', s', eqs') = expr_step (e1, t, s, eqs) in
      (NotEqual(e1', e2), t', s', eqs') 

    (* expr-tuple-step - TODO *)
  | Tuple es ->
      let (es', (e', t', s', eqs')) = step_first_nonvalue es in
      (Tuple es', t', s', eqs')

  | TupleSec(Nil, i) -> (Abort, t, s, eqs)

    (* expr-tuple-sec - TODO *)
  | TupleSec(es, i) when value_expr es ->
      let Tuple(lst) = es in
      (List.nth lst i, t, s, eqs)

    (* expr-tuple-sec-step - TODO *)
  | TupleSec(es, i) ->
      let (e', t', s', eqs') = expr_step (e, t, s, eqs) in
      (TupleSec(e', i), t', s', eqs') 

    (* expr-term-step *)
  | TermE (TermT(s, es)) -> 
      let (es', (e', t', s', eqs')) = step_first_nonvalue es in
        (TermE(TermT(s, es')), t', s', eqs')

    (* expr-attr-ref-step *)
  | AttrRef(e, a) when not (value_expr e) ->
      let (e', t', s', eqs') = expr_step (e, t, s, eqs) in
      (AttrRef(e', a), t', s', eqs') 

    (* expr-anonymous-nta : TODO *)
  | AttrRef(TermE(TermT(p, es)), a) ->
      let n = mk_node_id p in
      let t' = mk_tree n (TermT(p, es)) in
      (AttrRef(NodeRef(n), a), t @ t', s, eqs)


    (* expr-nta-instantiate *)
  | AttrRef(NodeRef(n), a) when nta_equation_in_set n eqs ->
      let (Some(eq), eqs') = remove_nta_eq_for n eqs in
      (e, t, eq :: s, eqs')

    (* expr-node-instantiate *)
  | AttrRef(NodeRef(n), a) when unvisited_node n t ->
      let (node_eqs, t'): set * tree = instantiate_eqs "top" n t in
      (*let (Some(eq), node_eqs') = remove_attr_eq_for (n, a) node_eqs in
      let t'' = make_demanded (n, a) t' in*)
      (e, t', s, eqs @ node_eqs)

    (* expr-attr-complete, expr-attr-undemanded, and cycle detection *)
  | AttrRef(NodeRef(n), a) -> 
      let n_a_status: attr_status = attr_status (n, a) t in
      (match n_a_status with
        (* expr-attr-complete *)
      | Complete(e) -> (e, t, s, eqs)
        (* cycle detection *)
      | Demanded -> raise (Failure ("Cycle detected from attribute " ^ n ^ "." ^ a ^ " - exiting"))
        (* expr-attr-undemanded*)
      | Undemanded  -> let (Some eq, eqs') = remove_attr_eq_for (n, a) eqs in
                       let t' = make_demanded (n, a) t in
                       (e, t', eq :: s, eqs'))

    (* TODO rule *)
  | Case(NodeRef(n), ps) when nta_equation_in_set n eqs ->
      let (Some(eq), eqs') = remove_nta_eq_for n eqs in
      (e, t, eq :: s, eqs')

    (* expr-case-expand *)
  | Case (e, ps) when value_expr e ->
      (match unify_lst ps e t with
      | None -> raise (Failure ("Could not unify " ^ (str_expr e) ^ "!"))
      | Some (bnds, e) -> 
          let e': expr = List.fold_right (fun (s, e') e -> substitute_expr s e' e) bnds e in
          (e', t, s, eqs))

    (* expr-case-step *)
  | Case (e, ps) -> 
      let (e', t', s', eqs') = expr_step (e, t, s, eqs) in
      (Case(e', ps), t', s', eqs')

    (* expr-beta-reduce *)
  | App (e1, e2) when value_expr e1 && value_expr e2 ->
      let Fun(x, body) = e1 in
      let e': expr = substitute_expr x e2 body in
      (e', t, s, eqs)

    (* expr-app-step-arg *)
  | App (e1, e2) when value_expr e1 ->
      let (e2', t', s', eqs') = expr_step (e2, t, s, eqs) in
      (App(e1, e2'), t', s', eqs')

    (* expr-app-step-fun *)
  | App (e1, e2) ->
      let (e1', t', s', eqs') = expr_step (e1, t, s, eqs) in
      (App(e1', e2), t', s', eqs')

    (* TODO rule *)
  | If (Bool(true), e2, e3) -> (e2, t, s, eqs)

    (* TODO rule *)
  | If (Bool(false), e2, e3) -> (e3, t, s, eqs)

    (* TODO rule *)
  | If(e1, e2, e3) ->
      let (e1', t', s', eqs') = expr_step (e1, t, s, eqs) in
      (If(e1', e2, e3), t', s', eqs')

    (* TODO rule *)
  | Let (x, e1, e2) ->
      let e2' = substitute_expr x e1 e2 in
      (e2', t, s, eqs)

  | VarE x -> raise (Failure ("TODO: expr_step: VarE, had '" ^ x ^ "'"))
  | Left e -> raise (Failure "TODO: expr_step: Left")
  | Right e -> raise (Failure "TODO: expr_step: Right")

  | Abort -> raise (Failure "Found an error, aborting...")


(*****************************)
(***** EQUATION STEPPING *****)


(* and expr step is the relation: <t | stack; set> -> <t | stack'; set'> *)
type eq_step_state = tree * stack * set


(* printing a state for debugging purposes *)
let print_state ((t, s, eqs): eq_step_state): unit =
  if debug
    then
      (print_endline "_____ TREE ______";
       print_endline (str_tree t);
       print_endline "_____ STACK _____";
       print_endline (str_stack s);
       print_endline "______ SET ______";
       print_endline (str_set eqs);
       print_endline "_________________")
    else
      ()


(* eq_step :: eq_step_state -> eq_step_state
 * step on attribute grammar evaluation with respect to a tree, and an equation
 * stack and set 
 *)
let rec eq_step (t, s, eqs: eq_step_state): eq_step_state =
  match s with

    (* done *)
  | AttrEq(AttrRef(VarE("outer"), attr), e)::rest when value_expr e ->
    print_endline ("DONE: outer." ^ attr ^ " = " ^ (str_expr e));
    (t, s, eqs)


    (* step-simple-value *)
  | AttrEq(AttrRef(VarE(n), a), e)::rest when value_expr e ->
      
      (match a with
      | "ty" | "VAR" | "LEX" | "nwce" | "ret"
          -> print_interesting ("" ^ n ^ "." ^ a ^ " = " ^ (str_expr e) ^ ".")
      | _ -> ());
      
      print_state (t, s, eqs);
      (make_complete (n, a) e t, rest, eqs)


    (* step-on-expr-normal *)
  | AttrEq(AttrRef(VarE(n), a), e)::rest when not(value_expr e) ->
      print_state (t, s, eqs);
      let (e', t', s', eqs') = expr_step (e, t, s, eqs) in
      (t', replace_first (n, a) e' s', eqs')

      
    (* step-attr-eq-lhs *)
  | AttrEq(e, _)::rest when not(value_expr e) ->
      print_state (t, s, eqs);
      let (e', t', s', eqs') = expr_step (e, t, s, eqs) in
      (t', s', eqs')


    (* step-nta-build *)
  | NtaEq(n, e)::rest when value_expr e ->
      
      let TermE(TermT(id, es)) = e in

      (match id with
      | "mkScope" | "mkScopeDatum" | "nwce" | "nwceState" | "tgt" | "datumOf"
          -> print_interesting (n ^ " = " ^ (str_expr e) ^ ".")
      | _ -> ());
    
      print_state (t, s, eqs);
      let t' = mk_tree n (TermT(id, es)) in
      let (eqs', t''): set * tree = instantiate_eqs "top" n t' in
      (t @ t'', rest, eqs @ eqs')


    (* step-on-expr-nta *)
  | NtaEq(n, e)::rest when not(value_expr e) ->
    print_state (t, s, eqs);
    let (e', t', s', eqs') = expr_step (e, t, s, eqs) in
    (t', replace_first_nta n e' s', eqs')


  | _ -> print_endline "didn't know what to do!"; (t, s, eqs) (* TODO *)
          
  

let rec keep_stepping (state: eq_step_state): unit =
    match state with
    | (t, AttrEq(AttrRef(VarE("outer"), attr), e)::rest, eqs) when value_expr e ->
      print_endline ("DONE with outer." ^ attr ^ " = " ^ (str_expr e));
        let s: stack = AttrEq(AttrRef(VarE("outer"), attr), e)::rest in
        print_state (t, s, eqs);
    | s -> keep_stepping (eq_step s)


(*********************)
(**** TEST CASES *****)


(* def a = 1 + a *)
let add_term: term = 
  TermT("program", [
    TermE(TermT("declsCons", [
      TermE(TermT("declDef", [
        TermE(TermT("parBindUntyped", [
          String("a");
          TermE(TermT("exprAdd", [
            TermE(TermT("exprInt", [
              Int(1)
            ]));
            TermE(TermT("exprVar", [
              TermE(TermT("varRef", [
                String("a")
              ]))
            ]))
          ]))
        ]))
      ]));
      TermE(TermT("declsNil", []))
    ]))
  ])


(* def a = let x = 1 in 1 + x *)
let let_term: term =
  TermT("program", [
    TermE(TermT("declsCons", [
      TermE(TermT("declDef", [
        TermE(TermT("parBindUntyped", [
          String("a");
          TermE(TermT("exprLetSeq", [
            TermE(TermT("seqBindsOne", [
              TermE(TermT("seqBindUntyped", [
                String("x");
                TermE(TermT("exprInt", [
                  Int(1)
                ]))
              ]))
            ]));
            TermE(TermT("exprAdd", [ 
              TermE(TermT("exprInt", [
                Int(1)
              ]));
              TermE(TermT("exprVar", [
                TermE(TermT("varRef",[
                  String("x")
                ]))
              ]))
            ]))            
          ]))
        ]))
      ]));
      TermE(TermT("declsNil", []))
    ]))
  ])


let add_term_state: eq_step_state =
  let init_node: node_id = "prog_000" in
  let t: tree = mk_tree init_node add_term in
  (
    t, (* initial tree *)
    AttrEq(AttrRef(VarE("outer"), "ok"), AttrRef(NodeRef(init_node), "ok")) :: [], (* initial stack *)
    [] (* initial set *)
  )


let let_term_state: eq_step_state =
  let init_node: node_id = "prog_000" in
  let t: tree = mk_tree init_node let_term in
  (
    t, (* initial tree *)
    AttrEq(AttrRef(VarE("outer"), "ret"), AttrRef(NodeRef(init_node), "ok")) :: [], (* initial stack *)
    [] (* initial set *)
  )