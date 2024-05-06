## Jast equations for inputs/forwardvarref.lm

### Input program:
```
def a = b
def b = 1
```

### Equations:
```

local globalScope::Scope = mkScope();
Decls_26.s = globalScope;
Decl_27.s = Decls_26.s;
Decls_28.s = Decls_26.s;
ParBind_29.s = Decl_27.s;
ParBind_29.s_def = Decl_27.s;
local varScope_30::Scope = mkScopeVar(("a", Expr_31.ty));
Expr_31.s = ParBind_29.s;
ParBind_29.s_def.varScopes <- [varScope_30];
VarRef_32.s = Expr_31.s;
Expr_31.ty = case VarRef_32.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_33::Regex = `LEX* VAR`;
local dfa_34::DFA = regex_33.dfa;
local resFun_35::ResFunTy = resolutionFun(dfa_34);
local result_36::[Decorated Scope] = resFun_35(VarRef_32.s, "b");
VarRef_32.datum = 
	case result_36 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
Decl_37.s = Decls_28.s;
Decls_38.s = Decls_28.s;
ParBind_39.s = Decl_37.s;
ParBind_39.s_def = Decl_37.s;
local varScope_40::Scope = mkScopeVar(("b", Expr_41.ty));
Expr_41.s = ParBind_39.s;
ParBind_39.s_def.varScopes <- [varScope_40];
Expr_41.ty = tInt();

```
