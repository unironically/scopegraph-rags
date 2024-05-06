## Silver equations for inputs/letrec.lm

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

01: local globalScope::Scope = mkScopeGlobal(Decls_25.varScopes);
02: Decls_25.s = globalScope;
03: Decl_26.s = Decls_25.s;
04: Decls_27.s = Decls_25.s;
05: Decls_25.varScopes = Decl_26.varScopes ++ Decls_27.varScopes;
06: Decl_26.varScopes = ParBind_28.varScopes;
07: ParBind_28.s = Decl_26.s;
08: local varScope_29::Scope = mkScopeVar(("a", Expr_30.ty));
09: Expr_30.s = ParBind_28.s;
10: ParBind_28.varScopes = [varScope_29];
11: local letScope_31::Scope = mkScopeLet(Expr_30.s, ParBinds_32.varScopes);
12: ParBinds_32.s = letScope_31;
13: Expr_33.s = letScope_31;
14: ParBind_34.s = ParBinds_32.s;
15: ParBinds_35.s = ParBinds_32.s;
16: local varScope_36::Scope = mkScopeVar(("x", Expr_37.ty));
17: Expr_37.s = ParBind_34.s;
18: ParBind_34.varScopes = [varScope_36];
19: ParBind_38.s = ParBinds_35.s;
20: ParBinds_39.s = ParBinds_35.s;
21: local varScope_40::Scope = mkScopeVar(("y", Expr_41.ty));
22: Expr_41.s = ParBind_38.s;
23: ParBind_38.varScopes = [varScope_40];
24: ParBind_42.s = ParBinds_39.s;
25: ParBinds_43.s = ParBinds_39.s;
26: local varScope_44::Scope = mkScopeVar(("z", Expr_45.ty));
27: Expr_45.s = ParBind_42.s;
28: ParBind_42.varScopes = [varScope_44];
29: ParBinds_43.varScopes = [];
30: Expr_46.s = Expr_33.s;
31: Expr_47.s = Expr_33.s;
32: Expr_48.s = Expr_46.s;
33: Expr_49.s = Expr_46.s;
34: VarRef_50.s = Expr_48.s;
35: local regex_51::Regex = `LEX* VAR`;
36: local dfa_52::DFA = regex_51.dfa;
37: local resFun_53::ResFunTy = resolutionFun(dfa_52);
38: local result_54::[Decorated Scope] = resFun_53(VarRef_50.s, "x");
39: VarRef_50.datum = 
	case result_54 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
40: VarRef_55.s = Expr_49.s;
41: local regex_56::Regex = `LEX* VAR`;
42: local dfa_57::DFA = regex_56.dfa;
43: local resFun_58::ResFunTy = resolutionFun(dfa_57);
44: local result_59::[Decorated Scope] = resFun_58(VarRef_55.s, "y");
45: VarRef_55.datum = 
	case result_59 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
46: VarRef_60.s = Expr_47.s;
47: local regex_61::Regex = `LEX* VAR`;
48: local dfa_62::DFA = regex_61.dfa;
49: local resFun_63::ResFunTy = resolutionFun(dfa_62);
50: local result_64::[Decorated Scope] = resFun_63(VarRef_60.s, "z");
51: VarRef_60.datum = 
	case result_64 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
52: Decls_27.varScopes = [];

```
