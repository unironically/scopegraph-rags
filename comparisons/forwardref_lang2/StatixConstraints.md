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
03: {s_1}
04: new s_1
05: s_1 -[ `LEX ]-> s_0
06: {s_var_2, ty_3}
07: new s_var_2 -> ("a", ty_3)
08: s_1 -[ `VAR ]-> s_var_2
09: {vars_4, xvars_5, xvars_6}
10: query s_0 `LEX*`IMP? `VAR as vars_4
11: filter vars_4 ((x, _) where x == "b") xvars_5
12: min-refs(xvars_5, xvars_6)
13: only(xvars_6, p_7)
14: datum(p_7, (x_8, ty_3))
15: {s_9}
16: new s_9
17: s_9 -[ `LEX ]-> s_1
18: {s_var_10, ty_11}
19: new s_var_10 -> ("b", ty_11)
20: s_9 -[ `VAR ]-> s_var_10
21: ty_11 == INT()
22: true
```
