grammar statix_translate:translation;


--------------------------------------------------


nonterminal LocalNames;

abstract production localNamesCons
top::LocalNames ::= l::LocalName ls::LocalNames
{

}

abstract production localNamesNil
top::LocalNames ::=
{

}


--------------------------------------------------


attribute name occurs on LocalName;

nonterminal LocalName;

abstract production localNameScope
top::LocalName ::= si::LocalScopeInstance
{
  top.name = si.name;
}

abstract production localNameOther
top::LocalName ::= ni::LocalNameInstance
{
  top.name = ni.name;
}


--------------------------------------------------


nonterminal LocalScopeInstance with name, scopeSource, flowsToNodes, localContribs;

synthesized attribute scopeSource::String;              -- "INH"/"SYN"/"LOCAL" - signifying where the scope instance comes from (parent/child/local)
inherited attribute flowsToNodes::[(String, String)];             -- for what children is this scope inherited by, with its local name and its name within the child
inherited attribute localContribs::[(Label, String)];   -- any edge contributions made whose source is this scope. with (label, target scope name)

abstract production localScopeInstance
top::LocalScopeInstance ::=
  name::String
  scopeSource::String
{
  -- what is its name
  top.name = name;

  -- where is its definition
  top.scopeSource = scopeSource;
}


--------------------------------------------------

-- todo

nonterminal LocalNameInstance with name;

abstract production localNameInstance
top::LocalNameInstance ::=
  name::String
{
  top.name = name;
}