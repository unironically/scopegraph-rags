grammar lmr1:lmr:nameanalysis_kastenswaite;

--------------------------------------------------

synthesized attribute pp::String;
synthesized attribute ok::Boolean;

inherited attribute env::Env;         -- scope to lookup in
inherited attribute bindEnv::Env;     -- scope to add binds to

inherited attribute bindsIn::Env;     -- Module members threading down
synthesized attribute bindsOut::Env;  -- Module members threading up

synthesized attribute outEnv::Env;    -- Env coming up from a declaration to pass down to next
synthesized attribute type::Type;     -- Type of an expression

--------------------------------------------------

nonterminal Main with location, ok;

production program
top::Main ::= ds::Decls
{
  top.ok = ds.ok;

  ds.env = newEnv();
  ds.bindsIn = newEnv();
}

--------------------------------------------------


nonterminal Decls with location, ok, env, outEnv, bindsIn, bindsOut;

production declsCons
top::Decls ::= d::Decl ds::Decls
{
  d.env = top.env;
  d.bindsIn = top.bindsIn;

  ds.env = newScope(d.outEnv);
  ds.bindsIn = d.bindsOut;

  top.outEnv = ds.outEnv;
  top.bindsOut = ds.bindsOut;

  top.ok = d.ok && ds.ok;
}

production declsNil
top::Decls ::=
{
  top.outEnv = top.env;
  top.bindsOut = top.bindsIn;

  top.ok = true;
}

--------------------------------------------------

nonterminal Decl with location, ok, env, outEnv, bindsIn, bindsOut;

production declModule
top::Decl ::= m::Module
{
  m.env = top.env;
  m.bindsIn = top.bindsIn;

  top.outEnv = m.outEnv;
  top.bindsOut = m.bindsOut;

  top.ok = m.ok;
}

production declImport
top::Decl ::= mr::ModRef
{
  mr.env = top.env;

  top.outEnv = mr.outEnv;
  top.bindsOut = top.bindsIn;

  top.ok = mr.ok;
}

production declDef
top::Decl ::= b::Bind
{
  b.env = top.env;
  b.bindEnv = top.env;
  b.bindsIn = top.bindsIn;

  top.outEnv = b.outEnv;
  top.bindsOut = b.bindsOut;

  top.ok = b.ok;
}

--------------------------------------------------

synthesized attribute fields::Env;

nonterminal Module with location, ok, env, outEnv, fields, bindsIn, bindsOut;

production module
top::Module ::= x::String ds::Decls
{
  ds.env = newScope(top.env);
  ds.bindsIn = newEnv();

  top.outEnv = addMod(top.env, x, top);
  top.bindsOut = addMod(top.env, x, top);

  top.fields = ds.bindsOut;

  top.ok = ds.ok;
}

--------------------------------------------------

nonterminal Expr with location, ok, env, type;

production exprVar
top::Expr ::= r::VarRef
{
  r.env = top.env;

  top.ok = r.ok;
  top.type = r.type;
}

production exprFloat
top::Expr ::= f::Float
{
  top.ok = true;
  top.type = tFloat();
}

production exprInt
top::Expr ::= i::Integer
{
  top.ok = true;
  top.type = tInt();
}

production exprTrue
top::Expr ::=
{
  top.ok = true;
  top.type = tBool();
}

production exprFalse
top::Expr ::=
{
  top.ok = true;
  top.type = tBool();
}

production exprAdd
top::Expr ::= e1::Expr e2::Expr
{
  e1.env = top.env;
  e2.env = top.env;
  
  top.type = case e1.type, e2.type of
               tInt(), tInt() -> tInt()
             | tInt(), tFloat() -> tInt()
             | tFloat(), tInt() -> tInt()
             | tFloat(), tFloat() -> tFloat()
             | _, _ -> tErr()
             end;
  top.ok = e1.ok && e2.ok && top.type != tErr();
}

production exprAnd
top::Expr ::= e1::Expr e2::Expr
{
  e1.env = top.env;
  e2.env = top.env;
  
  top.type = tBool();
  top.ok = e1.ok && e2.ok &&
           e1.type == tBool() && e2.type == tBool();
}

production exprEq
top::Expr ::= e1::Expr e2::Expr
{
  e1.env = top.env;
  e2.env = top.env;
  
  top.type = tBool();
  top.ok = e1.ok && e2.ok &&
           e1.type == e2.type;
}

production exprFun
top::Expr ::= b::Bind e::Expr
{
  b.env = top.env;
  b.bindEnv = newScope(top.env);
  b.bindsIn = newEnv();

  e.env = b.outEnv;

  top.type = tFun(b.type, e.type);
  top.ok = b.ok && e.ok;
}

production exprApp
top::Expr ::= e1::Expr e2::Expr
{
  e1.env = top.env;
  e2.env = top.env;

  top.type = case e1.type of
             | tFun(_, tOut) -> ^tOut
             | _ -> tErr()
             end;
  top.ok = e1.ok && e2.ok &&
           case e1.type, e2.type of
           | tFun(tIn, tOut), tArg -> tArg == ^tIn
           | _, _ -> false
           end;
}

production exprIf
top::Expr ::= e1::Expr e2::Expr e3::Expr
{
  e1.env = top.env;
  e2.env = top.env;
  e3.env = top.env;

  top.type = if e2.type == e3.type then e2.type else tErr();
  top.ok = e1.ok && e2.ok && e3.ok && 
           e1.type == tBool() && e2.type == e3.type;
}

production exprLet
top::Expr ::= bs::Binds e::Expr
{
  bs.env = top.env;

  e.env = bs.outEnv;

  top.type = e.type;
  top.ok = bs.ok && e.ok;
}

production exprLetRec
top::Expr ::= bs::ParBinds e::Expr
{
  nondecorated local bindEnv::Env = newScope(top.env);

  bs.env = bs.outEnv;
  bs.bindEnv = newScope(top.env);

  e.env = bs.outEnv;

  top.type = e.type;
  top.ok = bs.ok && e.ok;
}

production exprLetPar
top::Expr ::= bs::ParBinds e::Expr
{
  nondecorated local bindEnv::Env = newScope(top.env);

  bs.env = top.env;
  bs.bindEnv = newScope(top.env);

  e.env = newScope(bs.outEnv);

  top.type = e.type;
  top.ok = bs.ok && e.ok;
}

--------------------------------------------------

nonterminal Binds with location, ok, env, outEnv;

production seqBindsCons
top::Binds ::= b::Bind bs::Binds
{
  b.env = top.env;
  b.bindEnv = newScope(top.env);
  b.bindsIn = newEnv();

  bs.env = b.outEnv;

  top.outEnv = bs.outEnv;
  top.ok = b.ok && bs.ok;
}

production seqBindsLast
top::Binds ::= b::Bind
{
  b.env = top.env;
  b.bindEnv = newScope(top.env);
  b.bindsIn = newEnv();

  top.outEnv = b.outEnv;
  top.ok = b.ok;
}

production seqBindsNil
top::Binds ::=
{
  top.outEnv = top.env;
  top.ok = true;
}

--------------------------------------------------

nonterminal ParBinds with location, ok, env, outEnv, bindEnv;

production parBindsCons
top::ParBinds ::= b::Bind bs::ParBinds
{
  b.env = top.env;
  b.bindEnv = top.bindEnv;
  b.bindsIn = newEnv();

  bs.env = top.env;
  bs.bindEnv = b.outEnv;

  top.outEnv = bs.outEnv;
  top.ok = b.ok && bs.ok;
}

production parBindsLast
top::ParBinds ::= b::Bind
{
  b.env = top.env;
  b.bindEnv = top.bindEnv;
  b.bindsIn = newEnv();

  top.outEnv = b.outEnv;
  top.ok = b.ok;
}

production parBindsNil
top::ParBinds ::=
{
  top.outEnv = top.bindEnv;
  top.ok = true;
}

--------------------------------------------------

nonterminal Bind with location, ok, env, bindEnv, outEnv, type, bindsOut, bindsIn;

production bindTyped
top::Bind ::= tyann::Type x::String e::Expr
{
  e.env = top.env;

  top.outEnv = addVar(top.bindEnv, x, top);
  top.bindsOut = addVar(top.bindsIn, x, top);

  top.type = ^tyann;
  top.ok = e.ok && ^tyann == e.type;
}

production bind
top::Bind ::= x::String e::Expr
{
  e.env =  top.env;

  top.outEnv = addVar(top.bindEnv, x, top);
  top.bindsOut = addVar(top.bindsIn, x, top);

  top.type = e.type;
  top.ok = e.ok;
}

production bindArgDcl
top::Bind ::= x::String tyann::Type
{
  top.outEnv = addVar(top.bindEnv, x, top);
  top.bindsOut = addVar(top.bindsIn, x, top);

  top.type = ^tyann;
  top.ok = true;
}

--------------------------------------------------

nonterminal Type with pp;

production tFun
top::Type ::= tyann1::Type tyann2::Type
{
  top.pp =
    case tyann1 of
    | tFun(_, _) -> "(" ++ tyann1.pp ++ ") -> " ++ tyann2.pp
    | _ -> tyann1.pp ++ " -> " ++ tyann2.pp
    end;
}

production tFloat
top::Type ::=
{
  top.pp = "float";
}

production tInt
top::Type ::=
{
  top.pp = "int";
}

production tBool
top::Type ::=
{
  top.pp = "bool";
}

production tErr
top::Type ::=
{
  top.pp = "<err>";
}

fun eqType Boolean ::= t1::Type t2::Type =
  case t1, t2 of
  | tFloat(), tFloat() -> true
  | tInt(), tInt() -> true
  | tBool(), tBool() -> true
  | tFun(t1_1, t1_2), tFun(t2_1, t2_2) -> eqType(^t1_1, ^t2_1) && eqType(^t1_2, ^t2_2)
  | tErr(), tErr() -> true
  | _, _ -> false
  end;

instance Eq Type {
  eq = eqType;
}

--------------------------------------------------

nonterminal ModRef with location, ok, env, outEnv;

production modRef
top::ModRef ::= x::String
{
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
}

--------------------------------------------------

nonterminal VarRef with location, ok, env, type;

production varRef
top::VarRef ::= x::String
{
  local res::Maybe<Decorated Bind> = top.env.lookupEnvVar(x);

  top.type = case res of
               just(b) -> b.type
             | _ -> tErr()
             end;

  top.ok =
    unsafeTracePrint(
      res.isJust,
      "Resolution of variable " ++ x ++ " on line " ++
        top.location.unparse ++ (if res.isJust then " found" else " not found") ++ "\n");
}
