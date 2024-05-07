## Statix core constraints for inputs/modulessimple.lm

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
01: {s_0}
02: new s_0
03: {s_1}
04: new s_1
05: s_1 -[ `LEX ]-> s_0
06: {s_mod_2}
07: new s_mod_2 -> ("A", s_mod_2)
08: s_1 -[ `MOD ]-> s_mod_2
09: s_mod_2 -[ `LEX ]-> s_1
10: {s_3}
11: new s_3
12: s_3 -[ `LEX ]-> s_1
13: {s_var_4, ty_5}
14: new s_var_4 -> ("a", ty_5)
15: s_3 -[ `VAR ]-> s_var_4
16: s_mod_2 -[ `VAR ]-> s_var_4
17: ty_5 == INT()
18: true
19: {s_6}
20: new s_6
21: s_6 -[ `LEX ]-> s_1
22: {s_mod_7}
23: new s_mod_7 -> ("B", s_mod_7)
24: s_6 -[ `MOD ]-> s_mod_7
25: s_mod_7 -[ `LEX ]-> s_6
26: {s_8}
27: new s_8
28: s_8 -[ `LEX ]-> s_6
29: {p_9, x_10, s_mod_11}
30: {mods_12, xmods_13, xmods_14}
31: query s_6 `LEX*`IMP? `VAR as mods_12
32: filter mods_12 ((x, _) where x == "A") xmods_13
33: min-refs(xmods_13, xmods_14)
34: only(xmods_14, p_9)
35: datum(p_9, (x_10, s_mod_11))
36: s_8 -[ `IMP ]-> s_mod_11
37: {s_15}
38: new s_15
39: s_15 -[ `LEX ]-> s_8
40: {s_var_16, ty_17}
41: new s_var_16 -> ("b", ty_17)
42: s_15 -[ `VAR ]-> s_var_16
43: s_mod_7 -[ `VAR ]-> s_var_16
44: {vars_18, xvars_19, xvars_20}
45: query s_8 `LEX*`IMP? `VAR as vars_18
46: filter vars_18 ((x, _) where x == "a") xvars_19
47: min-refs(xvars_19, xvars_20)
48: only(xvars_20, p_21)
49: datum(p_21, (x_22, ty_17))
50: true
51: true
```
