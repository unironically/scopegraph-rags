## Statix core constraints for inputs/forwardvarref.lm

### Input program:
```
def a = b
def b = 1
```

### Constraints:
```
01: {s_0}
02: new s_0
03: {s_var_1, ty_2}
04: new s_var_1 -> ("a", ty_2)
05: s_0 -[ `VAR ]-> s_var_1
06: {vars_3, xvars_4, xvars_5}
07: query s_0 `LEX*`IMP? `VAR as vars_3
08: filter vars_3((x, _) where x == "b") xvars_4
09: min-refs(xvars_4, xvars_5)
10: only(xvars_5, p_6)
11: datum(p_6, (x_7, ty_2))
12: {s_var_8, ty_9}
13: new s_var_8 -> ("b", ty_9)
14: s_0 -[ `VAR ]-> s_var_8
15: ty_9 == INT()
16: true
```
