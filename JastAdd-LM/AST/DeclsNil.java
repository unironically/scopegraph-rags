/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_LM.ast:4
 * @production DeclsNil : {@link Decls};

 */
public class DeclsNil extends Decls implements Cloneable {
  /**
   * @apilevel internal
   */
  public DeclsNil clone() throws CloneNotSupportedException {
    DeclsNil node = (DeclsNil) super.clone();
    node.ok_visited = -1;
    node.ok_computed = false;
    node.ok_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public DeclsNil copy() {
    try {
      DeclsNil node = (DeclsNil) clone();
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
  public DeclsNil fullCopy() {
    DeclsNil tree = (DeclsNil) copy();
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/PrettyPrint.jrag:14
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("DeclsNil ()");
	}
  /**
   */
  public DeclsNil() {
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Typing.jrag:14
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
  private Boolean ok_compute() {  return true;  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
