/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_LM.ast:24
 * @production Type : {@link ASTNode};

 */
public abstract class Type extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Type clone() throws CloneNotSupportedException {
    Type node = (Type) super.clone();
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   */
  public Type() {
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
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
