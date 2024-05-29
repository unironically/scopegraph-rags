grammar LM;


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
 - The datum associated with a declaration node, or nothing if the node is only a scope.
 -}
synthesized attribute datum::Maybe<Datum> occurs on Scope;

{-
 - The ID of a datum, defined as the ID of the LM declaration which the datum represents.
 -}
synthesized attribute id::String occurs on Datum;



nonterminal Scope with vars, mods, imps, lexs;

{-
 - Scopes with no datum attached.
 -}
abstract production scope
top::Scope ::=
{
  top.datum = nothing();
}

{-
 - Scopes with a datum.
 -}
abstract production scopeDatum
top::Scope ::=
  datum::Datum
{
  top.datum = just(datum);
}



nonterminal Datum with id;

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