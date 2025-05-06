/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_LM.ast:4
 * @production DeclsNil : {@link Decls};

 */
public class DeclsNil extends Decls implements Cloneable {
  /**
   * @apilevel internal
   */
  public DeclsNil clone() throws CloneNotSupportedException {
    DeclsNil node = (DeclsNil) super.clone();
    node.impTentatives_visited = -1;
    node.impTentatives_computed = false;
    node.impTentatives_initialized = false;
    node.impTentatives_value = null;
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:14
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
    impTentatives_visited = -1;
    impTentatives_computed = false;
    impTentatives_initialized = false;
    impTentatives_value = null;
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
  protected int impTentatives_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean impTentatives_computed = false;
  /**
   * @apilevel internal
   */
  protected boolean impTentatives_initialized = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Resolution> impTentatives_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:119
   */
  public ArrayList<Resolution> impTentatives() {
    if(impTentatives_computed) {
      return impTentatives_value;
    }
    ASTNode$State state = state();
    if (!impTentatives_initialized) {
      impTentatives_initialized = true;
      impTentatives_value = new ArrayList<Resolution>();
    }
    if (!state.IN_CIRCLE) {
      state.IN_CIRCLE = true;
      int num = state.boundariesCrossed;
      boolean isFinal = this.is$Final();
      // TODO: fixme
      // state().CIRCLE_INDEX = 1;
      do {
        impTentatives_visited = state.CIRCLE_INDEX;
        state.CHANGE = false;
        ArrayList<Resolution> new_impTentatives_value = impTentatives_compute();
        if ((new_impTentatives_value==null && impTentatives_value!=null) || (new_impTentatives_value!=null && !new_impTentatives_value.equals(impTentatives_value))) {
          state.CHANGE = true;
        }
        impTentatives_value = new_impTentatives_value;
        state.CIRCLE_INDEX++;
      } while (state.CHANGE);
      if(isFinal && num == state().boundariesCrossed) {
        impTentatives_computed = true;
        state.LAST_CYCLE = true;
        impTentatives_compute();
        state.LAST_CYCLE = false;
      } else {
        state.RESET_CYCLE = true;
        impTentatives_compute();
        state.RESET_CYCLE = false;
        impTentatives_computed = false;
        impTentatives_initialized = false;
      }
      state.IN_CIRCLE = false;
      return impTentatives_value;
    }
    if(impTentatives_visited != state.CIRCLE_INDEX) {
      impTentatives_visited = state.CIRCLE_INDEX;
      if (state.LAST_CYCLE) {
      impTentatives_computed = true;
        ArrayList<Resolution> new_impTentatives_value = impTentatives_compute();
        return new_impTentatives_value;
      }
      if (state.RESET_CYCLE) {
        impTentatives_computed = false;
        impTentatives_initialized = false;
        impTentatives_visited = -1;
        return impTentatives_value;
      }
      ArrayList<Resolution> new_impTentatives_value = impTentatives_compute();
      if ((new_impTentatives_value==null && impTentatives_value!=null) || (new_impTentatives_value!=null && !new_impTentatives_value.equals(impTentatives_value))) {
        state.CHANGE = true;
      }
      impTentatives_value = new_impTentatives_value;
      return impTentatives_value;
    }
    return impTentatives_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Resolution> impTentatives_compute() {  return new ArrayList<Resolution>();  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
