## Jast equations for inputs/letseq.lm

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

local globalScope::Scope = mkScope();
Decls_68.s = globalScope;
Decl_69.s = Decls_68.s;
Decls_70.s = Decls_68.s;
ParBind_71.s = Decl_69.s;
ParBind_71.s_def = Decl_69.s;
local varScope_72::Scope = mkScopeVar(("a", Expr_73.ty));
Expr_73.s = ParBind_71.s;
ParBind_71.s_def.varScopes <- [varScope_72];
local letScope_74::Scope = mkScopeLet();
SeqBinds_75.s = Expr_73.s;
SeqBinds_75.s_def = letScope_74;
Expr_76.s = letScope_74;
Expr_73.ty = Expr_76.ty;
local letBindScope_77::Scope = mkScopeSeqBind();
letBindScope_77.lexScopes <- [SeqBinds_75.s];
SeqBind_78.s = SeqBinds_75.s;
SeqBind_78.s_def = letBindScope_77;
SeqBinds_79.s = letBindScope_77;
SeqBinds_79.s_def = SeqBinds_75.s_def;
local varScope_80::Scope = mkScopeVar(("x", Expr_81.ty));
Expr_81.s = SeqBind_78.s;
SeqBind_78.s_def.varScopes <- [varScope_80];
Expr_81.ty = tInt();
local letBindScope_82::Scope = mkScopeSeqBind();
letBindScope_82.lexScopes <- [SeqBinds_79.s];
SeqBind_83.s = SeqBinds_79.s;
SeqBind_83.s_def = letBindScope_82;
SeqBinds_84.s = letBindScope_82;
SeqBinds_84.s_def = SeqBinds_79.s_def;
local varScope_85::Scope = mkScopeVar(("y", Expr_86.ty));
Expr_86.s = SeqBind_83.s;
SeqBind_83.s_def.varScopes <- [varScope_85];
Expr_86.ty = tInt();
SeqBind_87.s = SeqBinds_84.s;
SeqBind_87.s_def = SeqBinds_84.s_def
SeqBinds_84.s_def.lexScopes <- [SeqBinds_84.s];
local varScope_88::Scope = mkScopeVar(("z", Expr_89.ty));
Expr_89.s = SeqBind_87.s;
SeqBind_87.s_def.varScopes <- [varScope_88];
Expr_89.ty = tInt();
Expr_90.s = Expr_76.s;
Expr_91.s = Expr_76.s;
Expr_76.ty = if Expr_90.ty == tInt() && Expr_91.ty == tInt() then tInt() else tErr();
Expr_92.s = Expr_90.s;
Expr_93.s = Expr_90.s;
Expr_90.ty = if Expr_92.ty == tInt() && Expr_93.ty == tInt() then tInt() else tErr();
VarRef_94.s = Expr_92.s;
Expr_92.ty = case VarRef_94.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_95::Regex = `LEX* VAR`;
local dfa_96::DFA = regex_95.dfa;
local resFun_97::ResFunTy = resolutionFun(dfa_96);
local result_98::[Decorated Scope] = resFun_97(VarRef_94.s, "x");
VarRef_94.datum = 
	case result_98 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
VarRef_99.s = Expr_93.s;
Expr_93.ty = case VarRef_99.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_100::Regex = `LEX* VAR`;
local dfa_101::DFA = regex_100.dfa;
local resFun_102::ResFunTy = resolutionFun(dfa_101);
local result_103::[Decorated Scope] = resFun_102(VarRef_99.s, "y");
VarRef_99.datum = 
	case result_103 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
VarRef_104.s = Expr_91.s;
Expr_91.ty = case VarRef_104.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_105::Regex = `LEX* VAR`;
local dfa_106::DFA = regex_105.dfa;
local resFun_107::ResFunTy = resolutionFun(dfa_106);
local result_108::[Decorated Scope] = resFun_107(VarRef_104.s, "z");
VarRef_104.datum = 
	case result_108 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;

```
