## Jast equations for inputs/letrec.lm

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

local globalScope::Scope = mkScope();
Decls_65.s = globalScope;
Decl_66.s = Decls_65.s;
Decls_67.s = Decls_65.s;
ParBind_68.s = Decl_66.s;
ParBind_68.s_def = Decl_66.s;
local varScope_69::Scope = mkScopeVar(("a", Expr_70.ty));
Expr_70.s = ParBind_68.s;
ParBind_68.s_def.varScopes <- [varScope_69];
local letScope_71::Scope = mkScopeLet();
letScope_71.lexScopes <- [Expr_70.s];
ParBinds_72.s = letScope_71;
ParBinds_72.s_def = letScope_71;
Expr_73.s = letScope_71;
Expr_70.ty = Expr_73.ty;
ParBind_74.s = ParBinds_72.s;
ParBind_74.s_def = ParBinds_72.s_def;
ParBinds_75.s = ParBinds_72.s;
ParBinds_75.s_def = ParBinds_72.s_def;
local varScope_76::Scope = mkScopeVar(("x", Expr_77.ty));
Expr_77.s = ParBind_74.s;
ParBind_74.s_def.varScopes <- [varScope_76];
Expr_77.ty = tInt();
ParBind_78.s = ParBinds_75.s;
ParBind_78.s_def = ParBinds_75.s_def;
ParBinds_79.s = ParBinds_75.s;
ParBinds_79.s_def = ParBinds_75.s_def;
local varScope_80::Scope = mkScopeVar(("y", Expr_81.ty));
Expr_81.s = ParBind_78.s;
ParBind_78.s_def.varScopes <- [varScope_80];
Expr_81.ty = tInt();
ParBind_82.s = ParBinds_79.s;
ParBind_82.s_def = ParBinds_79.s_def;
ParBinds_83.s = ParBinds_79.s;
ParBinds_83.s_def = ParBinds_79.s_def;
local varScope_84::Scope = mkScopeVar(("z", Expr_85.ty));
Expr_85.s = ParBind_82.s;
ParBind_82.s_def.varScopes <- [varScope_84];
Expr_85.ty = tInt();
Expr_86.s = Expr_73.s;
Expr_87.s = Expr_73.s;
Expr_73.ty = if Expr_86.ty == tInt() && Expr_87.ty == tInt() then tInt() else tErr();
Expr_88.s = Expr_86.s;
Expr_89.s = Expr_86.s;
Expr_86.ty = if Expr_88.ty == tInt() && Expr_89.ty == tInt() then tInt() else tErr();
VarRef_90.s = Expr_88.s;
Expr_88.ty = case VarRef_90.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_91::Regex = `LEX* VAR`;
local dfa_92::DFA = regex_91.dfa;
local resFun_93::ResFunTy = resolutionFun(dfa_92);
local result_94::[Decorated Scope] = resFun_93(VarRef_90.s, "x");
VarRef_90.datum = 
	case result_94 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
VarRef_95.s = Expr_89.s;
Expr_89.ty = case VarRef_95.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_96::Regex = `LEX* VAR`;
local dfa_97::DFA = regex_96.dfa;
local resFun_98::ResFunTy = resolutionFun(dfa_97);
local result_99::[Decorated Scope] = resFun_98(VarRef_95.s, "y");
VarRef_95.datum = 
	case result_99 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
VarRef_100.s = Expr_87.s;
Expr_87.ty = case VarRef_100.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_101::Regex = `LEX* VAR`;
local dfa_102::DFA = regex_101.dfa;
local resFun_103::ResFunTy = resolutionFun(dfa_102);
local result_104::[Decorated Scope] = resFun_103(VarRef_100.s, "z");
VarRef_100.datum = 
	case result_104 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;

```
