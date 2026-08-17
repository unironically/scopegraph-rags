grammar lmr1:lmr:extension_records_sg;

imports silver:langutil; -- for location.unparse
exports lmr1:lmr:nameanalysis_hardcoded;

--------------------------------------------------

production declRecord
top::Decl ::= r::Record
{
{-
  r.env = top.env;
  r.bindsIn = top.bindsIn;

  top.outEnv = r.outEnv;
  top.bindsOut = r.bindsOut;

  top.ok = r.ok;
-}
}

--------------------------------------------------

nonterminal Record with location;

production record
top::Record ::= x::String fields::Fields
{
{-
  fields.env = top.env;
  fields.bindsIn = newEnv();

  top.outEnv = addRec(top.env, x, top);
  top.bindsOut = addRec(top.env, x, top);

  top.fields = fields.bindsOut;

  top.type = tRecord(x, fields.bindsOut);

  top.ok = fields.ok;
-}
}

production recordExt
top::Record ::= x::String par::String fields::Fields
{
{-
  local resPar::Maybe<Decorated Record> = top.env.lookupEnvRec(par);

  fields.env = top.env;
  fields.bindsIn = fieldsIfJust(resPar);

  top.outEnv = addRec(top.env, x, top);
  top.bindsOut = addRec(top.env, x, top);

  top.fields = fields.bindsOut;

  top.type = tRecord(x, fields.bindsOut);

  top.ok = resPar.isJust && fields.ok;
-}
}

--------------------------------------------------

nonterminal Fields with location;

production fieldsCons
top::Fields ::= x::String ty::TypeExpr rest::Fields
{
{-
  ty.env = top.env;

  rest.env = top.env;
  rest.bindsIn = addRecBind(top.bindsIn, top.env, x, ^ty).bindsOut;

  top.bindsOut = rest.bindsOut;

  -- todo - no dupl check
  top.ok = rest.ok;
-}
}

production fieldsOne
top::Fields ::= x::String ty::TypeExpr
{
{-
  ty.env = top.env;

  top.bindsOut = addRecBind(top.bindsIn, top.env, x, ^ty).bindsOut;

  -- todo - no dupl check
  top.ok = true;
-}
}

{-
fun addRecBind Decorated Bind ::= fldsEnv::Env env::Env x::String ty::TypeExpr =
  let newBind::Bind = bindArgDcl(x, ty, location=bogusLoc()) in
    decorate newBind with { env = env; bindsIn = fldsEnv; bindEnv = newEnv(); }
  end
;
-}

--------------------------------------------------

production exprRecord
top::Expr ::= name::String flds::FieldExprs
{
{-
  local res::Maybe<Decorated Record> = top.env.lookupEnvRec(name);

  flds.env = top.env;
  flds.bindEnv = fieldsIfJust(res);

  top.type = if res.isJust then res.fromJust.type else tErr();

  -- todo - check flds.defined covers all fields of resolved record
  top.ok = res.isJust && flds.ok;
-}
}

production exprRecordAccess
top::Expr ::= r::RecAccess
{
{-
  r.env = top.env;

  top.type = r.type;

  top.ok = r.ok;
-}
}

--------------------------------------------------

nonterminal FieldExprs with location;

production fieldExprsCons
top::FieldExprs ::= x::String e::Expr rest::FieldExprs
{
{-
  e.env = top.env;

  rest.env = top.env;
  rest.bindEnv = top.bindEnv;

  local res::Maybe<Decorated Bind> = top.bindEnv.lookupEnvVar(x);

  local resTy::Type = res.fromJust.type;
  resTy.env = top.env;

  top.ok = res.isJust && e.ok && resTy.eq(e.type) && rest.ok;
-}

}

production fieldExprsOne
top::FieldExprs ::= x::String e::Expr
{
{-
  e.env = top.env;

  local res::Maybe<Decorated Bind> = top.bindEnv.lookupEnvVar(x);
  
  local resTy::Type = res.fromJust.type;
  resTy.env = top.env;

  top.ok = res.isJust && e.ok && resTy.eq(e.type);
-}
}

--------------------------------------------------

nonterminal RecAccessLHS with location;

production recAccessLHSQual
top::RecAccessLHS ::= r::RecAccessLHS x::String
{
{-
  r.env = top.env;

  local res::Maybe<Decorated Bind> = r.bindsOut.lookupEnvVar(x);

  top.bindsOut = fieldsFromRecRes(res, top.env);
    
  top.ok = r.ok && res.isJust;
-}
}

production recAccessLHS
top::RecAccessLHS ::= x::String
{
{-
  local res::Maybe<Decorated Bind> = top.env.lookupEnvVar(x);

  local nextEnv::Env = fieldsFromRecRes(res, top.env);

  top.bindsOut = ^nextEnv;

  top.ok = res.isJust;
-}
}

--

nonterminal RecAccess with location;

production recAccess
top::RecAccess ::= lhs::RecAccessLHS x::String
{
{-
  lhs.env = top.env;

  local res::Maybe<Decorated Bind> = lhs.bindsOut.lookupEnvVar(x);

  top.type = if res.isJust then res.fromJust.type else tErr();

  top.ok = lhs.ok && res.isJust;
-}
}

--------------------------------------------------

production tRecord
top::Type ::= name::String s::LMScope
{
{-
  top.pp = name;

  top.eq = \t::Type ->
    case t of
      tRecord(n, _) -> n == name -- todo - fields eq
    | _ -> false
    end;
-}
}

--------------------------------------------------

production teRecord
top::TypeExpr ::= x::String
{
{-
  top.type = 
    case top.env.lookupEnvRec(x) of
      just(r) -> r.type
    | _ -> tErr()
    end;
-}
}

--------------------------------------------------

{-
fun fieldsIfJust Env ::= res::Maybe<Decorated Record> =
  if res.isJust then res.fromJust.fields else newEnv()
;

fun fieldsFromRecRes Env ::= res::Maybe<Decorated Bind> env::Env =
  case res of
    just(b) ->
      case b.type of
        tRecord(r, e) -> ^e
      | _ -> newEnv()
      end
  | _ -> newEnv()
  end;
-}