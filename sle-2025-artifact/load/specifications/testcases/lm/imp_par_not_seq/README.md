# imp_par_not_seq

## Concrete syntax

```
module A {
  def x = 1;
}

module B {
  import A;
  module A {
    def x = true;
  }
  def y = 1 + x;
}
```

## Results

- `lm-rec`

Stuck in Ministatix, cycle in OCaml AG, and Silver AG.
Validates case 4 of Theorem 2 in the paper.

- `lm-par`

Satisfiable by Ministatix, OCaml AG, and Silver AG.
Validates case 1 of Theorem 2 in the paper.

- `lm-seq`

Unsatisfiable by Ministatix, OCaml AG, and Silver AG.
Validates case 2 of Theorem 2 in the paper.