grammar LM;


{-
 - Collection attributes for vars, mods, imps, lexs.
 - Each definition has a name, type, append op, initial value, and a declaration the type of the
 - LM AST node from which we will descend the tree to find contributions.
 -}
synthesized attribute vars::[Decorated Scope] with ++, [] occurs on Scope;
synthesized attribute mods::[Decorated Scope] with ++, [] occurs on Scope;
synthesized attribute lexs::[Decorated Scope] with ++, [] occurs on Scope;


{-
 - Circular attribute to find all of the reachable imports during a resolution.
 - This list grows during the cyclic evaluation.
 -}
collection attribute circular impsReachable::[Res] with _union_, [] root Program occurs on Scope;

{-
 - Once impsReachable is done computing, we can contribute a subset of the reachable scopes to the 
 - imps collection attribute without circularity issues.
 -}
synthesized attribute imps::[Decorated Scope] with ++, [] occurs on Scope;

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
  vars::[Decorated Scope]
  mods::[Decorated Scope]
  imps::[Decorated Scope]
  lexs::[Decorated Scope]

{
  top.datum = nothing();
}

{-
 - Scopes with a datum.
 -}
abstract production scopeDatum
top::Scope ::=
  vars::[Decorated Scope]
  mods::[Decorated Scope]
  imps::[Decorated Scope]
  lexs::[Decorated Scope]
  datum::Datum
{
  top.vars = vars;
  top.mods = mods;
  top.lexs = lexs;
  top.datum = just(datum);
}



nonterminal Datum with id;

{-
 - Datum of a def declaration.
 -}
abstract production datumVar
top::Datum ::=
  id::String
  ty::Type
{
  top.id = id;
}

{-
 - Datum of a module declaration.
 -}
abstract production datumMod
top::Datum ::=
  id::String
  smod::Decorated Scope
{
  top.id = id;
}



nonterminal Res;

synthesized attribute resolvedScope::Scope occurs on Res;
synthesized attribute path::[Label] occurs on Res;
synthesized attribute fromRef::Ref occurs on Res;

abstract production impRes
top::Res ::=
  fromRef::Ref
  resolvedScope::Scope
  path::[Label]
{
  top.resolvedScope = scope;
  top.path = path;
  top.fromRef = fromRef;
}

abstract production varRes
top::Res ::=
  fromRef::Ref
  resolvedScope::Scope
  path::[Label]
{
  top.resolvedScope = scope;
  top.path = path;
  top.fromRef = fromRef;
}



nonterminal Label;
abstract production labelVar top::Label ::= {}
abstract production labelMod top::Label ::= {}
abstract production labelImp top::Label ::= {}
abstract production labelLex top::Label ::= {}



function pathBetter
top::Boolean ::= 
  i1::Res          -- is this imp res
  i2::Res          -- "better" than this one?
{
  local path1::[Label] = i1.path;
  local path2::[Label] = i2.path;

  return leftPathBetter(path1, path2);
}


function leftPathBetter
Boolean ::=
  i1::[Label]
  i2::[Label]
{
  return
    case i1, i2 of

      -- IMP > MOD
    | labelMod()::_, labelImp()::_ -> true
    | labelImp()::_, labelMod()::_ -> false

      -- LEX > MOD
    | labelMod()::_, labelLex()::_ -> true
    | labelLex()::_, labelMod()::_ -> false

      -- IMP > VAR
    | labelVar()::_, labelImp()::_ -> true
    | labelImp()::_, labelVar()::_ -> false

      -- LEX > VAR
    | labelVar()::_, labelLex()::_ -> true
    | labelLex()::_, labelVar()::_ -> false

      -- LEX > IMP
    | labelImp()::_, labelLex()::_ -> true
    | labelLex()::_, labelImp()::_ -> false

      -- Equal
    | _::t1, _::t2 -> leftPathBetter(t1, t2) 

    | [], [] -> false
    end;
}


function _union_
[Res] ::=
  current::[Res]
  toAdd::[Res]
{
  return
    case toAdd of
    | h::t -> if contains(h, current) then _union_(current, t) else _union_(h::current, t)
    | [] -> current
    end;
}
