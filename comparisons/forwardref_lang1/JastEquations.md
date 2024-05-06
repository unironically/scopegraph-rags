## Jast equations for inputs/forwardvarref.lm

### Input program:
```
def a = b
def b = 1
```

### Equations:
```

01: local globalScope::Scope = mkScope();
02: Decls_26.s = globalScope;
03: Decl_27.s = Decls_26.s;
04: Decls_28.s = Decls_26.s;
05: ParBind_29.s = Decl_27.s;
06: ParBind_29.s_def = Decl_27.s;
07: local varScope_30::Scope = mkScopeVar(("a", Expr_31.ty));
08: Expr_31.s = ParBind_29.s;
09: ParBind_29.s_def.varScopes <- [varScope_30];
10: VarRef_32.s = Expr_31.s;
11: Expr_31.ty = case VarRef_32.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
12: local regex_33::Regex = `LEX* VAR`;
13: local dfa_34::DFA = regex_33.dfa;
14: local resFun_35::ResFunTy = resolutionFun(dfa_34);
15: local result_36::[Decorated Scope] = resFun_35(VarRef_32.s, "b");
16: VarRef_32.datum =
	case result_36 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
17: Decl_37.s = Decls_28.s;
18: Decls_38.s = Decls_28.s;
19: ParBind_39.s = Decl_37.s;
20: ParBind_39.s_def = Decl_37.s;
21: local varScope_40::Scope = mkScopeVar(("b", Expr_41.ty));
22: Expr_41.s = ParBind_39.s;
23: ParBind_39.s_def.varScopes <- [varScope_40];
24: Expr_41.ty = tInt();

```
