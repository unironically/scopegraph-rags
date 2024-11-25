# Jast equations for inputs/modulessimple.lm

## Input program:
```
module A {
  def a = 1
}

module B {
  import A
  def b = a
}
```

## Comparison:
### Equations involving the global scope
###### Interesting equations
```
local globalScope::Scope = mkScope();-- Constraint 2
lookupScope_60.lexScopes <- [Decls_59.s];-- Constraint 5
```
###### Copy equations
```
Decls_59.s = globalScope;
Decls_59.s_mod = globalScope;
Decls_59.s_glob = globalScope;
Decl_61.s_mod = Decls_59.s_mod;
Decls_62.s_mod = Decls_59.s_mod;
Decl_61.s_glob = Decls_59.s_glob;
Decls_62.s_glob = Decls_59.s_glob;
Decl_74.s_mod = Decls_62.s_mod;
Decls_75.s_mod = Decls_62.s_mod;
Decls_64.s_glob = Decl_61.s_glob;
Decl_74.s_glob = Decls_62.s_glob;
Decls_75.s_glob = Decls_62.s_glob;
Decl_66.s_glob = Decls_64.s_glob;
Decls_67.s_glob = Decls_64.s_glob;
Decls_77.s_glob = Decl_74.s_glob;
ParBind_68.s_glob = Decl_66.s_glob;
Decl_79.s_glob = Decls_77.s_glob;
Decls_80.s_glob = Decls_77.s_glob;
Decl_88.s_glob = Decls_80.s_glob;
Decls_89.s_glob = Decls_80.s_glob;
ParBind_90.s_glob = Decl_88.s_glob;
Decl_61.s_lookup = Decls_59.s;

-- Scope copy equation structure, where child relation is node equality:
globalScope
├── Decls_59.s
│   └── Decl_61.s_lookup
├── Decls_59.s_mod
│   ├── Decl_61.s_mod
│   └── Decls_62.s_mod
│       ├── Decl_74.s_mod
│       └── Decls_75.s_mod
└── Decls_59.s_glob
    ├── Decl_61.s_glob
    │   └── Decls_64.s_glob
    │       ├── Decl_66.s_glob
    │       │   └── ParBind_68.s_glob
    │       └── Decls_67.s_glob
    └── Decls_62.s_glob
        ├── Decl_74.s_glob
        │   └── Decls_77.s_glob
        │       ├── Decl_79.s_glob
        │       └── Decls_80.s_glob
        │           ├── Decl_88.s_glob
        │           │   └── ParBind_90.s_glob
        │           └── Decls_89.s_glob
        └── Decls_75.s_glob
```


### Equations involving the first lookup scope
###### Interesting equations
```
local lookupScope_60::Scope = mkScopeImpLookup();-- Constraint 4
Decl_61.s.modScopes <- [s_mod_63];-- Constraint 8
s_mod_63.lexScopes <- [Decl_61.s];-- Constraint 9
lookupScope_73.lexScopes <- [Decls_62.s];-- Constraint 12
lookupScope_65.lexScopes <- [Decls_64.s];-- Constraint 21
```
###### Copy equations
```
Decl_61.s = lookupScope_60;
Decls_62.s = lookupScope_60;
Decls_64.s = Decl_61.s;
Decl_74.s_lookup = Decls_62.s;
Decl_66.s_lookup = Decls_64.s;
ParBind_68.s = Decl_66.s_lookup;
Expr_70.s = ParBind_68.s;

-- Scope copy equation structure, where child relation is node equality:
lookupScope_60
├── Decl_61.s
│   └── Decls_64.s
│       └── Decl_66.s_lookup
│           └── ParBind_68.s
│               └── Expr_70.s
└── Decls_62.s
    └── Decl_74.s_lookup
```


### Equations involving the module scope for `A`
###### Interesting equations
```
local s_mod_63::Scope = mkScopeMod(("A", s_mod_63));-- Constraint 7
Decl_61.s.modScopes <- [s_mod_63];-- Constraint 8
s_mod_63.lexScopes <- [Decl_61.s];-- Constraint 9
local varScope_69::Scope = mkScopeVar(("a", Expr_70.ty));-- Constraint 14
ParBind_68.s_mod.varScopes <- [varScope_69];-- Constraint 16
```
###### Copy equations
```
Decls_64.s_mod = s_mod_63;
Decl_66.s_mod = Decls_64.s_mod;
Decls_67.s_mod = Decls_64.s_mod;
ParBind_68.s_mod = Decl_66.s_mod

-- Scope copy equation structure, where child relation is node equality:
s_mod_63
└── Decls_64.s_mod
    ├── Decl_66.s_mod
    │   └── ParBind_68.s_mod
    └── Decls_67.s_mod
```


### Equations involving the second lookup scope
###### Interesting equations
```
local lookupScope_65::Scope = mkScopeImpLookup();-- Constraint 11
lookupScope_65.lexScopes <- [Decls_64.s];-- Constraint 12
local varScope_69::Scope = mkScopeVar(("a", Expr_70.ty));-- Constraint 14
ParBind_68.s_def.varScopes <- [varScope_69];-- Constraint 15
```
###### Copy equations
```
Decl_66.s = lookupScope_65;
Decls_67.s = lookupScope_65;
ParBind_68.s_def = Decl_66.s;

-- Scope copy equation structure, where child relation is node equality:
lookupScope_65
├── Decl_66.s
│   └── ParBind_68.s_def
└── Decls_67.s
```


### Equations involving the third lookup scope
###### Interesting equations
```
local lookupScope_73::Scope = mkScopeImpLookup();-- Constraint 20
s_mod_76.lexScopes <- [Decl_74.s];-- Constraint 21
Decl_74.s.modScopes <- [s_mod_76];-- Constraint 24
lookupScope_78.lexScopes <- [Decls_77.s];-- Constraint 28

```
###### Copy equations
```
Decl_74.s = lookupScope_73;
Decls_75.s = lookupScope_73;
Decls_77.s = Decl_74.s;
Decl_79.s_lookup = Decls_77.s;

-- Scope copy equation structure, where child relation is node equality:
lookupScope_73
├── Decl_74.s
│   └── Decls_77.s
│       └── Decl_79.s_lookup
└── Decls_75.s
```


### Equations involving the module scope for `B`
###### Interesting equations
```
local s_mod_76::Scope = mkScopeMod(("B", s_mod_76));-- Constraint 23
Decl_74.s.modScopes <- [s_mod_76];-- Constraint 24
s_mod_76.lexScopes <- [Decl_74.s];-- Constraint 25
local varScope_91::Scope = mkScopeVar(("b", Expr_92.ty));-- Constraint 41
ParBind_90.s_mod.varScopes <- [varScope_91];-- Constraint 43
```
###### Copy equations
```
Decls_77.s_mod = s_mod_76;
Decl_79.s_mod = Decls_77.s_mod;
Decls_80.s_mod = Decls_77.s_mod;
Decl_88.s_mod = Decls_80.s_mod;
Decls_89.s_mod = Decls_80.s_mod;
ParBind_90.s_mod = Decl_88.s_mod

-- Scope copy equation structure, where child relation is node equality:
s_mod_76
└── Decls_77.s_mod
    ├── Decl_79.s_mod
    └── Decls_80.s_mod
        ├── Decl_88.s_mod
        │   └── ParBind_90.s_mod
        └── Decls_89.s_mod
```


### Equations involving the fourth lookup scope
###### Interesting equations
```
local lookupScope_78::Scope = mkScopeImpLookup();-- Constraint 27
lookupScope_87.lexScopes <- [Decls_80.s];-- Constraint 39
local datum_81::[Decorated Scope] = case ModRef_82.datum of | datumMod((_, s)) -> [s] | _ -> [] end;-- Constraint 35
Decl_79.s.impScopes <- datum_81;-- Constraint 36
```
###### Copy equations
```
Decl_79.s = lookupScope_78;
Decls_80.s = lookupScope_78;
ModRef_82.s = Decl_79.s;
Decl_88.s_lookup = Decls_80.s;
ParBind_90.s = Decl_88.s_lookup;
Expr_92.s = ParBind_90.s;
VarRef_94.s = Expr_92.s;

-- Scope copy equation structure, where child relation is node equality:
lookupScope_78
├── Decl_79.s
│   └── ModRef_82.s
└── Decls_80.s
    └── Decl_88.s_lookup
        └── ParBind_90.s
            └── Expr_92.s
                └── VarRef_94.s
```

###### Query equations
```
local regex_83::Regex = `LEX* IMP? MOD`;-- Constraints 31-35
local dfa_84::DFA = regex_83.dfa;
local resFun_85::ResFunTy = resolutionFun(dfa_84);
local result_86::[Decorated Scope] = resFun_85(ModRef_82.s, "A");
ModRef_82.datum = 
	case result_86 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;

local regex_95::Regex = `LEX* IMP? VAR`;-- Constraints 45-49
local dfa_96::DFA = regex_95.dfa;
local resFun_97::ResFunTy = resolutionFun(dfa_96);
local result_98::[Decorated Scope] = resFun_97(VarRef_94.s, "a");
VarRef_94.datum = 
	case result_98 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
```


### Equations involving the fifth lookup scope
###### Interesting equations
```
local lookupScope_87::Scope = mkScopeImpLookup();-- Constraint 38
lookupScope_87.lexScopes <- [Decls_80.s];-- Constraint 39
local varScope_91::Scope = mkScopeVar(("b", Expr_92.ty));-- Constraint 41
ParBind_90.s_def.varScopes <- [varScope_91];-- Constraint 42
```
###### Copy equations
```
Decl_88.s = lookupScope_87;
Decls_89.s = lookupScope_87;
ParBind_90.s_def = Decl_88.s;

-- Scope copy equation structure, where child relation is node equality:
lookupScope_87
├── Decl_88.s
│   └── ParBind_90.s_def
└── Decls_89.s
```


## Remaining equations:
```
Expr_70.ty = tInt();

Expr_92.ty = case VarRef_94.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
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
##### First lookup scope
```
-- Jast
local lookupScope_60::Scope = mkScopeImpLookup();

-- Statix
new s_1
```
##### Module scope for `A`
```
-- Jast
local s_mod_63::Scope = mkScopeMod(("A", s_mod_63));

-- Statix
new s_mod_2 -> ("A", s_mod_2)
```
##### Second lookup scope
```
-- Jast
local lookupScope_65::Scope = mkScopeImpLookup();

-- Statix
new s_3
```
##### Third lookup scope
```
-- Jast
local lookupScope_73::Scope = mkScopeImpLookup();

-- Statix
new s_6
```
##### Module scope for `B`
```
-- Jast
local s_mod_76::Scope = mkScopeMod(("B", s_mod_76));

-- Statix
new s_mod_7 -> ("B", s_mod_7)
```
##### Fourth lookup scope
```
-- Jast
local lookupScope_78::Scope = mkScopeImpLookup();

-- Statix
new s_8
```
##### Fifth lookup scope
```
-- Jast
local lookupScope_87::Scope = mkScopeImpLookup();

-- Statix
new s_15
```

#### All instances of edge assertions in Jast vs. Statix
##### VAR edges
###### VAR edge for `a`
```
-- Jast
ParBind_68.s_def.varScopes <- [varScope_69];
ParBind_68.s_mod.varScopes <- [varScope_69];

-- Statix
s_3 -[ `VAR ]-> s_var_4
s_mod_2 -[ `VAR ]-> s_var_4
```
###### VAR edge for `b`
```
-- Jast
ParBind_90.s_def.varScopes <- [varScope_91];
ParBind_90.s_mod.varScopes <- [varScope_91];

-- Statix
s_15 -[ `VAR ]-> s_var_16
s_mod_7 -[ `VAR ]-> s_var_16
```
##### LEX edges
###### First lookup scope to global scope
```
-- Jast
lookupScope_60.lexScopes <- [Decls_59.s];

-- Statix
s_1 -[ `LEX ]-> s_0
```
###### Module scope for `A` to first lookup scope
```
-- Jast
s_mod_63.lexScopes <- [Decl_61.s];

-- Statix
s_mod_2 -[ `LEX ]-> s_1
```
###### Second lookup scope to first lookup scope
```
-- Jast
lookupScope_65.lexScopes <- [Decls_64.s];

-- Statix
s_3 -[ `LEX ]-> s_1
```
###### Third lookup scope to first lookup scope
```
-- Jast
lookupScope_73.lexScopes <- [Decls_62.s];

-- Statix
s_6 -[ `LEX ]-> s_1
```
###### Module scope for `A` to third lookup scope
```
-- Jast
s_mod_76.lexScopes <- [Decl_74.s];

-- Statix
s_mod_7 -[ `LEX ]-> s_6
```
###### Fourth lookup scope to third lookup scope
```
-- Jast
lookupScope_78.lexScopes <- [Decls_77.s];

-- Statix
s_8 -[ `LEX ]-> s_6
```
###### Fifth lookup scope to fourth lookup scope
```
-- Jast
lookupScope_87.lexScopes <- [Decls_80.s];

-- Statix
s_15 -[ `LEX ]-> s_8
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
Decls_59.s = globalScope;
Decls_59.s_mod = globalScope;
Decls_59.s_glob = globalScope;
local lookupScope_60::Scope = mkScopeImpLookup()
lookupScope_60.lexScopes <- [Decls_59.s];
Decl_61.s = lookupScope_60;
Decl_61.s_lookup = Decls_59.s;
Decl_61.s_mod = Decls_59.s_mod;
Decl_61.s_glob = Decls_59.s_glob;
Decls_62.s = lookupScope_60;
Decls_62.s_mod = Decls_59.s_mod;
Decls_62.s_glob = Decls_59.s_glob;
local s_mod_63::Scope = mkScopeMod(("A", s_mod_63));
Decl_61.s.modScopes <- [s_mod_63];
s_mod_63.lexScopes <- [Decl_61.s];
Decls_64.s = Decl_61.s;
Decls_64.s_mod = s_mod_63;
Decls_64.s_glob = Decl_61.s_glob;
local lookupScope_65::Scope = mkScopeImpLookup()
lookupScope_65.lexScopes <- [Decls_64.s];
Decl_66.s = lookupScope_65;
Decl_66.s_lookup = Decls_64.s;
Decl_66.s_mod = Decls_64.s_mod;
Decl_66.s_glob = Decls_64.s_glob;
Decls_67.s = lookupScope_65;
Decls_67.s_mod = Decls_64.s_mod;
Decls_67.s_glob = Decls_64.s_glob;
ParBind_68.s = Decl_66.s_lookup;
ParBind_68.s_def = Decl_66.s;
ParBind_68.s_mod = Decl_66.s_mod
ParBind_68.s_glob = Decl_66.s_glob;
local varScope_69::Scope = mkScopeVar(("a", Expr_70.ty));
Expr_70.s = ParBind_68.s;
ParBind_68.s_def.varScopes <- [varScope_69];
ParBind_68.s_mod.varScopes <- [varScope_69];
Expr_70.ty = tInt();
local lookupScope_73::Scope = mkScopeImpLookup()
lookupScope_73.lexScopes <- [Decls_62.s];
Decl_74.s = lookupScope_73;
Decl_74.s_lookup = Decls_62.s;
Decl_74.s_mod = Decls_62.s_mod;
Decl_74.s_glob = Decls_62.s_glob;
Decls_75.s = lookupScope_73;
Decls_75.s_mod = Decls_62.s_mod;
Decls_75.s_glob = Decls_62.s_glob;
local s_mod_76::Scope = mkScopeMod(("B", s_mod_76));
Decl_74.s.modScopes <- [s_mod_76];
s_mod_76.lexScopes <- [Decl_74.s];
Decls_77.s = Decl_74.s;
Decls_77.s_mod = s_mod_76;
Decls_77.s_glob = Decl_74.s_glob;
local lookupScope_78::Scope = mkScopeImpLookup()
lookupScope_78.lexScopes <- [Decls_77.s];
Decl_79.s = lookupScope_78;
Decl_79.s_lookup = Decls_77.s;
Decl_79.s_mod = Decls_77.s_mod;
Decl_79.s_glob = Decls_77.s_glob;
Decls_80.s = lookupScope_78;
Decls_80.s_mod = Decls_77.s_mod;
Decls_80.s_glob = Decls_77.s_glob;
local datum_81::[Decorated Scope] = case ModRef_82.datum of | datumMod((_, s)) -> [s] | _ -> [] end;
Decl_79.s_lookup.impScopes <- datum_81;
ModRef_82.s = Decl_79.s;
local regex_83::Regex = `LEX* IMP? MOD`;
local dfa_84::DFA = regex_83.dfa;
local resFun_85::ResFunTy = resolutionFun(dfa_84);
local result_86::[Decorated Scope] = resFun_85(ModRef_82.s, "A");
ModRef_82.datum = 
	case result_86 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
local lookupScope_87::Scope = mkScopeImpLookup()
lookupScope_87.lexScopes <- [Decls_80.s];
Decl_88.s = lookupScope_87;
Decl_88.s_lookup = Decls_80.s;
Decl_88.s_mod = Decls_80.s_mod;
Decl_88.s_glob = Decls_80.s_glob;
Decls_89.s = lookupScope_87;
Decls_89.s_mod = Decls_80.s_mod;
Decls_89.s_glob = Decls_80.s_glob;
ParBind_90.s = Decl_88.s_lookup;
ParBind_90.s_def = Decl_88.s;
ParBind_90.s_mod = Decl_88.s_mod
ParBind_90.s_glob = Decl_88.s_glob;
local varScope_91::Scope = mkScopeVar(("b", Expr_92.ty));
Expr_92.s = ParBind_90.s;
ParBind_90.s_def.varScopes <- [varScope_91];
ParBind_90.s_mod.varScopes <- [varScope_91];
VarRef_94.s = Expr_92.s;
Expr_92.ty = case VarRef_94.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_95::Regex = `LEX* IMP? VAR`;
local dfa_96::DFA = regex_95.dfa;
local resFun_97::ResFunTy = resolutionFun(dfa_96);
local result_98::[Decorated Scope] = resFun_97(VarRef_94.s, "a");
VarRef_94.datum = 
	case result_98 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
```