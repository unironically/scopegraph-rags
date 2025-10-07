# LMR with Scope Graphs in Attribute Grammars

## Languages

### LMR 0 ([link](./lmr0/README.md))

- No modules
- Original semantics
- Has forward referencing

A global scope is created, then all variable declarations in the program are
applied as edges to that global scope.
There is one "lookup" scope in the resulting scope graph, but also a declaration
scope for every variable declaration in the program.

### LMR 1 ([link](./lmr1/README.md))

- Modules included
- Sequential scoping
- No forward referencing

A scope is created for every declaration in a declaration list.
Edges for variable, module or import declarations are applied to that scope,
which is then passed down to the next declaration in the declaration list.
Module scopes get the same variable and module edges, allowing for imports.

### LMR 2 ([link](./lmr2/README.md))

- Modules included
- Sequential scoping for imports, original scoping otherwise
- Has forward referencing of variables



Sequential scopes are still created in a declaration list and used to resolve 
any name.
Only import edges are applied to these however.
Other edges are applied to the scope of the enclosing module allowing forward
referencing.

### LMR 3 ([link](./lmr3/README.md))

- Modules included
- Original semantics
- Has forward referencing of variables and imports

This language has the original semantics for LMR.
Imports are self-influencing and all forward referencing is allowed.
The use of imports causes circular dependencies.