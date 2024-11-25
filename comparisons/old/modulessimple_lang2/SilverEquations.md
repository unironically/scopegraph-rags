## Silver equations for inputs/modulessimple.lm

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

01: local globalScope::Scope = mkScopeGlobal([], []);
02: Decls_23.s = globalScope;
03: local lookupScope_24::Scope = mkScopeImpLookup(Decls_23.s, Decl_25.varScopes, Decl_25.modScopes, Decl_25.impScope);
04: Decl_25.s = Decls_23.s;
05: Decl_25.sLooukp = lookupScope_24;
06: Decls_26.s = lookupScope_24;
07: Decls_23.varScopes = Decl_25.varScopes ++ Decls_26.varScopes;
08: Decls_23.modScopes = Decl_25.modScopes ++ Decls_26.modScopes;
09: local modScope_27::Scope = mkScopeMod(Decl_25.s, Decls_28.varScopes, Decls_28.modScopes, "A");
10: Decl_25.varScopes = [];
11: Decl_25.modScopes = [modScope_27];
12: Decl_25.impScope = nothing();
13: Decls_28.s = Decl_25.s;
14: local lookupScope_29::Scope = mkScopeImpLookup(Decls_28.s, Decl_30.varScopes, Decl_30.modScopes, Decl_30.impScope);
15: Decl_30.s = Decls_28.s;
16: Decl_30.sLooukp = lookupScope_29;
17: Decls_31.s = lookupScope_29;
18: Decls_28.varScopes = Decl_30.varScopes ++ Decls_31.varScopes;
19: Decls_28.modScopes = Decl_30.modScopes ++ Decls_31.modScopes;
20: Decl_30.varScopes = ParBind_32.varScopes;
21: Decl_30.modScopes = [];
22: Decl_30.impScope = nothing();
23: ParBind_32.s = Decl_30.sLookup;
24: local varScope_33::Scope = mkScopeVar(("a", Expr_34.ty));
25: Expr_34.s = ParBind_32.s;
26: ParBind_32.varScopes = [varScope_33];
27: Decls_31.varScopes = [];
28: Decls_31.modScopes = [];
29: local lookupScope_35::Scope = mkScopeImpLookup(Decls_26.s, Decl_36.varScopes, Decl_36.modScopes, Decl_36.impScope);
30: Decl_36.s = Decls_26.s;
31: Decl_36.sLooukp = lookupScope_35;
32: Decls_37.s = lookupScope_35;
33: Decls_26.varScopes = Decl_36.varScopes ++ Decls_37.varScopes;
34: Decls_26.modScopes = Decl_36.modScopes ++ Decls_37.modScopes;
35: local modScope_38::Scope = mkScopeMod(Decl_36.s, Decls_39.varScopes, Decls_39.modScopes, "B");
36: Decl_36.varScopes = [];
37: Decl_36.modScopes = [modScope_38];
38: Decl_36.impScope = nothing();
39: Decls_39.s = Decl_36.s;
40: local lookupScope_40::Scope = mkScopeImpLookup(Decls_39.s, Decl_41.varScopes, Decl_41.modScopes, Decl_41.impScope);
41: Decl_41.s = Decls_39.s;
42: Decl_41.sLooukp = lookupScope_40;
43: Decls_42.s = lookupScope_40;
44: Decls_39.varScopes = Decl_41.varScopes ++ Decls_42.varScopes;
45: Decls_39.modScopes = Decl_41.modScopes ++ Decls_42.modScopes;
46: Decl_41.varScopes = [];
47: Decl_41.modScopes = [];
48: Decl_41.impScope = ModRef_43.declScope;
49: ModRef_43.s = Decl_41.s;
50: local regex_44::Regex = `LEX* IMP? MOD`;
51: local dfa_45::DFA = regex_44.dfa;
52: local resFun_46::ResFunTy = resolutionFun(dfa_45);
53: local result_47::[Decorated Scope] = resFun_46(ModRef_43.s, "A");
54: ModRef_43.declScope = 
	case result_47 of
	| s::_ -> just(s)
	| [] -> nothing()
	end;
55: ModRef_43.ok = ModRef_43.declScope.isJust;
56: local lookupScope_48::Scope = mkScopeImpLookup(Decls_42.s, Decl_49.varScopes, Decl_49.modScopes, Decl_49.impScope);
57: Decl_49.s = Decls_42.s;
58: Decl_49.sLooukp = lookupScope_48;
59: Decls_50.s = lookupScope_48;
60: Decls_42.varScopes = Decl_49.varScopes ++ Decls_50.varScopes;
61: Decls_42.modScopes = Decl_49.modScopes ++ Decls_50.modScopes;
62: Decl_49.varScopes = ParBind_51.varScopes;
63: Decl_49.modScopes = [];
64: Decl_49.impScope = nothing();
65: ParBind_51.s = Decl_49.sLookup;
66: local varScope_52::Scope = mkScopeVar(("b", Expr_53.ty));
67: Expr_53.s = ParBind_51.s;
68: ParBind_51.varScopes = [varScope_52];
69: VarRef_54.s = Expr_53.s;
70: local regex_55::Regex = `LEX* IMP? VAR`;
71: local dfa_56::DFA = regex_55.dfa;
72: local resFun_57::ResFunTy = resolutionFun(dfa_56);
73: local result_58::[Decorated Scope] = resFun_57(VarRef_54.s, "a");
74: VarRef_54.declScope = 
	case result_58 of
	| s::_ -> just(s)
	| [] -> nothing()
	end;
75: VarRef_54.ok = VarRef_54.declScope.isJust;
76: Decls_50.varScopes = [];
77: Decls_50.modScopes = [];
78: Decls_37.varScopes = [];
79: Decls_37.modScopes = [];

```
