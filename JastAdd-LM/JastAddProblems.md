# Issues with JastAdd
 


#### Use of `==` instead of `.equals(..)` for inherited attribute collection

A node of the type `Ref` (scope graph reference node) is defined as a NTA in 
the `VarRef` LM production. The `Ref` node needs to be supplied a `lex` 
definition, as is done in the below code for the `VarRef` production. Note that 
`MkVarRef` is a subclass of `Ref`.

```Java
aspect Scoping {

  ...

  /*---------- VarRef ----------*/

  // top.r = mkVarRef(id)
  syn nta MkVarRef VarRef.r() = new MkVarRef(getId());

  // r.lex = [top.scope]
  eq VarRef.r().lex() { ArrayList<Scope> lexLst = new ArrayList<Scope>(); 
                        lexLst.add(this.scope()); return lexLst; }

  ...

}
```

For the `MkVarRef` to collect its inherited `lex` value, it invokes its parent 
class `Ref`'s `lex()` method from the generated code below, since the behavior 
of `MkVarRef` and `MkModRef` is defined uniformly for the abstract `Ref` node 
type:

```Java
public abstract class Ref extends ASTNode<ASTNode> implements Cloneable {

  ...

  public ArrayList<Scope> lex() {
    if(lex_computed) {
      return lex_value;
    }
    ASTNode$State state = state();
    if (lex_visited == state().boundariesCrossed) {
      throw new RuntimeException
      ("Circular definition of attr: lex in class: org.jastadd.ast.AST.InhDecl");
    }
    lex_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    lex_value = getParent().Define_ArrayList_Scope__lex(this, null);
    if(isFinal && num == state().boundariesCrossed) {
      lex_computed = true;
    } else {
    }

    lex_visited = -1;
    return lex_value;
  }

  ...

}
```

Where `getParent()` in this instance returns the LM `VarRef` node which defined 
this scope graph `Ref` NTA - whose `Scoping.jrag` code is the first snippet in 
this subsection.

Then invoking `Define_ArrayList_Scope__lex(this, null)` on that parent executes 
the generated code in the snippet below, in `AST/VarRef.java`. 

Needed to modify the code with which a child collects its inherited attribute 
values as in the below, using the `equals` method instead of `==`. Example 
below is in `AST/VarRef.java`.

```Java
public class VarRef extends ASTNode<ASTNode> implements Cloneable {

  ...

  public ArrayList<Scope> Define_ArrayList_Scope__lex(ASTNode caller, 
                                                      ASTNode child) {

    // luke addition
    if (caller.equals(getrNoTransform())) { 
      ArrayList<Scope> lexLst = new ArrayList<Scope>(); 
      lexLst.add(this.scope());
      return lexLst;
    }

    /*if (caller == getrNoTransform()) { 
      ArrayList<Scope> lexLst = new ArrayList<Scope>(); 
      lexLst.add(this.scope());
      return new ArrayList<Scope>();
    }*/
                        
    else {
      return getParent().Define_ArrayList_Scope__lex(this, caller);
    }
  }

  ...

}
```

Without this change to the generated code, we get an output such as the below:

```
Exception in thread "main" java.lang.NullPointerException: Cannot invoke "AST.ASTNode.Define_ArrayList_Scope__lex(AST.ASTNode, AST.ASTNode)" because the return value of "AST.Program.getParent()" is null
	at AST.Program.Define_ArrayList_Scope__lex(Program.java:284)
	at AST.ASTNode.Define_ArrayList_Scope__lex(ASTNode.java:647)
	at AST.ASTNode.Define_ArrayList_Scope__lex(ASTNode.java:647)
	at AST.ASTNode.Define_ArrayList_Scope__lex(ASTNode.java:647)
	at AST.ASTNode.Define_ArrayList_Scope__lex(ASTNode.java:647)
	at AST.ParBind.Define_ArrayList_Scope__lex(ParBind.java:405)
	at AST.ASTNode.Define_ArrayList_Scope__lex(ASTNode.java:647)
	at AST.VarRef.Define_ArrayList_Scope__lex(VarRef.java:352)
	at AST.Ref.lex(Ref.java:211)
	at AST.MkVarRef.varRes_compute(MkVarRef.java:269)
	at AST.MkVarRef.varRes(MkVarRef.java:257)
	at AST.MkVarRef.binds_compute(MkVarRef.java:399)
	at AST.MkVarRef.binds(MkVarRef.java:385)
	at AST.VarRef.binds_compute(VarRef.java:305)
	at AST.VarRef.binds(VarRef.java:293)
	at AST.Expr.binds_compute(Expr.java:117)
	at AST.Expr.binds(Expr.java:103)
	at AST.ParBind.binds_compute(ParBind.java:360)
	at AST.ParBind.binds(ParBind.java:348)
	at AST.DefDecl.binds_compute(DefDecl.java:233)
	at AST.DefDecl.binds(DefDecl.java:221)
	at AST.DeclsCons.binds_compute(DeclsCons.java:216)
	at AST.DeclsCons.binds(DeclsCons.java:202)
	at AST.DeclsCons.binds_compute(DeclsCons.java:217)
	at AST.DeclsCons.binds(DeclsCons.java:202)
	at AST.DeclsCons.binds_compute(DeclsCons.java:217)
	at AST.DeclsCons.binds(DeclsCons.java:202)
	at AST.Program.binds_compute(Program.java:266)
	at AST.Program.binds(Program.java:254)
	at Compiler.run(Compiler.java:53)
	at Compiler.main(Compiler.java:20)
```



#### NTAs not being assigned as children to the production they belong to

After the problem in the previous section was solved, needed to go into the 
generated JastAdd code to add the `setChild(r_value, 0)` statement in the code 
below, so that the result of `VarRef.getrNoTransform()` is not null, but correctly the `MkVarRef r()` which is initialized as an NTA in `Scoping.jrag` (seen in prev. subsection). Example below shows relevant parts of `AST/VarRef.java` and `AST/ASTNode.java`. Without the addition of `setChild(r_value, 0)`, no [nonterminal-typed] child exists from the perspective of `VarRef`.

```Java
// AST/VarRef.java
public class VarRef extends ASTNode<ASTNode> implements Cloneable {

  ...

  public MkVarRef getrNoTransform() {
    return (MkVarRef) getChildNoTransform(0); // essentially getChild(0)
  }

  ...

  public MkVarRef r() {
    if(r_computed) {
      return r_value;
    }
    ASTNode$State state = state();
    if (r_visited == state().boundariesCrossed) {
      throw new RuntimeException
      ("Circular definition of attr: r in class: org.jastadd.ast.AST.SynDecl");
    }
    r_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    r_value = r_compute();
    
    r_value.setParent(this);
    setChild(r_value, 0); // luke addition

    r_value.is$Final = true;
    if(true) {
      r_computed = true;
    } else {
    }

    r_visited = -1;
    return r_value;
  }
  
  ...

}

// AST/ASTNode.java
public class ASTNode<T extends ASTNode> implements Cloneable, Iterable<T> {

  ...

  public final T getChildNoTransform(int i) {
    if (children == null) {
      return null;
    }
    T child = (T)children[i];
    return child;
  }

  ...

}
```

Following this fix (and that in the last subsection) for this particular 
inherited attribute, the `MkVarRef` node from the previous subsection is able to find its proper value. However, the same problem exists for other instances of inherited attributes.