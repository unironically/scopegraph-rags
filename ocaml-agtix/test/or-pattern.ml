type foo =
  | FooInt of int
  | FooStr of string
  | FooVar of string
  | FooAdd of foo * foo
  | FooSub of foo * foo
  | FooMul of foo * foo
  | FooDiv of foo * foo
  | FooIf of foo * foo * foo

let rec vars (t: foo): string list =
  match t with
  | FooInt _
  | FooStr _ -> []
  | FooVar s -> [s]
  | FooAdd(t1, t2)
  | FooSub(t1, t2)
  | FooMul(t1, t2)
  | FooIf(t1, t2, _)
  | FooDiv(t1, t2) -> (vars t1) @ (vars t2)

(*

type foo =
  | FooInt of int
  | FooStr of string
  | FooVar of string
  | FooAdd of foo * string
  | FooSub of foo * foo
  | FooMul of foo * foo
  | FooDiv of foo * foo

let rec vars (t: foo): string list =
  match t with
  | FooInt _
  | FooStr _ -> []
  | FooVar s -> [s]
  | FooAdd(t1, t2)
  | FooSub(t1, t2)
  | FooMul(t1, t2)
  | FooDiv(t1, t2) -> (vars t1) @ (vars t2)


File "or-pattern.ml", lines 15-16, characters 4-18:
15 | ....FooAdd(t1, t2)
16 |   | FooSub(t1, t2)
Error: The variable t2 on the left-hand side of this or-pattern has type 
       string but on the right-hand side it has type foo

*)

(*

type foo =
  | FooInt of int
  | FooStr of string
  | FooVar of string
  | FooAdd of foo * foo
  | FooSub of foo * string
  | FooMul of foo * foo
  | FooDiv of foo * foo

let rec vars (t: foo): string list =
  match t with
  | FooInt _
  | FooStr _ -> []
  | FooVar s -> [s]
  | FooAdd(t1, t2)
  | FooSub(t1, t2)
  | FooMul(t1, t2)
  | FooDiv(t1, t2) -> (vars t1) @ (vars t2)


File "or-pattern.ml", lines 15-16, characters 4-18:
15 | ....FooAdd(t1, t2)
16 |   | FooSub(t1, t2)
Error: The variable t2 on the left-hand side of this or-pattern has type 
       foo but on the right-hand side it has type string

*)

(*

type foo =
  | FooInt of int
  | FooStr of string
  | FooVar of string
  | FooAdd of foo * foo
  | FooSub of foo * foo
  | FooMul of foo * string
  | FooDiv of foo * foo

let rec vars (t: foo): string list =
  match t with
  | FooInt _
  | FooStr _ -> []
  | FooVar s -> [s]
  | FooAdd(t1, t2)
  | FooSub(t1, t2)
  | FooMul(t1, t2)
  | FooDiv(t1, t2) -> (vars t1) @ (vars t2)

File "or-pattern.ml", lines 15-17, characters 4-18:
15 | ....FooAdd(t1, t2)
16 |   | FooSub(t1, t2)
17 |   | FooMul(t1, t2)
Error: The variable t2 on the left-hand side of this or-pattern has type 
       foo but on the right-hand side it has type string

*)

(*

type foo =
  | FooInt of int
  | FooStr of string
  | FooVar of string
  | FooAdd of foo * foo
  | FooSub of foo * foo
  | FooMul of foo * foo
  | FooDiv of foo * string

let rec vars (t: foo): string list =
  match t with
  | FooInt _
  | FooStr _ -> []
  | FooVar s -> [s]
  | FooAdd(t1, t2)
  | FooSub(t1, t2)
  | FooMul(t1, t2)
  | FooDiv(t1, t2) -> (vars t1) @ (vars t2)


File "or-pattern.ml", lines 15-18, characters 4-18:
15 | ....FooAdd(t1, t2)
16 |   | FooSub(t1, t2)
17 |   | FooMul(t1, t2)
18 |   | FooDiv(t1, t2).........................
Error: The variable t2 on the left-hand side of this or-pattern has type 
       foo but on the right-hand side it has type string

*)

(*

type foo =
  | FooInt of int
  | FooStr of string
  | FooVar of string
  | FooAdd of foo * foo
  | FooSub of foo * foo
  | FooMul of foo * foo
  | FooDiv of foo * foo
  | FooIf of foo * foo * foo

let rec vars (t: foo): string list =
  match t with
  | FooInt _
  | FooStr _ -> []
  | FooVar s -> [s]
  | FooAdd(t1, t2)
  | FooSub(t1, t2)
  | FooMul(t1, t2)
  | FooIf(t1, t2, t3)
  | FooDiv(t1, t2) -> (vars t1) @ (vars t2)


File "or-pattern.ml", lines 16-19, characters 4-21:
16 | ....FooAdd(t1, t2)
17 |   | FooSub(t1, t2)
18 |   | FooMul(t1, t2)
19 |   | FooIf(t1, t2, t3)
Error: Variable t3 must occur on both sides of this | pattern

*)