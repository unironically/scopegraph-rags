# LM Implementations

#### Implementations
Note that the syntax for languages 2, 3 and 4 are identical, whereas the syntax for 1 is a subset.
- 1:
  - The only declarations allowed are `def`s. No modules or imports.
  - Scope graphs only have `LEX` and `VAR` as edge labels
  - See [lm_language_1/](lm_language_1/)
- 2:
  - Module and import declarations are allowed.
  - Only one import edge is allowed per scope graph node.
  - A new "lookup" scope is created for every declaration in a declaration list, as well as any scopes created for those declarations (such as the scope for a `module`). This "lookup" scope is the origin of the `IMP` edge we get from resolving the `import` declaration at the head of the declaration list (if it is one), however the resolution of that import occurs in the lexical parent of the "lookup" scope.
  - The global or latest module scope a declaration list falls under is maintained as we descend through the list, despite these new "lookup" scopes being created. New declaration scope graph nodes are associated with this scope instead of the "lookup" one, allowing queries from elsewhere in the program to find declarations within a module scope.
  - Forward referencing is not allowed in any instance.
  - See [lm_language_2/](lm_language_2/)
- 3:
  - Module and import declarations are allowed.
  - Only one import edge is allowed per scope graph node.
  - A new "lookup" scope is created only when the current declaration in a declaration list is an `import`. In this case, the resolution of the import reference happens in the parent scope of the new "lookup" scope, but the resulting import edge appears on the "lookup" scope.
  - Two scopes are maintained as we descend through a declaration list as described for language 2. The only difference is that less scopes are created with this approach.
  - Forward referencing is allowed so long as there is not an `import` between the LM reference and declaration in question, since lookup occurs on the "lookup" scopes.
  - See [lm_language_3/](lm_language_3/)
- 4:
  - Module and import declarations are allowed.
  - Multiple import edges are allowed per scope graph node.
  - No new lookup scopes are created under declaration lists. Instead only one lexically enclosing scope is passed down a declaration list for name resolution and scope edge referencing.
  - In both Statix and Silver, we get stuck if a program in this language has an `import` declaration anywhere. This is because the scope the import reference is resolved in is the same scope which will receive the resulting `IMP` edge. In Statix, this results in a weakly critical `IMP` edge blocking the query it results from, whereas in Silver we get into an attribute dependency cycle.
  - See [lm_language_4/](lm_language_4/)

#### Scope Graph Examples
Coming soon...