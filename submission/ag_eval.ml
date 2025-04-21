open Ag_syntax
open Ag_sig

module AG (Spec : AG_Spec) = struct

(* switch on for printing tree/stack/state at every step. 
 * drastically slows down evaluation for large programs!
 *)
let debug = false

(* print_state :: eq_step_state -> unit 
 * print the current AG evaluation state
 *)
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

(******************)
(***** VALUES *****)

(* all: ('a -> bool) -> 'a list -> bool
 * returns true if all elements in a list satisfy the given predicate
 *)
 let rec all (p: 'a -> bool) (lst: 'a list): bool =
  match lst with
  | [] -> true
  | h::t -> (p h) && all p t

(* value_expr :: expr -> bool
 * returns true if the expression given is a value
 *)
 let rec value_expr (e: expr): bool =
  match e with
  | Abort(_) -> false
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

(******************)

(* todo - generic *)
let globalLabelList: expr = 
  Cons(
    TermE(TermT("labelLEX", [])),
    Cons (
      TermE(TermT("labelVAR", [])),
      Cons (
        TermE(TermT("labelIMP", [])),
        Cons (
          TermE(TermT("labelMOD", [])),
          Nil
        )
      )
    )
  )

let nt_env: nt list = Spec.nt_set @ [

  (* builtin *)
  ("FunResult", ["ok"; "ret"]);
  ("datum", ["datum_id"; "data"]);
  ("ActualData", []);
  ("Scope", "datum"::Spec.label_set);

]

let prod_env: prod list = Spec.prod_set @ [

  ("mkScope", "Scope", [], [], []);

  (***********)
  (* STD LIB *)

  (
    "resolve", "FunResult",
    ["rx"; "s"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"), 
        If(AttrRef(TermE(TermT("isEmptySet", [AttrRef(VarE("top"), "rx")])), "ret"),
          Nil,
          If(AttrRef(TermE(TermT("isEpsilon", [AttrRef(VarE("top"), "rx")])), "ret"),
            Cons(
              TermE(TermT("End", [AttrRef(VarE("top"), "s")])),
              Nil
            ),
            AttrRef(TermE(TermT("list_concat", [
              AttrRef(TermE(TermT("list_map", [ (* for every label *)
                Fun("l",

                  AttrRef(TermE(TermT("list_concat", [

                  AttrRef(TermE(TermT("list_map", [
                    Fun("s'",

                      AttrRef(TermE(TermT("list_map", [
                        Fun("p",
                          TermE(TermT("Edge", [AttrRef(VarE("top"), "s"); VarE("l"); VarE("p")]))
                        );
                        AttrRef(TermE(TermT("resolve", [
                          AttrRef(TermE(TermT("match", [VarE("l"); AttrRef(VarE("top"), "rx")])), "ret");
                          VarE("s'");
                        ])), "ret")

                        ])), "ret")
                    );
                    AttrRef(TermE(TermT("demandEdgesForLabel", [AttrRef(VarE("top"), "s"); VarE("l")])), "ret")
                  ])), "ret")

                  ])), "ret")

                );
                globalLabelList
              ])), "ret")
            ])), "ret")
          )
        )
      )
    ]
  );

  (
    "query", "FunResult",
    ["s"; "rx"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),

        If (AttrRef(TermE(TermT("dwce", [AttrRef(VarE("top"), "rx"); AttrRef(VarE("top"), "s")])), "ret"),
          AttrRef(
            TermE(TermT("resolve", [AttrRef(VarE("top"), "rx"); AttrRef(VarE("top"), "s")])),
          "ret"),
          Nil
        )
      )
    ]
  );

  (* path comp pair *)
  (
    "path_comp", "FunResult",
    ["f"; "p1"; "p2"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case(Tuple([AttrRef(VarE("top"), "p1"); AttrRef(VarE("top"), "p2")]), [
          (TupleP([
            TermP("Edge", [VarP("x1"); VarP("l1"); VarP("xs1")]);
            TermP("Edge", [VarP("x2"); VarP("l2"); VarP("xs2")]);
          ]),
            Let("headRes", App(App(AttrRef(VarE("top"), "f"), VarE("l1")), VarE("l2")), 
              If(
                Equal(VarE("headRes"), Int(0)),
                AttrRef(TermE(TermT("path_comp", [
                  AttrRef(VarE("top"), "f");
                  VarE("t1");
                  VarE("t2")
                ])), "ret"),
                VarE("headRes")
              )
            )
          );
          (TupleP([TermP("End", [UnderscoreP]); TermP("End", [UnderscoreP])]), Int(0));
          (TupleP([TermP("End", [UnderscoreP]); UnderscoreP]), Int(-1));
          (TupleP([UnderscoreP; TermP("End", [UnderscoreP])]), Int(1));
        ])
      )
    ]
  );

  (
    "path_min", "FunResult",
    ["f"; "ps"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case(AttrRef(VarE("top"), "ps"), [

          (NilP, Nil);

          (ConsP(VarP("hp"), VarP("t")),
            AttrRef(
              TermE(TermT("list_fold_right", [
                Fun("item", Fun("acc", 
                  Let("hd", Case(VarE("acc"), [(ConsP(VarP("h"), UnderscoreP), VarE("h"))]),
                    Let("minRes", AttrRef(TermE(TermT("path_comp", [AttrRef(VarE("top"), "f"); VarE("item"); VarE("hd")])), "ret"), 
                      If (Equal(VarE("minRes"), Int(-1)),
                        Cons(VarE("item"), Nil),          (* current is less than hd *)
                        If(Equal(VarE("minRes"), Int(1)),
                          VarE("acc"),                    (* item is greater than hd*)
                          Cons(VarE("item"), VarE("acc")) (* item is equal to hd *)
                        )
                      )
                    )
                  )
                ));
                VarE("t");
                Cons(VarE("hp"), Nil)
              ])), "ret") )

        ])
      )
    ]
  );

  (
    "one", "FunResult",
    ["lst"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case(AttrRef(VarE("top"), "lst"), [

          (ConsP(VarP("h"), NilP), VarE("h"));

          (UnderscoreP, Abort("one arg was not singleton"))

        ])
      )
    ]
  );

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
                    If (
                      NotEqual(VarE("ok_"), Bool(true)),
                      Abort("bad tgt res in path_filter"),
                      If (
                        App(AttrRef(VarE("top"), "f"), AttrRef(VarE("s_"), "datum")),
                        Cons(VarE("p"), VarE("acc")),
                        VarE("acc")
                      )
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

  (* DWCE *)

  (
    "nullableAnd", "FunResult",
    ["r1"; "r2"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Let("r1res", AttrRef(TermE(TermT("nullable", [VarE("r1")])), "ret"),
        Let("r2res", AttrRef(TermE(TermT("nullable", [VarE("r2")])), "ret"),
          And(VarE("r1res"), VarE("r2res"))
        ))
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
          Or(VarE("r1res"), VarE("r2res"))
        ))
      )
    ]
  );

  (
    "nullable", "FunResult",
    ["r"], [],
    [
      AttrEq(AttrRef(VarE("top"), "ret"),
        Case(AttrRef(VarE("top"), "r"), [

          ( TermP("regexLabel", [VarP("a")]),
            Bool(false)
          );

          ( TermP("regexEps", []),
            Bool(true)
          );

          ( TermP("regexEmptySet", []),
            Bool(false)
          );

          ( TermP("regexStar", [VarP("sub")]),
            Bool(true)
          );

          ( TermP("regexSeq", [VarP("r1"); VarP("r2")]),
            AttrRef(TermE(TermT("nullableAnd", [VarE("r1"); VarE("r2")])), "ret")
          );

          ( TermP("regexAnd", [VarP("r1"); VarP("r2")]),
            AttrRef(TermE(TermT("nullableAnd", [VarE("r1"); VarE("r2")])), "ret")
          );

          ( TermP("regexAlt", [VarP("r1"); VarP("r2")]),
            AttrRef(TermE(TermT("nullableOr", [VarE("r1"); VarE("r2")])), "ret")
          );

          ( TermP("regexNeg", [VarP("sub")]),
            AttrRef(TermE(TermT("nullable", [VarE("sub")])), "ret")
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

          ( TermP("regexLabel", [VarP("b")]),
            If(Equal(VarE("a"), VarE("b")),
              TermE(TermT("regexEps", [])),
              TermE(TermT("regexEmptySet", [])))
          );

          ( TermP("regexEps", []),
            TermE(TermT("regexEmptySet", []))
          );

          ( TermP("regexEmptySet", []),
            TermE(TermT("regexEmptySet", []))
          );

          ( TermP("regexStar", [VarP("sub")]),
            TermE(TermT("regexSeq", [
              AttrRef(TermE(TermT("match", [VarE("a"); VarE("sub")])), "ret");
              TermE(TermT("regexStar", [VarE("sub")]))
            ]))
          );

          ( TermP("regexSeq", [VarP("r1"); VarP("r2")]),
            Let("r1nullable", AttrRef(TermE(TermT("nullable", [VarE("r1")])), "ret"),
            Let("r1rec", 
              TermE(TermT("regexSeq", [
                AttrRef(TermE(TermT("match", [VarE("a"); VarE("r1")])), "ret"); 
                        VarE("r2")
              ])),
              If(VarE("r1nullable"),
                TermE(TermT("regexAlt", [
                  VarE("r1rec"); 
                  AttrRef(TermE(TermT("match", [VarE("a"); VarE("r2")])), "ret")
                ])),
                VarE("r1rec")
              )
            ))
          );

          ( TermP("regexAnd", [VarP("r1"); VarP("r2")]),
            TermE(TermT("regexAnd", [
              AttrRef(TermE(TermT("match", [VarE("a"); VarE("r1")])), "ret");
              AttrRef(TermE(TermT("match", [VarE("a"); VarE("r2")])), "ret");
            ]))
          );

          ( TermP("regexAlt", [VarP("r1"); VarP("r2")]),
            TermE(TermT("regexAlt", [
              AttrRef(TermE(TermT("match", [VarE("a"); VarE("r1")])), "ret");
              AttrRef(TermE(TermT("match", [VarE("a"); VarE("r2")])), "ret");
            ]))
          );

          ( TermP("regexNeg", [VarP("sub")]),
            TermE(TermT("regexNeg", [
              AttrRef(TermE(TermT("match", [VarE("a"); VarE("sub")])), "ret")
            ]))
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

          ( TermP("regexLabel", [VarP("a")]), Bool(false) );

          ( TermP("regexEps", []), Bool(false) );

          ( TermP("regexEmptySet", []), Bool(true) );

          ( TermP("regexStar", [VarP("sub")]),
            AttrRef(TermE(TermT("isEmptySet", [VarE("sub")])), "ret")
          );

          ( TermP("regexSeq", [VarP("r1"); VarP("r2")]),
            Or (
              AttrRef(TermE(TermT("isEmptySet", [VarE("r1")])), "ret"),
              AttrRef(TermE(TermT("isEmptySet", [VarE("r2")])), "ret")) );

          ( TermP("regexAnd", [VarP("r1"); VarP("r2")]),
            Or (
              AttrRef(TermE(TermT("isEmptySet", [VarE("r1")])), "ret"),
              AttrRef(TermE(TermT("isEmptySet", [VarE("r2")])), "ret")) );

          ( TermP("regexAlt", [VarP("r1"); VarP("r2")]),
            And (
              AttrRef(TermE(TermT("isEmptySet", [VarE("r1")])), "ret"),
              AttrRef(TermE(TermT("isEmptySet", [VarE("r2")])), "ret")) );

          ( TermP("regexNeg", [VarP("sub")]),
            AttrRef(TermE(TermT("isEmptySet", [VarE("sub")])), "ret") )

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

          ( TermP("regexLabel", [VarP("a")]), Bool(false) );

          ( TermP("regexEps", []), Bool(true) );

          ( TermP("regexEmptySet", []), Bool(false) );
          
          ( TermP("regexStar", [VarP("sub")]), Bool(false) );

          ( TermP("regexSeq", [VarP("r1"); VarP("r2")]),
            And (
              AttrRef(TermE(TermT("isEpsilon", [VarE("r1")])), "ret"),
              AttrRef(TermE(TermT("isEpsilon", [VarE("r2")])), "ret"))
          );

          ( TermP("regexAnd", [VarP("r1"); VarP("r2")]),
            And (
              AttrRef(TermE(TermT("isEpsilon", [VarE("r1")])), "ret"),
              AttrRef(TermE(TermT("isEpsilon", [VarE("r2")])), "ret"))
          );

          ( TermP("regexAlt", [VarP("r1"); VarP("r2")]),
            Let ("r1Empty", AttrRef(TermE(TermT("isEmptySet", [VarE("r1")])), "ret"),
            Let ("r2Empty", AttrRef(TermE(TermT("isEmptySet", [VarE("r2")])), "ret"),
              Or (
                And (
                  AttrRef(TermE(TermT("isEpsilon", [VarE("r1")])), "ret"),
                  AttrRef(TermE(TermT("isEpsilon", [VarE("r2")])), "ret")),
                Or (
                  And(
                    VarE("r1Empty"),
                    AttrRef(TermE(TermT("isEpsilon", [VarE("r2")])), "ret")),
                  And (
                    VarE("r2Empty"),
                    AttrRef(TermE(TermT("isEpsilon", [VarE("r1")])), "ret")))))) );

          ( TermP("regexNeg", [VarP("sub")]), Bool(false) )

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
            Let("sid", AttrRef(VarE("s"), "id"), Bool(true)),
            AttrRef(TermE(TermT("list_fold_right", [
              Fun("l", Fun("acc", 
                And(VarE("acc"),
                  AttrRef(TermE(TermT("list_all", [
                    AttrRef(TermE(TermT("list_map", [
                      Fun("s'", AttrRef(TermE(TermT("dwce", [
                        AttrRef(TermE(TermT("match", [
                          VarE("l"); 
                          AttrRef(VarE("top"), "r")
                        ])), "ret");
                        VarE("s'")
                      ])), "ret"));
                      AttrRef(TermE(TermT("demandEdgesForLabel", [
                        AttrRef(VarE("top"), "s"); 
                        VarE("l")
                      ])), "ret")
                    ])), "ret")
                  ])), "ret")
                )
              ));
              globalLabelList;
              Bool(true);
            ])), "ret")
          )
        )
      )
    ]
  );

  (* LIST FUNS *)

  (
    "list_fold_right", "FunResult",
    ["f"; "lst"; "initial"], [],
    [ AttrEq(AttrRef(VarE("top"), "ret"),
        Case (VarE("lst"), [
            ( NilP, VarE("initial") );

            ( ConsP(VarP("h"), VarP("t")),
              App(
                App(VarE("f"), VarE("h")), 
                AttrRef(TermE(TermT("list_fold_right", [
                  VarE("f"); VarE("t"); 
                  VarE("initial")])), 
                "ret")) ) 
        ])
      )
    ]
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

  (
    "list_map", "FunResult",
    ["f"; "lst"], [],
    [ AttrEq(AttrRef(VarE("top"), "ret"),
        AttrRef(
          TermE(TermT("list_fold_right", [
            Fun("item", Fun("acc", 
              Cons(App(VarE("f"), VarE("item")), VarE("acc"))
            ));
            VarE("lst");
            Nil
          ])),
          "ret"
        )
      )
    ]
  );

  (
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
                  Append(VarE("item"), VarE("acc"))
                )
              )
            ));
            VarE("lsts");
            Nil
          ])),
          "ret"
        )
      )
    ]
  );

]


(****************)
(***** UTIL *****)


(* lookup_prod :: prod_id -> prod list -> prod option
 * lookup a production ID in a production environment 
 *)
let rec lookup_prod (p: prod_id) (ps: prod list): prod option =
  match ps with
  | [] -> None
  | (p', n, cs, ls, eqs)::_ when p = p' -> Some (p', n, cs, ls, eqs)
  | _::rest -> lookup_prod p rest


(* lookup_nt :: nt_id -> nt list -> nt option
 * lookup a nonterminal ID in a nonterminal environment
 *)
let rec lookup_nt (n: nt_id) (nts: nt list): nt option =
  match nts with
  | [] -> None
  | (id, attrs)::_ when n = id -> Some (id, attrs)
  | _::rest -> lookup_nt n rest

(* lookup_eqs :: node_id -> tree -> equation list
 * lookup the equations in the tree for a node given its ID 
 *)
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

(* lookup_complete_attr_val :: (node_id * attr_id) -> attr_item list -> expr option
 * find the value of an attribute if it is complete
 *)
let rec lookup_complete_attr_val ((n, a): node_id * attr_id) (attrs: attr_item list): expr option =
  match attrs with
  | [] -> None
  | AttrStatus(n', a', Complete(e))::_ when n = n' && a = a' -> Some e
  | _::t -> lookup_complete_attr_val (n, a) t

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
    | Abort(_) -> e
    | Fun (x, e) -> if x = name then Fun(x, e) else Fun(x, instantiate_expr e)
    | App(e1, e2) -> App(instantiate_expr e1, instantiate_expr e2)
    | If(e1, e2, e3) -> If(instantiate_expr e1, instantiate_expr e2, 
                                                instantiate_expr e3)
    | Let(s, e1, e2) -> 
        if s = name 
        then Let(name, e1, instantiate_expr e2) 
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
    | Node(n', s, eqs, attrs)::rest when n = n' -> 
        Node(n, Visited, eqs, attrs)::rest
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
  | Abort(_) -> e
  | Fun (x, e) -> if x = s then Fun (x, e) else Fun (x, substitute_expr s e' e)
  | App(e1, e2) -> App(substitute_expr s e' e1, substitute_expr s e' e2)
  | If(e1, e2, e3) -> If(substitute_expr s e' e1, substitute_expr s e' e2, 
                                                  substitute_expr s e' e3)
  | Let(s', e1, e2) -> 
      if s' = s 
      then Let(s, e1, substitute_expr s e' e2)
      else Let(s', substitute_expr s e' e1, substitute_expr s e' e2)

(* substitute_eqs :: string -> expr -> set -> set
 * substitute an expression for a string name in an equation set
 *)
let substitute_eqs (s: string) (e': expr) (eqs: set): set =
  let substitute_eq (eq: equation): equation =
    match eq with
    | AttrEq(AttrRef(VarE(n), a), e) -> AttrEq(AttrRef(VarE(n), a), substitute_expr s e' e)
    | NtaEq(n, e)     -> NtaEq(n, substitute_expr s e' e)
  in
  List.map substitute_eq eqs

(* counter :: int ref 
 * count on the number of tree nodes.
 *)
let counter: int ref = ref 0

(* mk_node_id :: string -> string 
 * generate a new node identifier
 *)
let mk_node_id (s: string): string =
  counter := (!counter) + 1;
  "#_" ^ s ^ "_" ^ (string_of_int !counter)

(* mk_tree :: node_id -> term -> tree
 * given a node ID and a production ID:
 * 1. find the corresponding production definition,
 * 2. make new node IDs its children,
 * 3. partially instantiate the equations of the production with those 
 *    names/node IDS, and substitute children otherwise,
 * 4. make node IDs for NTAs in the prod and instantiate its equations,
 * 5.1. make tree slots for attributes of this node,
 * 5.2. make "intrinsic" attribute slots,
 * 6. put everything created above in the tree as a new node,
 * 7. recursive call on children of `t` that are terms to build the tree, giving
      the node IDs created for them in step 2.
 *)
let rec mk_tree (n: node_id) (TermT(p, es): term): tree =
  (* 1. find the corresponding production definition *)
  let lookupRes = lookup_prod p prod_env in
  let _ = if Option.is_none lookupRes 
          then raise(Failure("Couldn't find production for " ^ p))
          else () in
  let Some (_, nt_name, children, locals, eqs) = lookup_prod p prod_env in
  (* 2. make new node IDs its children *)
  let rec match_children (ch_decls: prod_child list)
                         (es: expr list): (string * expr) list =
    match ch_decls, es with
    | [], []         -> []
    | cd::cds, TermE(t)::es when nt_name <> "FunResult" -> 
        let child_node_id = mk_node_id cd in
        (cd, NodeRef(child_node_id)) :: match_children cds es
    | cd::cds, e::es -> (cd, e) :: match_children cds es
    | _, _ -> 
        raise(Failure("Unequal child decl/arg lists in match_children on " ^ p))
  in
  let matched_children: (string * expr) list = match_children children es in
  (* 3. partially instantiate the equations of the production with those 
        names/node IDS, and substitute children otherwise *)
  let instantiate_child ((s, e): string * expr) (eqs: set): set =
    match e with
    | NodeRef(n) -> instantiate_eqs_set s n eqs
    | e          -> substitute_eqs s e eqs
  in
  let instantiated_eqs: set = 
    List.fold_right instantiate_child matched_children eqs in
  (* 4. make node IDs for NTAs in the prod and instantiate its equations *)
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
  (* 5.1. make tree slots for attributes of this node *)
  let attrs =
    match lookup_nt nt_name nt_env with
    | Some(_, attrs) -> attrs
    | _ -> raise(Failure ("Could not find nonterminal " ^ nt_name))
  in
  let attribute_slots_tree: attr_item list = 
    List.map (fun a -> AttrStatus(n, a, Undemanded)) (attrs @ locals) in
  (* 5.2. make "intrinsic" attribute slots *)
  let rec make_child_attrs (lst: (string * expr) list): attr_item list =
    match lst with
    | [] -> []
    | (s, e)::t -> AttrStatus(n, s, Complete(e)) :: (make_child_attrs t)
  in
  let id_attr: attr_item = AttrStatus(n, "id", Complete(NodeRef(n))) in
  let prod_attr: attr_item = AttrStatus(n, "prod", Complete(String(p))) in
  let intrinsic_attrs_tree: attr_item list = 
    id_attr :: prod_attr :: make_child_attrs matched_children in
  (* 6. put everything created above in the tree as a new node *)
  let node_eqs_tree: tree = [ Node(n, Unvisited, instantiated_eqs, intrinsic_attrs_tree @ attribute_slots_tree) ] in
  (* 7. recursive call on children of `t` that are terms to build the tree,
        giving the node IDs created for them in step 2 *)
  let rec mk_sub_trees (es: expr list) (chs: (string * expr) list): tree list =
    match es, chs with
    | [], [] -> []
    | TermE(t)::es, (_, NodeRef(n))::chs -> (mk_tree n t)::(mk_sub_trees es chs)
    | _::es, _::chs -> mk_sub_trees es chs
    | _, _ -> raise(Failure "Unequal child decl/argument lists in term_children!")
  in
  let sub_trees: tree list = mk_sub_trees es matched_children in
  node_eqs_tree @
  List.concat sub_trees

(* unvisited_node :: node_id -> tree -> bool
 * check if a node has been visited by looking at its status in the tree
 *)
let rec unvisited_node (n: node_id) (t_init: tree) ((t, s, eqs): eq_step_state): bool =
  match t with
  | [] -> raise(Failure ("Could not find node " ^ n ^ " in unvisited_node"))
  | Node(n', s, _, _)::_ when n = n' -> s = Unvisited
  | _::t -> unvisited_node n t_init (t, s, eqs)

(* remove_attr_eq :: (node_id * attr_id) -> set -> equation option * set 
 * find from an equation set the equation whose LHS is `n.a`. return that
 * equation and the remaining equation set
 *)
let rec remove_attr_eq ((n, a): node_id * attr_id) (eqs: set): equation option * set =
  match eqs with
  | [] -> (None, [])
  | AttrEq(AttrRef(VarE(n'), a'), e)::rest when n = n' && a = a' -> 
      (Some (AttrEq(AttrRef(VarE(n'), a'), e)), rest)
  | h::rest -> let (eq, eqs') = remove_attr_eq (n, a) rest in (eq, h::eqs')
  
(* remove_nta_eq :: node_id -> set -> equation option * set
 * find from an equation set the equation whose LHS is `n`. return that equation
 * and the remaning equation set
 *)
let rec remove_nta_eq (n: node_id) (eqs: set): equation option * set =
  match eqs with
  | [] -> (None, [])
  | NtaEq(n', e)::rest when n = n' -> (Some (NtaEq(n, e)), rest)
  | h::rest -> let (eq, eqs') = remove_nta_eq n rest in (eq, h::eqs')

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
 * mark an attribute as complete with a value, return the resulting tree.
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
 * mark an attribute as demanded in the tree.
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
 * as an argument.
 *)
let rec replace_first ((n, a): node_id * attr_id) (e': expr) (s: stack): stack =
  match s with
  | [] -> []
  | AttrEq(AttrRef(VarE(n'), a'), e)::rest when n = n' && a = a' -> 
      AttrEq(AttrRef(VarE(n), a), e') :: rest
  | h::t -> h :: replace_first (n, a) e' t

(* replace_first_nta :: node_id -> expr -> stack -> stack
 * similar to replace_first, but for NTA equations.
 *)
let rec replace_first_nta (n: node_id) (e': expr) (s: stack): stack =
  match s with
  | [] -> []
  | NtaEq(n', e)::rest when n = n' -> NtaEq(n, e') :: rest
  | h::t -> h :: replace_first_nta n e' t

(* nta_equation_in_set :: node_id -> set -> bool
 * returns true if an equation `n = e` is in the set where `n` is the name of
 * the node given as an argument.
 *)
let rec nta_equation_in_set (n: node_id) (eqs: set): bool =
  match eqs with
  | [] -> false
  | NtaEq(n', _)::_ when n = n' -> true
  | _::rest -> nta_equation_in_set n rest

(* unify_one :: pattern -> expr -> eq_step_state -> ((string * expr) list) option
 * returns `Some` of a pattern variable to expression binding list if `e` is 
 * unifiable with `p`. Othewise, `None`.
 *)
 let rec unify_one (p: pattern) (e: expr) ((tree, stk, eqs): eq_step_state): ((string * expr) list) option =
  let unify_args (ps: pattern list) (es: expr list): ((string * expr) list) option =
    let sub_unify: (((string * expr) list) option) list =
      List.map2 (fun ps es -> unify_one ps es (tree, stk, eqs)) ps es in
    if all Option.is_some sub_unify
    then Some (List.concat (List.map (fun (Some lst) -> lst) sub_unify))
    else None
  in  
  match p, e with
  | TermP(s, ps), NodeRef(n) ->
      let Some(Node(id, _, eqs, attrs)) = lookup_node n tree in
      let Some(String(prod_name)) = lookup_complete_attr_val (id, "prod") attrs in
      let Some (_, _, cs, _, _) = lookup_prod prod_name prod_env in
      let child_expr_list: expr list = List.filter_map (fun c -> lookup_complete_attr_val (id, c) attrs) cs in
      let e' = (TermE(TermT(prod_name, child_expr_list))) in
      let res = unify_one p e' (tree, stk, eqs) in
      res
  | VarP x, _ -> Some [(x, e)]
  | StringP s, String(s') when s = s' -> Some []
  | UnderscoreP, _ -> Some []
  | NilP, Nil -> Some []
  | ConsP(p, ps), Cons(e, es) -> 
      let unify_h = unify_one p e (tree, stk, eqs) in
      let unify_t = unify_one ps es (tree, stk, eqs) in
      if Option.is_none unify_h || Option.is_none unify_t
      then None
      else let Some(bnds_h) = unify_h in
           let Some(bnds_t) = unify_t in
           Some(bnds_h @ bnds_t)
  | TermP(s, ps), TermE(TermT(s', es)) when s = s' && List.length ps == List.length es  ->
      unify_args ps es   
  | TupleP(ps), Tuple(es) when List.length ps == List.length es -> 
      unify_args ps es
  | _, _ -> None

(* unify_lst :: (pattern * expr) list -> expr -> eq_step_state -> (((string * expr) list) * expr) option
 * returns `Some` over a list of bindings and the expression to substitute those
 * bindings in if `e` is unifiable with some pattern in `ps`. Otherwise, `None`.
 *)
and unify_lst (ps: case list) (e: expr) ((tree, stk, eqs): eq_step_state): (((string * expr) list) * expr) option =
  match ps with
  | [] -> None
  | (p, e')::rest ->
      let unify_binds: ((string * expr) list) option = unify_one p e (tree, stk, eqs) in
      (match unify_binds with
      | None -> unify_lst rest e (tree, stk, eqs)
      | Some bnds -> Some (bnds, e'))


(*******************************)
(***** EXPRESSION STEPPING *****)


(* expr_step :: expr_step_state -> expr_step_state
 * step on an expression with respect to an equation stack and set.
 *)
and expr_step (e, t, s, eqs: expr_step_state): expr_step_state =
  let rec step_first_nonvalue (es: expr list): expr list * expr_step_state =
    match es with
    | []      -> raise (Failure "First_not_value found no non-value expression!")
    | h::rest -> if not (value_expr h) 
                 then let (h', t', s', eq's) = expr_step (h, t, s, eqs) in
                      (h' :: rest, (h', t', s', eq's))
                 else let (e', new_state) = step_first_nonvalue rest in
                      (h :: e', new_state)
  in
  match e with

    (* expr-append-nil-left - TODO rule *)
  | Append(Nil, e2) when value_expr e2 ->
      (e2, t, s, eqs)
    (* expr-append-nil-right - TODO rule *)
  | Append(e1, Nil) when value_expr e1 ->
      (e1, t, s, eqs)
    (* expr-append-cons - TODO rule *)
  | Append(Cons(h1, t1), e2) when value_expr e2->
      (Cons(h1, Append(t1, e2)), t, s, eqs)

    (* expr-binop-right *)
  | Append(e1, e2) when value_expr e1 -> 
      let (e2', t', s', eqs') = expr_step (e2, t, s, eqs) in
      (Append(e1, e2'), t', s', eqs')
    (* expr-binop-left *)
  | Append(e1, e2) -> 
      let (e1', t', s', eqs') = expr_step (e1, t, s, eqs) in
      (Append(e1', e2), t', s', eqs')

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
    (* expr-binop-left *)
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
    (* expr-binop-right *)
  | Equal(e1, e2) when value_expr e1 ->
      let (e2', t', s', eqs') = expr_step (e2, t, s, eqs) in
      (Equal(e1, e2'), t', s', eqs')
    (* expr-binop-left *)
  | Equal(e1, e2) ->
      let (e1', t', s', eqs') = expr_step (e1, t, s, eqs) in
      (Equal(e1', e2), t', s', eqs') 

    (* expr-neq-vals - TODO rule *)
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

    (* expr-tuple-step - TODO rule *)
  | Tuple es ->
      let (es', (e', t', s', eqs')) = step_first_nonvalue es in
      (Tuple es', t', s', eqs')

    (* TODO rule *)
  | TupleSec(Nil, i) -> (Abort("Tuple was nil in TupleSec eval"), t, s, eqs)

    (* expr-tuple-sec - TODO *)
  | TupleSec(es, i) when value_expr es ->
      let Tuple(lst) = es in
      (List.nth lst (i-1), t, s, eqs)

    (* expr-tuple-sec-step - TODO *)
  | TupleSec(es, i) ->
      let (es', t', s', eqs') = expr_step (es, t, s, eqs) in
      (TupleSec(es', i), t', s', eqs') 

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
      let (Some(eq), eqs') = remove_nta_eq n eqs in
      (e, t, eq :: s, eqs')

    (* expr-node-instantiate *)
  | AttrRef(NodeRef(n), a) when unvisited_node n t (t, s, eqs) ->
      let (node_eqs, t'): set * tree = instantiate_eqs "top" n t in
      (e, t', s, eqs @ node_eqs)

    (* expr-attr-complete, expr-attr-undemanded, and cycle detection *)
  | AttrRef(NodeRef(n), a) -> 
      let n_a_status: attr_status = attr_status (n, a) t in
      (match n_a_status with
        (* expr-attr-complete *)
      | Complete(e) -> (e, t, s, eqs)
        (* cycle detection - TODO rule *)
      | Demanded -> print_state (t, s, eqs); 
                    raise (Failure ("Cycle detected from attribute " ^ 
                                    n ^ "." ^ a))
        (* expr-attr-undemanded*)
      | Undemanded  -> let (Some eq, eqs') = remove_attr_eq (n, a) eqs in
                       let t' = make_demanded (n, a) t in
                       (e, t', eq :: s, eqs'))

    (* TODO rule *)
  | Case(NodeRef(n), ps) when nta_equation_in_set n eqs ->
      let (Some(eq), eqs') = remove_nta_eq n eqs in
      (e, t, eq :: s, eqs')

    (* expr-case-expand *)
  | Case (e, ps) when value_expr e ->
      (match unify_lst ps e (t, s, eqs) with
      | None -> print_state (t, s, eqs);
                raise (Failure ("Could not unify " ^ (str_expr e) ^ "!"))
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

  | Abort(msg) -> 
      (print_state (t, s, eqs));
      raise (Failure ("Found an error, aborting... Message: " ^ msg))

  | VarE x -> raise (Failure ("TODO: expr_step: VarE, had '" ^ x ^ "'"))

  | _ -> (print_state (t, s, eqs));
         raise (Failure ("Match failure in expr_step for expr: " ^ (str_expr e)))


(*****************************)
(***** EQUATION STEPPING *****)


(* eq_step :: eq_step_state -> eq_step_state
 * step on attribute grammar evaluation with respect to a tree, and an equation
 * stack and set 
 *)
let rec eq_step (t, s, eqs: eq_step_state): eq_step_state =
  match s with

    (* step-simple-value *)
  | AttrEq(AttrRef(VarE(n), a), e)::rest when value_expr e ->
      print_state (t, s, eqs);
      (make_complete (n, a) e t, rest, eqs)

    (* step-attr-eq *)
  | AttrEq(AttrRef(VarE(n), a), e)::rest when not(value_expr e) ->
      print_state (t, s, eqs);
      let (e', t', s', eqs') = expr_step (e, t, s, eqs) in
      (t', replace_first (n, a) e' s', eqs')
      
    (* step-attr-eq-lhs *)
  | AttrEq(e, _)::rest when not(value_expr e) ->
      print_state (t, s, eqs);
      let (e', t', s', eqs') = expr_step (e, t, s, eqs) in
      (t', s', eqs')

    (* step-build-nta *)
  | NtaEq(n, e)::rest when value_expr e ->
      print_state (t, s, eqs);  
      let TermE(TermT(id, es)) = e in
      let t' = mk_tree n (TermT(id, es)) in
      let (eqs', t''): set * tree = instantiate_eqs "top" n t' in
      (t @ t'', rest, eqs @ eqs')

    (* step-expr-nta *)
  | NtaEq(n, e)::rest when not(value_expr e) ->
    print_state (t, s, eqs);
    let (e', t', s', eqs') = expr_step (e, t, s, eqs) in
    (t', replace_first_nta n e' s', eqs')

    (* failure *)
  | _ -> print_state (t, s, eqs); 
         raise (Failure ("Match failure in eq_step"))

(* eq_steps :: eq_step_state -> eq_step_state
 * step the attribute grammar step until done
 *)
let rec eq_steps (state: eq_step_state): eq_step_state =
    match state with
    | (t, AttrEq(AttrRef(VarE("outer"), attr), e)::rest, eqs) when value_expr e ->
      print_endline ("DONE with outer." ^ attr ^ " = " ^ (str_expr e));
        let s: stack = AttrEq(AttrRef(VarE("outer"), attr), e)::rest in
        print_state (t, s, eqs); state
    | s -> eq_steps (eq_step s)

(* initial_state :: term -> eq_step_state
 * create the initial attribute grammar state given a program term
 *)
let init_state (prog: term): eq_step_state =
  let init_node: node_id = "prog_000" in
  let t: tree = mk_tree init_node prog in
  (
    t,
    AttrEq(AttrRef(VarE("outer"), "ok"), 
      AttrRef(NodeRef(init_node), "ok")) :: [],
    []
  )

(* go :: term -> unit 
 * evaluate an input term under the attribute grammar
 *)
let rec go (t: term): unit = 
  let _ = eq_steps (init_state t) in ()

(* okTrueState :: term -> bool
 * returns true if the final result of evaluation is `outer.ok = true`
 *)
let okTrueState (t: term): bool =
  let st  = init_state t in
  let st' = eq_steps st in
  match st' with
  | (_, AttrEq(AttrRef(VarE("outer"), "ok"), Bool(true))::_, _) -> true
  | _ -> false

(* okTrueState :: term -> bool
 * returns true if the final result of evaluation is `outer.ok = false`
 *)
let okFalseState (t: term): bool = 
  not(okTrueState t)

end