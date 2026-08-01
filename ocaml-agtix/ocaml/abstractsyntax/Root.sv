grammar ocaml:abstractsyntax;

--

scope attribute s;
scope attribute s_def;

monoid attribute errs::[Message];
synthesized attribute type::Type;

--

nonterminal Root with errs, location;

production root
top::Root ::= ms::ModuleItems
{
  propagate errs;

  newScope glob;

  -- int
  newScope intTyScope ->
    datumTypeDef("int", decorate typeDefBuiltin("int", location=top.location)
                        with { s = glob; s_def = glob; });
  glob -[ `ty ]-> intTyScope;
  -- bool
  newScope boolTyScope ->
    datumTypeDef("bool", decorate typeDefBuiltin("bool", location=top.location)
                         with { s = glob; s_def = glob; });
  glob -[ `ty ]-> boolTyScope;
  -- string
  newScope stringTyScope ->
    datumTypeDef("string", decorate typeDefBuiltin("string", location=top.location)
                           with { s = glob; s_def = glob; });
  glob -[ `ty ]-> stringTyScope;

  ms.s = glob;
}

--

nonterminal ModuleItems with errs, s, location;

production moduleItemsCons
top::ModuleItems ::= m::ModuleItem t::ModuleItems
{
  propagate errs;

  newScope seqScope;
  seqScope -[ `lex ]-> top.s;

  m.s = top.s;
  m.s_def = seqScope;

  t.s = seqScope;
}

production moduleItemsNil
top::ModuleItems ::=
{
  propagate errs;
}

--

nonterminal ModuleItem with errs, s, s_def, location;

production moduleItemDef
top::ModuleItem ::= d::Def
{
  propagate errs;

  d.s = top.s;
  d.s_def = top.s_def;
}

production moduleItemExpr
top::ModuleItem ::= e::Expr
{
  propagate errs;

  e.s = top.s;
  e.expectExprType = errType();
}
