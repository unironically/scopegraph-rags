/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:15
 * @production Resolution : {@link ASTNode} ::= <span class="component">ref:{@link Ref}</span> <span class="component">path:{@link Path}</span>;

 */
public class Resolution extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Resolution clone() throws CloneNotSupportedException {
    Resolution node = (Resolution) super.clone();
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
  public Resolution copy() {
    try {
      Resolution node = (Resolution) clone();
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
  public Resolution fullCopy() {
    Resolution tree = (Resolution) copy();
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
   * @aspect Paths
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Paths.jadd:104
   */
  public boolean equals(Object o) {
    if (!(o instanceof Resolution)) return false;

    //System.out.println("Testing resolution equality");

    Resolution other = (Resolution) o;

    return this.getrefNoTransform().equals(other.getrefNoTransform()) &&
           this.getpathNoTransform().equals(other.getpathNoTransform());
  }
  /**
   */
  public Resolution() {
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
   * Replaces the ref child.
   * @param node The new node to replace the ref child.
   * @apilevel high-level
   */
  public void setref(Ref node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the ref child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the ref child.
   * @apilevel low-level
   */
  public Ref getrefNoTransform() {
    return (Ref) getChildNoTransform(0);
  }
  /**
   * Retrieves the child position of the optional child ref.
   * @return The the child position of the optional child ref.
   * @apilevel low-level
   */
  protected int getrefChildPosition() {
    return 0;
  }
  /**
   * Replaces the path child.
   * @param node The new node to replace the path child.
   * @apilevel high-level
   */
  public void setpath(Path node) {
    setChild(node, 1);
  }
  /**
   * Retrieves the path child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the path child.
   * @apilevel low-level
   */
  public Path getpathNoTransform() {
    return (Path) getChildNoTransform(1);
  }
  /**
   * Retrieves the child position of the optional child path.
   * @return The the child position of the optional child path.
   * @apilevel low-level
   */
  protected int getpathChildPosition() {
    return 1;
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:134
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
  		return getpathNoTransform().pp();
  	}
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
