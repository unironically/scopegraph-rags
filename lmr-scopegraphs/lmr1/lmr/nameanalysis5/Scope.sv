grammar lmr1:lmr:nameanalysis5;

--

--type LMScope = Decorated Scope with ScopeInhs;
--type ScopeInhs = {lex, var, mod, imp};

inherited attribute lex::[Decorated SGRegNode] with ++;-- with ++ occurs on Scope;
inherited attribute var::[Decorated SGVarNode] with ++;-- with ++ occurs on Scope;
inherited attribute mod::[Decorated SGModNode] with ++;-- with ++ occurs on Scope;
inherited attribute imp::[Decorated SGModNode] with ++;-- with ++ occurs on Scope;

synthesized attribute name::String;
synthesized attribute astBind::Decorated Bind;
synthesized attribute astModule::Decorated Module;

synthesized attribute asDcl::Decorated SGDclNode;
synthesized attribute asReg::Decorated SGRegNode;

--------------------------------------------------------------------------------

{-nonterminal Scope;

production scopeNoData
top::Scope ::=
{}

production scopeVar
top::Scope ::= name::String ty::Type
{}

production scopeMod
top::Scope ::= name::String
{}-}

--------------------------------------------------------------------------------
-- classes

class 
  attribute lex occurs on a, 
  attribute var occurs on a, 
  attribute mod occurs on a, 
  attribute imp occurs on a =>
SGScope a {
}

-- LEX

class
  SGScope a =>
SGLex a {
}

-- DCL

class
  SGScope a,
  attribute name {} occurs on a,
  attribute asDcl {} occurs on a =>
SGDcl a {
}

-- REG

class
  SGScope a,
  attribute asReg {} occurs on a =>
SGReg a {
}

-- VAR

class
  SGDcl a,
  attribute astBind {} occurs on a =>
SGVar a {
}

-- MOD

class
  SGDcl a,
  attribute astModule {} occurs on a =>
SGMod a {
}

--------------------------------------------------------------------------------
-- instances

------
-- lex

nonterminal SGLexNode with lex, var, mod, imp, asReg;

production sgLexNode
top::SGLexNode ::=
{
  top.asReg = decorate sgRegNode(top) with
              {lex = top.lex; var = top.var; mod = top.mod; imp = top.imp;};
}

instance SGScope SGLexNode {}
instance SGReg SGLexNode {}
instance SGLex SGLexNode {}

------
-- var

nonterminal SGVarNode with name, astBind, lex, var, mod, imp, asDcl;

production sgVarNode
top::SGVarNode ::= name::String astBind::Decorated Bind
{
  top.name = name;
  top.astBind = astBind;
  top.asDcl = decorate sgDclNode(top) with
              {lex = top.lex; var = top.var; mod = top.mod; imp = top.imp;};
}

instance SGScope SGVarNode {}
instance SGDcl SGVarNode {}
instance SGVar SGVarNode {}

------
-- mod

nonterminal SGModNode with name, astModule, lex, var, mod, imp, asDcl, asReg;

production sgModNode
top::SGModNode ::= name::String astModule::Decorated Module
{
  top.name = name;
  top.astModule = astModule;
  top.asDcl = decorate sgDclNode(top) with
              {lex = top.lex; var = top.var; mod = top.mod; imp = top.imp;};
  top.asReg = decorate sgRegNode(top) with
              {lex = top.lex; var = top.var; mod = top.mod; imp = top.imp;};
}

instance SGScope SGModNode {}
instance SGDcl SGModNode {}
instance SGReg SGModNode {}
instance SGMod SGModNode {}

------
-- dcl

nonterminal SGDclNode with name, lex, var, mod, imp;

production sgDclNode
SGDcl a =>
top::SGDclNode ::= node::Decorated a with {lex, var, mod, imp}
{
  top.name = node.name; -- causes error if run with mwda
}

instance SGScope SGDclNode {}

------
-- reg

nonterminal SGRegNode with lex, var, mod, imp;

production sgRegNode
SGReg a =>
top::SGRegNode ::= node::Decorated a with {lex, var, mod, imp}
{}

instance SGScope SGRegNode {}
