## Jast equations for inputs/modulessimple.lm

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

### Equations:
```

01: local globalScope::Scope = mkScope();
02: Decls_59.s = globalScope;
03: Decls_59.s_mod = globalScope;
04: Decls_59.s_glob = globalScope;
05: local lookupScope_60::Scope = mkScopeImpLookup()
06: lookupScope_60.lexScopes <- [Decls_59.s];
07: Decl_61.s = lookupScope_60;
08: Decl_61.s_lookup = Decls_59.s;
09: Decl_61.s_mod = Decls_59.s_mod;
10: Decl_61.s_glob = Decls_59.s_glob;
11: Decls_62.s = lookupScope_60;
12: Decls_62.s_mod = Decls_59.s_mod;
13: Decls_62.s_glob = Decls_59.s_glob;
14: local s_mod_63::Scope = mkScopeMod(("A", s_mod_63));
15: Decl_61.s.modScopes <- [s_mod_63];
16: s_mod_63.lexScopes <- [Decl_61.s];
17: Decls_64.s = Decl_61.s;
18: Decls_64.s_mod = s_mod_63;
19: Decls_64.s_glob = Decl_61.s_glob;
20: local lookupScope_65::Scope = mkScopeImpLookup()
21: lookupScope_65.lexScopes <- [Decls_64.s];
22: Decl_66.s = lookupScope_65;
23: Decl_66.s_lookup = Decls_64.s;
24: Decl_66.s_mod = Decls_64.s_mod;
25: Decl_66.s_glob = Decls_64.s_glob;
26: Decls_67.s = lookupScope_65;
27: Decls_67.s_mod = Decls_64.s_mod;
28: Decls_67.s_glob = Decls_64.s_glob;
29: ParBind_68.s = Decl_66.s_lookup;
30: ParBind_68.s_def = Decl_66.s;
31: ParBind_68.s_mod = Decl_66.s_mod
32: ParBind_68.s_glob = Decl_66.s_glob;
33: local varScope_69::Scope = mkScopeVar(("a", Expr_70.ty));
34: Expr_70.s = ParBind_68.s;
35: ParBind_68.s_def.varScopes <- [varScope_69];
36: ParBind_68.s_mod.varScopes <- [varScope_69];
37: Expr_70.ty = tInt();
38: local lookupScope_73::Scope = mkScopeImpLookup()
39: lookupScope_73.lexScopes <- [Decls_62.s];
40: Decl_74.s = lookupScope_73;
41: Decl_74.s_lookup = Decls_62.s;
42: Decl_74.s_mod = Decls_62.s_mod;
43: Decl_74.s_glob = Decls_62.s_glob;
44: Decls_75.s = lookupScope_73;
45: Decls_75.s_mod = Decls_62.s_mod;
46: Decls_75.s_glob = Decls_62.s_glob;
47: local s_mod_76::Scope = mkScopeMod(("B", s_mod_76));
48: Decl_74.s.modScopes <- [s_mod_76];
49: s_mod_76.lexScopes <- [Decl_74.s];
50: Decls_77.s = Decl_74.s;
51: Decls_77.s_mod = s_mod_76;
52: Decls_77.s_glob = Decl_74.s_glob;
53: local lookupScope_78::Scope = mkScopeImpLookup()
54: lookupScope_78.lexScopes <- [Decls_77.s];
55: Decl_79.s = lookupScope_78;
56: Decl_79.s_lookup = Decls_77.s;
57: Decl_79.s_mod = Decls_77.s_mod;
58: Decl_79.s_glob = Decls_77.s_glob;
59: Decls_80.s = lookupScope_78;
60: Decls_80.s_mod = Decls_77.s_mod;
61: Decls_80.s_glob = Decls_77.s_glob;
62: local datum_81::[Decorated Scope] = case ModRef_82.datum of | datumMod((_, s)) -> [s] | _ -> [] end;
63: Decl_79.s_lookup.impScopes <- datum_81;
64: ModRef_82.s = Decl_79.s;
65: local regex_83::Regex = `LEX* IMP? MOD`;
66: local dfa_84::DFA = regex_83.dfa;
67: local resFun_85::ResFunTy = resolutionFun(dfa_84);
68: local result_86::[Decorated Scope] = resFun_85(ModRef_82.s, "A");
69: ModRef_82.datum = 
	case result_86 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
70: local lookupScope_87::Scope = mkScopeImpLookup()
71: lookupScope_87.lexScopes <- [Decls_80.s];
72: Decl_88.s = lookupScope_87;
73: Decl_88.s_lookup = Decls_80.s;
74: Decl_88.s_mod = Decls_80.s_mod;
75: Decl_88.s_glob = Decls_80.s_glob;
76: Decls_89.s = lookupScope_87;
77: Decls_89.s_mod = Decls_80.s_mod;
78: Decls_89.s_glob = Decls_80.s_glob;
79: ParBind_90.s = Decl_88.s_lookup;
80: ParBind_90.s_def = Decl_88.s;
81: ParBind_90.s_mod = Decl_88.s_mod
82: ParBind_90.s_glob = Decl_88.s_glob;
83: local varScope_91::Scope = mkScopeVar(("b", Expr_92.ty));
84: Expr_92.s = ParBind_90.s;
85: ParBind_90.s_def.varScopes <- [varScope_91];
86: ParBind_90.s_mod.varScopes <- [varScope_91];
87: VarRef_94.s = Expr_92.s;
88: Expr_92.ty = case VarRef_94.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
89: local regex_95::Regex = `LEX* IMP? VAR`;
90: local dfa_96::DFA = regex_95.dfa;
91: local resFun_97::ResFunTy = resolutionFun(dfa_96);
92: local result_98::[Decorated Scope] = resFun_97(VarRef_94.s, "a");
93: VarRef_94.datum = 
	case result_98 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;

```
