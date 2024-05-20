/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_LM.ast:13
 * @production VarExpr : {@link Expr} ::= <span class="component">Ref:{@link VarRef}</span>;

 */
public class VarExpr extends Expr implements Cloneable {
  /**
   * @apilevel internal
   */
  public VarExpr clone() throws CloneNotSupportedException {
    VarExpr node = (VarExpr) super.clone();
    node.type_visited = -1;
    node.type_computed = false;
    node.type_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public VarExpr copy() {
    try {
      VarExpr node = (VarExpr) clone();
      node.parent = null;
      if(children != null) {
        node.children = (ASTNode[]) children.clone();
      }
      return node;
    } catch (CloneNotSupportedException e) {
      throw new Error("Error: clone not supported for " + getClass().getName());
    }
  }
  /**
   * Create a deep copy of the AST subtree at this node.
   * The copy is dangling, i.e. has no parent.
   * @return dangling copy of the subtree at this node
   * @apilevel low-level
   */
  public VarExpr fullCopy() {
    VarExpr tree = (VarExpr) copy();
    if (children != null) {
      for (int i = 0; i < children.length; ++i) {
        ASTNode child = (ASTNode) children[i];
        if(child != null) {
          child = child.fullCopy();
          tree.setChild(child, i);
        }
      }
    }
    return tree;
  }
  /**
   * @aspect PrettyPrint
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/PrettyPrint.jrag:47
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("VarExpr (\n");
		getRef().prettyPrint(sb, t+1);
		sb.append("\n").append(getIndent(t)).append(")");
	}
  /**
   */
  public VarExpr() {
    super();
  }
  /**
   * Initializes the child array to the correct size.
   * Initializes List and Opt nta children.
   * @apilevel internal
   * @ast method
   */
  public void init$Children() {
    children = new ASTNode[1];
  }
  /**
   */
  public VarExpr(VarRef p0) {
    setChild(p0, 0);
  }
  /**
   * @apilevel low-level
   */
  protected int numChildren() {
    return 1;
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
    type_visited = -1;
    type_computed = false;
    type_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * Replaces the Ref child.
   * @param node The new node to replace the Ref child.
   * @apilevel high-level
   */
  public void setRef(VarRef node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the Ref child.
   * @return The current node used as the Ref child.
   * @apilevel high-level
   */
  public VarRef getRef() {
    return (VarRef) getChild(0);
  }
  /**
   * Retrieves the Ref child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Ref child.
   * @apilevel low-level
   */
  public VarRef getRefNoTransform() {
    return (VarRef) getChildNoTransform(0);
  }
  /**
   * @apilevel internal
   */
  protected int type_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean type_computed = false;
  /**
   * @apilevel internal
   */
  protected Type type_value;
  /**
   * @attribute syn
   * @aspect Typing
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Typing.jrag:31
   */
  public Type type() {
    if(type_computed) {
      return type_value;
    }
    ASTNode$State state = state();
    if (type_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: type in class: org.jastadd.ast.AST.SynDecl");
    }
    type_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    type_value = type_compute();
    if(isFinal && num == state().boundariesCrossed) {
      type_computed = true;
    } else {
    }

    type_visited = -1;
    return type_value;
  }
  /**
   * @apilevel internal
   */
  private Type type_compute() { return getRef().type(); }
  /**
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:82
   * @apilevel internal
   */
  public Scope Define_Scope_scope(ASTNode caller, ASTNode child) {
    if (caller == getRefNoTransform()){ return scope(); }
    else {
      return getParent().Define_Scope_scope(this, caller);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
