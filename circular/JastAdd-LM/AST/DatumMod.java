/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:8
 * @production DatumMod : {@link Datum} ::= <span class="component">&lt;id:String&gt;</span>;

 */
public class DatumMod extends Datum implements Cloneable {
  /**
   * @apilevel internal
   */
  public DatumMod clone() throws CloneNotSupportedException {
    DatumMod node = (DatumMod) super.clone();
    node.str_visited = -1;
    node.str_computed = false;
    node.str_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public DatumMod copy() {
    try {
      DatumMod node = (DatumMod) clone();
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
  public DatumMod fullCopy() {
    DatumMod tree = (DatumMod) copy();
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
   */
  public DatumMod() {
    super();
    is$Final(true);
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
  public DatumMod(String p0) {
    setid(p0);
    is$Final(true);
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
    str_visited = -1;
    str_computed = false;
    str_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * Replaces the lexeme id.
   * @param value The new value for the lexeme id.
   * @apilevel high-level
   */
  public void setid(String value) {
    tokenString_id = value;
  }
  /**
   * @apilevel internal
   */
  protected String tokenString_id;
  /**
   * Retrieves the value for the lexeme id.
   * @return The value for the lexeme id.
   * @apilevel high-level
   */
  public String getid() {
    return tokenString_id != null ? tokenString_id : "";
  }
  /**
   * @apilevel internal
   */
  protected int str_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean str_computed = false;
  /**
   * @apilevel internal
   */
  protected String str_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:434
   */
  public String str() {
    if(str_computed) {
      return str_value;
    }
    ASTNode$State state = state();
    if (str_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: str in class: org.jastadd.ast.AST.SynDecl");
    }
    str_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    str_value = str_compute();
    if(isFinal && num == state().boundariesCrossed) {
      str_computed = true;
    } else {
    }

    str_visited = -1;
    return str_value;
  }
  /**
   * @apilevel internal
   */
  private String str_compute() {
      return getid();
    }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
