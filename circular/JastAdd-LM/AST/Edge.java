/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:21
 * @production Edge : {@link ASTNode} ::= <span class="component">tgt:{@link Scope}</span>;

 */
public abstract class Edge extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Edge clone() throws CloneNotSupportedException {
    Edge node = (Edge) super.clone();
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @aspect Paths
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Paths.jadd:43
   */
  public boolean equals(Object o) {
    
    if (this instanceof LexEdge && o instanceof LexEdge) {
      LexEdge current = (LexEdge) this;
      LexEdge other = (LexEdge) o;
      boolean b = 
        current.getsrcNoTransform().equals(other.getsrcNoTransform()) &&
        current.gettgtNoTransform().equals(other.gettgtNoTransform());
      return b;
    }

    if (this instanceof LexEdgeRef && o instanceof LexEdgeRef) {
      LexEdgeRef other = (LexEdgeRef) o;
      LexEdgeRef current = (LexEdgeRef) this;
      boolean b =  
        current.getsrcNoTransform().equals(other.getsrcNoTransform()) &&
        current.gettgtNoTransform().equals(other.gettgtNoTransform());
      return b;
    }

    if (this instanceof ImpEdge && o instanceof ImpEdge) {
      ImpEdge other = (ImpEdge) o;
      ImpEdge current = (ImpEdge) this;
      boolean b =  
        current.getsrcNoTransform().equals(other.getsrcNoTransform()) &&
        current.gettgtNoTransform().equals(other.gettgtNoTransform());
      return b;
    }

    if (this instanceof ModEdge && o instanceof ModEdge) {
      ModEdge other = (ModEdge) o;
      ModEdge current = (ModEdge) this;
      boolean b =  
        current.getsrcNoTransform().equals(other.getsrcNoTransform()) &&
        current.gettgtNoTransform().equals(other.gettgtNoTransform());
      return b;
    }

    if (this instanceof VarEdge && o instanceof VarEdge) {
      VarEdge other = (VarEdge) o;
      VarEdge current = (VarEdge) this;
      boolean b =  
        current.getsrcNoTransform().equals(other.getsrcNoTransform()) &&
        current.gettgtNoTransform().equals(other.gettgtNoTransform());
      return b;
    }

    if (this instanceof ImpTentEdge && o instanceof ImpTentEdge) {
      ImpTentEdge other = (ImpTentEdge) o;
      ImpTentEdge current = (ImpTentEdge) this;
      boolean b =  
        current.getsrcNoTransform().equals(other.getsrcNoTransform()) &&
        current.gettgtNoTransform().equals(other.gettgtNoTransform());
      return b;
    }

    return false;

  }
  /**
   */
  public Edge() {
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
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
