/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_Scope.ast:5
 * @production Datum : {@link ASTNode} ::= <span class="component">&lt;Id:String&gt;</span>;

 */
public abstract class Datum extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Datum clone() throws CloneNotSupportedException {
    Datum node = (Datum) super.clone();
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   */
  public Datum() {
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
  public Datum(String p0) {
    setId(p0);
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
   * Replaces the lexeme Id.
   * @param value The new value for the lexeme Id.
   * @apilevel high-level
   */
  public void setId(String value) {
    tokenString_Id = value;
  }
  /**
   * @apilevel internal
   */
  protected String tokenString_Id;
  /**
   * Retrieves the value for the lexeme Id.
   * @return The value for the lexeme Id.
   * @apilevel high-level
   */
  public String getId() {
    return tokenString_Id != null ? tokenString_Id : "";
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
