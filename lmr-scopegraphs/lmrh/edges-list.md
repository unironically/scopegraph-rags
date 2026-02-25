# List representation for scope graph edges

Representing the edges from a scope as a list stored as an inherited collection
attribute on scopes. Each edge, regardless of label, is in the same list.

## Scopes/Labels

```
nonterminal Scope;

synthesized attribute datum::Datum occurs on Scope;
inherited attribute edges::[Edge] with union occurs on Scope;

production scope
top::Scope ::= d::Datum
{ top.datum = ^d; }
```

## Resolution

Resolve is a function attribute here, but could also be an independent function.

```
aspect production scope
top::Scope ::= d::Datum
{
  top.resolve = \p::DwfPred r::Regex ->
    let
      rSimp::Regex = r.simplify
    in
      case rSimp of
      | regexEmp() -> []
      | regexEps() -> if p(^d) then [top] else []
      | _ ->
        let cont::[Decorated Scope] =
          concat(map (tryEdge(rSimp, p, _), top.edges))
        in
          if rSimp.nullable && p(^d) then top::cont else cont
        end
      end
    end;
}
```

## Example specification - LM

### Host

#### Scopes/labels/query information

Two kinds of scope graph nodes, usual scopes and variable declarations.

```
abstract production scopeNoData
top::Scope ::=
{ forwards to scope(datumNone()); }

abstract production scopeVar
top::Scope ::= id::String ty::Type
{ forwards to scope(datumVar(id, ^ty)); }

--

abstract production datumVar
top::Datum ::= id::String ty::Type
{ forwards to datumName(id); }
```

Two edge kinds in the host language, `LEX` and `VAR`.

```
abstract production lexEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("LEX", tgt); }

abstract production varEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("VAR", tgt); }
```

Host language variable resolution regex, `LEX* VAR`.

```
global varRx::Regex =
  regexCat(
    regexStar(
      regexLabel(lexLabel())
    ),
    regexLabel(varLabel())
  );
```

#### Scope construction, edge propagation

Usual inherited scope attribute for lexical scopes:

```
inherited attribute scope::Decorated Scope;
```

One attribute that collects all (regardless of label) synthesized edge targets.

```
monoid attribute synEdges::[Edge] with [], ++;
```

Constructing the global scope, which only has `VAR` edges to variable
declarations.

```
aspect production program
top::Main ::= ds::Decls
{
  production attribute globScope::Scope = scopeNoData();
  globScope.edges := ds.synEdges;

  ds.scope = globScope;
}
```

Query for variable references. Query results (`vars`) is a collection production
attribute, allowing extensions to the host language to contribute more query
results using different query parameters (see example of modules/imports).

```
aspect production varRef
top::VarRef ::= x::String
{
  production attribute vars::[Decorated Scope] with union;
  vars := top.scope.resolve(isName(x), varRx());

  local okLookup::Maybe<Type> =
    case vars of
    | h::[] -> case h.datum of
               | datumVar(_, ty) -> just(ty)
               | nothing()
               end
    | _ -> nothing()
    end;

  top.ok := okLookup.isJust
  top.type = if top.ok then okLookup.fromJust else tErr();
}
```

### Extension (modules and imports)

#### Scopes/labels/query information

New module scope production:

```
abstract production scopeMod
top::Scope ::= id::String
{ forwards to scope(datumMod(id)); }

--

abstract production datumMod
top::Datum ::= id::String
{ forwards to datumName(id); }
```

Introducing `MOD` and `IMP` edges:

```
abstract production modEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("MOD", tgt); }

abstract production impEdge
top::Edge ::= tgt::Decorated Scope
{ forwards to edge("IMP", tgt); }
```

A new regular expression for resolving variable references. Note that we have
`LEX* IMP VAR` instead of `LEX* IMP? VAR` as usual, since the host language
variable resolution regex already resolves with `LEX* VAR` (no `IMP`). So using
`LEX* IMP? VAR` would contribute duplicate declarations to the resolution of the
variable. 

```
global newVarRx::Regex =
  regexCat(
    regexStar(
      regexLab("LEX")
    ),
    regexCat(
      regexLab("IMP"), -- no option here, host var rx already resolves using no IMP labs
      regexLab("VAR")
    )
  );
```

Also a regular expression for resolving imports. In this example we use regex
`LEX* MOD`. Breaks cycle of import resolution in a scope contributing `IMP`
edges to it, whilst demanding them for resolution. Instructive when compared to
results of edges-as-one-list representation, which has a cycle with this regex,
whereas the map representation described here does not.

```
global impRx::Regex =
  regexCat(
    regexStar(
      regexLab("LEX")
    ),
    regexLab("MOD")
  );
```

#### Scope construction, edge propagation

No new attributes as in the map example. As described above, all edge targets
go in the same list. We could separate out the synthesized attributes for each
label and then combine them into one list when constructing a scope, but the
result would be the same.

Module scope constructed by the `declMod` production:

```
aspect production declMod
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = scopeMod(id);
  modScope.edges := lexEdge(top.scope) :: ds.synEdges;

  ds.scope = modScope;

  top.synEdges := [ modEdge(modScope) ];

  top.ok := ds.ok;
}
```

Resolving imports as follows:

```
aspect production declImp
top::Decl ::= x::String
{
  production attribute mods::[Decorated Scope] with ++;
  mods := top.scope.resolve(isName(x), impRx());

  local okLookup::Maybe<Decorated Scope> =
    case mods of
    | h::[] -> case h.datum of
               | datumMod(_) -> just(h)
               | _ -> nothing()
               end
    | _ -> nothing()
    end;

  top.ok := okLookup.isJust;
  top.synEdges := if top.ok then [ impEdge(okLookup.fromJust) ] else [];
}
```

Contributions made to the host language attribute `vars` as the result of
querying `LEX* IMP VAR` on the lexical scope.

```
aspect production varRef
top::VarRef ::= x::String
{
  vars <- top.scope.resolve(isName(x), newVarRx());
}
```

## Issues

Cycles occur in specifications where the same does not happen using the map
representation for edges, or the representation with each edge label as a
separate inherited attribute.

For example, using the below production for `declImp` instead of the one above
causes a cycle when using imports:

```
aspect production declImp
top::Decl ::= x::String
{
  production attribute mods::[Decorated Scope] with ++;
  mods := top.scope.resolve(isName(x), impRx());

  top.ok := true;
  top.synEdges := map(impEdge(_), mods);
}
```

Whereas the following similarly behaving production does not result in cycles
using the map representation:

```
aspect production declImp
top::Decl ::= x::String
{
  local mods::[Decorated Scope] = resolve(isName(x), impRx(), top.scope);

  top.synVar := [];
  top.synMod := [];
  top.synImp := mods;

  top.ok := true;
}
```

E.g. cycle causes when analyzing the following simple LM program:

```
module A {
  def a:int = 1
}

module B {
  import A
  def b:int = a
}
```

This is because the edge list of `top.scope` depends on the equation 
`top.synEdges := map(impEdge(_), mods);`, whose evaluation must demand `mods`
before making imp edges with the `map` application. `mods` then transitively 
demands the edge list on `top.scope`. Demanding the list of edges on `top.scope`
necessarily demands `mods` - the cycle.

In the earlier definition of `declImp` for the list representation, we have:
`top.synEdges := if top.ok then [ impEdge(okLookup.fromJust) ] else [];`.
Here, `okLookup.fromJust` does not have to be evaluated for queries to know that
there is an `IMP` edge being contributed, and therefore will not demand `mods`
if the query cannot follow an `IMP` edge. Demanding the list of edges on
`top.scope` does not necessarily demand `mods`, so there is no cycle unless
the query giving `mods` can follow `IMP` edges (which would also cause a cycle
in the map representation and any representation).