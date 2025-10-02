# nores_let

## Concrete syntax

```
def a = let x = 1, y = 1 + x
        in x + y + z;
```

## Results

- `lm-rec`

Unsatisfiable by Ministatix, OCaml AG, and Silver AG.
Validates case 3 of Theorem 2 in the paper.

- `lm-par`

Unsatisfiable by Ministatix, OCaml AG, and Silver AG.
Validates case 3 of Theorem 2 in the paper.

- `lm-seq`

Unsatisfiable by Ministatix, OCaml AG, and Silver AG.
Validates case 3 of Theorem 2 in the paper.