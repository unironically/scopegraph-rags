grammar lmr1:lmr:extension_records;

imports silver:langutil; -- for location.unparse
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

nonterminal Record with location, ok, env, outEnv, fields, bindsIn, bindsOut, type;

production record
top::Record ::= x::String fields::Fields
{
  fields.env = top.env;
  fields.bindsIn = newEnv();

  top.outEnv = addRec(top.env, x, top);
  top.bindsOut = addRec(top.env, x, top);

  top.fields = fields.bindsOut;

  local recTy::Type = tRecord(x, fields.bindsOut);
  recTy.env = top.env;

  top.type = recTy;

  top.ok = fields.ok;
}

production recordExt
top::Record ::= x::String par::String fields::Fields
{
  local resPar::Maybe<Decorated Record> = top.env.lookupEnvRec(par);

  fields.env = top.env;
  fields.bindsIn = fieldsIfJust(resPar);

  top.outEnv = addRec(top.env, x, top);
  top.bindsOut = addRec(top.env, x, top);

  top.fields = fields.bindsOut;

  local recTy::Type = tRecord(x, fields.bindsOut);
  recTy.env = top.env;

  top.type = recTy;

  top.ok = resPar.isJust && fields.ok;
}

--------------------------------------------------

nonterminal Fields with location, ok, env, bindsIn, bindsOut;

production fieldsCons
top::Fields ::= x::String ty::Type rest::Fields
{
  ty.env = top.env;

  rest.env = top.env;
  rest.bindsIn = addRecBind(top.bindsIn, x, ty).bindsOut;

  top.bindsOut = rest.bindsOut;

  -- todo - no dupl check
  top.ok = rest.ok;
}

production fieldsOne
top::Fields ::= x::String ty::Type
{
  ty.env = top.env;

  top.bindsOut = addRecBind(top.bindsIn, x, ty).bindsOut;

  -- todo - no dupl check
  top.ok = true;
}

fun addRecBind Decorated Bind ::= inEnv::Env x::String ty::Decorated Type =
  let newBind::Bind = bindArgDcl(x, ^ty, location=bogusLoc()) in
    decorate newBind with { env = ty.env; bindsIn = inEnv; bindEnv = newEnv(); }
  end
;

--------------------------------------------------

production exprRecord
top::Expr ::= name::String flds::FieldExprs
{
  local res::Maybe<Decorated Record> = top.env.lookupEnvRec(name);

  flds.env = top.env;
  flds.bindEnv = fieldsIfJust(res);

  top.type = if res.isJust then res.fromJust.type else decTErr();

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

  top.bindsOut = fieldsFromRecRes(res, top.env);
    
  top.ok = r.ok && res.isJust;
}

production recAccessLHS
top::RecAccessLHS ::= x::String
{
  local res::Maybe<Decorated Bind> = top.env.lookupEnvVar(x);

  local nextEnv::Env = fieldsFromRecRes(res, top.env);

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

  top.type = if res.isJust then res.fromJust.type else decTErr();

  top.ok = lhs.ok && res.isJust;
}

--------------------------------------------------

production tRecord
top::Type ::= name::String fldEnv::Env
{
  top.pp = name;

  top.eq = \t::Decorated Type ->
    case t of
      tRecord(n, _) -> n == name -- todo - fields eq
    | tErr() -> true
    | _ -> false
    end;
}

production tRecordLookup
top::Type ::= name::String
{
  forwards to
    case top.env.lookupEnvRec(name) of
      just(r) -> tRecord(name, r.fields)
    | _ -> tRecord("<err>", newEnv())
    end;
}

--------------------------------------------------

fun fieldsIfJust Env ::= res::Maybe<Decorated Record> =
  if res.isJust then res.fromJust.fields else newEnv()
;

fun fieldsFromRecRes Env ::= res::Maybe<Decorated Bind> env::Env =
  case res of
    just(b) ->
      case b.type of
        tRecord(r, env) -> ^env
      | _ -> newEnv()
      end
  | _ -> newEnv()
  end;
