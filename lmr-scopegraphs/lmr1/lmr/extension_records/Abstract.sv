grammar lmr1:lmr:extension_records;

exports lmr1:lmr:nameanalysis_kastenswaite;

--------------------------------------------------

production declRecord
top::Decl ::= r::Record
{
  r.env = top.env;
  r.bindsIn = top.bindsIn;

  top.outEnv = r.outEnv;
  top.bindsOut = r.bindsOut;

  top.ok = r.ok;
}

--------------------------------------------------

nonterminal Record with location, ok, env, outEnv, fields, bindsIn, bindsOut;

production record
top::Record ::= x::String fields::Fields
{
  fields.env = top.env;
  fields.bindsIn = newEnv();

  top.outEnv = addRec(top.env, x, top);
  top.bindsOut = addRec(top.env, x, top);

  top.fields = fields.bindsOut;

  top.ok = fields.ok;
}

production recordExt
top::Record ::= x::String par::String fields::Fields
{
  local resPar::Maybe<Decorated Record> = top.env.lookupEnvRec(par);

  fields.env = top.env;
  fields.bindsIn = if resPar.isJust then resPar.fromJust.fields else newEnv();

  top.outEnv = addRec(top.env, x, top);
  top.bindsOut = addRec(top.env, x, top);

  top.fields = fields.bindsOut;

  top.ok = resPar.isJust && fields.ok;
}

--------------------------------------------------

nonterminal Fields with location, ok, env, bindsIn, bindsOut;

production fieldsCons
top::Fields ::= x::String ty::Type rest::Fields
{
  local newBind::Bind = bindArgDcl(x, ^ty, location=bogusLoc());
  newBind.env = newEnv();
  newBind.bindsIn = top.bindsIn;

  rest.bindsIn = newBind.bindsOut;

  top.bindsOut = rest.bindsOut;

  -- todo - no dupl check
  top.ok = true;
}

production fieldsOne
top::Fields ::= x::String ty::Type
{
  local newBind::Bind = bindArgDcl(x, ^ty, location=bogusLoc());
  newBind.env = newEnv();
  newBind.bindsIn = top.bindsIn;

  top.bindsOut = newBind.bindsOut;

  -- todo - no dupl check
  top.ok = true;
}

--------------------------------------------------

production exprRecord
top::Expr ::= name::String flds::FieldExprs
{
  local res::Maybe<Decorated Record> = top.env.lookupEnvRec(name);

  flds.env = top.env; --if res.isJust then res.fromJust.fields else newEnv();
  flds.bindEnv = if res.isJust then res.fromJust.fields else newEnv();

  top.type = if res.isJust then tRecord(name) else tErr();

  -- todo - check flds.defined covers all fields of resolved record
  top.ok = res.isJust && flds.ok;
}

production exprRecordAccess
top::Expr ::= r::RecAccess
{
  r.env = top.env;

  top.type = r.type;

  top.ok = r.ok;
}

--------------------------------------------------

nonterminal FieldExprs with location, ok, env, bindEnv;

production fieldExprsCons
top::FieldExprs ::= x::String e::Expr rest::FieldExprs
{
  e.env = top.env;

  rest.env = top.env;
  rest.bindEnv = top.bindEnv;

  local res::Maybe<Decorated Bind> = top.bindEnv.lookupEnvVar(x);

  top.ok = res.isJust && e.ok && res.fromJust.type.eq(e.type) && rest.ok;
}

production fieldExprsOne
top::FieldExprs ::= x::String e::Expr
{
  e.env = top.env;

  local res::Maybe<Decorated Bind> = top.bindEnv.lookupEnvVar(x);

  top.ok = res.isJust && e.ok && res.fromJust.type.eq(e.type);
}

--------------------------------------------------

nonterminal RecAccessLHS with location, ok, env, bindsOut;

production recAccessLHSQual
top::RecAccessLHS ::= r::RecAccessLHS x::String
{
  r.env = top.env;

  local res::Maybe<Decorated Bind> = r.bindsOut.lookupEnvVar(x);

  top.bindsOut = 
    case res of
    | just(b) ->
        case b.type of
        | tRecord(r) ->
          let resRec::Maybe<Decorated Record> = top.env.lookupEnvRec(r) in
          if resRec.isJust then resRec.fromJust.fields else newEnv() end
        | _ -> newEnv()
        end
    | _ -> newEnv()
    end;
    
  top.ok = r.ok && res.isJust;
}

production recAccessLHS
top::RecAccessLHS ::= x::String
{
  local res::Maybe<Decorated Bind> = top.env.lookupEnvVar(x);

  local nextEnv::Env = 
    case res of
    | just(b) ->
        case b.type of
        | tRecord(r) ->
          let resRec::Maybe<Decorated Record> = top.env.lookupEnvRec(r) in
          if resRec.isJust then resRec.fromJust.fields else newEnv() end
        | _ -> newEnv()
        end
    | _ -> newEnv()
    end;

  top.bindsOut = ^nextEnv;

  top.ok = res.isJust;
}

--

nonterminal RecAccess with location, env, ok, type;

production recAccess
top::RecAccess ::= lhs::RecAccessLHS x::String
{
  lhs.env = top.env;

  local res::Maybe<Decorated Bind> = lhs.bindsOut.lookupEnvVar(x);

  top.type = if res.isJust then res.fromJust.type else tErr();

  top.ok = lhs.ok && res.isJust;
}

--------------------------------------------------

production tRecord
top::Type ::= name::String
{
  top.eq = \t::Type -> case t of tRecord(n) -> n == name | tErr() -> true | _ -> false end;
}
