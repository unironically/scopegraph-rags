# Map representation for scope graph edges

## Scopes/Labels

Representing the set of edges for a scope as a map of strings to lists of
decorated scopes, where each string is an edge label name e.g. "LEX", and the
corresponding list of scopes is the targets of edges of that label.

```
nonterminal Scope;

synthesized attribute datum::Datum occurs on Scope;
inherited attribute edges::Map<String [Decorated Scope]> with combineMap occurs on Scope;

production scope
top::Scope ::= datum::Datum
{ top.datum = ^datum; }

--

nonterminal Datum with name;

production datumNone
top::Datum ::=
{ top.name = ""; }

production datumName
top::Datum ::= x::String
{ top.name = x; }
```

Labels much the same as in the edges-as-inherited-attributes approach, with a 
`demand` attribute for demanding targets of edges of the corresponding label. 

```
nonterminal Label with name;

synthesized attribute demand::([Decorated Scope] ::= Decorated Scope)
  occurs on Label;

production label
top::Label ::=
{ top.name = error("label.name");         -- default, not used
  top.demand = error("label.demand"); }   -- default, not used

instance Eq Label
{ eq = \l::Label r::Label -> l.name == r.name; }

```

## Map representation

We implement a map in Silver as a list of key/value pairs. Allows us to take
advantage of the laziness of Silver, which, using scope graphs as an example,
means that the list of scopes (value) will not be demanded when not necessary
for a query. Differs from the list representation of edges which may demand edge
contributions (all are in the same single list) for a scope that are not
relevant to the current query, causing a cycle. See `lmre` example with
`nameanalysis_list` vs. `nameanalysis_map`.

```
nonterminal Map<k v>;

synthesized attribute compare<k>::(Boolean ::= k k) occurs on Map<k v>;
synthesized attribute lookup<k v>::([v] ::= k) occurs on Map<k v>;
```

The `mapNone` production used for empty maps, takes an equality comparison
function for the type of the map key.

```
production mapNone
top::Map<k v> ::= compare::(Boolean ::= k k)
{
  top.compare = compare;
  
  top.lookup = \_ -> [];
}
```

The `mapCons` production takes a key and a value, as well as the rest of the
map.

```
production mapCons
top::Map<k v> ::= key::k val::v next::Map<k v>
{
  top.compare = next.compare;
  
  top.lookup = 
    \key_::k -> let lookupNext::[v] = next.lookup(key_) in
                  if top.compare(key, key_)
                  then val::lookupNext
                  else lookupNext
                end;
}
```

The `combineMap` function used in the definition of the `edges` attribute above
is defined as follows. Assumption being that the `compare` attribute is equal
for `l` and `r`. Equates to list concatenation using a `nil` and `cons`
representation.

```
fun combineMap
Map<k v> ::= l::Map<k v> r::Map<k v>
=
  case l of
  | mapNone(_) -> r
  | mapCons(k, v, next) -> mapCons(k, v, combineMap(^next, r))
  end
;
```

Some more work can be done here. Perhaps we require the `Eq` typeclass from the
type `k` for a map instead of having the `compare` argument, restricting the
key comparison to `(==)` but making the representation more clean.

## Resolution

Resolution function:

```
fun resolve
[Decorated Scope] ::= p::Predicate r::Regex s::Decorated Scope
=
  let cont::[Decorated Scope] =
    let validLabels::[Label] = r.first in
      foldl(
        \acc::(Maybe<Label>, [Decorated Scope]) nextLab::Label ->
          let prevLab::Maybe<Label> = acc.1 in
            let prevRes::[Decorated Scope] = acc.2 in
              let nextRes::[Decorated Scope] = 
                concat(map(resolve(p, r.deriv(nextLab), _), nextLab.demand(s)))
              in
                (just(nextLab), prevRes ++ nextRes)
              end
            end
          end,
        (nothing(), []),
        validLabels
      ).2
    end
  in
    case r.simplify of
    | regexEmpty() -> []
    | _ -> if p(s.datum) && r.nullable then s::cont else cont
    end
  end;
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

Two labels in the host language, `LEX` and `VAR`. Note use of `s.edges.lookup`,
looking up `LEX` targets in the edges map for the scope `s`.

```
production lexLabel
top::Label ::=
{
  top.name = "LEX";
  top.demand = \s::Decorated Scope -> concat(s.edges.lookup("LEX"));
  forwards to label();
}

production varLabel
top::Label ::=
{
  top.name = "VAR";
  top.demand = \s::Decorated Scope -> concat(s.edges.lookup("VAR"));
  forwards to label();
}
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

Usual inherited scope attribute:

```
inherited attribute scope::Decorated Scope;
```

Attribute for lifting up targets of `VAR` edges. If there were other labels,
they would be separate monoid attributes.

```
monoid attribute synVar::[Decorated Scope] with [], ++;
```

Constructing the global scope, which only has `VAR` edges to variable
declarations.

```
aspect production program
top::Main ::= ds::Decls
{
  production attribute globScope::Scope = scopeNoData();
  globScope.edges := mapCons("VAR", ds.synVar, mapNone());

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
  production attribute vars::[Decorated Scope] with ++;
  vars := resolve(isName(x), varRx(), top.scope);

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

Introducing module scopes:

```
abstract production scopeMod
top::Scope ::= id::String
{ forwards to scope(datumMod(id)); }

--

abstract production datumMod
top::Datum ::= id::String
{ forwards to datumName(id); }
```

Two new labels, `MOD` and `IMP`:

```
production modLabel
top::Label ::=
{
  top.name = "MOD";
  top.demand = \s::Decorated Scope -> concat(s.edges.lookup("MOD"));
  forwards to label();
}

production impLabel
top::Label ::=
{
  top.name = "IMP";
  top.demand = \s::Decorated Scope -> concat(s.edges.lookup("IMP"));
  forwards to label();
}
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
      regexLabel(lexLabel())
    ),
    regexCat(
      regexLabel(impLabel()), -- no option here, host var rx already resolves using no IMP labs
      regexLabel(varLabel())
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
      regexLabel(lexLabel())
    ),
    regexLabel(modLabel())
  );
```

#### Scope construction, edge propagation

Two new monoid attributes for synthesizing targets of `MOD` and `IMP` edges:

```
monoid attribute synMod::[Decorated Scope] with [], ++;
monoid attribute synImp::[Decorated Scope] with [], ++;
```

Global scope edge map now has contributions for `MOD` and `IMP` edges
synthesized by the declaration list child: 

```
aspect production program
top::Main ::= ds::Decls
{
  globScope.edges <- mapCons("MOD", ds.synMod, mapNone());
  globScope.edges <- mapCons("IMP", ds.synImp, mapNone());
}
```

Module scope constructed by the `declMod` production:

```
aspect production declMod
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = scopeMod(id);
  modScope.edges := mapCons("LEX", [top.scope], mapNone());
  modScope.edges <- mapCons("VAR", ds.synVar, mapNone());
  modScope.edges <- mapCons("MOD", ds.synMod, mapNone());
  modScope.edges <- mapCons("IMP", ds.synImp, mapNone());

  ds.scope = modScope;

  top.synVar := [];
  top.synMod := [ modScope ];
  top.synImp := [];

  top.ok := ds.ok;
}
```

Resolving imports as follows:

```
aspect production declImp
top::Decl ::= x::String
{
  production attribute mods::[Decorated Scope] with ++;
  mods := resolve(isName(x), impRx(), top.scope);

  local okLookup::Maybe<Decorated Scope> =
    case mods of
    | h::[] -> case h.datum of
               | datumMod(_) -> just(h)
               | _ -> nothing()
               end
    | _ -> nothing()
    end;

  top.ok := okLookup.isJust
  top.type = if top.ok then okLookup.fromJust else dummyScope;
}
```

Contributions made to the host language attribute `vars` as the result of
querying `LEX* IMP VAR` on the lexical scope.

```
aspect production varRef
top::VarRef ::= x::String
{
  vars <- resolve(isName(x), newVarRx(), top.scope);
}
```

## Issues

A bit verbose and ugly in places, especially in the case of contructing module
scopes as above. Syntax can be condensed to the following. But is still a bit
ugly.

```
aspect production declMod
top::Decl ::= id::String ds::Decls
{
  local modScope::Scope = scopeMod(id);
  modScope.edges := 
    mapCons("LEX", [top.scope], 
    mapCons("VAR", ds.synVar,
    mapCons("MOD", ds.synMod,
    mapCons("IMP", ds.synImp,
    mapNone()))));

  ...
}
```