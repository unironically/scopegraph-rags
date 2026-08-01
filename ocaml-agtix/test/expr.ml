type expr = Int of int
          | Let of string * expr
          | Add of expr * expr
          | Mul of expr * expr

let rec simplify (e:expr): expr =
  match e with
    Int _ -> e
  | Add(e, Int 0) | Add(Int 0, e)
  | Mul(e, Int 1) | Mul(Int 1, e) -> e
  | _ -> e (* unfinished *)
