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

- [MkScopeDcl interface](./src/jastadd/DeclarationResolution.jrag).

```
abstract scope MkScopeDcl -> name:String;
```

Makes new interface:

```java
aspect MkScopeDcl {
  interface MkScopeDcl<T extends Scope> {
    public String getname();
    public Boolean dclPredicate(String name);
    public ArrayList<T> demandEdge(Scope s);
  }
}
```

Where `getname()` returns the name of the `Bind` or `Module` tree decl. Each
must have a `name` child of type `String`, since `MkScopeDcl` is declarted to
have data `name:String`.

#### MkScopeVar

- [MkScopeVar as MkScopeDcl](./src/jastadd/DeclarationResolution.jrag).

```
scope MkScopeVar -> b:Bind;
MkScopeVar isa MkScopeDcl;
```

`MkScopeVar isa MkScopeDcl` means `MkScopeVar` implements the `MkScopeDcl`
interface as below:

```java
aspect MkScopeVarAsDcl {

  MkScopeVar implements MkScopeDcl;

  public String MkScopeVar.getname() {
    return this.getnode().getid();
  }

  public Boolean MkScopeVar.dclPredicate(String name) {
    return name.equals(getname());
  }

  public ArrayList<MkScopeVar> MkScopeVar.demandEdge(Scope s) {
    return s.var();
  }

}
```

#### MkScopeMod

- [MkScopeMod as MkScopeDcl](./src/jastadd/DeclarationResolution.jrag).

```
scope MkScopeMod -> m:Module;
MkScopeMod isa MkScopeDcl;
```

`MkScopeMod isa MkScopeDcl` means `MkScopeMod` implements the `MkScopeDcl`
interface as below:

```java
aspect MkScopeModAsDcl {
  
  MkScopeMod implements MkScopeDcl;
  
  public String MkScopeMod.getname() {
    return this.getnode().getid();
  }

  public Boolean MkScopeMod.dclPredicate(String name) {
    return name.equals(getname());
  }

  public ArrayList<MkScopeMod> MkScopeMod.demandEdge(Scope s) {
    return s.mod();
  }

}

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
    new Query().state1DCL(this, name, res, new MkScopeVar(), new MkScopeMod());
    endQueryLog(name, res, "dclQuery");
    return res;
  }
  ...
}

aspect DeclarationResolution {

  class Query<T extends MkScopeDcl> {

    // DFA state 1 for regex = LEX* IMP? VAR
    public void state1DCL(Scope cur, String name, ArrayList<T> acc, T dclTypeVar, T dclTypeMod) {
      
      cur.queryEnterLog();
    
      // Follow VAR
      ArrayList<T> sdsVar = dclTypeVar.demandEdge(cur);
      for (T sd: sdsVar) {
        cur.queryFollowLog("VAR", (Scope) sd);
        state3DCL(sd, name, acc);
        cur.queryReturnLog();
      }

      // Follow MOD
      ArrayList<T> sdsMod = dclTypeMod.demandEdge(cur);
      for (T sd: sdsMod) {
        cur.queryFollowLog("MOD", (Scope) sd);
        state3DCL(sd, name, acc);
        cur.queryReturnLog();
      }

      // Follow IMP if no resolutions found by VAR or MOD
      if (acc.size() == 0) {
        for (MkScopeMod sn: cur.imp()) {
          cur.queryFollowLog("IMP", sn);
          state2DCL(sn, name, acc, dclTypeVar, dclTypeMod);
          cur.queryReturnLog();
        }
      }

      // Follow LEX if no resolutions found by IMP
      if (acc.size() == 0) {
        for (Scope sn: cur.lex()) {
          cur.queryFollowLog("LEX", sn);
          state1DCL(sn, name, acc, dclTypeVar, dclTypeMod);
          cur.queryReturnLog();
        }
      }

      cur.queryLeaveLog();

    }

    // DFA state 2 for regex = LEX* IMP? VAR
    public void state2DCL(Scope cur, String name, ArrayList<T> acc, T dclTypeVar, T dclTypeMod) {

      cur.queryEnterLog();

      // Follow VAR
      ArrayList<T> sdsVar = dclTypeVar.demandEdge(cur);
      for (T sd: sdsVar) {
        cur.queryFollowLog("VAR", (Scope) sd);
        state3DCL(sd, name, acc);
        cur.queryReturnLog();
      }

      // Follow MOD
      ArrayList<T> sdsMod = dclTypeMod.demandEdge(cur);
      for (T sd: sdsMod) {
        cur.queryFollowLog("MOD", (Scope) sd);
        state3DCL(sd, name, acc);
        cur.queryReturnLog();
      }

      cur.queryLeaveLog();

    }

    // // DFA state 3 for regex = LEX* IMP? DCL
    public void state3DCL(T cur, String name, ArrayList<T> acc) {
      
      Scope s = (Scope) cur;

      s.queryEnterLog();

      // Use of varPredicate - name equality
      if (cur.dclPredicate(name)) {
        s.queryGoodResLog(name);
        acc.add(cur);
      } else {
        s.queryBadResLog(name);
      }

      s.queryLeaveLog();

    }

  }

}
```