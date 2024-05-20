/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_DFA.ast:1
 * @production DFA : {@link ASTNode} ::= <span class="component">Start:{@link State}</span>;

 */
public class DFA extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public DFA clone() throws CloneNotSupportedException {
    DFA node = (DFA) super.clone();
    node.resolve_String_Scope_visited = null;
    node.resolve_String_Scope_values = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public DFA copy() {
    try {
      DFA node = (DFA) clone();
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
  public DFA fullCopy() {
    DFA tree = (DFA) copy();
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
  public DFA() {
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
  public DFA(State p0) {
    setChild(p0, 0);
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
    resolve_String_Scope_visited = null;
    resolve_String_Scope_values = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * Replaces the Start child.
   * @param node The new node to replace the Start child.
   * @apilevel high-level
   */
  public void setStart(State node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the Start child.
   * @return The current node used as the Start child.
   * @apilevel high-level
   */
  public State getStart() {
    return (State) getChild(0);
  }
  /**
   * Retrieves the Start child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Start child.
   * @apilevel low-level
   */
  public State getStartNoTransform() {
    return (State) getChildNoTransform(0);
  }
  /**
   * @apilevel internal
   */
  protected java.util.Map resolve_String_Scope_visited;
  protected java.util.Map resolve_String_Scope_values;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Resolution.jrag:105
   */
  public ArrayList<Scope> resolve(String id, Scope currentScope) {
    java.util.List _parameters = new java.util.ArrayList(2);
    _parameters.add(id);
    _parameters.add(currentScope);
    if(resolve_String_Scope_visited == null) resolve_String_Scope_visited = new java.util.HashMap(4);
    if(resolve_String_Scope_values == null) resolve_String_Scope_values = new java.util.HashMap(4);
    if(resolve_String_Scope_values.containsKey(_parameters)) {
      return (ArrayList<Scope>)resolve_String_Scope_values.get(_parameters);
    }
    ASTNode$State state = state();
    if (Integer.valueOf(state().boundariesCrossed).equals(resolve_String_Scope_visited.get(_parameters))) {
      throw new RuntimeException("Circular definition of attr: resolve in class: org.jastadd.ast.AST.SynDecl");
    }
    resolve_String_Scope_visited.put(_parameters, Integer.valueOf(state().boundariesCrossed));
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    ArrayList<Scope> resolve_String_Scope_value = resolve_compute(id, currentScope);
    if(isFinal && num == state().boundariesCrossed) {
      resolve_String_Scope_values.put(_parameters, resolve_String_Scope_value);
    } else {
    }

    resolve_String_Scope_visited.remove(_parameters);
    return resolve_String_Scope_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Scope> resolve_compute(String id, Scope currentScope) {  return getStart().resolve(id, currentScope);  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
