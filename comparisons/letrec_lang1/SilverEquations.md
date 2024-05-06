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

local globalScope::Scope = mkScopeGlobal(Decls_25.varScopes);
Decls_25.s = globalScope;
Decl_26.s = Decls_25.s;
Decls_27.s = Decls_25.s;
Decls_25.varScopes = Decl_26.varScopes ++ Decls_27.varScopes;
Decl_26.varScopes = ParBind_28.varScopes;
ParBind_28.s = Decl_26.s;
local varScope_29::Scope = mkScopeVar(("a", Expr_30.ty));
Expr_30.s = ParBind_28.s;
ParBind_28.varScopes = [varScope_29];
local letScope_31::Scope = mkScopeLet(Expr_30.s, ParBinds_32.varScopes);
ParBinds_32.s = letScope_31;
Expr_33.s = letScope_31;
ParBind_34.s = ParBinds_32.s;
ParBinds_35.s = ParBinds_32.s;
local varScope_36::Scope = mkScopeVar(("x", Expr_37.ty));
Expr_37.s = ParBind_34.s;
ParBind_34.varScopes = [varScope_36];
ParBind_38.s = ParBind_34.s;
ParBinds_39.s = ParBind_34.s;
local varScope_40::Scope = mkScopeVar(("y", Expr_41.ty));
Expr_41.s = ParBind_38.s;
ParBind_38.varScopes = [varScope_40];
ParBind_42.s = ParBind_38.s;
ParBinds_43.s = ParBind_38.s;
local varScope_44::Scope = mkScopeVar(("z", Expr_45.ty));
Expr_45.s = ParBind_42.s;
ParBind_42.varScopes = [varScope_44];
ParBind_42.varScopes = [];
Expr_46.s = Expr_33.s;
Expr_47.s = Expr_33.s;
Expr_48.s = Expr_46.s;
Expr_49.s = Expr_46.s;
VarRef_50.s = Expr_48.s;
local regex_51::Regex = `LEX* VAR`;
local dfa_52::DFA = regex_51.dfa;
local resFun_53::ResFunTy = resolutionFun(dfa_52);
local result_54::[Decorated Scope] = resFun_53(VarRef_50.s, "x");
VarRef_50.datum = 
	case result_54 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
VarRef_55.s = Expr_49.s;
local regex_56::Regex = `LEX* VAR`;
local dfa_57::DFA = regex_56.dfa;
local resFun_58::ResFunTy = resolutionFun(dfa_57);
local result_59::[Decorated Scope] = resFun_58(VarRef_55.s, "y");
VarRef_55.datum = 
	case result_59 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
VarRef_60.s = Expr_47.s;
local regex_61::Regex = `LEX* VAR`;
local dfa_62::DFA = regex_61.dfa;
local resFun_63::ResFunTy = resolutionFun(dfa_62);
local result_64::[Decorated Scope] = resFun_63(VarRef_60.s, "z");
VarRef_60.datum = 
	case result_64 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
Decls_27.varScopes = [];

```
