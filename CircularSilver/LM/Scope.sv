grammar LM;


{-
 - Collection attributes for vars, mods, imps, lexs.
 - Each definition has a name, type, append op, initial value, and a declaration the type of the
 - LM AST node from which we will descend the tree to find contributions.
 -}
collection attribute vars::[Scope] with ++, [] root Program occurs on Scope;
collection attribute mods::[Scope] with ++, [] root Program occurs on Scope;
collection attribute lexs::[Scope] with ++, [] root Program occurs on Scope;

{-
 - The type of imps is [[Scope]], which structurally maintains the precedence of certain reachable
 - import resolutions over others. The leftmost sub-list in which a resolution exists for a given
 - reference contains the 'visible' resolutions (may be ambiguous) of that reference.
 - Declared as circular, as the resolution of an import may depend on the resolutions of others.
 -}
collection attribute circular imps::[Res] with impsUpdate, [] root Program occurs on Scope;

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



{-
 - Function for updating the imps collection attribute on a scope.
 -}
function impsUpdate
[Res] ::=
  currRes::[Res]
  addRes::[Res]
{
  local impsNotFromSameRef::[Res] = filter((\i::Res -> i.fromRef != currRes.fromRef), currRes);

  local impsFromSameRef::[[Res]] = 
    foldr (
      (
        \i::Res acc::[[Res]] ->
          case acc of
          | better::same::[] ->
              if pathBetter(i, currRes) 
                then [i::better, same]             -- this res in the list is better
                else acc                           -- this res in the list is worse or is equal
          | _ -> []
          end;
      ),
      [[], []],
      currRes
    );

  return
    let better::[Res] = head(impsFromSameRef) in
    let same::[Res] = head(tail(impsFromSameRef)) in
      if !null(better) then better ++ impsNotFromSameRef      -- ignore the newly found res
      else (currRes::same) ++ impsNotFromSameRef              -- keep the newly found res
    end end;
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