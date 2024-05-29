## [`ModulesNestedSame.lm`](examples/ModulesNestedSame.lm)


### Program
```
module A {  
  module A {
    def x:int = 2
  }
}

module C {
  import A
  def z:int = x
}
```


### AST
```
Program(
  DeclsCons(
    DeclModule(
      "A", 
      DeclsCons(
        DeclModule(
          "A", 
          DeclsCons(
            DeclDef(
              DefBindTyped(
                "x", 
                TInt(), 
                ExprInt(
                  "2"
                )
              )
            ), 
            DeclsNil()
          )
        ), 
        DeclsNil()
      )
    ), 
    DeclsCons(
      DeclModule(
        "C", 
        DeclsCons(
          DeclImport(
            ModRef(
              "A"
            )
          ), 
          DeclsCons(
            DeclDef(
              DefBindTyped(
                "z", 
                TInt(), 
                ExprVar(
                  VarRef(
                    "x"
                  )
                )
              )
            ), 
            DeclsNil()
          )
        )
      ), 
      DeclsNil()
    )
  )
)
```


### Scope graph
```
-- global scope
S_G = scope()
S_G -[ `MOD ]-> S_C
S_G -[ `MOD ]-> S_A1

-- module C scope
S_C = scopeDatum(datumMod("C", S_G))
S_C -[ `LEX ]-> S_G
S_C -[ `VAR ]-> S_z
S_C -[ `IMP ]-> ???

-- var z scope
S_z = scopeDatum(datumVar("z", ???))

-- outer module A scope
S_A1 = scopeDatum(datumMod("A", S_A1))
S_A1 -[ `LEX ]-> S_G
S_A1 -[ `MOD ]-> S_A2

-- inner module A scope
S_A2 = scopeDatum(datumMod("A", S_A2))
S_A2 -[ `LEX ]-> S_A1
S_A2 -[ `VAR ]-> S_x

-- var x scope
S_x = scopeDatum(datumVar("x", INT))
```

### Resolution of `x`
```
```

### DFA
```
state0 {
  --LEX-> state0
  --IMP-> state1
  --VAR/MOD-> state2
}

state1 {
  -- VAR -> state2
}

state2 (final) {}

sink {}

```

#### Evaluation of `S_C.imps`

##### Evaluation of `dfaModRef.findVisible("A", S_C)`

```

-- Before iteration 1, S_C.imps = []

dfaModRef.findVisible("A", S_C)       -- iteration 1
  state0.findVisible("A", S_C)
    S_C.vars = [S_z]
      sinkState.findVisible("A", S_z)
        Sink state. Return []
    S_C.mods
      None. Return []
    S_C.imps
      Circular use. Return []        -- using current value of S_C.imps
    S_C.lexs
      Contains [S_G]
      state0.findVisible("A", S_G)
        S_G.vars
          None. Return []
        S_G.mods
          Contains [S_C, S_A1]
          state2.findVisible("A", S_C)
            S_C.vars
              Sink state. Return []
            S_C.mods
              Sink state. Return []
            S_C.imps
              Sink state. Return []
            S_C.lexs
              Sink state. Return []
            S_C datum does not match.
              Return []
          state2.findVisible("A", S_A1)
            S_A1.vars
              Sink state. Return []
            S_A1.mods
              Sink state. Return []
            S_A1.imps
              Sink state. Return []
            S_A1.lexs
              Sink state. Return []
            S_A1 datum matches. 
              Return [S_A1]
        S_G.imps
          None. Return []
        S_G.lexs
          None. Return []
  Return [S_A1]

-- Before iteration 2, S_C.imps = [[S_A1]]

dfaModRef.findVisible("A", S_C)       -- iteration 2
state0.findVisible("A", S_C)
    S_C.vars = [S_z]
      sinkState.findVisible("A", S_z)
        Sink state. Return []
    S_C.mods
      None. Return []
    S_C.imps
      Contains [S_A1]
      state1.findVisible("A", S_A1)
        S_A1.vars
          Sink state. Return []
        S_A1.mods
          Contains [S_A2]
          state2.findVisible("A", S_A2)
            S_A2.vars
              Sink state. Return []
            S_A2.mods
              None. Return []
            S_A2.imps
              Sink state. Return []
            S_A2.lexs
              Sink state. Return []
            S_A2 datum matches
              Return [S_A2]
        S_A1.imps
          Sink State. Return []
        S_A1.lexs
          Sink State. Return []
    S_C.lexs
      Contains [S_G]
      state0.findVisible("A", S_C)
        S_G.vars
          None. Return []
        S_G.mods
          Contains [S_C, S_A1]
          state2.findVisible("A", S_C)
            S_C datum does not match. 
              Return []
          state2.findVisible("A", S_A1)
            S_A1 datum matches.
              Return [S_A1]
        S_G.imps
          None. Return []
        S_G.lexs
          None. Return []

-- Before iteration 3, S_C.imps = [[S_A2]]

dfaModRef.findVisible("A", S_C)       -- iteration 3
state0.findVisible("A", S_C)
    S_C.vars = [S_z]
      sinkState.findVisible("A", S_z)
        Sink state. Return []
    S_C.mods
      None. Return []
    S_C.imps
      Contains [S_A2]
      state1.findVisible("A", S_A2)
        S_A2.vars
          Sink State. Return []
        S_A2.mods
          None. Return []
        S_A2.imps
          Sink State. Return []
        S_A2.lexs
          Sink State. Return []
    S_C.lexs
      Contains [S_G]
      state0.findVisible("A", S_G)
        S_G.vars
          None. Return []
        S_G.mods
          Contains [S_C, S_A1]
          state2.findVisible("A", S_C)
            S_C.vars
              Sink state. Return []
            S_C.mods
              Sink state. Return []
            S_C.imps
              Sink state. Return []
            S_C.lexs
              Sink state. Return []
            S_C datum does not match.
              Return []
          state2.findVisible("A", S_A1)
            S_A1.vars
              Sink state. Return []
            S_A1.mods
              Sink state. Return []
            S_A1.imps
              Sink state. Return []
            S_A1.lexs
              Sink state. Return []
            S_A1 datum matches.
              Return [S_A1]
        S_G.imps
          None. Return []
        S_G.lexs
          None. Return []
  Return [S_A1]

-- Before iteration 4, S_C.imps = [[S_A2], [S_A1]]

dfaModRef.findVisible("A", S_C)       -- iteration 3
state0.findVisible("A", S_C)
    S_C.vars = [S_z]
      sinkState.findVisible("A", S_z)
        Sink state. Return []
    S_C.mods
      None. Return []
    S_C.imps
      Contains [S_A2]
      state1.findVisible("A", S_A2)
        S_A2.vars
          Sink State. Return []
        S_A2.mods
          None. Return []
        S_A2.imps
          Sink State. Return []
        S_A2.lexs
          Sink State. Return []
    S_C.lexs
      Contains [S_G]
      state0.findVisible("A", S_G)
        S_G.vars
          None. Return []
        S_G.mods
          Contains [S_C, S_A1]
          state2.findVisible("A", S_C)
            S_C.vars
              Sink state. Return []
            S_C.mods
              Sink state. Return []
            S_C.imps
              Sink state. Return []
            S_C.lexs
              Sink state. Return []
            S_C datum does not match.
              Return []
          state2.findVisible("A", S_A1)
            S_A1.vars
              Sink state. Return []
            S_A1.mods
              Sink state. Return []
            S_A1.imps
              Sink state. Return []
            S_A1.lexs
              Sink state. Return []
            S_A1 datum matches.
              Return [S_A1]
        S_G.imps
          None. Return []
        S_G.lexs
          None. Return []
  Return [S_A1]

-- After iteration 4, S_C.imps = [[S_A2], [S_A1]]

-- Same result as previous iteration, terminate.
```