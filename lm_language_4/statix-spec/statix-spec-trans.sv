grammar statix-spec;

inherited attribute s::Scope;
synthesized attribute s_lex::[Scope];
synthesized attribute s_imp::[Scope];
synthesized attribute s_mod::[Scope];
synthesized attribute s_var::[Scope];

inherited attribute s_def::Scope;
synthesized attribute s_def_lex::[Scope];
synthesized attribute s_def_imp::[Scope];
synthesized attribute s_def_mod::[Scope];
synthesized attribute s_def_var::[Scope];




nonterminal Expr with
  s, s_lex, s_imp, s_mod, s_var;

production ExprLet
top::Expr ::= bs::SeqBinds e::Expr
{
  -- equations on locals
  local s_let::Scope = mkScope();
  s_let.lex = bs.s_def_lex ++ e.s_lex;
  s_let.imp = bs.s_def_imp ++ e.s_imp;
  s_let.mod = bs.s_def_mod ++ e.s_mod;
  s_let.var = bs.s_def_var ++ e.s_var;

  -- inherited attrs on child 1
  bs.s = top.s;
  bs.s_def = s_let;

  -- inherited attrs on child 2
  e.s = s_let;

  -- synthesized edges for scope s
  top.s_lex = bs.s_lex;
  top.s_imp = bs.s_imp;
  top.s_mod = bs.s_mod;
  top.s_var = bs.s_var;
}




nonterminal SeqBinds with 
  s, s_lex, s_imp, s_mod, s_var,
  s_def, s_def_lex, s_def_imp, s_def_mod, s_def_var;

production SeqBindsNil
top::SeqBinds ::=
{
  -- synthesized edges for scope s
  top.s_lex = [];
  top.s_imp = []; 
  top.s_mod = [];
  top.s_var = [];
  
  -- synthesized edges for scope s_def
  top.s_def_lex = [top.s];
  top.s_def_imp = []; 
  top.s_def_mod = [];
  top.s_def_var = [];
}

production SeqBindsOne
top::SeqBinds ::= b::SeqBind
{
  -- inherited attrs on child 1
  b.s = top.s;
  b.s_def = top.s_def;

  -- synthesized edges for scope s
  top.s_lex = b.s_lex; 
  top.s_imp = b.s_imp; 
  top.s_mod = b.s_mod;
  top.s_var = b.s_var;
  
  -- synthesized edges for scope s_def
  top.s_def_lex = [top.s] ++ b.s_def_lex;
  top.s_def_imp = b.s_def_imp; 
  top.s_def_mod = b.s_def_mod;
  top.s_def_var = b.s_def_var;
}

production SeqBindsCons
top::SeqBinds ::= b::SeqBind bs::SeqBinds
{
  -- equations on locals
  local s_def_prime::Scope = mkScope();
  s_def_prime.lex = b.s_def_lex ++ bs.s_lex ++ [top.s];
  s_def_prime.imp = b.s_def_imp ++ bs.s_imp;
  s_def_prime.mod = b.s_def_mod ++ bs.s_mod;
  s_def_prime.var = b.s_def_var ++ bs.s_var;

  -- inherited attrs on child 1
  b.s = top.s;
  b.s_def = top.s_def;

  -- inherited attrs on child 2
  bs.s = s_def_prime;
  bs.s_def = top.s_def;

  -- synthesized edges for scope s
  top.s_lex = b.s_lex;
  top.s_imp = b.s_imp; 
  top.s_mod = b.s_mod;
  top.s_var = b.s_var;

  -- synthesized edges for scope s_def
  top.s_def_lex = bs.s_def_lex;
  top.s_def_imp = bs.s_def_imp; 
  top.s_def_mod = bs.s_def_mod;
  top.s_def_var = bs.s_def_var;
}




nonterminal SeqBind with
  s, s_lex, s_imp, s_mod, s_var,
  s_def, s_def_lex, s_def_imp, s_def_mod, s_def_var;

production SeqBindTyped
top::SeqBind ::= x::String tyann::Type e::Expr
{
  -- equations on locals
  local s_var::Scope = mkScopeVar(x, tyann.ty);
  s_var.lex = [];
  s_var.imp = [];
  s_var.mod = [];
  s_var.var = [];

  -- synthesized edges for scope s
  top.s_lex = e.s_lex;
  top.s_imp = e.s_imp; 
  top.s_mod = e.s_mod;
  top.s_var = e.s_var;

  -- synthesized edges for scope s_def
  top.s_def_lex = [];
  top.s_def_imp = [];
  top.s_def_mod = [];
  top.s_def_var = [s_var];
}