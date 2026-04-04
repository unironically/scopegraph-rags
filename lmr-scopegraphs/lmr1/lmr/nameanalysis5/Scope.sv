grammar lmr1:lmr:nameanalysis5;

--

type LMInhs = {lex, var, imp, mod};

inherited attribute lex::[Decorated SGRegNode] with ++;
inherited attribute var::[Decorated SGVarNode] with ++;
inherited attribute mod::[Decorated SGModNode] with ++;
inherited attribute imp::[Decorated SGModNode] with ++;

synthesized attribute name::String;

synthesized attribute astBnd::Decorated Bind;
synthesized attribute astMod::Decorated Module;

synthesized attribute asSGRegNode::Decorated SGRegNode with LMInhs;
synthesized attribute asSGDclNode::Decorated SGDclNode with LMInhs;

--------------------------------------------------------------------------------
-- classes

-- Any scope (most general)

class 
  attribute lex occurs on a, attribute var occurs on a,
  attribute mod occurs on a, attribute imp occurs on a =>
SGScope a {
}

-- DCL

class
  SGScope a,
  attribute asSGDclNode {} occurs on a,
  attribute name {} occurs on a =>
SGDclTgt a {}

-- REG

class
  SGScope a,
  attribute asSGRegNode {} occurs on a =>
SGRegTgt a {}

--------------------------------------------------------------------------------
-- instances

------
-- lex

nonterminal SGLexNode with lex, var, mod, imp, asSGRegNode;

instance SGScope SGLexNode {}
instance SGRegTgt SGLexNode {}

production sgLexNode
top::SGLexNode ::=
{
  top.asSGRegNode = decorate sgRegNode(top) with {
    lex = top.lex; var = top.var;
    mod = top.mod; imp = top.imp;
  };
}

------
-- var

nonterminal SGVarNode with lex, var, mod, imp, name, astBnd, asSGDclNode;

instance SGScope SGVarNode {}
instance SGDclTgt SGVarNode {}

production sgVarNode
top::SGVarNode ::= astBnd::Decorated Bind
{
  top.name = astBnd.name;
  top.astBnd = astBnd;

  top.asSGDclNode = decorate sgDclNode(top) with {
    lex = top.lex; var = top.var;
    mod = top.mod; imp = top.imp;
  };
}

------
-- mod

nonterminal SGModNode with lex, var, mod, imp, name, astMod, asSGDclNode, asSGRegNode;

instance SGScope SGModNode {}
instance SGDclTgt SGModNode {}
instance SGRegTgt SGModNode {}

production sgModNode
top::SGModNode ::= astMod::Decorated Module
{
  top.name = astMod.name;
  top.astMod = astMod;

  top.asSGRegNode = decorate sgRegNode(top) with {
    lex = top.lex; var = top.var;
    mod = top.mod; imp = top.imp;
  };

  top.asSGDclNode = decorate sgDclNode(top) with {
    lex = top.lex; var = top.var;
    mod = top.mod; imp = top.imp;
  };
}

------
-- dcl

nonterminal SGDclNode with lex, var, imp, mod, name;

production sgDclNode
SGDclTgt a =>
top::SGDclNode ::= node::Decorated a with LMInhs
{
  top.name = node.name;
}

instance SGScope SGDclNode {}

------
-- reg

nonterminal SGRegNode with lex, var, mod, imp;

production sgRegNode
SGRegTgt a =>
top::SGRegNode ::= node::Decorated a with LMInhs
{
}

instance SGScope SGRegNode {}
