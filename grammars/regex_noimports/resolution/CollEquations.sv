grammar regex_noimports:resolution;

monoid attribute constraintsColl::[String] occurs on Program, Decls, Decl, Expr, Bind, VarRef, ModRef;

aspect production program
top::Program ::= h::String ds::Decls
{
  --local initScope::Scope = mkScopeGlobal(ds.varScopes, ds.modScopes);
  --ds.scope = initScope;

  local dsName::String = "ds_" ++ toString(genInt());
  local initScopeName::String = "initScope_" ++ toString(genInt());

  top.constraintsColl := [
    "##### constraints from `program(h = " ++ h ++ ", ds = " ++ dsName ++ ")`",
    "```",
    "local " ++ initScopeName ++ "::Scope = mkScopeGlobal();",
    dsName ++ ".scope = " ++ initScopeName ++ ";",
    "```",
    "\n"
  ] ++ ds.constraintsColl;

  ds.topName = dsName;
}

aspect production decls_list
top::Decls ::= d::Decl ds::Decls
{
  --d.scope = top.scope;
  --ds.scope = case d.impLookupScope of nothing() -> top.scope | just(s) -> s end;

  local dName::String = "d_" ++ toString(genInt());
  local dsName::String = "ds_" ++ toString(genInt());
  local impScopeName::String = "impScope_" ++ toString(genInt());
  
  top.constraintsColl := [
    "##### constraints from `" ++ top.topName ++ " = decls_list(d = " ++ dName ++ ", ds = " ++ dsName ++ ")`",
    "```",
    "local " ++ impScopeName ++ "::Scope = mkScope();",
    impScopeName ++ ".lexEdge = " ++ top.topName ++ ".scope;",
    impScopeName ++ ".impEdge = " ++ dName ++ ".impScope;",
    dName ++ ".scope = " ++ top.topName ++ ".scope;",
    dsName ++ ".scope = case " ++ dName ++ " of decl_import(_, _) -> " ++ impScopeName ++ ".scope | _ -> " ++ top.topName ++ ".scope end;",
    "```",
    "\n"
  ] ++ d.constraintsColl ++ ds.constraintsColl;

  d.topName = dName;
  ds.topName = dsName;
}

aspect production decls_empty
top::Decls ::=
{
  -- propagate varScopes, modScopes;

  top.constraintsColl := [
     "##### constraints from `" ++ top.topName ++ " = decls_empty()`",
     "```",
    "```",
    "\n"
  ];
}

aspect production decl_module
top::Decl ::= x::String ds::Decls
{
  --local modScope::Scope = mkScopeMod(top.scope, ds.varScopes, ds.modScopes, top);
  --top.modScopes := [modScope];
  --top.varScopes := [];
  --top.impLookupScope = nothing();
  --ds.scope = modScope;

  local xName::String = "\"" ++ x ++ "\"";
  local dsName::String = "ds_" ++ toString(genInt());
  local modScopeName::String = "modScope_" ++ toString(genInt());

  top.constraintsColl := [
    "##### constraints from `" ++ top.topName ++ " = decl_module(x = " ++ xName ++ ", ds = " ++ dsName ++ ")`",
    "```",
    "local " ++ modScopeName ++ "::Scope = mkScopeMod(" ++ top.topName ++ ");",
    modScopeName ++ ".lexEdge = " ++ top.topName ++ ".scope;",
    top.topName ++ ".scope.modEdges <- [" ++ modScopeName ++ "];",
    dsName ++ ".scope = " ++ modScopeName ++ ";",
    "```",
    "\n"
  ] ++ ds.constraintsColl;

  ds.topName = dsName;
}

aspect production decl_def
top::Decl ::= b::Bind
{
  --local defScope::Scope = mkScopeVar(b);
  --top.varScopes := [defScope];
  --top.modScopes := [];
  --top.impLookupScope = nothing();

  local defScopeName::String = "defScope_" ++ toString(genInt());
  local bName::String = "b_" ++ toString(genInt());

  top.constraintsColl := [
    "##### constraints from `" ++ top.topName ++ " = decl_def(b = " ++ bName ++ ")`",
    "```",
    "local " ++ defScopeName ++ "::Scope = mkScopeVar(" ++ bName ++ ");",
    top.topName ++ ".scope.varEdges <- [" ++ defScopeName ++ "];",
    "```",
    "\n"
  ] ++ b.constraintsColl;

  b.topName = bName;
}

aspect production decl_import
top::Decl ::= r::ModRef
{
  --local lookupScope::Scope = mkScope(just(top.scope), [], [], r.impScope, nothing());
  --top.modScopes := [];
  --top.varScopes := [];
  --top.impLookupScope = just(lookupScope);
  --r.scope = top.scope;

  local rName::String = "r_" ++ toString(genInt());
  local lookupScopeName::String = "lookupScope_" ++ toString(genInt());

  top.constraintsColl := [
    "##### constraints from `" ++ top.topName ++ " = decl_import(r = " ++ rName ++ ")`",
    "```",
    rName ++ ".scope = " ++ top.topName ++ ".scope;",
    top.topName ++ ".impScope = " ++ rName ++ ".impScope;",
    "```",
    "\n"
  ] ++ r.constraintsColl;

  r.topName = rName;
}

aspect production expr_int
top::Expr ::= i::Integer
{
  top.constraintsColl := [
    "##### constraints from `" ++ top.topName ++ " = expr_int(i = " ++ toString(i) ++ ")`",
    "```",
    "```",
    "\n"
  ];
}

aspect production expr_var
top::Expr ::= r::VarRef
{
  -- r.scope = top.scope;

  local rName::String = "r_" ++ toString(genInt());

  top.constraintsColl := [
    "##### constraints from `" ++ top.topName ++ " = expr_var(r = " ++ rName ++ ")`",
    "```",
    "```",
    "\n"
  ] ++ r.constraintsColl;

  r.topName = rName;
}

aspect production expr_add
top::Expr ::= e1::Expr e2::Expr
{
  -- e1.scope = top.scope;
  -- e2.scope = top.scope;

  local e1Name::String = "e_" ++ toString(genInt());
  local e2Name::String = "e_" ++ toString(genInt());

  top.constraintsColl := [
    "##### constraints from `" ++ top.topName ++ " = expr_add(e1 = " ++ e1Name ++ ", e2 = " ++ e2Name ++ ")`",
    "```",
    e1Name ++ ".scope = " ++ top.topName ++ ".scope;",
    e2Name ++ ".scope = " ++ top.topName ++ ".scope;",
    "```",
    "\n"
  ] ++ e1.constraintsColl ++ e2.constraintsColl;

  e1.topName = e1Name;
  e2.topName = e2Name;
}

aspect production bind
top::Bind ::= x::VarRef_t e::Expr
{
  --top.label = x.lexeme ++ "_" ++ toString(x.line) ++ "_" ++ toString(x.column);

  local eName::String = "e_" ++ toString(genInt());
  local xName::String = "\"" ++ x.lexeme ++ "\"";

  top.constraintsColl := [
    "##### constraints from `" ++ top.topName ++ " = bind(x = " ++ xName ++ ", e = " ++ eName ++ ")`",
    "```",
    eName ++ ".scope = " ++ top.topName ++ ".scope",
    "```",
    "\n"
  ] ++ e.constraintsColl;

  e.topName = eName;
}



aspect production var_ref_single
top::VarRef ::= x::VarRef_t
{
  {-
  local regex::Regex = `LEX* IMP? VAR`;
  local dfa::DFA = regex.dfa;
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun(dfa);

  local decl::Maybe<Decorated Decl> =
    case resFun(top.scope, x.lexeme) of
    | mkScopeVar(d)::_ -> just(d)
    | _ -> nothing()
    end;
  -}

  local xName::String = "\"" ++ x.lexeme ++ "\"";
  local regexName::String = "regex_" ++ toString(genInt());
  local dfaName::String = "dfa_" ++ toString(genInt());
  local resFunName::String = "resFun_" ++ toString(genInt());
  local declName::String = "decl_" ++ toString(genInt());

  top.constraintsColl := [
    "##### constraints from `" ++ top.topName ++ " = var_ref_single(x = " ++ xName ++ ")`",
    "```",
    "local " ++ regexName ++ "::Regex = `LEX* IMP VAR`;",
    "local " ++ dfaName ++ "::DFA = " ++ regexName ++ ".dfa;",
    "local " ++ resFunName ++ "::([Decorated Scope] ::= Decorated Scope String) = resolutionFun(" ++ dfaName ++ ");",
    "local " ++ declName ++ " = \n" ++
                   "\tcase " ++ resFunName ++ "(" ++ top.topName ++ ".scope, " ++ xName ++ ".lexeme) of\n" ++
                     "\t\tmkScopeVar(d)::_ -> just(d)\n" ++
                   "\t| _ -> nothing()\n" ++
                 "\tend;",
    "```",
    "\n"
  ];
}

aspect production mod_ref_single
top::ModRef ::= x::TypeRef_t
{
  {-
  local regex::Regex = `LEX* IMP MOD`;
  local dfa::DFA = regex.dfa;
  local resFun::([Decorated Scope] ::= Decorated Scope String) = resolutionFun(dfa);

  top.impScope =
    case resFun(top.scope, x.lexeme) of
    | mkScopeMod(_, _, _d)::_ -> just(d)
    | _ -> nothing()
    end;
  -}

  local xName::String = "\"" ++ x.lexeme ++ "\"";
  local regexName::String = "regex_" ++ toString(genInt());
  local dfaName::String = "dfa_" ++ toString(genInt());
  local resFunName::String = "resFun_" ++ toString(genInt());

  top.constraintsColl := [
    "##### constraints from `" ++ top.topName ++ " = mod_ref_single(x = " ++ xName ++ ")`",
    "```",
    "local " ++ regexName ++ "::Regex = `LEX* IMP MOD`;",
    "local " ++ dfaName ++ "::DFA = " ++ regexName ++ ".dfa;",
    "local " ++ resFunName ++ "::([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) = resolutionFun(" ++ dfaName ++ ");",
    top.topName ++ ".impScope = \n" ++
                "\tcase " ++ resFunName ++ "(" ++ top.topName ++ ".scope, " ++ xName ++ ".lexeme) of\n" ++
                   "\t\tmkScopeMod(_, _, _, d)::_ -> just(d)\n" ++
                   "\t| _ -> nothing()\n" ++
                "\tend;",
    "```",
    "\n"
  ];
}