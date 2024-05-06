## Statix core constraints for inputs/letrec.lm

### Input program:
```
def a = 
  letrec
    x = 1,
    y = 2,
    z = 3
  in 
    x + y + z
```

### Constraints:
```
01: {s_0}
02: new s_0
03: {s_var_1, ty_2}
04: new s_var_1 -> ("a", ty_2)
05: s_0 -[ `VAR ]-> s_var_1
06: {s_let_3}
07: new s_let_3
08: s_let_3 -[ `LEX ]-> s_0
09: {s_var_4, ty_5}
10: new s_var_4 -> ("x", ty_5)
11: s_let_3 -[ `VAR ]-> s_var_4
12: ty_5 == INT()
13: {s_var_6, ty_7}
14: new s_var_6 -> ("y", ty_7)
15: s_let_3 -[ `VAR ]-> s_var_6
16: ty_7 == INT()
17: {s_var_8, ty_9}
18: new s_var_8 -> ("z", ty_9)
19: s_let_3 -[ `VAR ]-> s_var_8
20: ty_9 == INT()
21: true
22: {vars_10, xvars_11, xvars_12}
23: query s_let_3 `LEX*`IMP? `VAR as vars_10
24: filter vars_10 ((x, _) where x == "x") xvars_11
25: min-refs(xvars_11, xvars_12)
26: only(xvars_12, p_13)
27: datum(p_13, (x_14, INT()))
28: {vars_15, xvars_16, xvars_17}
29: query s_let_3 `LEX*`IMP? `VAR as vars_15
30: filter vars_15 ((x, _) where x == "y") xvars_16
31: min-refs(xvars_16, xvars_17)
32: only(xvars_17, p_18)
33: datum(p_18, (x_19, INT()))
34: INT() == INT()
35: {vars_20, xvars_21, xvars_22}
36: query s_let_3 `LEX*`IMP? `VAR as vars_20
37: filter vars_20 ((x, _) where x == "z") xvars_21
38: min-refs(xvars_21, xvars_22)
39: only(xvars_22, p_23)
40: datum(p_23, (x_24, INT()))
41: ty_2 == INT()
42: true
```
