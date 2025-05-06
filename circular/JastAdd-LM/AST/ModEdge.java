/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:25
 * @production ModEdge : {@link Edge} ::= <span class="component">src:{@link Scope}</span>;

 */
public class ModEdge extends Edge implements Cloneable {
  /**
   * @apilevel internal
   */
  public ModEdge clone() throws CloneNotSupportedException {
    ModEdge node = (ModEdge) super.clone();
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public ModEdge copy() {
    try {
      ModEdge node = (ModEdge) clone();
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
  public ModEdge fullCopy() {
    ModEdge tree = (ModEdge) copy();
    if (children != null) {
      for (int i = 0; i < children.length; ++i) {
        switch (i) {
        case 0:
        case 1:
          tree.children[i] = null;
          continue;
        }
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
  public ModEdge() {
    super();
  }
  /**
   * Initializes the child array to the correct size.
   * Initializes List and Opt nta children.
   * @apilevel internal
   * @ast method
   */
  public void init$Children() {
    children = new ASTNode[2];
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
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * Replaces the tgt child.
   * @param node The new node to replace the tgt child.
   * @apilevel high-level
   */
  public void settgt(Scope node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the tgt child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the tgt child.
   * @apilevel low-level
   */
  public Scope gettgtNoTransform() {
    return (Scope) getChildNoTransform(0);
  }
  /**
   * Retrieves the child position of the optional child tgt.
   * @return The the child position of the optional child tgt.
   * @apilevel low-level
   */
  protected int gettgtChildPosition() {
    return 0;
  }
  /**
   * Replaces the src child.
   * @param node The new node to replace the src child.
   * @apilevel high-level
   */
  public void setsrc(Scope node) {
    setChild(node, 1);
  }
  /**
   * Retrieves the src child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the src child.
   * @apilevel low-level
   */
  public Scope getsrcNoTransform() {
    return (Scope) getChildNoTransform(1);
  }
  /**
   * Retrieves the child position of the optional child src.
   * @return The the child position of the optional child src.
   * @apilevel low-level
   */
  protected int getsrcChildPosition() {
    return 1;
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
