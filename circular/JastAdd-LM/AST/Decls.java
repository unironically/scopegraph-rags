/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_LM.ast:3
 * @production Decls : {@link ASTNode};

 */
public abstract class Decls extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Decls clone() throws CloneNotSupportedException {
    Decls node = (Decls) super.clone();
    node.scope_visited = -1;
    node.scope_computed = false;
    node.scope_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @aspect PrettyPrint
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:13
   */
  public void prettyPrint(StringBuilder sb, int t) {}
  /**
   */
  public Decls() {
    super();
  }
  /**
   * Initializes the child array to the correct size.
   * Initializes List and Opt nta children.
   * @apilevel internal
   * @ast method
   */
  public void init$Children() {
  }
  /**
   * @apilevel low-level
   */
  protected int numChildren() {
    return 0;
  }
  /**
   * @apilevel internal
   */
  public boolean mayHaveRewrite() {
    return false;
  }
  /**
   * @apilevel low-level
   */
  public void flushCache() {
    super.flushCache();
    scope_visited = -1;
    scope_computed = false;
    scope_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:110
   */
  public abstract ArrayList<Resolution> impTentatives();
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:78
   */
  public Scope scope() {
    if(scope_computed) {
      return scope_value;
    }
    ASTNode$State state = state();
    if (scope_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: scope in class: org.jastadd.ast.AST.InhDecl");
    }
    scope_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    scope_value = getParent().Define_Scope_scope(this, null);
    if(isFinal && num == state().boundariesCrossed) {
      scope_computed = true;
    } else {
    }

    scope_visited = -1;
    return scope_value;
  }
  /**
   * @apilevel internal
   */
  protected int scope_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean scope_computed = false;
  /**
   * @apilevel internal
   */
  protected Scope scope_value;
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:80
   * @apilevel internal
   */
  public Scope Define_Scope_scope(ASTNode caller, ASTNode child) {
     {
      int i = this.getIndexOfChild(caller);
{ return scope(); }
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
