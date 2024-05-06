## Silver equations for inputs/forwardvarref.lm

### Input program:
```
def a = b
def b = 1
```

### Equations:
```

local globalScope::Scope = mkScopeGlobal(Decls_10.varScopes);
Decls_10.s = globalScope;
Decl_11.s = Decls_10.s;
Decls_12.s = Decls_10.s;
Decls_10.varScopes = Decl_11.varScopes ++ Decls_12.varScopes;
Decl_11.varScopes = ParBind_13.varScopes;
ParBind_13.s = Decl_11.s;
local varScope_14::Scope = mkScopeVar(("a", Expr_15.ty));
Expr_15.s = ParBind_13.s;
ParBind_13.varScopes = [varScope_14];
VarRef_16.s = Expr_15.s;
local regex_17::Regex = `LEX* VAR`;
local dfa_18::DFA = regex_17.dfa;
local resFun_19::ResFunTy = resolutionFun(dfa_18);
local result_20::[Decorated Scope] = resFun_19(VarRef_16.s, "b");
VarRef_16.datum = 
	case result_20 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
Decl_21.s = Decls_12.s;
Decls_22.s = Decls_12.s;
Decls_12.varScopes = Decl_21.varScopes ++ Decls_22.varScopes;
Decl_21.varScopes = ParBind_23.varScopes;
ParBind_23.s = Decl_21.s;
local varScope_24::Scope = mkScopeVar(("b", Expr_25.ty));
Expr_25.s = ParBind_23.s;
ParBind_23.varScopes = [varScope_24];
Decls_22.varScopes = [];

```
