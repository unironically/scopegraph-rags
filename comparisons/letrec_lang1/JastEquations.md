## Jast equations for inputs/letrec.lm

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

### Equations:
```

01: local globalScope::Scope = mkScope();
02: Decls_65.s = globalScope;
03: Decl_66.s = Decls_65.s;
04: Decls_67.s = Decls_65.s;
05: ParBind_68.s = Decl_66.s;
06: ParBind_68.s_def = Decl_66.s;
07: local varScope_69::Scope = mkScopeVar(("a", Expr_70.ty));
08: Expr_70.s = ParBind_68.s;
09: ParBind_68.s_def.varScopes <- [varScope_69];
10: local letScope_71::Scope = mkScopeLet();
11: letScope_71.lexScopes <- [Expr_70.s];
12: ParBinds_72.s = letScope_71;
13: ParBinds_72.s_def = letScope_71;
14: Expr_73.s = letScope_71;
15: Expr_70.ty = Expr_73.ty;
16: ParBind_74.s = ParBinds_72.s;
17: ParBind_74.s_def = ParBinds_72.s_def;
18: ParBinds_75.s = ParBinds_72.s;
19: ParBinds_75.s_def = ParBinds_72.s_def;
20: local varScope_76::Scope = mkScopeVar(("x", Expr_77.ty));
21: Expr_77.s = ParBind_74.s;
22: ParBind_74.s_def.varScopes <- [varScope_76];
23: Expr_77.ty = tInt();
24: ParBind_78.s = ParBinds_75.s;
25: ParBind_78.s_def = ParBinds_75.s_def;
26: ParBinds_79.s = ParBinds_75.s;
27: ParBinds_79.s_def = ParBinds_75.s_def;
28: local varScope_80::Scope = mkScopeVar(("y", Expr_81.ty));
29: Expr_81.s = ParBind_78.s;
30: ParBind_78.s_def.varScopes <- [varScope_80];
31: Expr_81.ty = tInt();
32: ParBind_82.s = ParBinds_79.s;
33: ParBind_82.s_def = ParBinds_79.s_def;
34: ParBinds_83.s = ParBinds_79.s;
35: ParBinds_83.s_def = ParBinds_79.s_def;
36: local varScope_84::Scope = mkScopeVar(("z", Expr_85.ty));
37: Expr_85.s = ParBind_82.s;
38: ParBind_82.s_def.varScopes <- [varScope_84];
39: Expr_85.ty = tInt();
40: Expr_86.s = Expr_73.s;
41: Expr_87.s = Expr_73.s;
42: Expr_73.ty = if Expr_86.ty == tInt() && Expr_87.ty == tInt() then tInt() else tErr();
43: Expr_88.s = Expr_86.s;
44: Expr_89.s = Expr_86.s;
45: Expr_86.ty = if Expr_88.ty == tInt() && Expr_89.ty == tInt() then tInt() else tErr();
46: VarRef_90.s = Expr_88.s;
47: Expr_88.ty = case VarRef_90.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
48: local regex_91::Regex = `LEX* VAR`;
49: local dfa_92::DFA = regex_91.dfa;
50: local resFun_93::ResFunTy = resolutionFun(dfa_92);
51: local result_94::[Decorated Scope] = resFun_93(VarRef_90.s, "x");
52: VarRef_90.datum = 
	case result_94 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
53: VarRef_95.s = Expr_89.s;
54: Expr_89.ty = case VarRef_95.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
55: local regex_96::Regex = `LEX* VAR`;
56: local dfa_97::DFA = regex_96.dfa;
57: local resFun_98::ResFunTy = resolutionFun(dfa_97);
58: local result_99::[Decorated Scope] = resFun_98(VarRef_95.s, "y");
59: VarRef_95.datum = 
	case result_99 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
60: VarRef_100.s = Expr_87.s;
61: Expr_87.ty = case VarRef_100.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
62: local regex_101::Regex = `LEX* VAR`;
63: local dfa_102::DFA = regex_101.dfa;
64: local resFun_103::ResFunTy = resolutionFun(dfa_102);
65: local result_104::[Decorated Scope] = resFun_103(VarRef_100.s, "z");
66: VarRef_100.datum = 
	case result_104 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;

```
