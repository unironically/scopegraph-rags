## Statix core constraints for inputs/letseq.lm

### Input program:
```
def a =
  let
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
08: {s_def_4}
09: new s_def_4
10: s_def_4 -[ `LEX ]-> s_0
11: {s_var_5, ty_6}
12: new s_var_5 -> ("x", ty_6)
13: s_def_4 -[ `VAR ]-> s_var_5
14: ty_6 == INT()
15: {s_def_7}
16: new s_def_7
17: s_def_7 -[ `LEX ]-> s_def_4
18: {s_var_8, ty_9}
19: new s_var_8 -> ("y", ty_9)
20: s_def_7 -[ `VAR ]-> s_var_8
21: ty_9 == INT()
22: s_let_3 -[ `LEX ]-> s_def_7
23: {s_var_10, ty_11}
24: new s_var_10 -> ("z", ty_11)
25: s_let_3 -[ `VAR ]-> s_var_10
26: ty_11 == INT()
27: {vars_12, xvars_13, xvars_14}
28: query s_let_3 `LEX*`IMP? `VAR as vars_12
29: filter vars_12((x, _) where x == "x") xvars_13
30: min-refs(xvars_13, xvars_14)
31: only(xvars_14, p_15)
32: datum(p_15, (x_16, INT()))
33: {vars_17, xvars_18, xvars_19}
34: query s_let_3 `LEX*`IMP? `VAR as vars_17
35: filter vars_17((x, _) where x == "y") xvars_18
36: min-refs(xvars_18, xvars_19)
37: only(xvars_19, p_20)
38: datum(p_20, (x_21, INT()))
39: INT() == INT()
40: {vars_22, xvars_23, xvars_24}
41: query s_let_3 `LEX*`IMP? `VAR as vars_22
42: filter vars_22((x, _) where x == "z") xvars_23
43: min-refs(xvars_23, xvars_24)
44: only(xvars_24, p_25)
45: datum(p_25, (x_26, INT()))
46: ty_2 == INT()
47: true
```
