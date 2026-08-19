grammar lmr1:lmr:extension_records_sg;

imports silver:langutil; -- for location.unparse
exports lmr1:lmr:nameanalysis_hardcoded;

--------------------------------------------------

-- inherited attribute s::Decorated Scope;
monoid attribute s_rec::[Decorated Scope] with [], ++;

-- inherited attribute s_def::Decorated Scope;
monoid attribute s_def_rec::[Decorated Scope] with [], ++;
monoid attribute s_def_flds::[Decorated Scope] with [], ++;

-- inherited attribute s_module::Decorated Scope;
monoid attribute s_module_rec::[Decorated Scope] with [], ++;

-- inherited attribute s_final::Decorated Scope;
monoid attribute s_final_rec::[Decorated Scope] with [], ++;

--------------------------------------------------

aspect production program
top::Main ::= ds::Decls
{
  -- contribute extension edges to host's global scope
  glob.edges <- mapLast("rec", ds.s_rec);
} 

--------------------------------------------------

attribute s_rec occurs on Decls;
attribute s_module_rec occurs on Decls;

aspect production declsCons
top::Decls ::= d::Decl ds::Decls
{
  -- contribute extension edges to host's sequential decls scope
  next.edges <- mapLast("rec", d.s_def_rec ++ ds.s_rec);

  top.s_rec := d.s_rec;
  top.s_module_rec := d.s_module_rec ++ ds.s_module_rec;
}

aspect production declsNil
top::Decls ::=
{
  propagate s_rec, s_module_rec;
}

--------------------------------------------------

attribute s_rec occurs on Decl;
propagate s_rec on Decl;

attribute s_def_rec occurs on Decl;
propagate s_def_rec on Decl;

attribute s_module_rec occurs on Decl;
propagate s_module_rec on Decl;

production declRecord
top::Decl ::= r::Record
{
  r.s = top.s;
  r.s_def = top.s_def;
  r.s_module = top.s_module;

  top.ok = r.ok;

  propagate s_lex, s_var, s_mod, s_imp,
            s_def_lex, s_def_var, s_def_mod, s_def_imp,
            s_module_lex, s_module_var, s_module_mod, s_module_imp;
}

--------------------------------------------------

nonterminal Record with location, ok, type,
  s, 
  s_def, s_def_rec,
  s_module, s_module_rec;

production record
top::Record ::= x::String fields::Fields
{
  production attribute rec::Scope = scopeRec(x, top);
  rec.edges := mapLast("fld", fields.s_def_flds);

  fields.s = top.s;
  fields.s_def = rec;

  top.ok = fields.ok;

  top.type = tRecord(x, rec);

  top.s_def_rec := [rec];
  top.s_module_rec := [rec];
}

production recordExt
top::Record ::= x::String par::String fields::Fields
{
  -- lex* imp? rec
  local res::[Decorated Scope] = 
    queryVisible(
      regexCatFun(
        regexStarFun(regexLexFun()),
        regexCatFun(
          regexMaybeFun(regexImpFun()),
          regexRecFun()
        )
      ),
      \d::Datum -> case d of
                     datumRec(x_, _) -> par == x_
                   | _ -> false
                   end,
      lmOrd,
      top.s
    );
  
  local parScope::Decorated Scope =
    if length(res) == 1
    then head(res)
    else deadScope;

  production attribute rec::Scope = scopeRec(x, top);
  rec.edges := mapCons("rec", [parScope],
               mapLast("fld", fields.s_def_flds));

  fields.s = top.s;
  fields.s_def = rec;

  top.ok = fields.ok;

  top.type = tRecord(x, rec);

  top.s_def_rec := [rec];
  top.s_module_rec := [rec];
}

--------------------------------------------------

nonterminal Fields with location, ok, type,
  s,
  s_def, s_def_flds;

propagate s, s_def, s_def_flds on Fields;

production fieldsCons
top::Fields ::= x::String ty::TypeExpr rest::Fields
{
  production attribute fld::Scope = scopeFld(x, top);
  fld.edges := mapNone();

  top.ok = ty.ok && rest.ok;

  top.type = ty.type;

  top.s_def_flds <- [fld];
}

production fieldsOne
top::Fields ::= x::String ty::TypeExpr
{
  production attribute fld::Scope = scopeFld(x, top);
  fld.edges := mapNone();

  top.ok = ty.ok;

  top.type = ty.type;

  top.s_def_flds <- [fld];
}

--------------------------------------------------

production exprRecord
top::Expr ::= x::String flds::FieldExprs
{
  -- lex* imp? rec
  local res::[Decorated Scope] = 
    queryVisible(
      regexCatFun(
        regexStarFun(regexLexFun()),
        regexCatFun(
          regexMaybeFun(regexImpFun()),
          regexRecFun()
        )
      ),
      \d::Datum -> case d of
                     datumRec(x_, _) -> x == x_
                   | _ -> false
                   end,
      lmOrd,
      top.s
    );

  flds.s = top.s;
  flds.s_def = case res of
                 [s] -> s
               | _ -> deadScope
               end;

  top.ok = length(res) == 1 && flds.ok;

  top.type =
    case res of
      [s] -> case s.datum of
               datumRec(_, node) -> node.type
             | _ -> tErr()
             end
    | _ -> tErr()
    end;

  propagate s_lex, s_var, s_mod, s_imp;
}

production exprRecordAccess
top::Expr ::= r::RecAccess
{
  r.s = top.s;

  top.type = r.type;

  top.ok = r.ok;

  propagate s_lex, s_var, s_mod, s_imp;
}

--------------------------------------------------

nonterminal FieldExprs with location, ok, s, s_def;

production fieldExprsCons
top::FieldExprs ::= x::String e::Expr rest::FieldExprs
{
  -- rec* fld
  local res::[Decorated Scope] = 
    queryReachable(
      regexCatFun(regexStarFun(regexRecFun()), regexFldFun()),
      \d::Datum -> case d of
                     datumFld(x_, _) -> x == x_
                   | _ -> false
                   end,
      top.s_def
    );

  nondecorated local resTy::Type = 
    case res of
      [s] -> case s.datum of
               datumFld(_, node) -> node.type
             | _ -> tErr()
             end
    | _ -> tErr()
    end;

  e.s = top.s;

  rest.s = top.s;
  rest.s_def = top.s_def;

  top.ok = rest.ok && e.ok && length(res) == 1 && resTy.eq(e.type);
}

production fieldExprsOne
top::FieldExprs ::= x::String e::Expr
{
  -- rec* fld
  local res::[Decorated Scope] = 
    queryReachable(
      regexCatFun(regexStarFun(regexRecFun()), regexFldFun()),
      \d::Datum -> case d of
                     datumFld(x_, _) -> x == x_
                   | _ -> false
                   end,
      top.s_def
    );

  nondecorated local resTy::Type = 
    case res of
      [s] -> case s.datum of
               datumFld(_, node) -> node.type
             | _ -> tErr()
             end
    | _ -> tErr()
    end;

  e.s = top.s;

  top.ok = e.ok && length(res) == 1 && resTy.eq(e.type);
}

--------------------------------------------------

synthesized attribute s_qual::Decorated Scope;

nonterminal RecAccessLHS with location, ok, s, s_qual;

production recAccessLHSQual
top::RecAccessLHS ::= r::RecAccessLHS x::String
{
  -- rec* fld
  local res::[Decorated Scope] = 
    queryVisible(
      regexCatFun(regexStarFun(regexRecFun()), regexFldFun()),
      \d::Datum -> case d of
                     datumFld(x_, _) -> x == x_
                   | _ -> false
                   end,
      lmOrd,
      r.s_qual
    );

  top.s_qual = 
    case res of
      [s] -> case s.datum of
               datumFld(_, node) ->
                 case node.type of
                   tRecord(_, noderec) -> noderec
                 | _ -> deadScope
                 end
             | _ -> deadScope
             end
    | _ -> deadScope
    end;

  top.ok = r.ok && length(res) == 1;
}

production recAccessLHS
top::RecAccessLHS ::= x::String
{
  -- LEX* IMP? VAR
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

  top.s_qual = 
    case res of
      [s] -> case s.datum of
               datumVar(_, node) -> case node.type of
                                      tRecord(_, s) -> s
                                    | _ -> deadScope
                                    end
             | _ -> deadScope
             end
    | _ -> deadScope
    end;

  top.ok = length(res) == 1;
}

--

nonterminal RecAccess with location, ok, type, s;

production recAccess
top::RecAccess ::= lhs::RecAccessLHS x::String
{
  lhs.s = top.s;

  -- rec* fld
  local res::[Decorated Scope] = 
    queryVisible(
      regexCatFun(regexStarFun(regexRecFun()), regexFldFun()),
      \d::Datum -> case d of
                     datumFld(x_, _) -> x == x_
                   | _ -> false
                   end,
      lmOrd,
      lhs.s_qual
    );

  top.ok = lhs.ok && length(res) == 1;
  
  top.type =
    case res of
      [s] -> case s.datum of
               datumFld(_, node) -> node.type
             | _ -> tErr()
             end
    | _ -> tErr()
    end;
}

--------------------------------------------------
--------------------------------------------------

production tRecord
top::Type ::= name::String s::Decorated Scope
{
  top.pp = name;

  top.eq = \t::Type ->
    case t of
      tRecord(n, _) -> n == name -- todo - fields eq
    | _ -> false
    end;
}

--------------------------------------------------

production teRecord
top::TypeExpr ::= x::String
{
  -- lex* imp? rec
  local res::[Decorated Scope] = 
    queryVisible(
      regexCatFun(
        regexStarFun(regexLexFun()),
        regexCatFun(
          regexMaybeFun(regexImpFun()),
          regexRecFun()
        )
      ),
      \d::Datum -> case d of
                     datumRec(x_, _) -> x == x_
                   | _ -> false
                   end,
      lmOrd,
      top.s
    );

  top.ok = length(res) == 1;

  top.type = 
    case res of
      [s] -> case s.datum of
               datumRec(_, node) -> node.type
             | _ -> unsafeTracePrint(tErr(), "bladdy ell te " ++ x ++ " was not datumRec...\n")
             end
    | _ -> unsafeTracePrint(tErr(), "bladdy ell te " ++ x ++ " was not singleton...\n")
    end;

  top.s_lex := []; top.s_var := [];
  top.s_mod := []; top.s_imp := [];
}
