grammar lmr1:lmr:nameanalysis5;

--

type LMInhs = {lex, var, imp, mod};

inherited attribute lex::[SGRegNode] with ++;
inherited attribute var::[Decorated SGVarNode with LMInhs] with ++;
inherited attribute mod::[Decorated SGModNode with LMInhs] with ++;
inherited attribute imp::[Decorated SGModNode with LMInhs] with ++;

synthesized attribute lexWrap::[SGRegNode];
synthesized attribute varWrap::[Decorated SGVarNode with LMInhs];
synthesized attribute modWrap::[Decorated SGModNode with LMInhs];
synthesized attribute impWrap::[Decorated SGModNode with LMInhs];

synthesized attribute name::String;

synthesized attribute astBnd::Decorated Bind;
synthesized attribute astMod::Decorated Module;

synthesized attribute asSGRegNode::SGRegNode;
synthesized attribute asSGDclNode::SGDclNode;

--------------------------------------------------------------------------------
-- classes

-- Any scope has these edges

class 
  attribute lex occurs on a, attribute var occurs on a,
  attribute mod occurs on a, attribute imp occurs on a =>
SGScope a {
}

-- Target of MOD or VAR edges

class
  SGScope a,
  attribute asSGDclNode LMInhs occurs on a,
  attribute name LMInhs occurs on a =>
SGDclTgt a {}

-- Target of LEX edges

class
  SGScope a,
  attribute asSGRegNode LMInhs occurs on a =>
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
  top.asSGRegNode = sgRegNode(top);
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

  top.asSGDclNode = sgDclNode(top);
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

  top.asSGRegNode = sgRegNode(top);
  top.asSGDclNode = sgDclNode(top);
}

------
-- dcl

nonterminal SGDclNode with lexWrap, varWrap, modWrap, impWrap, name;

production sgDclNode
SGDclTgt a =>
top::SGDclNode ::= node::Decorated a with LMInhs
{
  top.lexWrap = node.lex;
  top.varWrap = node.var;
  top.modWrap = node.mod;
  top.impWrap = node.imp;

  top.name = node.name; -- mwda error
}

--instance SGScope SGDclNode {}

------
-- reg

nonterminal SGRegNode with lexWrap, varWrap, modWrap, impWrap;

production sgRegNode
SGScope a =>
top::SGRegNode ::= node::Decorated a with LMInhs
{
  top.lexWrap = node.lex;
  top.varWrap = node.var;
  top.modWrap = node.mod;
  top.impWrap = node.imp;
}

--instance SGScope SGRegNode {}
