grammar LM;


{-
 - Collection attributes for vars, mods, imps, lexs.
 - Each definition has a name, type, append op, initial value, and a declaration the type of the
 - LM AST node from which we will descend the tree to find contributions.
 -}
synthesized attribute vars::[Decorated Scope] occurs on Scope;
synthesized attribute mods::[Decorated Scope] occurs on Scope;
synthesized attribute lexs::[Decorated Scope] occurs on Scope;
synthesized attribute imps::[Decorated Scope] occurs on Scope;

{-
 - Circular attribute to find all of the reachable imports during a resolution.
 - This list grows during the cyclic evaluation.
 -}
collection attribute circular impsReachable::[Res] with _union_, [] root Program occurs on Scope;

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
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
  lex::Maybe<Decorated Scope>
  datum::Maybe<Datum>
{
  top.id = "S_" ++ toString(genInt());
  top.var = var; top.mod = mod;
  top.imp = imp; top.lex = lex;
  top.datum = datum;
}

{-
 - Global scope
 -}
abstract production scopeGlobal
top::Scope ::=
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
{ forwards to scope(var, mod, imp, nothing(), nothing()); }

{-
 - Def decl scope 
-}
abstract production scopeDcl
top::Scope ::= datum::(String, Type)
{ forwards to scope([], [], [], nothing(), datumVar(datum)); }

{-
 - Module dcl scope
 -}
abstract production scopeMod
top::Scope ::=
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
  lex::Decorated Scope
  datum::(String, Decorated Scope)
{ forwards to scope(var, mod, imp, just(lex), datumMod(datum)); }

{-
 - Let scope
 -}
abstract production scopeLet
top::Scope ::=
  var::[Decorated Scope]
  lex::Decorated Scope
{ forwards to scope(var, [], [], just(lex), nothing()); }



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



nonterminal Res;

synthesized attribute resolvedScope::Decorated Scope occurs on Res;
synthesized attribute path::[Label] occurs on Res;
synthesized attribute fromRef::Either<ModRef VarRef> occurs on Res;

abstract production impRes
top::Res ::=
  modRef::ModRef
  resolvedScope::Decorated Scope
  path::[Label]
{
  top.resolvedScope = scope;
  top.path = path;
  top.fromRef = left(modRef);
}

abstract production varRes
top::Res ::=
  varRef::VarRef
  resolvedScope::Decorated Scope
  path::[Label]
{
  top.resolvedScope = scope;
  top.path = path;
  top.fromRef = right(varRef);
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


function minRef
[Scope] ::=
  reachable::[Res]
  visible::[Res]
  ref::Either<ModRef VarRef>
{
  return
    let match::(Boolean ::= Res) = 
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