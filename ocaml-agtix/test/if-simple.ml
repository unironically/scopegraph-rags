type foo = Foo of int * bool | Bar of bool * int
;;

let a:bool = true in
  match Foo(0, a), Bar(a, 1) with
  | (Foo(a, _) | Bar(_, a)), (Foo(_, c) | Bar(c, _))
    -> a
