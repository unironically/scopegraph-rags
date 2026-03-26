# LM in JastAdd

### Building

To build `compiler.jar`:

```
./gradlew jar
```

### Execution

To compile an LM specification:

```
java -jar compiler.jar examples/Basic.lm
```

### Cleanup

To cleanup:

```
./gradlew clean
```


## Scope graphs

### JastAdd Edge Specs

### Specification example

Scopes:

```
scope MkScopeLex;
scope MkScopeVar -> node:Bind;
scope MkScopeMod -> node:Module;
```

Relationships:

```
abstract scope MkScopeDcl -> name:String;

MkScopeVar isa MkScopeDcl;
MkScopeMod isa MkScopeDcl;
```

Edges:

```
edge -[ LEX ]-> MkScopeLex;
edge -[ VAR ]-> MkScopeVar;
edge -[ MOD ]-> MkScopeMod;
edge -[ IMP ]-> MkScopeMod;
```

Predicates:

```
varPredicate = \name::String v::MkScopeVar -> v.name == name;
modPredicate = \name::String v::MkScopeMod -> v.name == name;
dclPredicate = \name::String v::MkScopeDcl -> v.name == name;
```

Queries:

```
query varQuery(String name):
  regex = LEX* IMP? VAR,
  order = LEX < VAR, LEX < IMP, IMP < VAR,
  predicate = varPredicate(name);

query impQuery: 
  regex = LEX* IMP? MOD,
  order = LEX < MOD, LEX < IMP, IMP < MOD,
  predicate = varPredicate(name);

query dclQuery:
  regex = LEX* IMP? (VAR | MOD)
  order = LEX < VAR, LEX < IMP, IMP < VAR, LEX < MOD, IMP < MOD,
  predicate = dclPredicate(name);
```

### Relationships/Scopes

- [Scope graphs AST](./src/jastadd/_AST_Scope.ast)

#### Builtin root scope type

```
abstract scope ::= ;
```

#### MkScopeLex

```
scope MkScopeLex;
```

No `isa` relationship for `MkScopeLex`, and it has no data, so it is the same 
as the builtin `Scope` root type. Essentially becomes an alias.

#### MkScopeDcl

```
abstract scope MkScopeDcl -> name:String;
```

Makes new abstract nonterminal:

```
abstract MkScopeDcl: Scope ::= <name:String>;
```

#### MkScopeVar

```
scope MkScopeVar -> b:Bind;
MkScopeVar isa MkScopeDcl;
```

`MkScopeVar isa MkScopeDcl` means that `MkScopeVar` is typed as `MkScoepDcl`
instead of `Scope`. Makes new AST nonterminal:

```
MkScopeVar: MkScopeDcl ::= node:Bind;
```

#### MkScopeMod

```
scope MkScopeMod -> m:Module;
MkScopeMod isa MkScopeDcl;
```

`MkScopeMod isa MkScopeDcl` means that `MkScopeMod` is typed as `MkScoepDcl`
instead of `Scope`. Makes new AST nonterminal:

```
MkScopeMod: MkScopeDcl ::= node:Module;
```

### Edges

- [Scope graphs edges](./src/jastadd/Scope.jrag)

#### LEX

```
edge -[ LEX ]-> MkScopeLex;
```

Recall `MkScopeLex` is an alias for `Scope`. Generates inherited attribute:

```
inh lazy ArrayList<Scope> Scope.lex();
```

#### VAR

```
edge -[ VAR ]-> MkScopeVar;
```

Generates inherited attribute:

```
inh lazy ArrayList<MkScopeVar> Scope.var();
```

#### MOD

```
edge -[ MOD ]-> MkScopeMod;
```

Generates inherited attribute:

```
inh lazy ArrayList<MkScopeMod> Scope.mod();
```

#### IMP

```
edge -[ IMP ]-> MkScopeMod;
```

Generates inherited attribute:

```
inh lazy ArrayList<MkScopeMod> Scope.imp();
```

### Queries/Predicates

#### varQuery

- [Variable query implementation](./src/jastadd/VariableResolution.jrag).
- [Variable query call](./src/jastadd/Scope.jrag).


```
varPredicate = \name::String v::MkScopeVar -> v.name == name;

query varQuery(String name):
  regex = LEX* IMP? VAR,
  order = LEX < VAR, LEX < IMP, IMP < VAR,
  predicate = varPredicate(name);
```

Generates the following aspect

```java
aspect Scope {
  syn ArrayList<MkScopeVar> Scope.varQuery(String name) {
    ArrayList<MkScopeVar> res = new ArrayList<MkScopeVar>();
    beginQueryLog(name, "varQuery");
    state1VAR(name, res);
    endQueryLog(name, res, "impQuery");
    return res;
  }
  ...
}

aspect VariableResolution {

  // predicate = varPredicate(name);
  public Boolean MkScopeVar.varPredicate(String name) {
    return this.getname().equals(name);
  }

  // DFA state 1 for regex = LEX* IMP? VAR
  public void Scope.state1VAR(String name, ArrayList<MkScopeVar> acc) {
    
    queryEnterLog();
  
    // Follow VAR
    for (MkScopeVar sd: var()) {
      queryFollowLog("VAR", sd);
      sd.state3VAR(name, acc);
      queryReturnLog();
    }

    // Follow IMP if no resolutions found by VAR
    if (acc.size() == 0) {
      for (MkScopeMod sn: imp()) {
        queryFollowLog("IMP", sn);
        sn.state2VAR(name, acc);
        queryReturnLog();
      }
    }

    // Follow LEX if no resolutions found by IMP
    if (acc.size() == 0) {
      for (Scope sn: lex()) {
        queryFollowLog("LEX", sn);
        sn.state1VAR(name, acc);
        queryReturnLog();
      }
    }

    queryLeaveLog();

  }

  // DFA state 2 for regex = LEX* IMP? VAR
  public void MkScopeMod.state2VAR(String name, ArrayList<MkScopeVar> acc) {

    queryEnterLog();

    // Follow VAR
    for (MkScopeVar sd: var()) {
      queryFollowLog("VAR", sd);
      sd.state3VAR(name, acc);
      queryReturnLog();
    }

    queryLeaveLog();

  }

  // // DFA state 3 for regex = LEX* IMP? VAR
  public void MkScopeVar.state3VAR(String name, ArrayList<MkScopeVar> acc) {
    
    queryEnterLog();

    // Use of varPredicate - name equality
    if (varPredicate(getname())) {
      queryGoodResLog(name);
      acc.add(this);
    } else {
      queryBadResLog(name);
    }

    queryLeaveLog();

  }

}
```

#### modQuery

- [Import query implementation](./src/jastadd/ImportResolution.jrag).
- [Import query call](./src/jastadd/Scope.jrag).

```
modPredicate = \name::String v::MkScopeMod -> v.name == name;

query impQuery: 
  regex = LEX* IMP? MOD,
  order = LEX < MOD, LEX < IMP, IMP < MOD,
  predicate = varPredicate(name);
```

Generates the following aspect:

```java
aspect Scope {
  syn ArrayList<MkScopeMod> Scope.modQuery(String name) {
    ArrayList<MkScopeMod> res = new ArrayList<MkScopeMod>();
    beginQueryLog(name, "impQuery");
    state1MOD(name, res);
    endQueryLog(name, res, "impQuery");
    return res;
  }
  ...
}

aspect ImportResolution {

  // predicate = modPredicate(name);
  public Boolean MkScopeMod.modPredicate(String name) {
    return this.getname().equals(name);
  }

  // DFA state 1 for regex = LEX* IMP? MOD
  public void Scope.state1MOD(String name, ArrayList<MkScopeMod> acc) {
    
    queryEnterLog();
  
    // Follow MOD
    for (MkScopeMod sd: mod()) {
      queryFollowLog("MOD", sd);
      sd.state3MOD(name, acc);
      queryReturnLog();
    }

    // Follow IMP if no resolutions found by MOD
    if (acc.size() == 0) {
      for (MkScopeMod sn: imp()) {
        queryFollowLog("IMP", sn);
        sn.state2MOD(name, acc);
        queryReturnLog();
      }
    }

    // Follow LEX if no resolutions found by IMP
    if (acc.size() == 0) {
      for (Scope sn: lex()) {
        queryFollowLog("LEX", sn);
        sn.state1MOD(name, acc);
        queryReturnLog();
      }
    }

    queryLeaveLog();

  }

  // DFA state 2 for regex = LEX* IMP? MOD
  public void MkScopeMod.state2MOD(String name, ArrayList<MkScopeMod> acc) {

    queryEnterLog();

    // Follow MOD
    for (MkScopeMod sd: mod()) {
      queryFollowLog("MOD", sd);
      sd.state3MOD(name, acc);
      queryReturnLog();
    }

    queryLeaveLog();

  }

  // // DFA state 3 for regex = LEX* IMP? MOD
  public void MkScopeMod.state3MOD(String name, ArrayList<MkScopeMod> acc) {
    
    queryEnterLog();

    // Use of modPredicate - name equality
    if (modPredicate(getname())) {
      queryGoodResLog(name);
      acc.add(this);
    } else {
      queryBadResLog(name);
    }

    queryLeaveLog();

  }

}
```

#### dclQuery

- [Import query implementation](./src/jastadd/DeclarationResolution.jrag).
- [Import query call](./src/jastadd/Scope.jrag).

```
dclPredicate = \name::String v::MkScopeDcl -> v.name == name;

query dclQuery:
  regex = LEX* IMP? (VAR | MOD)
  order = LEX < VAR, LEX < IMP, IMP < VAR, LEX < MOD, IMP < MOD,
  predicate = dclPredicate(name);
```

Generates the following aspect:

```java
aspect Scope {
  syn ArrayList<MkScopeDcl> Scope.dclQuery(String name) {
    ArrayList<MkScopeDcl> res = new ArrayList<MkScopeDcl>();
    beginQueryLog(name, "dclQuery");
    state1DCL(name, res);
    endQueryLog(name, res, "dclQuery");
    return res;
  }
  ...
}

aspect DeclarationResolution {

  // predicate = dclPredicate(name);
  public Boolean MkScopeDcl.dclPredicate(String name) {
    return this.getname().equals(name);
  }

  // DFA state 1 for regex = LEX* IMP? (VAR | MOD)
  public void Scope.state1DCL(String name, ArrayList<MkScopeDcl> acc) {
    
    queryEnterLog();
  
    // Follow VAR
    for (MkScopeVar sd: var()) {
      queryFollowLog("VAR", sd);
      sd.state3DCL(name, acc);
      queryReturnLog();
    }

    // Follow MOD
    for (MkScopeMod sd: mod()) {
      queryFollowLog("MOD", sd);
      sd.state3DCL(name, acc);
      queryReturnLog();
    }

    // Follow IMP if no resolutions found by VAR or MOD
    if (acc.size() == 0) {
      for (MkScopeMod sn: imp()) {
        queryFollowLog("IMP", sn);
        sn.state2DCL(name, acc);
        queryReturnLog();
      }
    }

    // Follow LEX if no resolutions found by IMP
    if (acc.size() == 0) {
      for (Scope sn: lex()) {
        queryFollowLog("LEX", sn);
        sn.state1DCL(name, acc);
        queryReturnLog();
      }
    }

    queryLeaveLog();

  }

  // DFA state 2 for regex = LEX* IMP? (VAR | MOD)
  public void MkScopeMod.state2DCL(String name, ArrayList<MkScopeDcl> acc) {

    queryEnterLog();

    // Follow VAR
    for (MkScopeVar sd: var()) {
      queryFollowLog("VAR", sd);
      sd.state3DCL(name, acc);
      queryReturnLog();
    }

    // Follow MOD
    for (MkScopeMod sd: mod()) {
      queryFollowLog("MOD", sd);
      sd.state3DCL(name, acc);
      queryReturnLog();
    }

    queryLeaveLog();

  }

  // // DFA state 3 for regex = LEX* IMP? (VAR | MOD)
  public void MkScopeVar.state3DCL(String name, ArrayList<MkScopeDcl> acc) {
    
    queryEnterLog();

    // Use of varPredicate - name equality
    if (dclPredicate(getname())) {
      queryGoodResLog(name);
      acc.add(this);
    } else {
      queryBadResLog(name);
    }

    queryLeaveLog();

  }

  // // DFA state 4 for regex = LEX* IMP? (VAR | MOD)
  public void MkScopeMod.state3DCL(String name, ArrayList<MkScopeDcl> acc) {
    
    queryEnterLog();

    // Use of varPredicate - name equality
    if (dclPredicate(getname())) {
      queryGoodResLog(name);
      acc.add(this);
    } else {
      queryBadResLog(name);
    }

    queryLeaveLog();

  }

}
```