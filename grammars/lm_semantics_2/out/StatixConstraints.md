## Statix core constraints for inputs/modules-simple.lm

### Input program:
```
module A {
  def a = 1
}

module B {
  import A
  def b = a
}
```

### Constraints:
```

new s_0
new s_imp_1
s_imp_1 -[ `LEX ]-> s_0
new s_imp_2
s_imp_2 -[ `LEX ]-> s_imp_1
true

```
