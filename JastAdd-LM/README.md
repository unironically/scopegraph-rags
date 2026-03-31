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
scope SGLexNode;
scope SGVarNode -> node:Bind;
scope SGModNode -> node:Module;
```

Relationships:

```
abstract scope SGDclNode -> name:String;

SGVarNode is SGDclNode;

SGModNode is SGDclNode;
SGModNode is SGLexNode;
```

Edges:

```
edge -[ LEX ]-> SGLexNode;
edge -[ VAR ]-> SGVarNode;
edge -[ MOD ]-> SGModNode;
edge -[ IMP ]-> SGModNode;
```

Predicates:

```
varPredicate = \name::String v::SGVarNode -> v.name == name;
modPredicate = \name::String v::SGModNode -> v.name == name;
dclPredicate = \name::String v::SGDclNode -> v.name == name;
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

#### SGLexNode

```
scope SGLexNode;
```

No `isa` relationship for `SGLexNode`, and it has no data, so it is the same 
as the builtin `Scope` root type. Essentially becomes an alias.

#### SGDclNode

- [SGDclNode interface](./src/jastadd/DeclarationResolution.jrag).

```
abstract scope SGDclNode -> name:String;
```

Makes new interface:

```java
aspect SGDclNode {
  interface SGDclNode<T extends Scope> {
    public String getname();
    public Boolean dclPredicate(String name);
    public ArrayList<T> demandEdge(Scope s);
  }
}
```

Where `getname()` returns the name of the `Bind` or `Module` tree decl. Each
must have a `name` child of type `String`, since `SGDclNode` is declarted to
have data `name:String`.

#### SGVarNode

- [SGVarNode as SGDclNode](./src/jastadd/DeclarationResolution.jrag).

```
scope SGVarNode -> b:Bind;
SGVarNode isa SGDclNode;
```

`SGVarNode isa SGDclNode` means `SGVarNode` implements the `SGDclNode`
interface as below:

```java
aspect SGVarNodeAsDcl {

  SGVarNode implements SGDclNode;

  public String SGVarNode.getname() {
    return this.getnode().getid();
  }

  public Boolean SGVarNode.dclPredicate(String name) {
    return name.equals(getname());
  }

  public ArrayList<SGVarNode> SGVarNode.demandEdge(Scope s) {
    return s.var();
  }

}
```

#### SGModNode

- [SGModNode as SGDclNode](./src/jastadd/DeclarationResolution.jrag).

```
scope SGModNode -> m:Module;
SGModNode isa SGDclNode;
```

`SGModNode isa SGDclNode` means `SGModNode` implements the `SGDclNode`
interface as below:

```java
aspect SGModNodeAsDcl {
  
  SGModNode implements SGDclNode;
  
  public String SGModNode.getname() {
    return this.getnode().getid();
  }

  public Boolean SGModNode.dclPredicate(String name) {
    return name.equals(getname());
  }

  public ArrayList<SGModNode> SGModNode.demandEdge(Scope s) {
    return s.mod();
  }

}

```

### Edges

- [Scope graphs edges](./src/jastadd/Scope.jrag)

#### LEX

```
edge -[ LEX ]-> SGLexNode;
```

Recall `SGLexNode` is an alias for `Scope`. Generates inherited attribute:

```
inh lazy ArrayList<Scope> Scope.lex();
```

#### VAR

```
edge -[ VAR ]-> SGVarNode;
```

Generates inherited attribute:

```
inh lazy ArrayList<SGVarNode> Scope.var();
```

#### MOD

```
edge -[ MOD ]-> SGModNode;
```

Generates inherited attribute:

```
inh lazy ArrayList<SGModNode> Scope.mod();
```

#### IMP

```
edge -[ IMP ]-> SGModNode;
```

Generates inherited attribute:

```
inh lazy ArrayList<SGModNode> Scope.imp();
```

### Queries/Predicates

#### varQuery

- [Variable query implementation](./src/jastadd/VariableResolution.jrag).
- [Variable query call](./src/jastadd/Scope.jrag).


```
varPredicate = \name::String v::SGVarNode -> v.name == name;

query varQuery(String name):
  regex = LEX* IMP? VAR,
  order = LEX < VAR, LEX < IMP, IMP < VAR,
  predicate = varPredicate(name);
```

Generates the following aspect

```java
aspect Scope {
  syn ArrayList<SGVarNode> Scope.varQuery(String name) {
    ArrayList<SGVarNode> res = new ArrayList<SGVarNode>();
    beginQueryLog(name, "varQuery");
    state1VAR(name, res);
    endQueryLog(name, res, "impQuery");
    return res;
  }
  ...
}

aspect VariableResolution {

  // predicate = varPredicate(name);
  public Boolean SGVarNode.varPredicate(String name) {
    return this.getname().equals(name);
  }

  // DFA state 1 for regex = LEX* IMP? VAR
  public void Scope.state1VAR(String name, ArrayList<SGVarNode> acc) {
    
    queryEnterLog();
  
    // Follow VAR
    for (SGVarNode sd: var()) {
      queryFollowLog("VAR", sd);
      sd.state3VAR(name, acc);
      queryReturnLog();
    }

    // Follow IMP if no resolutions found by VAR
    if (acc.size() == 0) {
      for (SGModNode sn: imp()) {
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
  public void SGModNode.state2VAR(String name, ArrayList<SGVarNode> acc) {

    queryEnterLog();

    // Follow VAR
    for (SGVarNode sd: var()) {
      queryFollowLog("VAR", sd);
      sd.state3VAR(name, acc);
      queryReturnLog();
    }

    queryLeaveLog();

  }

  // // DFA state 3 for regex = LEX* IMP? VAR
  public void SGVarNode.state3VAR(String name, ArrayList<SGVarNode> acc) {
    
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
modPredicate = \name::String v::SGModNode -> v.name == name;

query impQuery: 
  regex = LEX* IMP? MOD,
  order = LEX < MOD, LEX < IMP, IMP < MOD,
  predicate = varPredicate(name);
```

Generates the following aspect:

```java
aspect Scope {
  syn ArrayList<SGModNode> Scope.modQuery(String name) {
    ArrayList<SGModNode> res = new ArrayList<SGModNode>();
    beginQueryLog(name, "impQuery");
    state1MOD(name, res);
    endQueryLog(name, res, "impQuery");
    return res;
  }
  ...
}

aspect ImportResolution {

  // predicate = modPredicate(name);
  public Boolean SGModNode.modPredicate(String name) {
    return this.getname().equals(name);
  }

  // DFA state 1 for regex = LEX* IMP? MOD
  public void Scope.state1MOD(String name, ArrayList<SGModNode> acc) {
    
    queryEnterLog();
  
    // Follow MOD
    for (SGModNode sd: mod()) {
      queryFollowLog("MOD", sd);
      sd.state3MOD(name, acc);
      queryReturnLog();
    }

    // Follow IMP if no resolutions found by MOD
    if (acc.size() == 0) {
      for (SGModNode sn: imp()) {
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
  public void SGModNode.state2MOD(String name, ArrayList<SGModNode> acc) {

    queryEnterLog();

    // Follow MOD
    for (SGModNode sd: mod()) {
      queryFollowLog("MOD", sd);
      sd.state3MOD(name, acc);
      queryReturnLog();
    }

    queryLeaveLog();

  }

  // // DFA state 3 for regex = LEX* IMP? MOD
  public void SGModNode.state3MOD(String name, ArrayList<SGModNode> acc) {
    
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
dclPredicate = \name::String v::SGDclNode -> v.name == name;

query dclQuery:
  regex = LEX* IMP? (VAR | MOD)
  order = LEX < VAR, LEX < IMP, IMP < VAR, LEX < MOD, IMP < MOD,
  predicate = dclPredicate(name);
```

Generates the following aspect:

```java
aspect Scope {
  syn ArrayList<SGDclNode> Scope.dclQuery(String name) {
    ArrayList<SGDclNode> res = new ArrayList<SGDclNode>();
    beginQueryLog(name, "dclQuery");
    new Query().state1DCL(this, name, res, new SGVarNode(), new SGModNode());
    endQueryLog(name, res, "dclQuery");
    return res;
  }
  ...
}

aspect DeclarationResolution {

  class Query<T extends SGDclNode> {

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
        for (SGModNode sn: cur.imp()) {
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