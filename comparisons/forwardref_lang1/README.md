## Jast equations vs. Statix constraints for language 1 on inputs/forwardvarref.lm
- Jast equations at: [JastEquations.md](JastEquations.md)
- Statix constraints at: [StatixConstraints.md](StatixConstraints.md)

### Input program:
```
def a = b
def b = 1
```

## Comparison:
#### Equations involving the global scope
###### Interesting equations
```
local globalScope::Scope = mkScope();                                   -- Constraint 2

local varScope_30::Scope = mkScopeVar(("a", Expr_31.ty));               -- Constraint 4
ParBind_29.s_def.varScopes <- [varScope_30];                            -- Constraint 5

local varScope_40::Scope = mkScopeVar(("b", Expr_41.ty));               -- Constraint 13
ParBind_39.s_def.varScopes <- [varScope_40];                            -- Constraint 14

```
###### Copy equations
```
Decls_26.s = globalScope;
Decl_27.s = Decls_26.s;
ParBind_29.s = Decl_27.s;
Expr_31.s = ParBind_29.s;
VarRef_32.s = Expr_31.s;
ParBind_29.s_def = Decl_27.s;
Decls_28.s = Decls_26.s;
Decl_37.s = Decls_28.s;
ParBind_39.s = Decl_37.s;
Expr_41.s = ParBind_39.s;
ParBind_39.s_def = Decl_37.s;
Decls_38.s = Decls_28.s;

-- Scope copy equation structure, where child relation is node equality:
globalScope
└── Decls_26.s
    ├── Decl_27.s
    │   ├── ParBind_29.s
    │   │   └── Expr_31.s
    │   │       └── VarRef_32.s
    │   └── ParBind_29.s_def
    └── Decls_28.s
        ├── Decl_37.s
        │   ├── ParBind_39.s
        │   │   └── Expr_41.s
        │   └── ParBind_39.s_def
        └── Decls_38.s
```

###### Query equations
```
local regex_33::Regex = `LEX* VAR`;				        -- Constraints 7-11
local dfa_34::DFA = regex_33.dfa;
local resFun_35::ResFunTy = resolutionFun(dfa_34);
local result_36::[Decorated Scope] = resFun_35(VarRef_32.s, "b");
VarRef_32.datum =
	case result_36 of
	| s::_ -> s.datum
	| [] -> nothing()
	end;
```

### Remaining equations:
```
Expr_31.ty = case VarRef_32.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;

Expr_41.ty = tInt();
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

```
-- Jast
local varScope_30::Scope = mkScopeVar(("a", Expr_31.ty));

-- Statix
new s_var_1 -> ("a", ty_2)
```

```
-- Jast
local varScope_40::Scope = mkScopeVar(("b", Expr_41.ty));

-- Statix
new s_var_8 -> ("b", ty_9)
```

#### All instances of edge assertions in Jast vs. Statix
##### VAR edges
```
-- Jast
ParBind_29.s_def.varScopes <- [varScope_30];

-- Statix
s_0 -[ `VAR ]-> s_var_1
```

```
-- Jast
ParBind_39.s_def.varScopes <- [varScope_40];

-- Statix
s_0 -[ `VAR ]-> s_var_8
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