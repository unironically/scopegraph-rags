grammar ocaml:abstractsyntax;

imports silver:compiler:extension:scopegraphs;

--

scope labels 
  `lex,   -- lexical parenthood
  `ty,    -- type definition
  `con,   -- type constructor
  `var,   -- variable declaration
  `or,    -- links sides of or pattern
  `plex,  -- lexical parenthood within patterns
  `comma, -- points to scopes for either side of comma pattern
  `left   -- right side of comma pattern points to left side
as Labs;

--

synthesized attribute name::String occurs on Datum;

production datumTypeDef
top::Datum ::= name::String node::Decorated TypeDef 
{ top.name = name; }

production datumConstructor
top::Datum ::= name::String ty::String node::Decorated ConstructorDecl
{ top.name = name; }

production datumPatternVar
top::Datum ::= name::String node::Decorated Pattern
{ top.name = name; }

production datumLetVar
top::Datum ::= name::String t::Type
{ top.name = name; }

aspect default production top::Datum ::=
{ top.name = error("Default name demanded for Datum"); }
