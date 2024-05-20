/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_LM.ast:7
 * @production Decl : {@link ASTNode};

 */
public abstract class Decl extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Decl clone() throws CloneNotSupportedException {
    Decl node = (Decl) super.clone();
    node.ok_visited = -1;
    node.ok_computed = false;
    node.ok_value = null;
    node.scope_visited = -1;
    node.scope_computed = false;
    node.scope_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @aspect PrettyPrint
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/PrettyPrint.jrag:26
   */
  public void prettyPrint(StringBuilder sb, int t) {}
  /**
   */
  public Decl() {
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
    ok_visited = -1;
    ok_computed = false;
    ok_value = null;
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
   * @apilevel internal
   */
  protected int ok_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean ok_computed = false;
  /**
   * @apilevel internal
   */
  protected Boolean ok_value;
  /**
   * @attribute syn
   * @aspect Typing
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Typing.jrag:19
   */
  public Boolean ok() {
    if(ok_computed) {
      return ok_value;
    }
    ASTNode$State state = state();
    if (ok_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: ok in class: org.jastadd.ast.AST.SynDecl");
    }
    ok_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    ok_value = ok_compute();
    if(isFinal && num == state().boundariesCrossed) {
      ok_computed = true;
    } else {
    }

    ok_visited = -1;
    return ok_value;
  }
  /**
   * @apilevel internal
   */
  private Boolean ok_compute() {  return false;  }
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:35
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
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
