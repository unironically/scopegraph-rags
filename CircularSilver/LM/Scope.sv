grammar LM;


nonterminal Scope;

{-
 - Collection attributes for vars, mods, imps, lexs.
 - Each definition has a name, type, append op, initial value, and a declaration the type of the
 - LM AST node from which we will descend the tree to find contributions.
 - Attribute `imps` is declared as circular, as the resolution of an import may depend on the 
 - resolutions of other imports.
 -}
collection attribute vars::[Scope] with ++, [] root Program occurs on Scope;
collection attribute mods::[Scope] with ++, [] root Program occurs on Scope;
collection attribute circular imps::[Scope] with ++, [] root Program occurs on Scope;
collection attribute lexs::[Scope] with ++, [] root Program occurs on Scope;

{-
 - Scopes with no datum attached.
 -}
abstract production scope
top::Scope ::=
{}

{-
 - Scopes with a datum.
 -}
abstract production scopeDatum
top::Scope ::=
  datum::Datum
{}


nonterminal Datum;

{-
 - Datum of a def declaration.
 -}
abstract production datumVar
top::Scope ::=
  id::String
  ty::Type
{
  top.id = id;
}

{-
 - Datum of a module declaration.
 -}
abstract production datumMod
top::Scope ::=
  id::String
  smod::Scope
{
  top.id = id;
}