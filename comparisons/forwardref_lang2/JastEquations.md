## Jast equations for inputs/forwardvarref.lm

### Input program:
```
def a = b
def b = 1
```

### Equations:
```

local globalScope::Scope = mkScope();
Decls_30.s = globalScope;
Decls_30.s_mod = globalScope;
Decls_30.s_glob = globalScope;
local lookupScope_31::Scope = mkScopeImpLookup()
lookupScope_31.lexScopes <- [Decls_30.s];
Decl_32.s = lookupScope_31;
Decl_32.s_lookup = Decls_30.s;
Decl_32.s_mod = Decls_30.s_mod;
Decl_32.s_glob = Decls_30.s_glob;
Decls_33.s = lookupScope_31;
Decls_33.s_mod = Decls_30.s_mod;
Decls_33.s_glob = Decls_30.s_glob;
ParBind_34.s = Decl_32.s_lookup;
ParBind_34.s_def = Decl_32.s;
ParBind_34.s_mod = Decl_32.s_mod
ParBind_34.s_glob = Decl_32.s_glob;
local varScope_35::Scope = mkScopeVar(("a", Expr_36.ty));
Expr_36.s = ParBind_34.s;
ParBind_34.s_def.varScopes <- [varScope_35];
VarRef_38.s = Expr_36.s;
Expr_36.ty = case VarRef_38.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_39::Regex = `LEX* VAR`;
local dfa_40::DFA = regex_39.dfa;
local resFun_41::ResFunTy = resolutionFun(dfa_40);
local result_42::[Decorated Scope] = resFun_41(VarRef_38.s, "b");
VarRef_38.datum = 
	case result_42 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
local lookupScope_43::Scope = mkScopeImpLookup()
lookupScope_43.lexScopes <- [Decls_33.s];
Decl_44.s = lookupScope_43;
Decl_44.s_lookup = Decls_33.s;
Decl_44.s_mod = Decls_33.s_mod;
Decl_44.s_glob = Decls_33.s_glob;
Decls_45.s = lookupScope_43;
Decls_45.s_mod = Decls_33.s_mod;
Decls_45.s_glob = Decls_33.s_glob;
ParBind_46.s = Decl_44.s_lookup;
ParBind_46.s_def = Decl_44.s;
ParBind_46.s_mod = Decl_44.s_mod
ParBind_46.s_glob = Decl_44.s_glob;
local varScope_47::Scope = mkScopeVar(("b", Expr_48.ty));
Expr_48.s = ParBind_46.s;
ParBind_46.s_def.varScopes <- [varScope_47];
Expr_48.ty = tInt();

```
