/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_LM.ast:12
 * @production Expr : {@link ASTNode};

 */
public abstract class Expr extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Expr clone() throws CloneNotSupportedException {
    Expr node = (Expr) super.clone();
    node.refs_visited = -1;
    node.refs_computed = false;
    node.refs_value = null;
    node.scope_visited = -1;
    node.scope_computed = false;
    node.scope_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @aspect PrettyPrint
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:46
   */
  public void prettyPrint(StringBuilder sb, int t) {}
  /**
   */
  public Expr() {
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
    refs_visited = -1;
    refs_computed = false;
    refs_value = null;
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
  protected int refs_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean refs_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<MkVarRef> refs_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:286
   */
  public ArrayList<MkVarRef> refs() {
    if(refs_computed) {
      return refs_value;
    }
    ASTNode$State state = state();
    if (refs_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: refs in class: org.jastadd.ast.AST.SynDecl");
    }
    refs_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    refs_value = refs_compute();
    if(isFinal && num == state().boundariesCrossed) {
      refs_computed = true;
    } else {
    }

    refs_visited = -1;
    return refs_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<MkVarRef> refs_compute() {
      ArrayList<MkVarRef> refsRet = new ArrayList<MkVarRef>();
      for (int i = 0; i < this.getNumChildNoTransform(); i++) {
        refsRet.addAll(this.getChild(i).refs());
      }
      return refsRet;
    }
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:281
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
