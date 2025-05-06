/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:7
 * @production DatumVar : {@link Datum} ::= <span class="component">&lt;id:String&gt;</span> <span class="component">t:{@link Type}</span>;

 */
public class DatumVar extends Datum implements Cloneable {
  /**
   * @apilevel internal
   */
  public DatumVar clone() throws CloneNotSupportedException {
    DatumVar node = (DatumVar) super.clone();
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
  public DatumVar copy() {
    try {
      DatumVar node = (DatumVar) clone();
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
  public DatumVar fullCopy() {
    DatumVar tree = (DatumVar) copy();
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
  public DatumVar() {
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
    children = new ASTNode[1];
  }
  /**
   */
  public DatumVar(String p0, Type p1) {
    setid(p0);
    setChild(p1, 0);
    is$Final(true);
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
   * Replaces the t child.
   * @param node The new node to replace the t child.
   * @apilevel high-level
   */
  public void sett(Type node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the t child.
   * @return The current node used as the t child.
   * @apilevel high-level
   */
  public Type gett() {
    return (Type) getChild(0);
  }
  /**
   * Retrieves the t child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the t child.
   * @apilevel low-level
   */
  public Type gettNoTransform() {
    return (Type) getChildNoTransform(0);
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:430
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
