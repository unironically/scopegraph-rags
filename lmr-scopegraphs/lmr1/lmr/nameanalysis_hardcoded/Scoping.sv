grammar lmr1:lmr:nameanalysis_hardcoded;

--------------------------------------------------

synthesized attribute pp::String;
synthesized attribute ok::Boolean;

synthesized attribute type::Type; -- Type of an expression
synthesized attribute eq::(Boolean ::= Type); -- Type equality


--inherited attribute env::Env;         -- scope to lookup in
--inherited attribute bindEnv::Env;     -- scope to add binds to

--inherited attribute bindsIn::Env;     -- Module members threading down
--synthesized attribute bindsOut::Env;  -- Module members threading up

--synthesized attribute outEnv::Env;    -- Env coming up from a declaration to pass down to next

--

inherited attribute s::Decorated Scope;
monoid attribute s_lex::[Decorated Scope] with [], ++;
monoid attribute s_var::[Decorated Scope] with [], ++;
monoid attribute s_mod::[Decorated Scope] with [], ++;
monoid attribute s_imp::[Decorated Scope] with [], ++;

inherited attribute s_def::Decorated Scope;
monoid attribute s_def_lex::[Decorated Scope] with [], ++;
monoid attribute s_def_var::[Decorated Scope] with [], ++;
monoid attribute s_def_mod::[Decorated Scope] with [], ++;
monoid attribute s_def_imp::[Decorated Scope] with [], ++;

inherited attribute s_module::Decorated Scope;
monoid attribute s_module_lex::[Decorated Scope] with [], ++;
monoid attribute s_module_var::[Decorated Scope] with [], ++;
monoid attribute s_module_mod::[Decorated Scope] with [], ++;
monoid attribute s_module_imp::[Decorated Scope] with [], ++;

inherited attribute s_final::Decorated Scope;
monoid attribute s_final_lex::[Decorated Scope] with [], ++;
monoid attribute s_final_var::[Decorated Scope] with [], ++;
monoid attribute s_final_mod::[Decorated Scope] with [], ++;
monoid attribute s_final_imp::[Decorated Scope] with [], ++;

--------------------------------------------------

nonterminal Main with location, ok;

production program
top::Main ::= ds::Decls
{
{-
  top.ok = ds.ok;

  ds.env = newEnv();
  ds.bindsIn = newEnv();
-}
  production attribute glob::Scope = scope();
  glob.edges := mapCons("lex", ds.s_lex,
                mapCons("var", ds.s_var,
                mapCons("mod", ds.s_mod,
                mapLast("imp", ds.s_imp))));

  production attribute dead::Scope = scope();
  dead.edges := mapNone();

  ds.s = glob;
  ds.s_module = dead;

  top.ok = ds.ok;

}

--------------------------------------------------

nonterminal Decls with location, ok,
  s, s_lex, s_var, s_mod, s_imp,
  s_module, s_module_lex, s_module_var, s_module_mod, s_module_imp;

production declsCons
top::Decls ::= d::Decl ds::Decls
{
{-
  d.env = top.env;
  d.bindsIn = top.bindsIn;

  ds.env = newScope(d.outEnv);
  ds.bindsIn = d.bindsOut;

  top.outEnv = ds.outEnv;
  top.bindsOut = ds.bindsOut;

  top.ok = d.ok && ds.ok;
-}

  local next::Scope = scope();
  --next.lex = top.s::(d.s_def_lex ++ ds.s_lex);
  --next.var = d.s_def_var ++ ds.s_var;
  --next.mod = d.s_def_mod ++ ds.s_mod;
  --next.imp = d.s_def_imp ++ ds.s_imp;
  next.edges := mapCons("lex", top.s::(d.s_def_lex ++ ds.s_lex),
                mapCons("var", d.s_def_var ++ ds.s_var,
                mapCons("mod", d.s_def_mod ++ ds.s_mod,
                mapLast("imp", d.s_def_imp ++ ds.s_imp))));

  d.s = top.s;
  d.s_def = next;
  d.s_module = top.s_module;

  ds.s = next;
  ds.s_module = top.s_module;

  top.ok = d.ok && ds.ok;

  top.s_lex := d.s_lex; top.s_var := d.s_var;
  top.s_mod := d.s_mod; top.s_imp := d.s_imp;
  
  top.s_module_lex := d.s_module_lex ++ ds.s_module_lex;
  top.s_module_var := d.s_module_var ++ ds.s_module_var;
  top.s_module_mod := d.s_module_mod ++ ds.s_module_mod;
  top.s_module_imp := d.s_module_imp ++ ds.s_module_imp;
}

production declsNil
top::Decls ::=
{
{-
  top.outEnv = top.env;
  top.bindsOut = top.bindsIn;

  top.ok = true;
-}
  top.ok = true;

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
  
  top.s_module_lex := []; top.s_module_var := [];
  top.s_module_mod := []; top.s_module_imp := [];
}

--------------------------------------------------

nonterminal Decl with location, ok,
  s, s_lex, s_var, s_mod, s_imp,
  s_def, s_def_lex, s_def_var, s_def_mod, s_def_imp,
  s_module, s_module_lex, s_module_var, s_module_mod, s_module_imp;

production declModule
top::Decl ::= m::Module
{{-
  m.env = top.env;
  m.bindsIn = top.bindsIn;

  top.outEnv = m.outEnv;
  top.bindsOut = m.bindsOut;

  top.ok = m.ok;
-}
  m.s = top.s;
  top.s_lex := m.s_lex; top.s_var := m.s_var;
  top.s_mod := m.s_mod; top.s_imp := m.s_imp;

  m.s_def = top.s_def;
  top.s_def_lex := m.s_def_lex; top.s_def_var := m.s_def_var;
  top.s_def_mod := m.s_def_mod; top.s_def_imp := m.s_def_imp;

  top.s_module_lex := []; top.s_module_var := [];
  top.s_module_mod := m.s_def_mod; top.s_module_imp := [];

  top.ok = m.ok;
}

production declImport
top::Decl ::= mr::ModRef
{{-
  mr.env = top.env;

  top.outEnv = mr.outEnv;
  top.bindsOut = top.bindsIn;

  top.ok = mr.ok;
-}
  mr.s = top.s;
  top.s_lex := mr.s_lex; top.s_var := mr.s_var;
  top.s_mod := mr.s_mod; top.s_imp := mr.s_imp;

  mr.s_def = top.s_def;
  top.s_def_lex := mr.s_def_lex; top.s_def_var := mr.s_def_var;
  top.s_def_mod := mr.s_def_mod; top.s_def_imp := mr.s_def_imp;

  top.s_module_lex := []; top.s_module_var := [];
  top.s_module_mod := []; top.s_module_imp := [];

  top.ok = mr.ok;
}

production declDef
top::Decl ::= b::Bind
{{-
  b.env = top.env;
  b.bindEnv = top.env;
  b.bindsIn = top.bindsIn;

  top.outEnv = b.outEnv;
  top.bindsOut = b.bindsOut;

  top.ok = b.ok;
-}
  b.s = top.s;
  top.s_lex := b.s_lex; top.s_var := b.s_var;
  top.s_mod := b.s_mod; top.s_imp := b.s_imp;

  b.s_def = top.s_def;
  top.s_def_lex := b.s_def_lex; top.s_def_var := b.s_def_var;
  top.s_def_mod := b.s_def_mod; top.s_def_imp := b.s_def_imp;

  top.s_module_lex := []; top.s_module_var := top.s_def_var;
  top.s_module_mod := []; top.s_module_imp := [];

  top.ok = b.ok;
}

--------------------------------------------------

--synthesized attribute fields::Env;

nonterminal Module with location, ok,
  s, s_lex, s_var, s_mod, s_imp,
  s_def, s_def_lex, s_def_var, s_def_mod, s_def_imp;

production module
top::Module ::= x::String ds::Decls
{{-
  ds.env = newScope(top.env);
  ds.bindsIn = newEnv();

  top.outEnv = addMod(top.env, x, top);
  top.bindsOut = addMod(top.env, x, top);

  top.fields = ds.bindsOut;

  top.ok = ds.ok;
-}
  local mod::Scope = scopeMod(x, top);
  --mod.lex = top.s::ds.s_module_lex;
  --mod.var = ds.s_module_var;
  --mod.mod = ds.s_module_mod;
  --mod.imp = ds.s_module_imp;
  mod.edges := mapCons("lex", top.s::ds.s_module_lex,
               mapCons("var", ds.s_module_var,
               mapCons("mod", ds.s_module_mod,
               mapLast("imp", ds.s_module_imp))));

  ds.s = top.s;
  top.s_lex := ds.s_lex; top.s_var := ds.s_var;
  top.s_mod := ds.s_mod; top.s_imp := ds.s_imp;

  ds.s_module = mod;

  top.ok = ds.ok;

  top.s_def_lex := []; top.s_def_var := [];
  top.s_def_mod := [mod]; top.s_def_imp := [];
}

--------------------------------------------------

nonterminal Expr with location, ok, type,
  s, s_lex, s_var, s_mod, s_imp;

production exprVar
top::Expr ::= r::VarRef
{
{-
  r.env = top.env;

  top.ok = r.ok;
  top.type = r.type;
-}
  r.s = top.s;
  top.s_lex := r.s_lex; top.s_var := r.s_var;
  top.s_mod := r.s_mod; top.s_imp := r.s_imp;

  top.ok = r.ok;
  top.type = r.type;
}

production exprFloat
top::Expr ::= f::Float
{
{-
  top.ok = true;
  top.type = tFloat();
-}
  top.ok = true;
  top.type = tFloat();

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}

production exprInt
top::Expr ::= i::Integer
{
{-
  top.ok = true;
  top.type = tInt();
-}
  top.ok = true;
  top.type = tInt();

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}

production exprTrue
top::Expr ::=
{
{-
  top.ok = true;
  top.type = tBool();
-}
  top.ok = true;
  top.type = tBool();

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}

production exprFalse
top::Expr ::=
{
{-
  top.ok = true;
  top.type = tBool();
-}
  top.ok = true;
  top.type = tBool();

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}

production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
{-
  e1.env = top.env;
  e2.env = top.env;
  
  top.type = case e1.type, e2.type of
               tInt(), tInt() -> e1.type
             | tInt(), tFloat() -> e1.type
             | tFloat(), tInt() -> e2.type
             | tFloat(), tFloat() -> e1.type
             | _, _ -> tErr()
             end;

  top.ok = e1.ok && e2.ok && !top.type.eq(tErr());
-}
  e1.s = top.s;
  top.s_lex := e1.s_lex; top.s_var := e1.s_var;
  top.s_mod := e1.s_mod; top.s_imp := e1.s_imp;

  e2.s =  top.s;
  top.s_lex <- e2.s_lex; top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod; top.s_imp <- e2.s_imp;

  top.ok = e1.ok && e2.ok && !top.type.eq(tErr());
  top.type = case e1.type, e2.type of
               tInt(), tInt() -> e1.type
             | tInt(), tFloat() -> e1.type
             | tFloat(), tInt() -> e2.type
             | tFloat(), tFloat() -> e1.type
             | _, _ -> tErr()
             end;
}

production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
{-
  e1.env = top.env;
  e2.env = top.env;
  
  top.type = tBool();
  top.ok = e1.ok && e2.ok &&
           e1.type.eq(tBool()) && 
           e2.type.eq(tBool());
-}
  e1.s = top.s;
  top.s_lex := e1.s_lex; top.s_var := e1.s_var;
  top.s_mod := e1.s_mod; top.s_imp := e1.s_imp;

  e2.s =  top.s;
  top.s_lex <- e2.s_lex; top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod; top.s_imp <- e2.s_imp;

  top.ok = e1.ok && e2.ok &&
           e1.type.eq(tBool()) && 
           e2.type.eq(tBool());
  top.type = tBool();
}

production exprEq
top::Expr ::= e1::Expr e2::Expr
{
{-
  e1.env = top.env;
  e2.env = top.env;
  
  top.type = tBool();
  top.ok = e1.ok && e2.ok &&
           e1.type.eq(e2.type);
-}
  e1.s = top.s;
  top.s_lex := e1.s_lex; top.s_var := e1.s_var;
  top.s_mod := e1.s_mod; top.s_imp := e1.s_imp;

  e2.s =  top.s;
  top.s_lex <- e2.s_lex; top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod; top.s_imp <- e2.s_imp;

  top.ok = e1.ok && e2.ok &&
           e1.type.eq(e2.type);
  top.type = tBool();
}

production exprFun
top::Expr ::= b::Bind e::Expr
{
{-
  b.env = top.env;
  b.bindEnv = newScope(top.env);
  b.bindsIn = newEnv();

  e.env = b.outEnv;

  top.type = tFun(b.type, e.type);
  top.ok = b.ok && e.ok;
-}
  local next::Scope = scope();
  --next.lex = top.s::(b.s_def_lex ++ e.s_lex);
  --next.var = b.s_def_var ++ e.s_var;
  --next.mod = b.s_def_mod ++ e.s_mod;
  --next.imp = b.s_def_imp ++ e.s_imp;
  next.edges := mapCons("lex", top.s::(b.s_def_lex ++ e.s_lex),
                mapCons("var", b.s_def_var ++ e.s_var,
                mapCons("mod", b.s_def_mod ++ e.s_mod,
                mapLast("imp", b.s_def_imp ++ e.s_imp))));

  b.s = top.s;
  top.s_lex := b.s_lex; top.s_var := b.s_var;
  top.s_mod := b.s_mod; top.s_imp := b.s_imp;

  b.s_def = next;
  e.s = next;

  top.type = tFun(b.type, e.type);
  top.ok = b.ok && e.ok;
}

production exprApp
top::Expr ::= e1::Expr e2::Expr
{
{-
  e1.env = top.env;
  e2.env = top.env;

  top.type = case e1.type of
             | tFun(_, tOut) -> ^tOut
             | _ -> tErr()
             end;
  top.ok = e1.ok && e2.ok &&
           case e1.type, e2.type of
           | tFun(tIn, tOut), tArg -> tArg.eq(^tIn)
           | _, _ -> false
           end;
-}
  e1.s = top.s;
  top.s_lex := e1.s_lex; top.s_var := e1.s_var;
  top.s_mod := e1.s_mod; top.s_imp := e1.s_imp;

  e2.s =  top.s;
  top.s_lex <- e2.s_lex; top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod; top.s_imp <- e2.s_imp;

  top.ok = e1.ok && e2.ok &&
           case e1.type, e2.type of
           | tFun(tIn, tOut), tArg -> tArg.eq(^tIn)
           | _, _ -> false
           end;
  top.type = case e1.type of
             | tFun(_, tOut) -> ^tOut
             | _ -> tErr()
             end;
}

production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
{-
  e1.env = top.env;
  e2.env = top.env;
  e3.env = top.env;

  top.type = if e2.type.eq(e3.type) then e2.type else tErr();
  top.ok = e1.ok && e2.ok && e3.ok && 
           e1.type.eq(tBool()) && e2.type.eq(e3.type);
-}
  e1.s = top.s;
  top.s_lex := e1.s_lex; top.s_var := e1.s_var;
  top.s_mod := e1.s_mod; top.s_imp := e1.s_imp;

  e2.s =  top.s;
  top.s_lex <- e2.s_lex; top.s_var <- e2.s_var;
  top.s_mod <- e2.s_mod; top.s_imp <- e2.s_imp;

  e3.s = top.s;
  top.s_lex <- e3.s_lex; top.s_var <- e3.s_var;
  top.s_mod <- e3.s_mod; top.s_imp <- e3.s_imp;

  top.ok = e1.ok && e2.ok && e3.ok &&
           e1.type.eq(tBool()) && e2.type.eq(e3.type);
  top.type = if e2.type.eq(e3.type) then e2.type else tErr();
}

production exprLet
top::Expr ::= bs::Binds e::Expr
{
{-
  bs.env = top.env;

  e.env = bs.outEnv;

  top.type = e.type;
  top.ok = bs.ok && e.ok;
-}
  local final::Scope = scope();
  --final.lex = bs.s_final_lex ++ e.s_lex;
  --final.var = bs.s_final_var ++ e.s_var;
  --final.mod = bs.s_final_mod ++ e.s_mod;
  --final.imp = bs.s_final_imp ++ e.s_imp;
  final.edges := mapCons("lex", bs.s_final_lex ++ e.s_lex,
                 mapCons("var", bs.s_final_var ++ e.s_var,
                 mapCons("mod", bs.s_final_mod ++ e.s_mod,
                 mapLast("imp", bs.s_final_imp ++ e.s_imp))));

  bs.s = top.s;
  bs.s_final = final;

  e.s = final;

  top.ok = bs.ok && e.ok;
  top.type = e.type;

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}

production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
{-
  nondecorated local bindEnv::Env = newScope(top.env);

  bs.env = bs.outEnv;
  bs.bindEnv = newScope(top.env);

  e.env = bs.outEnv;

  top.type = e.type;
  top.ok = bs.ok && e.ok;
-}
  local next::Scope = scope();
  --next.lex = top.s::(bs.s_lex ++ bs.s_def_lex ++ e.s_lex);
  --next.var = bs.s_var ++ bs.s_def_var ++ e.s_var;
  --next.mod = bs.s_mod ++ bs.s_def_mod ++ e.s_mod;
  --next.imp = bs.s_imp ++ bs.s_def_imp ++ e.s_imp;
  next.edges := mapCons("lex", top.s::(bs.s_lex ++ bs.s_def_lex ++ e.s_lex),
                mapCons("var", bs.s_var ++ bs.s_def_var ++ e.s_var,
                mapCons("mod", bs.s_mod ++ bs.s_def_mod ++ e.s_mod,
                mapLast("imp", bs.s_imp ++ bs.s_def_imp ++ e.s_imp))));

  bs.s = next;
  bs.s_def = next;

  e.s = next;

  top.ok = bs.ok && e.ok;
  top.type = e.type;

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}

production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
{-
  nondecorated local bindEnv::Env = newScope(top.env);

  bs.env = top.env;
  bs.bindEnv = newScope(top.env);

  e.env = newScope(bs.outEnv);

  top.type = e.type;
  top.ok = bs.ok && e.ok;
-}
  local next::Scope = scope();
  --next.lex = top.s::(bs.s_def_lex ++ e.s_lex);
  --next.var = bs.s_def_var ++ e.s_var;
  --next.mod = bs.s_def_mod ++ e.s_mod;
  --next.imp = bs.s_def_imp ++ e.s_imp;
  next.edges := mapCons("lex", top.s::(bs.s_def_lex ++ e.s_lex),
                mapCons("var", bs.s_def_var ++ e.s_var,
                mapCons("mod", bs.s_def_mod ++ e.s_mod,
                mapLast("imp", bs.s_def_imp ++ e.s_imp))));

  bs.s = top.s;
  top.s_lex := bs.s_lex; top.s_var := bs.s_var;
  top.s_mod := bs.s_mod; top.s_imp := bs.s_imp;

  bs.s_def = next;

  e.s = next;

  top.ok = bs.ok && e.ok;
  top.type = e.type;
}

--------------------------------------------------

nonterminal Binds with location, ok,
  s, s_lex, s_var, s_mod, s_imp,
  s_final, s_final_lex, s_final_var, s_final_mod, s_final_imp;

production seqBindsCons
top::Binds ::= b::Bind bs::Binds
{
{-
  b.env = top.env;
  b.bindEnv = newScope(top.env);
  b.bindsIn = newEnv();

  bs.env = b.outEnv;

  top.outEnv = bs.outEnv;
  top.ok = b.ok && bs.ok;
-}
  local next::Scope = scope();
  --next.lex = top.s::(b.s_def_lex ++ bs.s_lex);
  --next.var = b.s_def_var ++ bs.s_var;
  --next.mod = b.s_def_mod ++ bs.s_mod;
  --next.imp = b.s_def_imp ++ bs.s_imp;
  next.edges := mapCons("lex", top.s::(b.s_def_lex ++ bs.s_lex),
                mapCons("var", b.s_def_var ++ bs.s_var,
                mapCons("mod", b.s_def_mod ++ bs.s_mod,
                mapLast("imp", b.s_def_imp ++ bs.s_imp))));

  b.s = top.s;
  top.s_lex := b.s_lex;
  top.s_var := b.s_var;
  top.s_mod := b.s_mod;
  top.s_imp := b.s_imp;

  b.s_def = next;

  bs.s = next;

  bs.s_final = top.s_final;
  top.s_final_lex := bs.s_final_lex;
  top.s_final_var := bs.s_final_var;
  top.s_final_mod := bs.s_final_mod;
  top.s_final_imp := bs.s_final_imp;

  top.ok = b.ok && bs.ok;
}

production seqBindsLast
top::Binds ::= b::Bind
{
{-
  b.env = top.env;
  b.bindEnv = newScope(top.env);
  b.bindsIn = newEnv();

  top.outEnv = b.outEnv;
  top.ok = b.ok;
-}

  b.s = top.s;
  top.s_lex := b.s_lex; top.s_var := b.s_var;
  top.s_mod := b.s_mod; top.s_imp := b.s_imp;

  b.s_def = top.s_final;
  top.s_final_lex := top.s::b.s_def_lex;
  top.s_final_var := b.s_def_var;
  top.s_final_mod := b.s_def_mod;
  top.s_final_imp := b.s_def_imp;

  top.ok = b.ok;
}

production seqBindsNil
top::Binds ::=
{
{-
  top.outEnv = top.env;
  top.ok = true;
-}
  top.ok = true;

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];

  top.s_final_lex := [top.s];
  top.s_final_var := [];
  top.s_final_mod := [];
  top.s_final_imp := [];
}

--------------------------------------------------

nonterminal ParBinds with location, ok,
  s, s_lex, s_var, s_mod, s_imp,
  s_def, s_def_lex, s_def_var, s_def_mod, s_def_imp;

production parBindsCons
top::ParBinds ::= b::Bind bs::ParBinds
{
{-
  b.env = top.env;
  b.bindEnv = top.bindEnv;
  b.bindsIn = newEnv();

  bs.env = top.env;
  bs.bindEnv = b.outEnv;

  top.outEnv = bs.outEnv;
  top.ok = b.ok && bs.ok;
-}
  
  b.s = top.s;
  top.s_lex := b.s_lex; top.s_var := b.s_var;
  top.s_mod := b.s_mod; top.s_imp := b.s_imp;

  b.s_def = top.s_def;
  top.s_def_lex := b.s_def_lex; top.s_def_var := b.s_def_var;
  top.s_def_mod := b.s_def_mod; top.s_def_imp := b.s_def_imp;

  bs.s = top.s;
  top.s_lex <- bs.s_lex; top.s_var <- bs.s_var;
  top.s_mod <- bs.s_mod; top.s_imp <- bs.s_imp;

  bs.s_def = top.s_def;
  top.s_def_lex <- bs.s_def_lex; top.s_def_var <- bs.s_def_var;
  top.s_def_mod <- bs.s_def_mod; top.s_def_imp <- bs.s_def_imp;

  top.ok = b.ok && bs.ok;
}

production parBindsLast
top::ParBinds ::= b::Bind
{
{-
  b.env = top.env;
  b.bindEnv = top.bindEnv;
  b.bindsIn = newEnv();

  top.outEnv = b.outEnv;
  top.ok = b.ok;
-}
  b.s = top.s;
  top.s_lex := b.s_lex; top.s_var := b.s_var;
  top.s_mod := b.s_mod; top.s_imp := b.s_imp;

  b.s_def = top.s_def;
  top.s_def_lex := b.s_def_lex; top.s_def_var := b.s_def_var;
  top.s_def_mod := b.s_def_mod; top.s_def_imp := b.s_def_imp;

  top.ok = b.ok;
}

production parBindsNil
top::ParBinds ::=
{
{-
  top.outEnv = top.bindEnv;
  top.ok = true;
-}
  top.ok = true;

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];

  top.s_def_lex := []; top.s_def_var := [];
  top.s_def_mod := []; top.s_def_imp := [];
}

--------------------------------------------------

nonterminal Bind with location, ok, type,
  s, s_lex, s_var, s_mod, s_imp,
  s_def, s_def_lex, s_def_var, s_def_mod, s_def_imp;

production bindTyped
top::Bind ::= tyann::TypeExpr x::String e::Expr
{
{-
  tyann.env = top.env;
  e.env = top.env;

  top.outEnv = addVar(top.bindEnv, x, top);
  top.bindsOut = addVar(top.bindsIn, x, top);

  top.type = tyann.type;
  top.ok = e.ok && tyann.type.eq(e.type);
-}
  local var::Scope = scopeVar(x, top);
  --var.lex = []; var.var = [];
  --var.mod = []; var.imp = [];
  var.edges := mapCons("lex", [],
               mapCons("var", [],
               mapCons("mod", [],
               mapLast("imp", []))));

  top.s_def_lex := [];
  top.s_def_var := [var];
  top.s_def_mod := [];
  top.s_def_imp := [];

  e.s = top.s;
  top.s_lex := e.s_lex; top.s_var := e.s_var;
  top.s_mod := e.s_mod; top.s_imp := e.s_imp;

  tyann.s = top.s;
  top.s_lex <- tyann.s_lex; top.s_var <- tyann.s_var;
  top.s_mod <- tyann.s_mod; top.s_imp <- tyann.s_imp;

  top.ok = e.ok && tyann.ok && tyann.type.eq(e.type);
  top.type = tyann.type;
}

production bind
top::Bind ::= x::String e::Expr
{
{-
  e.env = top.env;

  top.outEnv = addVar(top.bindEnv, x, top);
  top.bindsOut = addVar(top.bindsIn, x, top);

  top.type = e.type;
  top.ok = e.ok;
-}
  local var::Scope = scopeVar(x, top);
  --var.lex = []; var.var = [];
  --var.mod = []; var.imp = [];
  var.edges := mapCons("lex", [],
               mapCons("var", [],
               mapCons("mod", [],
               mapLast("imp", []))));

  top.s_def_lex := [];
  top.s_def_var := [var];
  top.s_def_mod := [];
  top.s_def_imp := [];

  e.s = top.s;
  top.s_lex := e.s_lex; top.s_var := e.s_var;
  top.s_mod := e.s_mod; top.s_imp := e.s_imp;

  top.ok = e.ok;
  top.type = e.type;
}

production bindArgDcl
top::Bind ::= x::String tyann::TypeExpr
{
{-
  tyann.env = top.env;

  top.outEnv = addVar(top.bindEnv, x, top);
  top.bindsOut = addVar(top.bindsIn, x, top);

  top.type = tyann.type;
  top.ok = true;
-}
  local var::Scope = scopeVar(x, top);
  --var.lex = []; var.var = [];
  --var.mod = []; var.imp = [];
  var.edges := mapCons("lex", [],
               mapCons("var", [],
               mapCons("mod", [],
               mapLast("imp", []))));

  top.s_def_lex := [];
  top.s_def_var := [var];
  top.s_def_mod := [];
  top.s_def_imp := [];

  tyann.s = top.s;
  top.s_lex := tyann.s_lex; top.s_var := tyann.s_var;
  top.s_mod := tyann.s_mod; top.s_imp := tyann.s_imp;

  top.ok = tyann.ok;
  top.type = tyann.type;
}

--------------------------------------------------

nonterminal TypeExpr with location, ok, type,
  s, s_lex, s_var, s_mod, s_imp;

production teFloat
top::TypeExpr ::= 
{
  top.ok = true;
  top.type = tFloat();

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}

production teInt
top::TypeExpr ::= 
{
  top.ok = true;
  top.type = tInt();

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}

production teBool
top::TypeExpr ::= 
{
  top.ok = true;
  top.type = tBool();

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}

production teFun
top::TypeExpr ::= te1::TypeExpr te2::TypeExpr 
{
  top.ok = true;
  top.type = tFun(te1.type, te2.type);

  te1.s = top.s;
  top.s_lex := te1.s_lex; top.s_var := te1.s_var;
  top.s_mod := te1.s_mod; top.s_imp := te1.s_imp;

  te2.s =  top.s;
  top.s_lex <- te2.s_lex; top.s_var <- te2.s_var;
  top.s_mod <- te2.s_mod; top.s_imp <- te2.s_imp;
}

--------------------------------------------------

nonterminal Type with pp, eq;

production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  top.eq = \t::Type ->
    case t of
      tFun(t1, t2) -> tyann1.eq(^t1) && tyann2.eq(^t2)
    | _ -> false
    end;

  top.pp =
    case tyann1 of
      tFun(_, _) -> "(" ++ tyann1.pp ++ ") -> " ++ tyann2.pp
    | _ -> tyann1.pp ++ " -> " ++ tyann2.pp
    end;
}

production tFloat
top::Type ::=
{
  top.eq = \t::Type -> case t of tFloat() -> true | _ -> false end;
  top.pp = "float";
}

production tInt
top::Type ::=
{
  top.eq = \t::Type -> case t of tInt() -> true | _ -> false end;
  top.pp = "int";
}

production tBool
top::Type ::=
{
  top.eq = \t::Type -> case t of tBool() -> true | _ -> false end;
  top.pp = "bool";
}

production tErr
top::Type ::=
{
  top.eq = \t::Type -> false;
  top.pp = "<err>";
}

--------------------------------------------------

nonterminal ModRef with location, ok,
  s, s_lex, s_var, s_mod, s_imp,
  s_def, s_def_lex, s_def_var, s_def_mod, s_def_imp;

production modRef
top::ModRef ::= x::String
{
{-
  local res::Maybe<Decorated Module> = top.env.lookupEnvMod(x);

  top.outEnv = case res of
                 just(m) -> newScope(m.fields)
               | _ -> top.env
               end;

  top.ok =
    unsafeTracePrint(
      res.isJust,
      "Resolution of module " ++ x ++ " on line " ++
        top.location.unparse ++ (if res.isJust then " found" else " not found") ++ "\n");
-}
  local res::[Decorated Scope] = 
    queryVisible(
      regexCatFun(
        regexStarFun(regexLexFun()),
        regexCatFun(
          regexMaybeFun(regexImpFun()),
          regexModFun()
        )
      ),
      \d::Datum -> case d of datumMod(x_, _) -> x == x_ | _ -> false end,
      lmOrd,
      top.s
    );

  top.ok = length(res) == 1;

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];

  top.s_def_lex := []; top.s_def_var := [];
  top.s_def_mod := []; top.s_def_imp := if top.ok then res else [];
}

--------------------------------------------------

nonterminal VarRef with location, ok, type,
  s, s_lex, s_var, s_mod, s_imp;

production varRef
top::VarRef ::= x::String
{
{-
  local res::Maybe<Decorated Bind> = top.env.lookupEnvVar(x);

  top.type = typeIfJust(res);

  top.ok =
    unsafeTracePrint(
      res.isJust,
      "Resolution of variable " ++ x ++ " on line " ++
        top.location.unparse ++ (if res.isJust then " found" else " not found") ++ "\n");
-}
  local res::[Decorated Scope] = 
    queryVisible(
      regexCatFun(
        regexStarFun(regexLexFun()),
        regexCatFun(
          regexMaybeFun(regexImpFun()),
          regexVarFun()
        )
      ),
      \d::Datum -> case d of datumVar(x_, _) -> x == x_ | _ -> false end,
      lmOrd,
      top.s
    );

  top.ok = length(res) == 1;
  top.type = typeIfSingleton(res);

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}

--------------------------------------------------


fun typeIfSingleton Type ::= res::[Decorated Scope] =
  case res of
    [s] -> case s.datum of datumVar(_, node) -> node.type | _ -> tErr() end 
  | _ -> tErr()
  end;
