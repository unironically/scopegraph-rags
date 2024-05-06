## Silver equations for inputs/forwardvarref.lm

### Input program:
```
def a = b
def b = 1
```

### Equations:
```

01: local globalScope::Scope = mkScopeGlobal(Decls_10.varScopes);
02: Decls_10.s = globalScope;
03: Decl_11.s = Decls_10.s;
04: Decls_12.s = Decls_10.s;
05: Decls_10.varScopes = Decl_11.varScopes ++ Decls_12.varScopes;
06: Decl_11.varScopes = ParBind_13.varScopes;
07: ParBind_13.s = Decl_11.s;
08: local varScope_14::Scope = mkScopeVar(("a", Expr_15.ty));
09: Expr_15.s = ParBind_13.s;
10: ParBind_13.varScopes = [varScope_14];
11: VarRef_16.s = Expr_15.s;
12: local regex_17::Regex = `LEX* VAR`;
13: local dfa_18::DFA = regex_17.dfa;
14: local resFun_19::ResFunTy = resolutionFun(dfa_18);
15: local result_20::[Decorated Scope] = resFun_19(VarRef_16.s, "b");
16: VarRef_16.datum = 
	case result_20 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
17: Decl_21.s = Decls_12.s;
18: Decls_22.s = Decls_12.s;
19: Decls_12.varScopes = Decl_21.varScopes ++ Decls_22.varScopes;
20: Decl_21.varScopes = ParBind_23.varScopes;
21: ParBind_23.s = Decl_21.s;
22: local varScope_24::Scope = mkScopeVar(("b", Expr_25.ty));
23: Expr_25.s = ParBind_23.s;
24: ParBind_23.varScopes = [varScope_24];
25: Decls_22.varScopes = [];

```
