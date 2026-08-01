grammar ocaml:concretesyntax;

imports ocaml:abstractsyntax;

synthesized attribute ast<a>::a;

-- https://ocaml.org/manual/5.4/language.html

--------
-- Rules

nonterminal Root_c with ast<Root>, location;

concrete production root_c
top::Root_c ::= ms::ModuleItems_c
{ top.ast = root(ms.ast, location=top.location); }

--

nonterminal ModuleItems_c with ast<ModuleItems>, location;

concrete production moduleSemi_c
top::ModuleItems_c ::= ';;' m::ModuleItems_c
{ top.ast = m.ast; }

concrete production moduleItemsCons_c
top::ModuleItems_c ::= m::ModuleItem_c t::ModuleItemsTail_c
{ top.ast = moduleItemsCons(m.ast, t.ast, location=top.location); }

concrete production moduleItemsNil_c
top::ModuleItems_c ::=
{ top.ast = moduleItemsNil(location=top.location); }

--

nonterminal ModuleItemsTail_c with ast<ModuleItems>, location;

concrete production moduleItemsTailDef_c
top::ModuleItemsTail_c ::= d::Def_c rest::ModuleItemsTail_c
{ top.ast = moduleItemsCons(moduleItemDef(d.ast, location=top.location), rest.ast, location=top.location); }

concrete production moduleItemsTailExpr_c
top::ModuleItemsTail_c ::= ';;' e::Expr_c rest::ModuleItemsTail_c
{ top.ast = moduleItemsCons(moduleItemExpr(e.ast, location=top.location), rest.ast, location=top.location); }

concrete production moduleItemsSemis_c
top::ModuleItemsTail_c ::= ';;' rest::ModuleItemsTail_c
{ top.ast = rest.ast; }

concrete production moduleItemsTailDefNil_c
top::ModuleItemsTail_c ::= 
{ top.ast = moduleItemsNil(location=top.location); }

--

nonterminal ModuleItem_c with ast<ModuleItem>, location;

concrete production moduleItemDef_c
top::ModuleItem_c ::= d::Def_c
{ top.ast = moduleItemDef(d.ast, location=top.location); }

concrete production moduleItemExpr_c
top::ModuleItem_c ::= e::Expr_c
{ top.ast = moduleItemExpr(e.ast, location=top.location); }
