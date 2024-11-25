## Silver equations for inputs/letseq.lm

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

01: local globalScope::Scope = mkScopeGlobal(Decls_27.varScopes);
02: Decls_27.s = globalScope;
03: Decl_28.s = Decls_27.s;
04: Decls_29.s = Decls_27.s;
05: Decls_27.varScopes = Decl_28.varScopes ++ Decls_29.varScopes;
06: Decl_28.varScopes = ParBind_30.varScopes;
07: ParBind_30.s = Decl_28.s;
08: local varScope_31::Scope = mkScopeVar(("a", Expr_32.ty));
09: Expr_32.s = ParBind_30.s;
10: ParBind_30.varScopes = [varScope_31];
11: local letScope_33::Scope = mkScopeLet(SeqBinds_34.lastScope, SeqBinds_34.varScopes);
12: SeqBinds_34.s = Expr_32.s;
13: Expr_35.s = letScope_33;
14: local letBindScope_36::Scope = mkScopeSeqBind(SeqBinds_34.s, SeqBind_37.varScopes);
15: SeqBind_37.s = SeqBinds_34.s;
16: SeqBinds_38.s = letBindScope_36;
17: SeqBinds_34.varScopes = SeqBinds_38.varScopes;
18: SeqBinds_34.lastScope = SeqBinds_38.lastScope;
19: local varScope_39::Scope = mkScopeVar(("x", Expr_40.ty));
20: Expr_40.s = SeqBind_37.s;
21: SeqBind_37.varScopes = [varScope_39];
22: local letBindScope_41::Scope = mkScopeSeqBind(SeqBinds_38.s, SeqBind_42.varScopes);
23: SeqBind_42.s = SeqBinds_38.s;
24: SeqBinds_43.s = letBindScope_41;
25: SeqBinds_38.varScopes = SeqBinds_43.varScopes;
26: SeqBinds_38.lastScope = SeqBinds_43.lastScope;
27: local varScope_44::Scope = mkScopeVar(("y", Expr_45.ty));
28: Expr_45.s = SeqBind_42.s;
29: SeqBind_42.varScopes = [varScope_44];
30: SeqBind_46.s = SeqBinds_43.s;
31: SeqBinds_43.varScopes = SeqBind_46.varScopes;
32: SeqBinds_43.lastScope = SeqBinds_43.s;
33: local varScope_47::Scope = mkScopeVar(("z", Expr_48.ty));
34: Expr_48.s = SeqBind_46.s;
35: SeqBind_46.varScopes = [varScope_47];
36: Expr_49.s = Expr_35.s;
37: Expr_50.s = Expr_35.s;
38: Expr_51.s = Expr_49.s;
39: Expr_52.s = Expr_49.s;
40: VarRef_53.s = Expr_51.s;
41: local regex_54::Regex = `LEX* VAR`;
42: local dfa_55::DFA = regex_54.dfa;
43: local resFun_56::ResFunTy = resolutionFun(dfa_55);
44: local result_57::[Decorated Scope] = resFun_56(VarRef_53.s, "x");
45: VarRef_53.datum =
	case result_57 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
46: VarRef_58.s = Expr_52.s;
47: local regex_59::Regex = `LEX* VAR`;
48: local dfa_60::DFA = regex_59.dfa;
49: local resFun_61::ResFunTy = resolutionFun(dfa_60);
50: local result_62::[Decorated Scope] = resFun_61(VarRef_58.s, "y");
51: VarRef_58.datum =
	case result_62 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
52: VarRef_63.s = Expr_50.s;
53: local regex_64::Regex = `LEX* VAR`;
54: local dfa_65::DFA = regex_64.dfa;
55: local resFun_66::ResFunTy = resolutionFun(dfa_65);
56: local result_67::[Decorated Scope] = resFun_66(VarRef_63.s, "z");
57: VarRef_63.datum =
	case result_67 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
58: Decls_29.varScopes = [];

```
