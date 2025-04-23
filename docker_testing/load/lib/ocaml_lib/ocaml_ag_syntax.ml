type nt_id = string
type node_id = string
type attr_id = string
type prod_id = string
type prod_child = string

type expr = Int      of int
          | Bool     of bool
          | String   of string
          | VarE     of string
          | Abort    of string
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
          | Tuple    of expr list
          | TupleSec of expr * int
          | Case     of expr * case list
          | TermE    of term
          | Fun      of string * expr
          | App      of expr * expr
          | If       of expr * expr * expr
          | Let      of string * expr * expr

and term  = TermT of string * expr list

and case    = pattern * expr

and pattern = TermP of string * pattern list
            | VarP  of string
            | StringP of string
            | ConsP of pattern * pattern
            | NilP
            | TupleP of pattern list
            | UnderscoreP

type attr_status = Complete of expr | Demanded | Undemanded

type node_status = Visited | Unvisited

type equation = AttrEq of expr * expr | NtaEq of node_id * expr

type stack = equation list

type set = equation list

type attr_item = NtaStatus  of node_id * attr_status
               | AttrStatus of node_id * attr_id * attr_status

type tree_item = Node of node_id * node_status * set * attr_item list

type tree  = tree_item list

type nt = nt_id * attr_id list

type prod = prod_id * nt_id * prod_child list * prod_child list * equation list

(* relation: <t | stack; set> -> <t | stack'; set'> *)
type eq_step_state = tree * stack * set

(* relation: <e; stack; set> -> <e'; stack'; set'> *)
type expr_step_state = expr * tree * stack * set


(***** Stringify functions *****)


(* str_pattern :: pattern -> string 
 * stringify a pattern
 *)
 let rec str_pattern (p: pattern): string =
  match p with
  | TermP(s, ps) -> s ^ "(" ^ (String.concat ", " (List.map str_pattern ps)) ^ ")"
  | VarP x -> x
  | StringP s -> "\"" ^ s ^ "\""
  | UnderscoreP -> "_"
  | TupleP(ps) -> "(" ^ (String.concat ", " (List.map str_pattern ps)) ^ ")"
  | ConsP(h, t) -> (str_pattern h) ^ "::" ^ (str_pattern t)
  | NilP -> "[]"

(* str_expr :: expr -> string 
 * stringify an expression
 *)
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
  | Abort(s) -> "ERROR(" ^ s ^ ")"
  | Fun (x, e) -> "\\" ^ x ^ " -> " ^ str_expr e
  | App (e1, e2) -> (str_expr e1) ^ "(" ^ (str_expr e2) ^ ")"
  | If (e1, e2, e3) -> "if " ^ (str_expr e1) ^ " then " ^ (str_expr e2) ^ " else " ^ (str_expr e3)
  | Let (s, e1, e2) -> "let " ^ s ^ " = " ^ (str_expr e1) ^ " in " ^ (str_expr e2)
and str_term (TermT(s, es): term): string =
  s ^ "(" ^ (String.concat ", " (List.map str_expr es)) ^ ")"

(* str_eq :: equation -> string 
 * stringify an equation
 *)
let rec str_eq (e: equation): string =
  match e with
  | AttrEq(AttrRef(VarE(n), a), e) -> n ^ "." ^ a ^ " = " ^ str_expr e
  | NtaEq(n, e) -> n ^ " = " ^ str_expr e
  | _ -> raise(Failure "Failed to stringify an equation")

(* str_stack :: stack -> string 
 * stringify a stack
 *)
let rec str_stack (s: stack): string =
  match s with
  | [] -> "[]\n"
  | h::t -> (str_eq h) ^ "\n:: " ^ (str_stack t)

(* strlist_set :: set -> string list 
 * stringify an equation list
 *)
let strlist_set (eqs: set): string list =
  let rec strlist_set_items (eqs: set): string list =
    match eqs with
    | [] -> []
    | h::[] -> [str_eq h]
    | h::t -> (str_eq h) :: (strlist_set_items t)
  in
  strlist_set_items eqs

(* str_set :: set -> string 
 * stringify a set
 *)
let str_set (eqs: set): string =
  let strs: string list = strlist_set eqs in
  if List.is_empty strs
  then "[]"
  else "[" ^ (String.concat "" (List.map (fun x -> "\n  " ^ x) strs)) ^ "\n]"

(* str_status :: attr_status -> string 
 * stringify an attribute status
 *)
let str_status (s: attr_status): string =
  match s with
  | Complete(e) -> "Complete(" ^ (str_expr e) ^ ")"
  | Demanded    -> "Demanded"
  | Undemanded  -> "Undemanded"

(* str_tree :: tree -> string
 * stringify a tree
 *)
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