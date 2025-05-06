/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:18
 * @production PathCons : {@link Path} ::= <span class="component">h:{@link Edge}</span> <span class="component">t:{@link Path}</span>;

 */
public class PathCons extends Path implements Cloneable {
  /**
   * @apilevel internal
   */
  public PathCons clone() throws CloneNotSupportedException {
    PathCons node = (PathCons) super.clone();
    node.pp_visited = -1;
    node.pp_computed = false;
    node.pp_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public PathCons copy() {
    try {
      PathCons node = (PathCons) clone();
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
  public PathCons fullCopy() {
    PathCons tree = (PathCons) copy();
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
  public PathCons() {
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
   */
  public PathCons(Edge p0, Path p1) {
    setChild(p0, 0);
    setChild(p1, 1);
  }
  /**
   * @apilevel low-level
   */
  protected int numChildren() {
    return 2;
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
    pp_visited = -1;
    pp_computed = false;
    pp_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * Replaces the h child.
   * @param node The new node to replace the h child.
   * @apilevel high-level
   */
  public void seth(Edge node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the h child.
   * @return The current node used as the h child.
   * @apilevel high-level
   */
  public Edge geth() {
    return (Edge) getChild(0);
  }
  /**
   * Retrieves the h child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the h child.
   * @apilevel low-level
   */
  public Edge gethNoTransform() {
    return (Edge) getChildNoTransform(0);
  }
  /**
   * Replaces the t child.
   * @param node The new node to replace the t child.
   * @apilevel high-level
   */
  public void sett(Path node) {
    setChild(node, 1);
  }
  /**
   * Retrieves the t child.
   * @return The current node used as the t child.
   * @apilevel high-level
   */
  public Path gett() {
    return (Path) getChild(1);
  }
  /**
   * Retrieves the t child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the t child.
   * @apilevel low-level
   */
  public Path gettNoTransform() {
    return (Path) getChildNoTransform(1);
  }
  /**
   * @apilevel internal
   */
  protected int pp_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean pp_computed = false;
  /**
   * @apilevel internal
   */
  protected String pp_value;
  /**
   * @attribute syn
   * @aspect PrettyPrint
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:142
   */
  public String pp() {
    if(pp_computed) {
      return pp_value;
    }
    ASTNode$State state = state();
    if (pp_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: pp in class: org.jastadd.ast.AST.SynDecl");
    }
    pp_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    pp_value = pp_compute();
    if(isFinal && num == state().boundariesCrossed) {
      pp_computed = true;
    } else {
    }

    pp_visited = -1;
    return pp_value;
  }
  /**
   * @apilevel internal
   */
  private String pp_compute() {
  		return geth().gettgtNoTransform().pp() + " <- " + gett().pp();
  	}
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
