grammar lmr1:lmr:nameanalysis6;

--

{-

  -- Implicit abstract node Scope exists. Everything is a subtype of Scope
  -- Occurs constraints on Scope typeclass taken from edge declarations

  abstract node Region;
  abstract node Dcl with { name::String };

  node Lex is Region;
  node Var with { type::Type } is Dcl;
  node Mod with { numVars::Integer} is Dcl, Region;

  edge -[ lex ]-> Region;
  edge -[ var ]-> Var;
  edge -[ mod ]-> Mod;
  edge -[ imp ]-> Mod;

-}

inherited attribute lex::[Decorated Region];
inherited attribute var::[Decorated Var];
inherited attribute mod::[Decorated Mod];
inherited attribute imp::[Decorated Mod];

type LMEdgeLabels = {lex, var, mod, imp};

-- data:
synthesized attribute name::String;
synthesized attribute type::Type;
synthesized attribute numVars::Integer;

--

-- Any SG node
class attribute lex occurs on a, attribute var occurs on a,
      attribute mod occurs on a, attribute imp occurs on a => Scope_ a
{
  asScope :: (Decorated Scope with LMEdgeLabels ::= Decorated a with LMEdgeLabels) =
    \s::Decorated a with LMEdgeLabels ->
      decorate mkScope(s) with {lex=s.lex; var=s.var; mod=s.mod; imp=s.imp;};
}

-- Dcl_ < Scope_
class Scope_ a, attribute name {} occurs on a => Dcl_ a 
{
  asDcl :: (Decorated Dcl with LMEdgeLabels ::= Decorated a with LMEdgeLabels) = 
    \s::Decorated a with LMEdgeLabels ->
      decorate mkDcl(s) with {lex=s.lex; var=s.var; mod=s.mod; imp=s.imp;};
}

-- Region_ < Scope_
class Scope_ a => Region_ a
{
  asRegion :: (Decorated Region with LMEdgeLabels ::= Decorated a with LMEdgeLabels) =
    \s::Decorated a with LMEdgeLabels ->
      decorate mkRegion(s) with {lex=s.lex; var=s.var; mod=s.mod; imp=s.imp;};
}

-- Lex_ < Region_
class Region_ a => Lex_ a
{}

-- Var_ < Dcl_
class Dcl_ a, attribute type {} occurs on a => Var_ a
{
}

-- Mod_ < Dcl_
-- Mod_ < Region_
class Dcl_ a, Region_ a, attribute numVars {} occurs on a => Mod_ a
{
}

--

nonterminal Scope with lex, var, mod, imp;
production mkScope
Scope_ a =>
top::Scope ::= s::Decorated a with LMEdgeLabels
{}

-- Lex is a region scope with no data
nonterminal Lex with lex, var, mod, imp;
production mkLex
top::Lex ::=
{}

instance Scope_ Lex {}
instance Region_ Lex {}
instance Lex_ Lex {}

-- Region is an 'abstract' label, the prod takes as arg a valid Region (Lex or Mod)
nonterminal Region with lex, var, mod, imp;
production mkRegion
Region_ a =>
top::Region ::= r::Decorated a with LMEdgeLabels
{}

instance Scope_ Region {}
instance Region_ Region {}

-- Dcl is an 'abstract' label, the prod takes as arg a valid Dcl (Var or Mod)
nonterminal Dcl with lex, var, mod, imp, name;
production mkDcl
Dcl_ a =>
top::Dcl ::= d::Decorated a with LMEdgeLabels
{}

instance Scope_ Dcl {}
instance Dcl_ Dcl {}

-- Var is a Dcl with a type
nonterminal Var with lex, var, mod, imp, name, type;
production mkVar
top::Var ::= name::String type::Type
{ top.name = name;
  top.type = ^type; }

instance Scope_ Var {}
instance Dcl_ Var {}
instance Var_ Var {}

-- Mod is a Dcl
nonterminal Mod with lex, var, mod, imp, name, numVars;
production mkMod
top::Mod ::= name::String numVars::Integer
{ top.name = name;
  top.numVars = numVars; }

instance Scope_ Mod {}
instance Region_ Mod {}
instance Dcl_ Mod {}
instance Mod_ Mod {}
