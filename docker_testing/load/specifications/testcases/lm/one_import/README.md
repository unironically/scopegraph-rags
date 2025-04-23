# one_import

## Concrete syntax

```
module A {
  def x = 1;
}

module B {
  import A;
  def y = x;
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

Satisfiable by Ministatix, OCaml AG, and Silver AG.
Validates case 1 of Theorem 2 in the paper.