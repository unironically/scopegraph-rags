grammar regex_noimports:resolution;

inherited attribute topName::String occurs on Decls, Decl, Expr, Bind, VarRef, ModRef;
monoid attribute constraints::[String] occurs on Program, Decls, Decl, Expr, Bind, VarRef, ModRef; 

aspect production program
top::Program ::= h::String ds::Decls
{
  --local initScope::Scope = mkScopeGlobal (ds.varScopes, ds.modScopes);
  --ds.scope = initScope;

  local dsName::String = "ds_" ++ toString (genInt ());
  local initScopeName::String = "initScope_" ++ toString (genInt ());

  top.constraints := [
    "##### constraints from program(h = " ++ h ++ ", ds = " ++ dsName ++ ")\n",
    "```",
    "local " ++ initScopeName ++ "::Scope = mkScopeGlobal(" ++ dsName ++ ".varScopes, " ++ dsName ++ ".modScopes);",
    dsName ++ ".scope = " ++ initScopeName ++ ";",
    "```",
    "\n"
  ] ++ ds.constraints;

  ds.topName = dsName;
}

aspect production decls_list
top::Decls ::= d::Decl ds::Decls
{
  --d.scope = top.scope;
  --ds.scope = case d.impLookupScope of nothing() -> top.scope | just(s) -> s end;

  local dName::String = "d_" ++ toString (genInt ());
  local dsName::String = "ds_" ++ toString (genInt ());
  
  top.constraints := [
    "##### constraints from decls_list(d = " ++ dName ++ ", ds = " ++ dsName ++ ")",
    "```",
    top.topName ++ ".varScopes := " ++ dName ++ ".varScopes ++ " ++ dsName ++ ".varScopes;",
    top.topName ++ ".modScopes := " ++ dName ++ ".modScopes ++ " ++ dsName ++ ".modScopes;",
    top.topName ++ ".binds := " ++ dName ++ ".binds ++ " ++ dsName ++ ".binds;",
    dName ++ ".scope = " ++ top.topName ++ ".scope;",
    dsName ++ ".scope = case " ++ dName ++ ".impLookupScope of nothing() -> " ++ top.topName ++ ".scope | just(s) -> s end;",
    "```",
    "\n"
  ] ++ d.constraints ++ ds.constraints;

  d.topName = dName;
  ds.topName = dsName;
}

aspect production decls_empty
top::Decls ::=
{
  -- propagate varScopes, modScopes;

  top.constraints := [
     "##### constraints from decls_empty()",
     "```",
    top.topName ++ ".varScopes := [];",
    top.topName ++ ".modScopes := [];",
    top.topName ++ ".binds := [];",
    "```",
    "\n"
  ];
}

aspect production decl_module
top::Decl ::= x::String ds::Decls
{
  --local modScope::Scope = mkScopeMod (top.scope, ds.varScopes, ds.modScopes, top);
  --top.modScopes := [modScope];
  --top.varScopes := [];
  --top.impLookupScope = nothing ();
  --ds.scope = modScope;

  local xName::String = "\"" ++ x ++ "\"";
  local dsName::String = "ds_" ++ toString (genInt ());
  local modScopeName::String = "modScope_" ++ toString (genInt ());

  top.constraints := [
    "##### constraints from decl_module(x = " ++ xName ++ ", ds = " ++ dsName ++ ")",
    "```",
    "local " ++ modScopeName ++ "::Scope = mkScopeMod (" ++ top.topName ++ ".scope, " ++ dsName ++ ".varScopes, " ++ dsName ++ ".modScopes, " ++ top.topName ++ ");",
    top.topName ++ ".varScopes := [];",
    top.topName ++ ".modScopes := [" ++ modScopeName ++ "];",
    top.topName ++ ".impLookupScope = nothing();",
    top.topName ++ ".binds := " ++ dsName ++ ".binds;",
    dsName ++ ".scope = " ++ modScopeName ++ ";",
    "```",
    "\n"
  ] ++ ds.constraints;

  ds.topName = dsName;
}

aspect production decl_def
top::Decl ::= b::Bind
{  
  --local defScope::Scope = mkScopeVar (b);
  --top.varScopes := [defScope];
  --top.modScopes := [];
  --top.impLookupScope = nothing ();

  local defScopeName::String = "defScope_" ++ toString (genInt ());
  local bName::String = "b_" ++ toString (genInt ());

  top.constraints := [
    "##### constraints from decl_def(b = " ++ bName ++ ")\n",
    "```",
    "local " ++ defScopeName ++ "::Scope = mkScopeVar (" ++ bName ++ ");",
    top.topName ++ ".varScopes := [" ++ defScopeName ++ "];",
    top.topName ++ ".modScopes := [];",
    top.topName ++ ".impLookupScope = nothing ();",
    top.topName ++ ".binds := " ++ bName ++ ".binds;",
    "```",
    "\n"
  ] ++ b.constraints;

  b.topName = bName;
}

aspect production decl_import
top::Decl ::= r::ModRef
{
  --local lookupScope::Scope = mkScope (just(top.scope), [], [], r.impScope, nothing ());
  --top.modScopes := [];
  --top.varScopes := [];
  --top.impLookupScope = just(lookupScope);
  --r.scope = top.scope;

  local rName::String = "r_" ++ toString (genInt ());
  local lookupScopeName::String = "lookupScope_" ++ toString (genInt ());

  top.constraints := [
    "##### constraints from decl_import(r = " ++ rName ++ ")",
    "```",
    "local " ++ lookupScopeName ++ "::Scope = mkScope(just(" ++ top.topName ++ ".scope), [], [], " ++ rName ++ ".impScope, nothing());",
    top.topName ++ ".varScopes := [];",
    top.topName ++ ".modScopes := [];",   
    top.topName ++ ".impLookupScope = just(" ++ lookupScopeName ++ ");",
    top.topName ++ ".binds := [];",
    rName ++ ".scope = " ++ top.topName ++ ".scope;",
    "```",
    "\n"
  ] ++ r.constraints;

  r.topName = rName;
}

aspect production expr_int
top::Expr ::= i::Integer
{
  top.constraints := [
    "##### constraints from expr_int(i = " ++ toString (i) ++ ")",
    "```",
    top.topName ++ ".binds = [];",
    "```",
    "\n"
  ];
}

aspect production expr_var
top::Expr ::= r::VarRef
{
  -- r.scope = top.scope;

  local rName::String = "r_" ++ toString (genInt ());

  top.constraints := [
    "##### constraints from expr_var(r = " ++ rName ++ ")",
    "```",
    top.topName ++ ".binds := " ++ rName ++ ".binds;",
    rName ++ ".scope = " ++ top.topName ++ ".scope;",
    "```",
    "\n"
  ] ++ r.constraints;

  r.topName = rName;
}

aspect production expr_add
top::Expr ::= e1::Expr e2::Expr
{
  -- e1.scope = top.scope;
  -- e2.scope = top.scope;

  local e1Name::String = "e_" ++ toString (genInt ());
  local e2Name::String = "e_" ++ toString (genInt ());

  top.constraints := [
    "##### constraints from expr_add(e1 = " ++ e1Name ++ ", e2 = " ++ e2Name ++ ")",
    "```",
    top.topName ++ ".binds := " ++ e1Name ++ ".binds ++ " ++ e2Name ++ ".binds;",
    e1Name ++ ".scope = " ++ top.topName ++ ".scope;",
    e2Name ++ ".scope = " ++ top.topName ++ ".scope;",
    "```",
    "\n"
  ] ++ e1.constraints ++ e2.constraints;

  e1.topName = e1Name;
  e2.topName = e2Name;
}

aspect production bind
top::Bind ::= x::VarRef_t e::Expr
{
  --top.label = x.lexeme ++ "_" ++ toString(x.line) ++ "_" ++ toString(x.column);

  local eName::String = "e_" ++ toString (genInt ());
  local xName::String = "\"" ++ x.lexeme ++ "\"";

  top.constraints := [
    "##### constraints from bind(x = " ++ xName ++ ", e = " ++ eName ++ ")",
    "```",
    top.topName ++ ".label = " ++ xName ++ ".lexeme ++ \"_\" ++ toString(" ++ xName ++ ".line) ++ \"_\" ++ toString(" ++ xName ++ ".column);",
    top.topName ++ ".binds := " ++ eName ++ ".binds;",
    "```",
    "\n"
  ] ++ e.constraints;

  e.topName = eName;
}



aspect production var_ref_single
top::VarRef ::= x::VarRef_t
{
  --local regex::Regex = regexCat (regexStar (regexSingle(labelLex())), regexCat (regexOption (regexSingle (labelImp())), regexSingle(labelVar())));
  --local dfa::DFA = regex.dfa;
  --local resFun::([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) = resolutionFun (dfa);
  --top.refname = x.lexeme;
  --top.label = x.lexeme ++ "_" ++ toString(x.line) ++ "_" ++ toString(x.column);
  --top.binds := 
  --  let res::[Decorated Scope] = resFun (top.scope, x.lexeme, []) in
  --    case res of
  --      mkScopeVar (d)::t -> [(left(top), d)]
  --    | _ -> []
  --    end
  --  end;

  local xName::String = "\"" ++ x.lexeme ++ "\"";
  local regexName::String = "regex_" ++ toString (genInt ());
  local dfaName::String = "dfa_" ++ toString (genInt ());
  local resFunName::String = "resFun_" ++ toString (genInt ());

  top.constraints := [
    "##### constraints from var_ref_single(x = " ++ xName ++ ")",
    "```",
    "local " ++ regexName ++ "::Regex = regexCat (regexStar (regexSingle(labelLex())), regexCat (regexOption (regexSingle (labelImp())), regexSingle(labelVar())));",
    "local " ++ dfaName ++ "::DFA = " ++ regexName ++ ".dfa;",
    "local " ++ resFunName ++ "::([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) = resolutionFun (" ++ dfaName ++ ");",
    top.topName ++ ".refname = " ++ xName ++ ".lexeme;",
    top.topName ++ ".label = " ++ xName ++ ".lexeme ++ \"_\" ++ toString(" ++ xName ++ ".line) ++ \"_\" ++ toString(" ++ xName ++ ".column);",
    top.topName ++ ".binds := \n" ++
                 "\tlet res::[Decorated Scope] = resFun (" ++ top.topName ++ ".scope, " ++ xName ++ ".lexeme, []) in\n" ++
                   "\t\tcase res of\n" ++
                     "\t\t\tmkScopeVar (d)::t -> [(left(top), d)]\n" ++
                   "\t\t| _ -> []\n" ++
                   "\t\tend\n" ++
                 "\tend;",
    "```",
    "\n"
  ];
}

aspect production mod_ref_single
top::ModRef ::= x::TypeRef_t
{
  --local regex::Regex = regexCat (regexStar (regexSingle(labelLex())), regexCat (regexOption (regexSingle (labelImp())), regexSingle(labelMod())));
  --local dfa::DFA = regex.dfa;
  --local resFun::([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) = resolutionFun (dfa);
  --top.refname = x.lexeme;
  --top.label = x.lexeme ++ "_" ++ toString(x.line) ++ "_" ++ toString(x.column);
  --top.impScope = just (head(resFun (top.scope, x.lexeme, [])));

  local xName::String = "\"" ++ x.lexeme ++ "\"";
  local regexName::String = "regex_" ++ toString (genInt ());
  local dfaName::String = "dfa_" ++ toString (genInt ());
  local resFunName::String = "resFun_" ++ toString (genInt ());

  top.constraints := [
    "##### constraints from mod_ref_single(x = " ++ xName ++ ")",
    "```",
    "local " ++ regexName ++ "::Regex = regexCat (regexStar (regexSingle(labelLex())), regexCat (regexOption (regexSingle (labelImp())), regexSingle(labelMod())));",
    "local " ++ dfaName ++ "::DFA = " ++ regexName ++ ".dfa;",
    "local " ++ resFunName ++ "::([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) = resolutionFun (" ++ dfaName ++ ");",
    top.topName ++ ".refname = " ++ xName ++ ".lexeme;",
    top.topName ++ ".label = " ++ xName ++ ".lexeme ++ \"_\" ++ toString(" ++ xName ++ ".line) ++ \"_\" ++ toString(" ++ xName ++ ".column);",
    top.topName ++ ".impScope = just(head(" ++ resFunName ++ "(" ++ top.topName ++ ".scope, " ++ xName ++ ".lexeme, [])));",
    "```",
    "\n"
  ];
}