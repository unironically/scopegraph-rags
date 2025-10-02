
```
type resolution = name -> [ Decorated Scope ]
                | { [ program_resolution ] }

type program_resolution = [ resolution ]
```

## Program 1

```
module G_1 {
  module A_1 {
    module A_2 {
      def x_1 = 1
    }
  }

  module B_1 {
    import A_3
    import A_4
    def y_1 = x_2
  }
}
```

Resolves to:

```
  [ A_3 -> [A_2], A_4 -> [A_2], x_2 -> [x_1] ]
```

AGs explanation:

The first iteration of the circular attribute gives us `A_1` for both references `A_3` and `A_4`, introducing two `IMP` edges to `module A_1`. On the next iteration, either of these tentative `IMP` edges is used to jump to `module A_1`, from which `module A_2` is visible via a `MOD` edge. Thus both `A_3` and `A_4` have found a better resolution in `module A_2`. This is then the best resolution of these references, and permanent `IMP` edges are added to the graph from `B_1` to `A_2`. Resolving `x_2` then leads only to `x_1` by either `IMP` edge.

## Program 2

```
module G_1 {
  module A_1 {
    module A_2 {
      def x_1 = 1
    }
  }

  module B_1 {
    import A_3
    import A_4
    def y_1 = x_2
  }

  module C_1 {
    import A_5
    import A_6
    def z_1 = x_3
  }
}
```

Resolves to:

```
  [ A_3 -> [A_2], A_4 -> [A_2], x_2 -> [x_1], A_5 -> [A_2], A_6 -> [A_2], x_3 -> [x_1] ]
```

AGs explanation:

The first iteration of the circular attribute gives us `A_1` for both references `A_3` and `A_4`, introducing two `IMP` edges to `module A_1`. On the next iteration, either of these tentative `IMP` edges is used to jump to `module A_1`, from which `module A_2` is visible via a `MOD` edge. Thus both `A_3` and `A_4` have found a better resolution in `module A_2`. This is then the best resolution of these references, and permanent `IMP` edges are added to the graph from `B_1` to `A_2`. Resolving `x_2` then leads only to `x_1` by either `IMP` edge. A similar result follows when resolving `A_5`, `A_6`, and `x_3` in `module C_1`.

## Program 3

```
module G_1 {
  module A_1 {
    module A_2 {
      def x_1 = 1
    }
  }

  module B_1 {
    import A_3
    import A_4
    def y_1 = x_2
  
    module C_1 {
      module D_1 {
        module D_2 {
          def w_1 = 1
        }
      }

      module E_1 {
        import D_3
        import D_4
        def z_1 = w_2
      }
    }
  }
}
```

Resolves to:

```
  [ A_3 -> [A_2], A_4 -> [A_2], x_2 -> [x_1], D_3 -> [D_2], D_4 -> [D_2], w_2 -> [w_1] ]
```

AGs explanation:

The first iteration of the circular attribute gives us `A_1` for both references `A_3` and `A_4`, introducing two `IMP` edges to `module A_1`. On the next iteration, either of these tentative `IMP` edges is used to jump to `module A_1`, from which `module A_2` is visible via a `MOD` edge. Thus both `A_3` and `A_4` have found a better resolution in `module A_2`. This is then the best resolution of these references, and permanent `IMP` edges are added to the graph from `B_1` to `A_2`. Resolving `x_2` then leads only to `x_1` by either `IMP` edge. A similar result follows when resolving `D_3`, `D_4`, and `w_2`.

## Program 4

```
module A_1 {
  module B_1 {
    def x_1 = 1
  }
}
module B_2 {
  module A_2 {
    def x_2 = 1
  }
}
module C_1 {
  import A_3
  import B_3
  def y_1 = x_3
}
```

Resolves to:

```
  [ A_3 -> [A_2], B_3 -> [B_1], x_3 -> [x_1, x_2] ]
```

AGs explanation:

When resolving `A_3` and `B_3`, the first iteration of the circular attribute results in tentative `IMP` edges to modules `A_1` and `B_2`. On the next iteration, we can follow these `IMP` edges to find modules `A_2` and `B_1` for imports `A_3` and `B_3` respectively. Since we followed `IMP` edges to get to these, whereas we followed `LEX` edges to get the initial resolutions, the new resolutions are preferred over the old ones. Thus `A_3` resolves to `A_2`, and `B_3` resolves to `B_1`. Since both declare an `x`, `x_3` is ambiguous.

## Program 5

```
module A_1 {
  def x_1 = 1
}
module B_1 {
  def x_2 = 1
}
module C_1 {
  import A_2
  import B_2
  def y_1 = x_3 + x_4
}
```

Resolves to:

```
  [ A_2 -> [A_1], 
    B_2 -> [B_1], 
    { [ x_3 -> [x_1] ], [ x_3 -> [x_2] ] }, 
    { [ x_4 -> [x_1] ], [ x_4 -> [x_2] ] }
  ]
```

AGs explanation:



## Program 6

```
module A_1 {
  module A_2 {
    def x_1 = 1
  }
}
module B_1 {
  module A_3 {
    def x_2 = 1
  }
}

module C_1 {
  import A_4
  import B_2
  def y_1 = x_3
}
```

Resolves to:

```
  [ A_4 -> [A_2, A_3], B_2 -> [B_1], x_3 -> [x_1, x_2] ]
```

AGs explanation:

`import A_4` resolves to `module A_1` on the first iteration of the circular attribute, and `import B_2` resolves to `module B_1`. Thus we now have tentative `IMP` edges from `C_1` to these modules. On the next iteration, we can now follow `IMP` edges to `B_1` and `A_1` when resolving `A_4` again. Thus we have to equally good choices for this import - we have an ambiguity. Resolving `B_2` on this iteration does not change the resolution - there is only one declared `B` module. Given that `A_4` is ambiguous, both `x_1` and `x_2` are visible declarations for the reference `x_3`.

## Program 7

```
module A_1 {
  module B_1 {
    def x_1 = 1
  }
}
module B_2 {
  module A_2 {
    def x_2 = 2
  }
}
module C_1 {
  import A_3
  import B_3
  def y_1 = x_3
  module D_1 {
    import A_4
    import B_4
    def y_2 = x_4
  }
}
```

Resolves to:

```
  [ A_3 -> [A_2], B_3 -> [B_1], x_3 -> [x_1, x_2], A_4 -> [A_2], B_4 -> [B_1], x_4 -> [x_1, x_2] ]
```

AGs explanation:

The initial resolution of `import A_3` resolves to `A_1`, and the initla resolution of `import B_3` resolved to `B_2`. Both of these edges can then be used in the next iteration of the circular attribute, so that resolving `import A_3` again uses the tentative `IMP` edge introduced by resolving `B_3` to jump to `B_3`'s module, from which `module A_2` is visible. Since this resolution follows an `IMP` edge first, whereas the inital resolution of `A_3` followed a `LEX` edge first, our new resolution is preferred. Similarly, `B_3` finds a new resolution in `module B_1`. The next iteration of the circular attribute does not change the list of reachable resolutions, therefore `A_2` and `B_1` are the final resolutions of `A_3` and `B_4`. Both of these contain an `x` declaration, and both of these declarations are reachable along equally good paths, so `x_3` is ambiguous. Imports `A_4` and `B_4` use the `IMP` edges introduced by resolving `A_3` and `B_3`, so these also resolve to `A_2` and `B_1`, and `x_4` is ambiguous too.

## Program 8

```
module A_1 {
  import B_1
  def x_1 = y_1
}
module B_2 {
  import A_2
  def y_2 = x_2
}
```

Resolves to:

```
  [ B_1 -> [B_2], x_1 -> [x_2], A_2 -> [A_1], y_2 -> [y_1] ]
```

AGs explanation:

There is only one declaration for both `A` and `B` in the program, so only one resolution for the respective imports. Then, only `x_1` and `y_2` are visible declarations for references `y_1` and `x_2`.


## Possible approach

Considering program 4 here.

We know that
- `C.refs = [A_3, B_3, x_3]`
- `A_3.res = [A_2, A_1]` where `A_2` is better than `A_1`
- `B_3.res = [B_1, B_2]` where `B_1` is better than `B_2`
- `x_3.res = [x_1, x_2]` where `x_1` is equally good as `x_2`

We separate the references types first, easily done by filtering on the ref node datum
- `impRefs = [A_3, B_3]`
- `varRefs = [x_3]`

Initialize `picks` by finding the leftmost resolutions for each item in `impRefs`

Start with accumulating `picks` list initially `[A_2, B_1]`
1. Choose an unpicked ref r1 in `varRefs`
2. Pick the best (leftmost) resolutions for r1 in its `res` list that depends on nothing, or something in the list so far. Add them to `picks`
3. Repeat 4 and 5 until there are no unpicked refs in `impRefs`

For program 4, `picks` is initially `[A_2, B_1]`.
Then running the steps above results in `[A_2, B_1, x_1, x_2]`

**Coherence preserved for only VarRefs.**