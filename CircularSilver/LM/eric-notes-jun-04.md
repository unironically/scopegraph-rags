
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
