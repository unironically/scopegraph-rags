## Silver equations for inputs/forwardvarref.lm

### Input program:
```
def a = b
def b = 1
```

### Equations:
```

01: local globalScope::Scope = mkScopeGlobal([], []);
02: Decls_12.s = globalScope;
03: local lookupScope_13::Scope = mkScopeImpLookup(Decls_12.s, Decl_14.varScopes, Decl_14.modScopes, Decl_14.impScope);
04: Decl_14.s = Decls_12.s;
05: Decls_15.s = lookupScope_13;
06: Decls_12.varScopes = Decl_14.varScopes ++ Decls_15.varScopes;
07: Decls_12.modScopes = Decl_14.modScopes ++ Decls_15.modScopes;
08: Decl_14.varScopes = ParBind_16.varScopes;
09: Decl_14.modScopes = [];
10: Decl_14.impScope = nothing();
11: ParBind_16.s = Decl_14.s;
12: local varScope_17::Scope = mkScopeVar(("a", Expr_18.ty));
13: Expr_18.s = ParBind_16.s;
14: ParBind_16.varScopes = [varScope_17];
15: VarRef_19.s = Expr_18.s;
16: local regex_20::Regex = `LEX* IMP? VAR`;
17: local dfa_21::DFA = regex_20.dfa;
18: local resFun_22::ResFunTy = resolutionFun(dfa_21);
19: local result_23::[Decorated Scope] = resFun_22(VarRef_19.s, "b");
20: VarRef_19.declScope = 
	case result_23 of
	| s::_ -> just(s)
	| [] -> nothing()
	end;
21: local lookupScope_24::Scope = mkScopeImpLookup(Decls_15.s, Decl_25.varScopes, Decl_25.modScopes, Decl_25.impScope);
22: Decl_25.s = Decls_15.s;
23: Decls_26.s = lookupScope_24;
24: Decls_15.varScopes = Decl_25.varScopes ++ Decls_26.varScopes;
25: Decls_15.modScopes = Decl_25.modScopes ++ Decls_26.modScopes;
26: Decl_25.varScopes = ParBind_27.varScopes;
27: Decl_25.modScopes = [];
28: Decl_25.impScope = nothing();
29: ParBind_27.s = Decl_25.s;
30: local varScope_28::Scope = mkScopeVar(("b", Expr_29.ty));
31: Expr_29.s = ParBind_27.s;
32: ParBind_27.varScopes = [varScope_28];
33: Decls_26.varScopes = [];
34: Decls_26.modScopes = [];

```
