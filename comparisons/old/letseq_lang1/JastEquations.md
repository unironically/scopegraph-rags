## Jast equations for inputs/letseq.lm

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

### Equations:
```

01: local globalScope::Scope = mkScope();
02: Decls_68.s = globalScope;
03: Decl_69.s = Decls_68.s;
04: Decls_70.s = Decls_68.s;
05: ParBind_71.s = Decl_69.s;
06: ParBind_71.s_def = Decl_69.s;
07: local varScope_72::Scope = mkScopeVar(("a", Expr_73.ty));
08: Expr_73.s = ParBind_71.s;
09: ParBind_71.s_def.varScopes <- [varScope_72];
10: local letScope_74::Scope = mkScopeLet();
11: SeqBinds_75.s = Expr_73.s;
12: SeqBinds_75.s_def = letScope_74;
13: Expr_76.s = letScope_74;
14: Expr_73.ty = Expr_76.ty;
15: local letBindScope_77::Scope = mkScopeSeqBind();
16: letBindScope_77.lexScopes <- [SeqBinds_75.s];
17: SeqBind_78.s = SeqBinds_75.s;
18: SeqBind_78.s_def = letBindScope_77;
19: SeqBinds_79.s = letBindScope_77;
20: SeqBinds_79.s_def = SeqBinds_75.s_def;
21: local varScope_80::Scope = mkScopeVar(("x", Expr_81.ty));
22: Expr_81.s = SeqBind_78.s;
23: SeqBind_78.s_def.varScopes <- [varScope_80];
24: Expr_81.ty = tInt();
25: local letBindScope_82::Scope = mkScopeSeqBind();
26: letBindScope_82.lexScopes <- [SeqBinds_79.s];
27: SeqBind_83.s = SeqBinds_79.s;
28: SeqBind_83.s_def = letBindScope_82;
29: SeqBinds_84.s = letBindScope_82;
30: SeqBinds_84.s_def = SeqBinds_79.s_def;
31: local varScope_85::Scope = mkScopeVar(("y", Expr_86.ty));
32: Expr_86.s = SeqBind_83.s;
33: SeqBind_83.s_def.varScopes <- [varScope_85];
34: Expr_86.ty = tInt();
35: SeqBind_87.s = SeqBinds_84.s;
36: SeqBind_87.s_def = SeqBinds_84.s_def
37: SeqBinds_84.s_def.lexScopes <- [SeqBinds_84.s];
38: local varScope_88::Scope = mkScopeVar(("z", Expr_89.ty));
39: Expr_89.s = SeqBind_87.s;
40: SeqBind_87.s_def.varScopes <- [varScope_88];
41: Expr_89.ty = tInt();
42: Expr_90.s = Expr_76.s;
43: Expr_91.s = Expr_76.s;
44: Expr_76.ty = if Expr_90.ty == tInt() && Expr_91.ty == tInt() then tInt() else tErr();
45: Expr_92.s = Expr_90.s;
46: Expr_93.s = Expr_90.s;
47: Expr_90.ty = if Expr_92.ty == tInt() && Expr_93.ty == tInt() then tInt() else tErr();
48: VarRef_94.s = Expr_92.s;
49: Expr_92.ty = case VarRef_94.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
50: local regex_95::Regex = `LEX* VAR`;
51: local dfa_96::DFA = regex_95.dfa;
52: local resFun_97::ResFunTy = resolutionFun(dfa_96);
53: local result_98::[Decorated Scope] = resFun_97(VarRef_94.s, "x");
54: VarRef_94.datum =
	case result_98 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
55: VarRef_99.s = Expr_93.s;
56: Expr_93.ty = case VarRef_99.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
57: local regex_100::Regex = `LEX* VAR`;
58: local dfa_101::DFA = regex_100.dfa;
59: local resFun_102::ResFunTy = resolutionFun(dfa_101);
60: local result_103::[Decorated Scope] = resFun_102(VarRef_99.s, "y");
61: VarRef_99.datum =
	case result_103 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
62: VarRef_104.s = Expr_91.s;
63: Expr_91.ty = case VarRef_104.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
64: local regex_105::Regex = `LEX* VAR`;
65: local dfa_106::DFA = regex_105.dfa;
66: local resFun_107::ResFunTy = resolutionFun(dfa_106);
67: local result_108::[Decorated Scope] = resFun_107(VarRef_104.s, "z");
68: VarRef_104.datum =
	case result_108 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;

```
