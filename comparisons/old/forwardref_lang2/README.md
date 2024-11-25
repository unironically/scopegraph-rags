# Jast equations vs. Statix constraints for language 2 on inputs/forwardvarref.lm
- Jast equations at: [JastEquations.md](JastEquations.md)
- Statix constraints at: [StatixConstraints.md](StatixConstraints.md)

## Input program:
```
def a = b
def b = 1
```

## Comparison:
#### Equations involving the global scope
###### Interesting equations
```
local globalScope::Scope = mkScope();					-- Constraint 2
lookupScope_31.lexScopes <- [Decls_30.s];				-- Constraint 5
```
###### Copy equations
```
Decls_30.s = globalScope;
Decl_32.s_lookup = Decls_30.s;
ParBind_34.s = Decl_32.s_lookup;
Expr_36.s = ParBind_34.s;
VarRef_38.s = Expr_36.s;
Decls_30.s_mod = globalScope;
Decl_32.s_mod = Decls_30.s_mod;
ParBind_34.s_mod = Decl_32.s_mod
Decls_33.s_mod = Decls_30.s_mod;
Decl_44.s_mod = Decls_33.s_mod;
ParBind_46.s_mod = Decl_44.s_mod;
Decls_45.s_mod = Decls_33.s_mod;
Decls_30.s_glob = globalScope;
Decl_32.s_glob = Decls_30.s_glob;
ParBind_34.s_glob = Decl_32.s_glob;
Decls_33.s_glob = Decls_30.s_glob;
Decl_44.s_glob = Decls_33.s_glob;
ParBind_46.s_glob = Decl_44.s_glob;
Decls_45.s_glob = Decls_33.s_glob;

-- Scope copy equation structure, where child relation is node equality:
globalScope
├── Decls_30.s
│   └── Decl_32.s_lookup
│       └── ParBind_34.s
│           └── Expr_36.s
│               └── VarRef_38.s
├── Decls_30.s_mod
│   ├── Decl_32.s_mod
│   │   └── ParBind_34.s_mod
│   └── Decls_33.s_mod
│       ├── Decl_44.s_mod
│       │   └── ParBind_46.s_mod
│       └── Decls_45.s_mod
└── Decls_30.s_glob
    ├── Decl_32.s_glob
    │   └── ParBind_34.s_glob
    └── Decls_33.s_glob
        ├── Decl_44.s_glob
        │   └── ParBind_46.s_glob
        └── Decls_45.s_glob
```

###### Queries
```
local regex_39::Regex = `LEX* VAR`;					-- Constraints 10-14
local dfa_40::DFA = regex_39.dfa;
local resFun_41::ResFunTy = resolutionFun(dfa_40);
local result_42::[Decorated Scope] = resFun_41(VarRef_38.s, "b");
VarRef_38.datum =
	case result_42 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
```


#### Equations involving the first Decls scope
###### Interesting equations
```
local lookupScope_31::Scope = mkScopeImpLookup();			-- Constraint 4
lookupScope_31.lexScopes <- [Decls_30.s];				-- Constraint 5
local varScope_35::Scope = mkScopeVar(("a", Expr_36.ty));		-- Constraint 7
ParBind_34.s_def.varScopes <- [varScope_35];				-- Constraint 8
```
###### Copy equations
```
Decl_32.s = lookupScope_31;
ParBind_34.s_def = Decl_32.s;
Decls_33.s = lookupScope_31;
Decl_44.s_lookup = Decls_33.s;
ParBind_46.s = Decl_44.s_lookup;
Expr_48.s = ParBind_46.s;

-- Scope copy equation structure, where child relation is node equality:
lookupScope_31
├── Decl_32.s
│   └── ParBind_34.s_def
└── Decls_33.s
    └── Decl_44.s_lookup
        └── ParBind_46.s
            └── Expr_48.s
```


#### Equations involving the second Decls scope
###### Interesting equations
```
local lookupScope_43::Scope = mkScopeImpLookup();			-- Constraint 16
lookupScope_43.lexScopes <- [Decls_33.s];				-- Constraint 17
local varScope_47::Scope = mkScopeVar(("b", Expr_48.ty));		-- Constraint 19
ParBind_46.s_def.varScopes <- [varScope_47];				-- Constraint 20
```
###### Copy equations
```
Decl_44.s = lookupScope_43;
ParBind_46.s_def = Decl_44.s;
Decls_45.s = lookupScope_43;

-- Scope copy equation structure, where child relation is node equality:
lookupScope_43
├── Decl_44.s
│   └── ParBind_46.s_def
└── Decls_45.s
```


### Remaining Equations:
```
Expr_36.ty = case VarRef_38.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;

Expr_48.ty = tInt();
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
##### First Decls scope
```
-- Jast
local lookupScope_31::Scope = mkScopeImpLookup();

-- Statix
new s_1
```

##### Var scope for `a`
```
-- Jast
local varScope_35::Scope = mkScopeVar(("a", Expr_36.ty));

-- Statix
new s_var_2 -> ("a", ty_3)
```

##### Second Decls scope
```
-- Jast
local lookupScope_43::Scope = mkScopeImpLookup();
-- Statix
new s_9
```

##### Var scope for `b`
```
-- Jasr
local varScope_47::Scope = mkScopeVar(("b", Expr_48.ty));
-- Statix
new s_var_10 -> ("b", ty_11)
```


#### All instances of edge assertions in Jast vs. Statix
##### VAR edges
```
-- Jast
ParBind_34.s_def.varScopes <- [varScope_35];

-- Statix
s_1 -[ `VAR ]-> s_var_2
```

```
-- Jast
ParBind_46.s_def.varScopes <- [varScope_47];

-- Statix
s_9 -[ `VAR ]-> s_var_10
```

##### LEX edges
```
-- Jast
lookupScope_31.lexScopes <- [Decls_30.s];

-- Statix
s_1 -[ `LEX ]-> s_0
```

```
-- Jast
lookupScope_43.lexScopes <- [Decls_33.s];

-- Statix
s_9 -[ `LEX ]-> s_1
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
Decls_30.s = globalScope;
Decls_30.s_mod = globalScope;
Decls_30.s_glob = globalScope;
local lookupScope_31::Scope = mkScopeImpLookup()
lookupScope_31.lexScopes <- [Decls_30.s];
Decl_32.s = lookupScope_31;
Decl_32.s_lookup = Decls_30.s;
Decl_32.s_mod = Decls_30.s_mod;
Decl_32.s_glob = Decls_30.s_glob;
Decls_33.s = lookupScope_31;
Decls_33.s_mod = Decls_30.s_mod;
Decls_33.s_glob = Decls_30.s_glob;
ParBind_34.s = Decl_32.s_lookup;
ParBind_34.s_def = Decl_32.s;
ParBind_34.s_mod = Decl_32.s_mod
ParBind_34.s_glob = Decl_32.s_glob;
local varScope_35::Scope = mkScopeVar(("a", Expr_36.ty));
Expr_36.s = ParBind_34.s;
ParBind_34.s_def.varScopes <- [varScope_35];
VarRef_38.s = Expr_36.s;
Expr_36.ty = case VarRef_38.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_39::Regex = `LEX* VAR`;
local dfa_40::DFA = regex_39.dfa;
local resFun_41::ResFunTy = resolutionFun(dfa_40);
local result_42::[Decorated Scope] = resFun_41(VarRef_38.s, "b");
VarRef_38.datum =
	case result_42 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
local lookupScope_43::Scope = mkScopeImpLookup()
lookupScope_43.lexScopes <- [Decls_33.s];
Decl_44.s = lookupScope_43;
Decl_44.s_lookup = Decls_33.s;
Decl_44.s_mod = Decls_33.s_mod;
Decl_44.s_glob = Decls_33.s_glob;
Decls_45.s = lookupScope_43;
Decls_45.s_mod = Decls_33.s_mod;
Decls_45.s_glob = Decls_33.s_glob;
ParBind_46.s = Decl_44.s_lookup;
ParBind_46.s_def = Decl_44.s;
ParBind_46.s_mod = Decl_44.s_mod
ParBind_46.s_glob = Decl_44.s_glob;
local varScope_47::Scope = mkScopeVar(("b", Expr_48.ty));
Expr_48.s = ParBind_46.s;
ParBind_46.s_def.varScopes <- [varScope_47];
Expr_48.ty = tInt();
```