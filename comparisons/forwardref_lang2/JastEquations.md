## Jast equations for inputs/forwardvarref.lm

### Input program:
```
def a = b
def b = 1
```

### Equations:
```

01: local globalScope::Scope = mkScope();
02: Decls_30.s = globalScope;
03: Decls_30.s_mod = globalScope;
04: Decls_30.s_glob = globalScope;
05: local lookupScope_31::Scope = mkScopeImpLookup()
06: lookupScope_31.lexScopes <- [Decls_30.s];
07: Decl_32.s = lookupScope_31;
08: Decl_32.s_lookup = Decls_30.s;
09: Decl_32.s_mod = Decls_30.s_mod;
10: Decl_32.s_glob = Decls_30.s_glob;
11: Decls_33.s = lookupScope_31;
12: Decls_33.s_mod = Decls_30.s_mod;
13: Decls_33.s_glob = Decls_30.s_glob;
14: ParBind_34.s = Decl_32.s_lookup;
15: ParBind_34.s_def = Decl_32.s;
16: ParBind_34.s_mod = Decl_32.s_mod
17: ParBind_34.s_glob = Decl_32.s_glob;
18: local varScope_35::Scope = mkScopeVar(("a", Expr_36.ty));
19: Expr_36.s = ParBind_34.s;
20: ParBind_34.s_def.varScopes <- [varScope_35];
21: VarRef_38.s = Expr_36.s;
22: Expr_36.ty = case VarRef_38.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
23: local regex_39::Regex = `LEX* VAR`;
24: local dfa_40::DFA = regex_39.dfa;
25: local resFun_41::ResFunTy = resolutionFun(dfa_40);
26: local result_42::[Decorated Scope] = resFun_41(VarRef_38.s, "b");
27: VarRef_38.datum = 
	case result_42 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
28: local lookupScope_43::Scope = mkScopeImpLookup()
29: lookupScope_43.lexScopes <- [Decls_33.s];
30: Decl_44.s = lookupScope_43;
31: Decl_44.s_lookup = Decls_33.s;
32: Decl_44.s_mod = Decls_33.s_mod;
33: Decl_44.s_glob = Decls_33.s_glob;
34: Decls_45.s = lookupScope_43;
35: Decls_45.s_mod = Decls_33.s_mod;
36: Decls_45.s_glob = Decls_33.s_glob;
37: ParBind_46.s = Decl_44.s_lookup;
38: ParBind_46.s_def = Decl_44.s;
39: ParBind_46.s_mod = Decl_44.s_mod
40: ParBind_46.s_glob = Decl_44.s_glob;
41: local varScope_47::Scope = mkScopeVar(("b", Expr_48.ty));
42: Expr_48.s = ParBind_46.s;
43: ParBind_46.s_def.varScopes <- [varScope_47];
44: Expr_48.ty = tInt();

```
