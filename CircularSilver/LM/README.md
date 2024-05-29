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

#### Evaluation of `S_C.imps`
```

```