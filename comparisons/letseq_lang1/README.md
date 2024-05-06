# Jast equations vs. Statix constraints for language 1 on inputs/letseq.lm

## Input program:
```
def a = 
  let
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
local varScope_72::Scope = mkScopeVar(("a", Expr_73.ty));		-- Constraint 4
ParBind_71.s_def.varScopes <- [varScope_72];				-- Constraint 5
letBindScope_77.lexScopes <- [SeqBinds_75.s];				-- Constraint 10

```

###### Copy equations
```
Decls_68.s = globalScope;
Decl_69.s = Decls_68.s;
ParBind_71.s = Decl_69.s;
ParBind_71.s_def = Decl_69.s;
Expr_73.s = ParBind_71.s;
SeqBinds_75.s = Expr_73.s;
SeqBind_78.s = SeqBinds_75.s;
Decls_70.s = Decls_68.s;

-- Scope copy equation structure, where child relation is node equality:
globalScope
└── Decls_68.s
    ├── Decl_69.s
    │   ├── ParBind_71.s
    │   │   └── Expr_73.s
    │   │       └── SeqBinds_75.s
    │   │           └── SeqBind_78.s
    │   └── ParBind_71.s_def
    └── Decls_70.s
```

#### Equations involving the last let scope (defined in exprLet and passed down to the bind list)
###### Interesting equations
```
local letScope_74::Scope = mkScopeLet();				-- Constraint 7
SeqBinds_84.s_def.lexScopes <- [SeqBinds_84.s];				-- Constraint 22
local varScope_88::Scope = mkScopeVar(("z", Expr_89.ty));		-- Constraint 24
SeqBind_87.s_def.varScopes <- [varScope_88];				-- Constraint 25
```

###### Copy equations
```
SeqBinds_75.s_def = letScope_74;
SeqBinds_79.s_def = SeqBinds_75.s_def;
SeqBinds_84.s_def = SeqBinds_79.s_def;
SeqBind_87.s_def = SeqBinds_84.s_def
Expr_76.s = letScope_74;
Expr_90.s = Expr_76.s;
Expr_91.s = Expr_76.s;
Expr_92.s = Expr_90.s;
Expr_93.s = Expr_90.s;
VarRef_94.s = Expr_92.s;
VarRef_99.s = Expr_93.s;
VarRef_104.s = Expr_91.s;

-- Scope copy equation structure, where child relation is node equality:
letScope_74
├── SeqBinds_75.s_def
│   └── SeqBinds_79.s_def
│       └── SeqBinds_84.s_def
│           └── SeqBind_87.s_def
└── Expr_76.s
    ├── Expr_90.s
    │   ├── Expr_92.s
    │   │   ├── VarRef_94.s
    │   │   └── VarRef_99.s
    │   └── Expr_93.s
    └── Expr_91.s
        └── VarRef_104.s
```

Query equations
```
local regex_95::Regex = `LEX* VAR`;					--Constraints 28-32
local dfa_96::DFA = regex_95.dfa;
local resFun_97::ResFunTy = resolutionFun(dfa_96);
local result_98::[Decorated Scope] = resFun_97(VarRef_94.s, "x");	
VarRef_94.datum = 
	case result_98 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;

local regex_100::Regex = `LEX* VAR`;					-- Constraint 34-38
local dfa_101::DFA = regex_100.dfa;
local resFun_102::ResFunTy = resolutionFun(dfa_101);
local result_103::[Decorated Scope] = resFun_102(VarRef_99.s, "y");
VarRef_99.datum = 
	case result_103 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;

local regex_105::Regex = `LEX* VAR`;					-- Constraints 41-45
local dfa_106::DFA = regex_105.dfa;
local resFun_107::ResFunTy = resolutionFun(dfa_106);
local result_108::[Decorated Scope] = resFun_107(VarRef_104.s, "z");
VarRef_104.datum = 
	case result_108 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
```

#### Equations involving the first let scope
###### Interesting equations
```
local letBindScope_77::Scope = mkScopeSeqBind();			-- Constraint 9
letBindScope_77.lexScopes <- [SeqBinds_75.s];				-- Constraint 10
local varScope_80::Scope = mkScopeVar(("x", Expr_81.ty));		-- Constraint 12
SeqBind_78.s_def.varScopes <- [varScope_80];				-- Constraint 13
```

###### Copy equations
```
SeqBind_78.s_def = letBindScope_77;
SeqBinds_79.s = letBindScope_77;
SeqBind_83.s = SeqBinds_79.s;
Expr_86.s = SeqBind_83.s;

-- Scope copy equation structure, where child relation is node equality:
letBindScope_77
├── SeqBind_78.s_def
└── SeqBinds_79.s
    └── SeqBind_83.s
        └── Expr_86.s
```


#### Equations involving the second let scope
###### Interesting equations
```
local letBindScope_82::Scope = mkScopeSeqBind();			-- Constraint 16
letBindScope_82.lexScopes <- [SeqBinds_79.s];				-- Constraint 17
local varScope_85::Scope = mkScopeVar(("y", Expr_86.ty));		-- Constraint 19
SeqBind_83.s_def.varScopes <- [varScope_85];				-- Constraint 20
SeqBinds_84.s_def.lexScopes <- [SeqBinds_84.s];				-- Constraint 22
```

###### Copy equations
```
SeqBind_83.s_def = letBindScope_82;
SeqBinds_84.s = letBindScope_82;
SeqBind_87.s = SeqBinds_84.s;
Expr_89.s = SeqBind_87.s;

-- Scope copy equation structure, where child relation is node equality:
letBindScope_82/
├── SeqBind_83.s_def
└── SeqBinds_84.s/
    └── SeqBind_87.s/
        └── Expr_89.s

```

#### Remaining equations
```
Expr_73.ty = Expr_76.ty;

Expr_81.s = SeqBind_78.s;
Expr_81.ty = tInt();

Expr_86.ty = tInt();

Expr_89.ty = tInt();

Expr_76.ty = if Expr_90.ty == tInt() && Expr_91.ty == tInt() then tInt() else tErr();

Expr_90.ty = if Expr_92.ty == tInt() && Expr_93.ty == tInt() then tInt() else tErr();

Expr_92.ty = case VarRef_94.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;

Expr_93.ty = case VarRef_99.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;

Expr_91.ty = case VarRef_104.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;

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
local varScope_72::Scope = mkScopeVar(("a", Expr_73.ty));

-- Statix
new s_var_1 -> ("a", ty_2)
```

##### Last let scope
```
-- Jast
local letScope_74::Scope = mkScopeLet();

-- Statix
new s_let_3
```
##### Var node for `z`
```
-- Jast
local varScope_88::Scope = mkScopeVar(("z", Expr_89.ty));

-- Statix
new s_var_10 -> ("z", ty_11)
```
##### First let bind scope
```
-- Jast
local letBindScope_77::Scope = mkScopeSeqBind();

-- Statix
new s_def_4
```
##### Var node for `x`
```
-- Jast
local varScope_80::Scope = mkScopeVar(("x", Expr_81.ty));

-- Statix
new s_var_5 -> ("x", ty_6)
```
##### Second let bind scope
```
-- Jast
local letBindScope_82::Scope = mkScopeSeqBind();

-- Statix
new s_def_7
```
##### Var node for `y`
```
-- Jast
local varScope_85::Scope = mkScopeVar(("y", Expr_86.ty));

-- Statix
new s_var_8 -> ("y", ty_9)
```

#### All instances of edge assertions in Jast vs. Statix
##### VAR edges
```
-- Jast
ParBind_71.s_def.varScopes <- [varScope_72];

-- Statix
s_0 -[ `VAR ]-> s_var_1
```

```
-- Jast
SeqBind_87.s_def.varScopes <- [varScope_88];

-- Statix
s_let_3 -[ `VAR ]-> s_var_10
```

```
-- Jast
SeqBind_78.s_def.varScopes <- [varScope_80];

-- Statix
s_def_4 -[ `VAR ]-> s_var_5
```

```
-- Jast
SeqBind_83.s_def.varScopes <- [varScope_85];

-- Statix
s_def_7 -[ `VAR ]-> s_var_8
```

##### LEX edges
```
-- Jast
letBindScope_77.lexScopes <- [SeqBinds_75.s];

-- Statix
s_def_4 -[ `LEX ]-> s_0
```

```
-- Jast
SeqBinds_84.s_def.lexScopes <- [SeqBinds_84.s];

-- Statix
s_let_3 -[ `LEX ]-> s_def_7
```

```
-- Jast
letBindScope_77.lexScopes <- [SeqBinds_75.s];

-- Statix
s_def_4 -[ `LEX ]-> s_0
```

```
-- Jast
letBindScope_82.lexScopes <- [SeqBinds_79.s];

-- Statix
s_def_7 -[ `LEX ]-> s_def_4
```

```
-- Jast
SeqBinds_84.s_def.lexScopes <- [SeqBinds_84.s];

-- Statix
s_let_3 -[ `LEX ]-> s_def_7
```

---

#### Equations to constraints "translations schemas"

##### Node assertions
###### Without datum
````
local <scope_name>::Scope = mkScope();			    	        -- Jast
≡
new <scope_name>						        -- Statix
````
###### With datum
````
local <scope_name>::Scope = mkScopeVar((<id>, <type_ref_jast>));	-- Jast
≡
new <scope_name> -> (<id>, <type_ref_statix>)		        	-- Statix
````
Where `<type_ref_jast>` is some qualified reference to a `Scope` AST node and `<type_ref_statix>` is a simple reference to some asserted scope.

##### Edge assertions
- LEX edge
```
<src_ref_jast>.lexScopes <- [ <tgt_ref_jast> ];			        -- Jast
≡
<src_ref_statix> -[ `LEX ]-> <tgt_ref_statix>			        -- Statix
```
- VAR edge
```
<src_ref_jast>.varScopes <- [ <tgt_ref_jast> ];			        -- Jast
≡
<src_ref_statix> -[ `VAR ]-> <tgt_ref_statix>			        -- Statix
```
Where `<srr/tgt_ref_jast>` is some qualified reference to a `Scope` AST node and `<src/tgt_ref_statix>` is a simple reference to some asserted scope.


## Full list of equations:
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
SeqBinds_84.s_def.varScopes <- [SeqBind_87.varScopes];
local varScope_88::Scope = mkScopeVar(("z", Expr_89.ty));
Expr_89.s = SeqBind_87.s;
SeqBind_87.s_def.varScopes <- [varScope_88];
Expr_89.ty = tInt();
Expr_90.s = Expr_76.s;
Expr_90.s = Expr_76.s;
Expr_76.ty = if Expr_90.ty == tInt() && Expr_91.ty == tInt() then tInt() else tErr();
Expr_92.s = Expr_90.s;
Expr_92.s = Expr_90.s;
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


```
https://tree.nathanfriend.io/?s=(%27options!(%27fancyC~fullPath!false~trailingSlashC~rootDotC)~G(%27G%27globalScopeAFs_68-F_692-**Expr_73-4s_75-*4_782.s_defA*Fs_70.s%27)~version!%271%27)*%20%20-.sA*2-*ParH_714***SeqHA%5Cn*C!trueFDeclGsource!HBind%01HGFCA42-*
```