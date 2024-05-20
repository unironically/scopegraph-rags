/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_Scope.ast:3
 * @production ScopeDatum : {@link Scope} ::= <span class="component">Datum:{@link Datum}</span>;

 */
public class ScopeDatum extends Scope implements Cloneable {
  /**
   * @apilevel internal
   */
  public ScopeDatum clone() throws CloneNotSupportedException {
    ScopeDatum node = (ScopeDatum) super.clone();
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public ScopeDatum copy() {
    try {
      ScopeDatum node = (ScopeDatum) clone();
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
  public ScopeDatum fullCopy() {
    ScopeDatum tree = (ScopeDatum) copy();
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
  public ScopeDatum() {
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
  public ScopeDatum(String p0, Datum p1) {
    setName(p0);
    setChild(p1, 0);
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
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * Replaces the lexeme Name.
   * @param value The new value for the lexeme Name.
   * @apilevel high-level
   */
  public void setName(String value) {
    tokenString_Name = value;
  }
  /**
   * Retrieves the value for the lexeme Name.
   * @return The value for the lexeme Name.
   * @apilevel high-level
   */
  public String getName() {
    return tokenString_Name != null ? tokenString_Name : "";
  }
  /**
   * Replaces the Datum child.
   * @param node The new node to replace the Datum child.
   * @apilevel high-level
   */
  public void setDatum(Datum node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the Datum child.
   * @return The current node used as the Datum child.
   * @apilevel high-level
   */
  public Datum getDatum() {
    return (Datum) getChild(0);
  }
  /**
   * Retrieves the Datum child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Datum child.
   * @apilevel low-level
   */
  public Datum getDatumNoTransform() {
    return (Datum) getChildNoTransform(0);
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
