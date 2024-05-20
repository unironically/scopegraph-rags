/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_LM.ast:14
 * @production IntExpr : {@link Expr} ::= <span class="component">&lt;Value:Integer&gt;</span>;

 */
public class IntExpr extends Expr implements Cloneable {
  /**
   * @apilevel internal
   */
  public IntExpr clone() throws CloneNotSupportedException {
    IntExpr node = (IntExpr) super.clone();
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
  public IntExpr copy() {
    try {
      IntExpr node = (IntExpr) clone();
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
  public IntExpr fullCopy() {
    IntExpr tree = (IntExpr) copy();
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/PrettyPrint.jrag:52
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("IntExpr (").append(Integer.toString(getValue())).append(")");
	}
  /**
   */
  public IntExpr() {
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
   */
  public IntExpr(Integer p0) {
    setValue(p0);
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
   * Replaces the lexeme Value.
   * @param value The new value for the lexeme Value.
   * @apilevel high-level
   */
  public void setValue(Integer value) {
    tokenInteger_Value = value;
  }
  /**
   * @apilevel internal
   */
  protected Integer tokenInteger_Value;
  /**
   * Retrieves the value for the lexeme Value.
   * @return The value for the lexeme Value.
   * @apilevel high-level
   */
  public Integer getValue() {
    return tokenInteger_Value;
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Typing.jrag:33
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
  private Type type_compute() { return new IntType(); }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
