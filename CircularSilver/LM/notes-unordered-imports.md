```
type resolution = name -> [ Decorated Scope ]
                | { [ program_resolution ] }

type program_resolution = [ resolution ]

-- report "good" (and bindings) if program_resolution is complete, and has no curly braces
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

Program resolution: a single ambiguity

```
  [ { [ A_3 -> [A_1], A_4 -> [A_2], x_2 -> [x_1] ],
      [ A_3 -> [A_2], A_4 -> [A_1], x_2 -> [x_1] ]
    }
  ]
```

Mophasco output (FAIL):

```
### Failure in: 0:0:eric-notes-1.aterm
test/Main.hs:82
It passes type checking
expected: True
 but got: False
```

Mophasco explanation:

This program fails due to a stability issue with regards to both `import A_3`
and `import A_4`. Mophasco creates two permutations of these unordered imports:
`p1 = [import A_3, import A_4]` and `p2 = [import A_4, import A_3]`. In each
case both import queries are unstable. Take `p1` - first we run the `import A_3`
query, which resolves to `module A_1` via `B_1 --LEX-> G_1 --MOD-> A_1`, and
results in an `IMP` edge being added from `B_1` to `A_1`. But then this result
is necessarily unstable, because under the newly extended scope graph the same
query would instead give scope `A_2` as the result. Using permutation `p2` leads
to the same issue where `import A_4`'s initial result causes itself to become
unstable by the addition of the same `IMP` edge.

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

program resolution: two ambiguities

```
  [ { [ A_3 -> [A_1], A_4 -> [A_2], x_2 -> [x_1] ],
      [ A_3 -> [A_2], A_4 -> [A_1], x_2 -> [x_1] ]
    },

    { [ A_5 -> [A_1], A_6 -> [A_2], x_3 -> [x_1] ],
      [ A_5 -> [A_2], A_6 -> [A_1], x_3 -> [x_1] ]
    }
  ]
```

Mophasco output (FAIL):

```
### Failure in: 0:0:eric-notes-2.aterm
test/Main.hs:82
It passes type checking
expected: True
 but got: False
```

Mophasco explanation:

This program inherits the same issue as program 1, where the result of each
import in the program (`A_3`, `A_4`, `A_5`, `A_6`) is unstable due to its result
being an `IMP` edge which would be valid to follow to a better `A` declaration
if the query were to be run after the addition of that edge.

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

    module G_2 {
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

This could resolve to two ambiguities.

```
  [ { [ A_3 -> [A_1], A_4 -> [A_2], x_2 -> [x_1] ],
      [ A_3 -> [A_2], A_4 -> [A_1], x_2 -> [x_1] ]
    } ,

    { [ D_3 -> [D_1], D_4 -> [D_2], w_2 -> [w_1] ],
      [ D_3 -> [D_2], d_4 -> [D_1], w_2 -> [w_1] ]
    }
  ]
```

Or the ambiguities are nested. This is easier to create but perhaps less useful.
The one above requires us to identify that the resolution of C are independent
of what happens in the ambiguity in B.

```
  [ { [ A_3 -> [A_1], A_4 -> [A_2], x_2 -> [x_1],
        { [ D_3 -> [D_1], D_4 -> [D_2], w_2 -> [w_1] ],
          [ D_3 -> [D_2], D_4 -> [D_1], w_2 -> [w_1] ]
        }
      ],
      [ A_3 -> [A_2], A_4 -> [A_1], x_2 -> [x_1]
        { [ D_3 -> [D_1], D_4 -> [D_2], w_2 -> [w_1] ],
          [ D_3 -> [D_2], D_4 -> [D_1], w_2 -> [w_1] ]
        }
      ]
    }
  ]
```

Mophasco output (FAIL):

```
### Failure in: 0:0:eric-notes-3.aterm
test/Main.hs:82
It passes type checking
expected: True
 but got: False
```

Mophasco explanation:

Again, this inherits the same issue as with program 1. The result of each import
in the program renders itself unstable due to the addition of the `IMP` edge
which we draw after the query. For each `import` query in this program, running
the same query later under the newly extended graph would lead to different
results.

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

Resolves to two ambiguities:

```
  [ { [ A_3 -> [A_1], B_3 -> [B_1], x_3 -> [x_1] ],
      [ A_3 -> [A_2], B_3 -> [B_2], x_3 -> [x_2] ]
    }
  ]
```

Mophasco output (PASS):

```
Test suite mophasco-test: PASS
```

Mophasco explanation:

Despite the ambiguity between the import orders, Mophasco determines that the
program has a stable model. This is likely due to Mophasco picking one of the
stable resolutions that we get from the two different import orderings. Each of
these different resolutions by itself is stable. For instance, with
`p1 = [import A_3, import B_3]`, the only reachable and visible resolution for
`A_3` is `A_1`. Then the only visible resolution for `B_3` is `B_1`, since `IMP`
shadows `LEX`. From here, `x_3` can only resolve to `x_1`. We get a similar
result with the other permutation, `p2 = [import B_3, import A_3]` but we
resolve to `B_2`, `A_2` and `x_2` instead. Mophasco does not recognize the
ambiguity between these imports.

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

No ambiguities on imports, but ambiguities on x_3, x_4:

(EVW: I would not call these ambiguities. This is just a reference with multiple
declarations. The term "ambiguity" (or something else) should be reserved for
two resolutions that individually coherent.)

```
  [ A_2 -> [A_1],
    B_2 -> [B_1],
    { [ x_3 -> [x_1] ], [ x_3 -> [x_2] ] },
    { [ x_4 -> [x_1] ], [ x_4 -> [x_2] ] }
  ]
```

Mophasco output (FAIL):

```
### Failure in: 0:0:eric-notes-5.aterm
test/Main.hs:82
It passes type checking
expected: True
 but got: False
```

Mophasco explanation:

The import resolutions are stable, however there is an ambiguity on `x_3` and
`x_4` as both `A_1` and `B_1` define their own versions of `x`.

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

Resolves to an ambiguity on imports:

```
  [ { [ A_4 -> [A_1], B_2 -> [B_1], x_3 -> [] ],
      [ A_4 -> [A_3], B_2 -> [B_1], x_3 -> [x_2] ]
    }
  ]
```

Mophasco output (PASS):

```
Test suite mophasco-test: PASS
```

Mophasco explanation:

There is one stable resolution, which we get if we choose to query `B_2` first.
This adds an `IMP` edge from `C_1` to `B_1`, which we follow to get the best
resolution of `A_4`. Without this sub-module `A_3`, the results of `import A_4`
would be unstable, for the same reason that program 1 is unstable. However we
avoid this instability by taking the `IMP` edge we get after resolving `B_2`.

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
  [ { [ A_3 -> [A_1], B_3 -> [B_1], x_3 -> [x_1],
        A_4 -> [A_1], B_4 -> [B_1], x_4 -> [x_1] ],
      [ A_3 -> [A_2], B_3 -> [B_2], x_3 -> [x_2],
        A_4 -> [A_2], B_4 -> [B_2], x_4 -> [x_2] ]
    }
  ]
```

Mophasco output (PASS):

```
Test suite mophasco-test: PASS
```

Mophasco explanation:

As with program 4, there are two stable resolutions for the program where we
either `import A_3` first, or `import B_3` first. The imports `A_4` and `B_4`
simply use the `IMP` edges introduced by importing `B_3` and `A_3` respectively
to get to the most visible `A` and `B` modules, which depends on whether `A_3`
or `B_3` were resolved first.

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

Mophasco output (PASS):

```
Test suite mophasco-test: PASS
```

Mophasco explanation:

Both of the imports here are easy to resolve, as there is only one declaration
for each. Then, we can follow the `IMP` edges introduced by these to find the
correct (and only) declarations of `x` and `y`.

## Program 9

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

  def D_1 {
    import A_4
    import B_4
    def y_2 = x_4
  }

  module G_1 {
    module A_5 {
      module B_5 {
        def x_5 = 1
      }
    }
    module B_6 {
      module A_6 {
        def x_6 = 1
      }
    }
    module C_2 {
      import A_7
      import B_7
      def y_3 = x_7
    }
  }

}
```

Resolves to:

```
[{

  [ A_3 -> [A_1], B_3 -> [B_1], x_3 -> [x_1] ]              -- from C_1, perma 1
    ++ [ A_4 -> [A_1], B_4 -> [B_1], x_4 -> [x_1] ]         -- from D_1, perma 1
    ++ [{
         [ A_7 -> [A_5], B_7 -> [B_5], x_7 -> [x_5] ],      -- from C_2, perma 1
         [ A_7 -> [A_6], B_7 -> [B_6], x_7 -> [x_6] ]       -- from C_2, perma 2
       }]


  [ A_3 -> [A_2], B_3 -> [B_2], x_3 -> [x_2] ]              -- from C_1, perma 2
    ++ [ A_4 -> [A_2], B_4 -> [B_2], x_4 -> [x_2] ]         -- from D_1, perma 1
    ++ [{
         [ A_7 -> [A_5], B_7 -> [B_5], x_7 -> [x_5] ],      -- from C_2, perma 1
         [ A_7 -> [A_6], B_7 -> [B_6], x_7 -> [x_6] ]       -- from C_2, perma 2
       }]

}]
```

Mophasco output (PASS):

```
Test suite mophasco-test: PASS
```

Mophasco explanation:

Multiple (4) good program resolutions - see the leaves of the program resolution
tree structure above. All resolutions are stable. Mophasco only requires that
there is not an unstable resolution.
