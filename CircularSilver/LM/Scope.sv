grammar LM;


{-
 - Collection attributes for vars, mods, imps, lexs.
 - Each definition has a name, type, append op, initial value, and a declaration the type of the
 - LM AST node from which we will descend the tree to find contributions.
 -}
inherited attribute var::[Decorated Scope] occurs on Scope;
inherited attribute mod::[Decorated Scope] occurs on Scope;
inherited attribute imp::[Decorated Scope] occurs on Scope;
inherited attribute lex::Maybe<Decorated Scope occurs on Scope;
inherited attribute res::[Res] occurs on Scope;

{-
 - Circular attribute to find all of the reachable imports during a resolution.
 - This list grows during the cyclic evaluation.
 -}
collection attribute impsReachable::[Res] 
  with ++, []       -- combination operator for contributions to the collection
  root Program      -- search tree root type
  circular _union_  -- combination operator for circular attribute results. new results go to the left
occurs on Scope;

{-
 - The datum associated with a declaration node, or nothing if the node is only a scope.
 -}
inherited attribute datum::Maybe<Datum> occurs on Scope;

{-
 - The ID of a datum, defined as the ID of the LM declaration which the datum represents.
 -}
synthesized attribute id::String occurs on Datum;



nonterminal Scope with id, var, mod, imp, lex, res, datum;

{-
 - Scopes with no datum attached.
 -}
abstract production scope
top::Scope ::=
{ top.id = "S_" ++ toString(genInt()); }

abstract production modRefScope
top::Scope ::=
{ forwards to scope(); }

abstract production varRefScope
top::Scope ::=
{ forwards to scope(); }



nonterminal Datum with id;

{-
 - Datum of a def declaration.
 -}
abstract production datumVar
top::Datum ::=
  data::(String, Type)
{
  top.id = fst(data);
}

{-
 - Datum of a module declaration.
 -}
abstract production datumMod
top::Datum ::=
  data::(String, Decorated Scope)
{
  top.id = fst(data);
}

{-
 - Datum of a module ref.
 -}
abstract production datumModRef
top::Datum ::=
  data::ModRef
{
  top.id = case data of modRef(id) -> id | _ -> "";
}

{-
 - Datum of a var reference.
 -}
abstract production datumVarRef
top::Datum ::=
  data::VarRef
{
  top.id = case data of varRef(id) -> id | _ -> "";
}


nonterminal Res;

synthesized attribute resTgt::Decorated Scope occurs on Res;
synthesized attribute path::[Label] occurs on Res;
synthesized attribute fromRef::Either<ModRef VarRef> occurs on Res;
synthesized attribute impDeps::[Res] occurs on Res;

abstract production impRes
top::Res ::=
  modRef::ModRef
  resTgt::Decorated Scope
  path::[Label]
  deps::[Res]
{
  top.resTgt = scope;
  top.path = path;
  top.fromRef = left(modRef);
  top.impDeps = deps;
}

abstract production varRes
top::Res ::=
  varRef::VarRef
  resTgt::Decorated Scope
  path::[Label]
  deps::[Res]
{
  top.resTgt = scope;
  top.path = path;
  top.fromRef = right(varRef);
  top.impDeps = deps;
}



nonterminal Label;
abstract production labVAR top::Label ::= {}
abstract production labMOD top::Label ::= {}
abstract production labIMP top::Label ::= {}
abstract production labLEX top::Label ::= {}



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
    | labMOD()::_, labIMP()::_ -> true
    | labIMP()::_, labMOD()::_ -> false

      -- LEX > MOD
    | labMOD()::_, labLEX()::_ -> true
    | labLEX()::_, labMOD()::_ -> false

      -- IMP > VAR
    | labVAR()::_, labIMP()::_ -> true
    | labIMP()::_, labVAR()::_ -> false

      -- LEX > VAR
    | labVAR()::_, labLEX()::_ -> true
    | labLEX()::_, labVAR()::_ -> false

      -- LEX > IMP
    | labIMP()::_, labLEX()::_ -> true
    | labLEX()::_, labIMP()::_ -> false

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


function minRefRes
[Resolution] ::=
  ref::Decorated Scope
{
  return
    case ref of
    | modRefScope(mref) -> modRefRes(mref, minRef(ref.res, [], left(mref)))
    | varRefScope(vref) -> varRefRes(vref, minRef(ref.res, [], right(vref)))
    end;
}

function minRef
[Scope] ::=
  reachable::[Res]
  visible::[Res]
  ref::Either<ModRef VarRef>
{
  return
    let match::(Boolean ::= Res) = -- determining whether a res is from resolving the same ref
      \r::Res -> case ref of 
                 | left(r) -> r.fromRef.fromLeft == ref
                 | right(r) -> r.fromRef.fromRight == ref
                 end
    in
      case reachable, visible of
      | rh::rt, [] -> -- visibility list is currently empty
          if match(rh) then minRef(rt, [rh], ref) else minRef(rt, [], ref)
      | rh::rt, vh::vt ->
          (case pathBetter(rh, vh), pathBetter(vh, rh) of
          | true, false ->    -- resolution `rh` is better than all resolutions in `visible`
              minRef(rt, [rh], ref)
          | false, true ->    -- resolution `rh` is worse than all resolutions in `visible`
              minRef(rt, visible, ref)
          | false, false ->  -- resolution `rh` is equally as good as all resolutions in `visible`
              minRef(rt, rh::visible, ref)
          | true, true ->    -- impossible
              []
          end)
      | _, _ -> visible
      end
    end;
}

function leftmostImps
[Decorated Scope] ::=
  refs::[Decorated Scope]
{
  return
    case refs of
    | h::t -> case h of modRefRes(_) -> minRefRes(h) | _ -> [] end 
              ++ leftmostImps(t)
    | [] -> []
    end;
}