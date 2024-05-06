# Jast equations vs. Statix constraints for language 1 on inputs/letrec.lm
- Jast equations at: [JastEquations.md](JastEquations.md)
- Statix constraints at: [StatixConstraints.md](StatixConstraints.md)

## Input program:
```
def a = 
  letrec
    x = 1,
    y = 2,
    z = 3
  in 
    x + y + z
```

## Comparison:
#### Equations involving the global scope
###### Interesting equations
```
local globalScope::Scope = mkScope();					-- Constraint 2
local varScope_69::Scope = mkScopeVar(("a", Expr_70.ty));		-- Constraint 4
ParBind_68.s_def.varScopes <- [varScope_69];				-- Constraint 5
letScope_71.lexScopes <- [Expr_70.s];					-- Constraint 8
```
###### Copy equations
```
Decls_65.s = globalScope;
Decl_66.s = Decls_65.s;
ParBind_68.s = Decl_66.s;
Expr_70.s = ParBind_68.s;
ParBind_68.s_def = Decl_66.s;
Decls_67.s = Decls_65.s;

-- Scope copy equation structure, where child relation is node equality:
globalScope
└── Decls_65.s
    ├── Decls_66.s
    │   ├── ParBind_68.s
    │   │   └── Expr_70.s
    │   └── ParBind_68.s_def
    └── Decls_67.s
```

#### Recursive let scope
###### Interesting equations
```
local letScope_71::Scope = mkScopeLet();				-- Constraint 7
letScope_71.lexScopes <- [Expr_70.s]					-- Constraint 8

local varScope_76::Scope = mkScopeVar(("x", Expr_77.ty));		-- Constraint 10
ParBind_74.s_def.varScopes <- [varScope_76];				-- Constraint 11

local varScope_80::Scope = mkScopeVar(("y", Expr_81.ty));		-- Constraint 14
ParBind_78.s_def.varScopes <- [varScope_80];				-- Constraint 15

local varScope_84::Scope = mkScopeVar(("z", Expr_85.ty));		-- Constraint 18
ParBind_82.s_def.varScopes <- [varScope_84];				-- Constraint 19
```
###### Copy equations
```
ParBinds_72.s = letScope_71;
ParBind_74.s = ParBinds_72.s;
Expr_77.s = ParBind_74.s;
ParBinds_75.s = ParBinds_72.s;
ParBind_78.s = ParBinds_75.s;
Expr_81.s = ParBind_78.s;
ParBinds_79.s = ParBinds_75.s;
ParBind_82.s = ParBinds_79.s;
Expr_85.s = ParBind_82.s;
ParBinds_83.s = ParBinds_79.s;
ParBinds_72.s_def = letScope_71;
ParBind_74.s_def = ParBinds_72.s_def;
ParBinds_75.s_def = ParBinds_72.s_def;
ParBind_78.s_def = ParBinds_75.s_def;
ParBinds_79.s_def = ParBinds_75.s_def;
ParBind_82.s_def = ParBinds_79.s_def;
ParBinds_83.s_def = ParBinds_79.s_def;
Expr_73.s = letScope_71;
Expr_86.s = Expr_73.s;
Expr_88.s = Expr_86.s;
VarRef_90.s = Expr_88.s;
Expr_89.s = Expr_86.s;
VarRef_95.s = Expr_89.s;
Expr_87.s = Expr_73.s;
VarRef_100.s = Expr_87.s;

-- Scope copy equation structure, where child relation is node equality:
letScope_71
├── ParBinds_72.s
│   ├── ParBind_74.s
│   │   └── Expr_77.s
│   └── ParBinds_75.s
│       ├── ParBind_78.s
│       │   └── Expr_81.s
│       └── ParBinds_79.s
│           ├── ParBind_82.s
│           │   └── Expr_85.s
│           └── ParBinds_83.s
├── ParBinds_72.s_def
│   ├── ParBind_74.s_def
│   └── ParBinds_75.s_def
│       ├── ParBind_78.s_def
│       └── ParBinds_79.s_def
│           ├── ParBind_82.s_def
│           └── ParBinds_83.s_def
└── Expr_73.s
    ├── Expr_86.s
    │   ├── Expr_88.s
    │   │   └── VarRef_90.s
    │   └── Expr_89.s
    │       └── VarRef_95.s
    └── Expr_87.s
        └── VarRef_100.s
```

###### Queries
```
local regex_91::Regex = `LEX* VAR`;					-- Constraints 23-27
local dfa_92::DFA = regex_91.dfa;
local resFun_93::ResFunTy = resolutionFun(dfa_92);
local result_94::[Decorated Scope] = resFun_93(VarRef_90.s, "x");
VarRef_90.datum = 
	case result_94 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;

local regex_96::Regex = `LEX* VAR`;					-- Constraints 29-33
local dfa_97::DFA = regex_96.dfa;
local resFun_98::ResFunTy = resolutionFun(dfa_97);
local result_99::[Decorated Scope] = resFun_98(VarRef_95.s, "y");
VarRef_95.datum = 
	case result_99 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;

local regex_101::Regex = `LEX* VAR`;					-- Constraints 36-40
local dfa_102::DFA = regex_101.dfa;
local resFun_103::ResFunTy = resolutionFun(dfa_102);
local result_104::[Decorated Scope] = resFun_103(VarRef_100.s, "z");
VarRef_100.datum = 
	case result_104 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
```

### Remaining equations:
```
Expr_70.ty = Expr_73.ty;

Expr_77.ty = tInt();

Expr_81.ty = tInt();

Expr_85.ty = tInt();

Expr_73.ty = if Expr_86.ty == tInt() && Expr_87.ty == tInt() then tInt() else tErr();

Expr_86.ty = if Expr_88.ty == tInt() && Expr_89.ty == tInt() then tInt() else tErr();

Expr_88.ty = case VarRef_90.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;

Expr_89.ty = case VarRef_95.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;

Expr_87.ty = case VarRef_100.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
```

## Correspondence pairs
#### All instances where a scope is created in Jast vs. Statix
##### Global scope
```
-- Jast
local globalScope::Scope = mkScope();

-- Statix
new s_0
```

##### Var node for `a`
```
-- Jast
local varScope_69::Scope = mkScopeVar(("a", Expr_70.ty));

-- Statix
new s_var_1 -> ("a", ty_2)
```

##### Recursive let scope
```
-- Jast
local letScope_71::Scope = mkScopeLet();

-- Statix
new s_let_3
```

##### Var node for `x`
```
-- Jast
local varScope_76::Scope = mkScopeVar(("x", Expr_77.ty));

-- Statix
new s_var_4 -> ("x", ty_5)
```

##### Var node for `y`
```
-- Jast
local varScope_80::Scope = mkScopeVar(("y", Expr_81.ty));	

-- Statix
new s_var_6 -> ("y", ty_7)
```

##### Var node for `z`
```
-- Jast
local varScope_84::Scope = mkScopeVar(("z", Expr_85.ty));

-- Statix
new s_var_8 -> ("z", ty_9)
```




#### All instances of edge assertions in Jast vs. Statix
##### VAR edges
```
-- Jast
ParBind_68.s_def.varScopes <- [varScope_69];

-- Statix
s_0 -[ `VAR ]-> s_var_1
```

```
-- Jast
ParBind_74.s_def.varScopes <- [varScope_76];

-- Statix
s_let_3 -[ `VAR ]-> s_var_4
```

```
-- Jast
ParBind_78.s_def.varScopes <- [varScope_80];

-- Statix
s_let_3 -[ `VAR ]-> s_var_6
```

```
-- Jast
ParBind_78.s_def.varScopes <- [varScope_80];

-- Statix
s_let_3 -[ `VAR ]-> s_var_6
```

```
-- Jast
ParBind_82.s_def.varScopes <- [varScope_84];

-- Statix
s_let_3 -[ `VAR ]-> s_var_8
```


##### LEX edges
```
-- Jast
letScope_71.lexScopes <- [Expr_70.s];

-- Statix
s_let_3 -[ `LEX ]-> s_0
```

---

#### Equations to constraints "translations schemas"

##### Node assertions
###### Without datum
````
local <scope_name>::Scope = mkScope();					-- Jast
≡
new <scope_name>							-- Statix
````
###### With datum
````
local <scope_name>::Scope = mkScopeVar((<id>, <type_ref_jast>));	-- Jast
≡
new <scope_name> -> (<id>, <type_ref_statix>)				-- Statix
````
Where `<type_ref_jast>` is some qualified reference to a `Scope` AST node and `<type_ref_statix>` is a simple reference to some asserted scope.

##### Edge assertions
- LEX edge
```
<src_ref_jast>.lexScopes <- [ <tgt_ref_jast> ];				-- Jast
≡
<src_ref_statix> -[ `LEX ]-> <tgt_ref_statix>				-- Statix
```
- VAR edge
```
<src_ref_jast>.varScopes <- [ <tgt_ref_jast> ];				-- Jast
≡
<src_ref_statix> -[ `VAR ]-> <tgt_ref_statix>				-- Statix
```
Where `<srr/tgt_ref_jast>` is some qualified reference to a `Scope` AST node and `<src/tgt_ref_statix>` is a simple reference to some asserted scope.




## Full list of equations:
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
