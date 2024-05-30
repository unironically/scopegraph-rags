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

**NOTE:** The resolution below and in the spec makes use of a function `minRef` that I have not defined yet. The purpose of this function is to take a list of `Res` nodes and filter out those that are not in the minimal path set, with respect to the LM label ordering. This is the same as the `minref` used in the Statix specs. It's type as I've been using is `[Scope] ::= [Res]`.

#### DFA
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

#### Resolution trace for local attribute `res` for `VarRef("x")`
```
minRef(dfaVarRef.findReachable(x, VarRef("x"), [], false, S_C), top)
  dfaVarRef.findReachable(x, VarRef("x"), [], false, S_C)
    S_C.vars
      Contains [S_z]
        state2.findReachable("x", VarRef("x"), [labelVar()], false, S_z)
          S_z datum does not match.
            Return []
    ++
    S_C.imps
      See "Evaluation of `S_C.imps`" below
      Returns [S_A2]
        state1.findReachable("x", VarRef("x"), [labelImp()], false, S_A2)
          S_A2.vars
            Contains [S_x]
              S_x datum matches.
                Return [S_x]
          ++
          S_A2.imps
            Transitions to sink state. Return []
          ++
          S_A2.lexs
            Transitions to sink state. Return []
          = [S_x]
    ++
    S_C.lexs
      Contains [S_G]
        state0.findReachable("x", VarRef("x"), [labelLex()], false, S_G)
          S_G.vars
            No contributions. Return []
          ++
          S_G.imps
            Transitions to sink state. Return []
          ++
          S_G.lexs
            No contributions. Return []
          = []
    = [S_x]
  Return [S_x]
Return [S_x]
```


##### Evaluation of `S_C.imps`
```
S_C.imps <- minRef(scope.impsReachable, "A")
  See "Evaluation of `S_C.impsReachable`" below
Return [S_A2]                                    -- minRef implementation TODO
```

###### Evaluation of `S_C.impsReachable`

```
-- Before iteration 1, S_C.impsReachable = []

dfaModRef.findReachable("A", ModRef("A"), [], true, S_C)                -- iteration 1
  state0.findReachable("A", ModRef("A"), [], true, S_C)
    S_C.mods
      No contributions. Return []
    ++
    S_C.impsReachable
      Circular use. Return []                    -- using current value of S_C.impsReachable
    ++
    S_C.lexs
      Contains [S_G]
      state0.findReachable("A", ModRef("A"), [labelLex()], true, S_G)
        S_G.mods
          Contains [S_C, S_A1]
          state2.findReachable("A", ModRef("A"), [labelMod()], true, S_C)
            S_C.mods
              Transitions to sink state. Return []
            ++
            S_C.impsReachable
              Transitions to sink state. Return []
            ++
            S_C.lexs
              Transitions to sink state. Return []
            ++
            S_C datum does not match.
              Return []
            = []
          ++
          state2.findReachable("A", ModRef("A"), [labelMod()], true, S_A1)
            S_A1.mods
              Transitions to sink state. Return []
            ++
            S_A1.imps
              Transitions to sink state. Return []
            ++
            S_A1.lexs
              Transitions to sink state. Return []
            ++
            S_A1 datum matches. 
              Return [S_A1]
            = [S_A1]
          = [S_A1]
        ++
        S_G.imps
          No contributions. Return []
        ++
        S_G.lexs
          No contributions. Return []
        = [S_A1]
    = [S_A1]
Return [S_A1]

-- Before iteration 2, S_C.impsReachable = [S_A1]

dfaModRef.findReachable("A", ModRef("A"), [], true, S_C)                -- iteration 2
state0.findReachable("A", ModRef("A"), [], true, S_C)
    S_C.mods
      No contributions. Return []
    ++
    S_C.impsReachable
      Contains [S_A1]
      state1.findReachable("A", ModRef("A"), [labelImp()], true, S_A1)
        S_A1.mods
          Contains [S_A2]
          state2.findReachable("A", ModRef("A"), [labelImp(), labelMod()], true, S_A2)
            S_A2.mods
              No contributions. Return []
            ++
            S_A2.impsReachable
              Transitions to sink state. Return []
            ++
            S_A2.lexs
              Transitions to sink state. Return []
            ++
            S_A2 datum matches
              Return [S_A2]
            = [S_A2]
        ++
        S_A1.impsReachable
          Transitions to sink state. Return []
        ++
        S_A1.lexs
          Transitions to sink state. Return []
        = [S_A2]
    ++
    S_C.lexs
      Contains [S_G]
      state0.findReachable("A", ModRef("A"), [labelLex()], true, S_G)
        S_G.mods
          Contains [S_C, S_A1]
          state2.findReachable("A", ModRef("A"), [labelLex(), labelMod()], true, S_C)
            S_C.mods
              Transitions to sink state. Return []
            ++
            S_C.impsReachable
              Transitions to sink state. Return []
            ++
            S_C.lexs
              Transitions to sink state. Return []
            ++
            S_C datum does not match. 
              Return []
            = []
          ++
          state2.findReachable("A", ModRef("A"), [labelLex(), labelMod()], true, S_A1)
            S_A1.mods
              Transitions to sink state. Return []
            ++
            S_A1.impsReachable
              Transitions to sink state. Return []
            ++
            S_A1.lexs
              Transitions to sink state. Return []
            ++
            S_A1 datum matches.
              Return [S_A1]
            = [S_A1]
        ++
        S_G.imps
          No contributions. Return []
        ++
        S_G.lexs
          No contributions. Return []
        = [S_A1]
    = [S_A1, S_A2]
Return [S_A1, S_A2]

-- Before iteration 3, S_C.impsReachable = [S_A1, S_A2]

dfaModRef.findReachable("A", ModRef("A"), [], true, S_C)                -- iteration 3
state0.findReachable("A", ModRef("A"), [], true, S_C)
    S_C.mods
      No contributions. Return []
    ++
    S_C.impsReachable
      Contains [S_A1, S_A2]
      state1.findReachable("A", ModRef("A"), [labelImp()], true, S_A1)
        S_A1.mods
          Contains [S_A2]
            state2.findReachable("A", ModRef("A"), [labelImp(), labelMod()], true, S_A2)
              S_A2.mods
                No contributions. Return []
              ++
              S_A2.imps
                Transitions to sink state. Return []
              ++
              S_A2.lexs
                Transitions to sink state. Return []
              ++
              S_A2 datum matches.
                Return [S_A2]
              = [S_A2]
        ++
        S_A1.impsReachable
          Transitions to sink state. Return []
        ++
        S_A1.lexs
          Transitions to sink state. Return []
        = [S_A2]
      ++
      state1.findReachable("A", ModRef("A"), [labelImp(), labelMod()], true, S_A2)
        S_A2.mods
          No contributions. Return []
        ++
        S_A2.impsReachable
          Transitions to sink state. Return []
        ++
        S_A2.lexs
          Transitions to sink state. Return []
        = []
      = [S_A2]
    ++
    S_C.lexs
      Contains [S_G]
      state0.findReachable("A", ModRef("A"), [labelLex()], true, S_G)
        S_G.mods
          Contains [S_C, S_A1]
          state2.findReachable("A", ModRef("A"), [labelLex(), labelMod()], true, S_C)
            S_C.mods
              Transitions to sink state. Return []
            ++
            S_C.impsReachable
              Transitions to sink state. Return []
            ++
            S_C.lexs
              Transitions to sink state. Return []
            ++
            S_C datum does not match.
              Return []
            = []
          ++
          state2.findReachable("A", ModRef("A"), [labelLex(), labelMod()], true, S_A1)
            S_A1.mods
              Transitions to sink state. Return []
            ++
            S_A1.impsReachable
              Transitions to sink state. Return []
            ++
            S_A1.lexs
              Transitions to sink state. Return []
            ++
            S_A1 datum matches.
              Return [S_A1]
            = [S_A1]
        ++
        S_G.impsReachable
          No contributions. Return []
        ++
        S_G.lexs
          No contributions. Return []
        = [S_A1]
    = [S_A1, S_A2]
Return [S_A1, S_A2]

-- After iteration 3, S_C.impsReachable = [S_A1, S_A2]
-- Same result as previous iteration, terminate.
```