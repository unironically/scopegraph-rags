## Silver equations for inputs/forwardvarref.lm

### Input program:
```
def a = b
def b = 1
```

### Equations:
```

local globalScope::Scope = mkScopeGlobal([], []);
Decls_12.s = globalScope;
local lookupScope_13::Scope = mkScopeImpLookup(Decls_12.s, Decl_14.varScopes, Decl_14.modScopes, Decl_14.impScope);
Decl_14.s = Decls_12.s;
Decls_15.s = lookupScope_13;
Decls_12.varScopes = Decl_14.varScopes ++ Decls_15.varScopes;
Decls_12.modScopes = Decl_14.modScopes ++ Decls_15.modScopes;
Decl_14.varScopes = ParBind_16.varScopes;
Decl_14.modScopes = [];
Decl_14.impScope = nothing();
ParBind_16.s = Decl_14.s;
local varScope_17::Scope = mkScopeVar(("a", Expr_18.ty));
Expr_18.s = ParBind_16.s;
ParBind_16.varScopes = [varScope_17];
VarRef_19.s = Expr_18.s;
local regex_20::Regex = `LEX* IMP? VAR`;
local dfa_21::DFA = regex_20.dfa;
local resFun_22::ResFunTy = resolutionFun(dfa_21);
local result_23::[Decorated Scope] = resFun_22(VarRef_19.s, "b");
VarRef_19.declScope = 
	case result_23 of
	| s::_ -> just(s)
	| [] -> nothing()
	end;
local lookupScope_24::Scope = mkScopeImpLookup(Decls_15.s, Decl_25.varScopes, Decl_25.modScopes, Decl_25.impScope);
Decl_25.s = Decls_15.s;
Decls_26.s = lookupScope_24;
Decls_15.varScopes = Decl_25.varScopes ++ Decls_26.varScopes;
Decls_15.modScopes = Decl_25.modScopes ++ Decls_26.modScopes;
Decl_25.varScopes = ParBind_27.varScopes;
Decl_25.modScopes = [];
Decl_25.impScope = nothing();
ParBind_27.s = Decl_25.s;
local varScope_28::Scope = mkScopeVar(("b", Expr_29.ty));
Expr_29.s = ParBind_27.s;
ParBind_27.varScopes = [varScope_28];
Decls_26.varScopes = [];
Decls_26.modScopes = [];

```
