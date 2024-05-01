## Silver equations for inputs/modules-simple.lm

### Input program:
```
module A {
  def a = 1
}

module B {
  import A
  def b = a
}
```

### Equations:
```

local globalScope::Scope = mkScopeGlobal(Decls_3.varScopes, Decls_3.modScopes);
Decls_3.s = globalScope;
Decls_3.sLookup = globalScope;
Main_4.ok = Decls_3.ok;
Decl_5.s = Decls_3.s;
Decl_5.sLookup = Decls_3.sLookup;
Decls_6.s = Decls_3.s;
Decls_6.sLookup = case Decl_5.impScope of | just(sImp) -> sImp | _ -> Decls_3.sLookup end;
Decls_3.varScopes = Decl_5.varScopes ++ Decls_6.varScopes;
Decls_3.modScopes = Decl_5.modScopes ++ Decls_6.modScopes;
Decls_3.ok = Decl_5.ok && Decls_6.ok;
local modScope_7::Scope = mkScopeMod(Decl_5.s, Decls_8.varScopes, Decls_8.modScopes, "A");
Decl_5.varScopes = [];
Decl_5.modScopes = [modScope_7];
Decl_5.impScope = nothing();
Decls_8.s = modScope_7;
Decls_8.sLookup = modScope_7;
Decl_5.ok = Decls_8.ok;
Decl_9.s = Decls_8.s;
Decl_9.sLookup = Decls_8.sLookup;
Decls_10.s = Decls_8.s;
Decls_10.sLookup = case Decl_9.impScope of | just(sImp) -> sImp | _ -> Decls_8.sLookup end;
Decls_8.varScopes = Decl_9.varScopes ++ Decls_10.varScopes;
Decls_8.modScopes = Decl_9.modScopes ++ Decls_10.modScopes;
Decls_8.ok = Decl_9.ok && Decls_10.ok;
Decl_9.varScopes = ParBind_11.varScopes;
ParBind_11.s = Decl_9.sLookup;
Decl_9.ok = ParBind_11.ok;
local varScope_12::Scope = mkScopeVar(("a", Expr_13.ty));
Expr_13.s = ParBind_11.s;
ParBind_11.varScopes = [varScope_12];
ParBind_11.ok = Expr_13.ty != tErr();
Expr_13.ty = tInt();
Decls_10.varScopes = [];
Decls_10.modScopes = [];
Decls_10.ok = true;
Decl_14.s = Decls_6.s;
Decl_14.sLookup = Decls_6.sLookup;
Decls_15.s = Decls_6.s;
Decls_15.sLookup = case Decl_14.impScope of | just(sImp) -> sImp | _ -> Decls_6.sLookup end;
Decls_6.varScopes = Decl_14.varScopes ++ Decls_15.varScopes;
Decls_6.modScopes = Decl_14.modScopes ++ Decls_15.modScopes;
Decls_6.ok = Decl_14.ok && Decls_15.ok;
local modScope_16::Scope = mkScopeMod(Decl_14.s, Decls_17.varScopes, Decls_17.modScopes, "B");
Decl_14.varScopes = [];
Decl_14.modScopes = [modScope_16];
Decl_14.impScope = nothing();
Decls_17.s = modScope_16;
Decls_17.sLookup = modScope_16;
Decl_14.ok = Decls_17.ok;
Decl_18.s = Decls_17.s;
Decl_18.sLookup = Decls_17.sLookup;
Decls_19.s = Decls_17.s;
Decls_19.sLookup = case Decl_18.impScope of | just(sImp) -> sImp | _ -> Decls_17.sLookup end;
Decls_17.varScopes = Decl_18.varScopes ++ Decls_19.varScopes;
Decls_17.modScopes = Decl_18.modScopes ++ Decls_19.modScopes;
Decls_17.ok = Decl_18.ok && Decls_19.ok;
local impScope_20::Scope = mkScopeImpLookup(Decl_18.sLookup, ModRef_21.declScope);
Decl_18.varScopes = [];
Decl_18.modScopes = [];
Decl_18.impScope = just(impScope_20);
ModRef_21.s = Decl_18.sLookup;
Decl_18.ok = ModRef_21.ok;
local regex_22::Regex = `LEX* IMP? MOD`;
local dfa_23::DFA = regex_22.dfa;
local resFun_24::ResFunTy = resolutionFun(dfa_23);
local result_25::[Decorated Scope] = resFun_24(ModRef_21.s, "A");
ModRef_21.declScope = 
	case result_25 of
	| s::_ -> just(s)
	| [] -> nothing()
	end;
ModRef_21.ok = ModRef_21.declScope.isJust;
Decl_26.s = Decls_19.s;
Decl_26.sLookup = Decls_19.sLookup;
Decls_27.s = Decls_19.s;
Decls_27.sLookup = case Decl_26.impScope of | just(sImp) -> sImp | _ -> Decls_19.sLookup end;
Decls_19.varScopes = Decl_26.varScopes ++ Decls_27.varScopes;
Decls_19.modScopes = Decl_26.modScopes ++ Decls_27.modScopes;
Decls_19.ok = Decl_26.ok && Decls_27.ok;
Decl_26.varScopes = ParBind_28.varScopes;
ParBind_28.s = Decl_26.sLookup;
Decl_26.ok = ParBind_28.ok;
local varScope_29::Scope = mkScopeVar(("b", Expr_30.ty));
Expr_30.s = ParBind_28.s;
ParBind_28.varScopes = [varScope_29];
ParBind_28.ok = Expr_30.ty != tErr();
VarRef_31.s = Expr_30.s;
Expr_30.ty = case VarRef_31.datum of | just(datumVar(id, ty)) -> ty | _ -> tErr() end;
local regex_32::Regex = `LEX* IMP? VAR`;
local dfa_33::DFA = regex_32.dfa;
local resFun_34::ResFunTy = resolutionFun(dfa_33);
local result_35::[Decorated Scope] = resFun_34(VarRef_31.s, "a");
VarRef_31.declScope = 
	case result_35 of
	| s::_ -> just(s)
	| [] -> nothing()
	end;
Decls_27.varScopes = [];
Decls_27.modScopes = [];
Decls_27.ok = true;
Decls_15.varScopes = [];
Decls_15.modScopes = [];
Decls_15.ok = true;

```
