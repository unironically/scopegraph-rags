
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

program resolution: a single ambiguity

```
  [ { [ A_3 -> [A_1], A_4 -> [A_2], x_2 -> [x_1] ],
      [ A_3 -> [A_2], A_4 -> [A_1], x_2 -> [x_1] ] 
    }
  ]
```

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

Or the ambiguities are nested. This is easier to create but perhaps
less useful. The one above requires us to identify that the resolution
of C are independent of what happens in the ambiguity in B.

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

(EVW: I would not call these ambiguities. This is just a reference
with multiple declarations. The term "ambiguity" (or something else)
should be reserved for two resolutions that individually coherent.)

```
  [ A_2 -> [A_1], 
    B_2 -> [B_1], 
    { [ x_3 -> [x_1] ], [ x_3 -> [x_2] ] }, 
    { [ x_4 -> [x_1] ], [ x_4 -> [x_2] ] }
  ]
```

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

## Program 7

```
module A_1 {
  module B_1 {
    def x_1 = 1
  }
}
module A_2 {
  module B_2 {
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

Resolves to an import ambiguity, which only occurs due import A_3 and import B_3.
There is no ambiguity involving A_4 and B_4, because the IMP edges we get by resolving
A_3 and B_3 are used when resolving A_4 and B_4. Thus the edge introduced for these can only
point to the same scopes as are pointed to by module C_1 after resolving A_3 and B_3:

```
  [ { [ A_3 -> [A_1], B_3 -> [B_1], x_3 -> [x_1], A_4 -> [A_1], B_4 -> [B_1], x_4 -> [x_1] ],
      [ A_3 -> [A_2], B_3 -> [B_2], x_3 -> [x_2], A_4 -> [A_2], B_4 -> [B_2], x_4 -> [x_2] ],
    }
  ]
```

## Program 8

```
module A_1 {
  import B_1
  def x_1 = y_1
}
module B_2 {
  import A_2
  def x_2 = y_2
}
```

Resolves to:

```
  [ B_1 -> [B_2], x_1 -> [x_2], A_2 -> [A_1], y_2 -> [y_1] ]
```
