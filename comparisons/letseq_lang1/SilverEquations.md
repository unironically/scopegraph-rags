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

local globalScope::Scope = mkScopeGlobal(Decls_27.varScopes);
Decls_27.s = globalScope;
Decl_28.s = Decls_27.s;
Decls_29.s = Decls_27.s;
Decls_27.varScopes = Decl_28.varScopes ++ Decls_29.varScopes;
Decl_28.varScopes = ParBind_30.varScopes;
ParBind_30.s = Decl_28.s;
local varScope_31::Scope = mkScopeVar(("a", Expr_32.ty));
Expr_32.s = ParBind_30.s;
ParBind_30.varScopes = [varScope_31];
local letScope_33::Scope = mkScopeLet(SeqBinds_34.lastScope, SeqBinds_34.varScopes);
SeqBinds_34.s = Expr_32.s;
Expr_35.s = letScope_33;
local letBindScope_36::Scope = mkScopeSeqBind(SeqBinds_34.s, SeqBind_37.varScopes);
SeqBind_37.s = SeqBinds_34.s;
SeqBinds_38.s = letBindScope_36;
SeqBinds_34.varScopes = SeqBinds_38.varScopes;
SeqBinds_34.lastScope = SeqBinds_38.lastScope;
local varScope_39::Scope = mkScopeVar(("x", Expr_40.ty));
Expr_40.s = SeqBind_37.s;
SeqBind_37.varScopes = [varScope_39];
local letBindScope_41::Scope = mkScopeSeqBind(SeqBinds_38.s, SeqBind_42.varScopes);
SeqBind_42.s = SeqBinds_38.s;
SeqBinds_43.s = letBindScope_41;
SeqBinds_38.varScopes = SeqBinds_43.varScopes;
SeqBinds_38.lastScope = SeqBinds_43.lastScope;
local varScope_44::Scope = mkScopeVar(("y", Expr_45.ty));
Expr_45.s = SeqBind_42.s;
SeqBind_42.varScopes = [varScope_44];
SeqBind_46.s = SeqBinds_43.s;
SeqBinds_43.varScopes = SeqBind_46.varScopes;
SeqBinds_43.lastScope = SeqBinds_43.s;
local varScope_47::Scope = mkScopeVar(("z", Expr_48.ty));
Expr_48.s = SeqBind_46.s;
SeqBind_46.varScopes = [varScope_47];
Expr_49.s = Expr_35.s;
Expr_50.s = Expr_35.s;
Expr_51.s = Expr_49.s;
Expr_52.s = Expr_49.s;
VarRef_53.s = Expr_51.s;
local regex_54::Regex = `LEX* VAR`;
local dfa_55::DFA = regex_54.dfa;
local resFun_56::ResFunTy = resolutionFun(dfa_55);
local result_57::[Decorated Scope] = resFun_56(VarRef_53.s, "x");
VarRef_53.datum = 
	case result_57 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
VarRef_58.s = Expr_52.s;
local regex_59::Regex = `LEX* VAR`;
local dfa_60::DFA = regex_59.dfa;
local resFun_61::ResFunTy = resolutionFun(dfa_60);
local result_62::[Decorated Scope] = resFun_61(VarRef_58.s, "y");
VarRef_58.datum = 
	case result_62 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
VarRef_63.s = Expr_50.s;
local regex_64::Regex = `LEX* VAR`;
local dfa_65::DFA = regex_64.dfa;
local resFun_66::ResFunTy = resolutionFun(dfa_65);
local result_67::[Decorated Scope] = resFun_66(VarRef_63.s, "z");
VarRef_63.datum = 
	case result_67 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
Decls_29.varScopes = [];

```
