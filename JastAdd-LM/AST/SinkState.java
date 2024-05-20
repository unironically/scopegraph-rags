/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_DFA.ast:14
 * @production SinkState : {@link State};

 */
public class SinkState extends State implements Cloneable {
  /**
   * @apilevel internal
   */
  public SinkState clone() throws CloneNotSupportedException {
    SinkState node = (SinkState) super.clone();
    node.resolve_String_Scope_visited = null;
    node.resolve_String_Scope_values = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public SinkState copy() {
    try {
      SinkState node = (SinkState) clone();
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
  public SinkState fullCopy() {
    SinkState tree = (SinkState) copy();
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
  public SinkState() {
    super();
  }
  /**
   * Initializes the child array to the correct size.
   * Initializes List and Opt nta children.
   * @apilevel internal
   * @ast method
   */
  public void init$Children() {
    children = new ASTNode[4];
  }
  /**
   */
  public SinkState(Integer p0, State p1, State p2, State p3, State p4, Boolean p5) {
    setId(p0);
    setChild(p1, 0);
    setChild(p2, 1);
    setChild(p3, 2);
    setChild(p4, 3);
    setFinal(p5);
  }
  /**
   * @apilevel low-level
   */
  protected int numChildren() {
    return 4;
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
   * Replaces the lexeme Id.
   * @param value The new value for the lexeme Id.
   * @apilevel high-level
   */
  public void setId(Integer value) {
    tokenInteger_Id = value;
  }
  /**
   * Retrieves the value for the lexeme Id.
   * @return The value for the lexeme Id.
   * @apilevel high-level
   */
  public Integer getId() {
    return tokenInteger_Id;
  }
  /**
   * Replaces the LexTrans child.
   * @param node The new node to replace the LexTrans child.
   * @apilevel high-level
   */
  public void setLexTrans(State node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the LexTrans child.
   * @return The current node used as the LexTrans child.
   * @apilevel high-level
   */
  public State getLexTrans() {
    return (State) getChild(0);
  }
  /**
   * Retrieves the LexTrans child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the LexTrans child.
   * @apilevel low-level
   */
  public State getLexTransNoTransform() {
    return (State) getChildNoTransform(0);
  }
  /**
   * Replaces the ImpTrans child.
   * @param node The new node to replace the ImpTrans child.
   * @apilevel high-level
   */
  public void setImpTrans(State node) {
    setChild(node, 1);
  }
  /**
   * Retrieves the ImpTrans child.
   * @return The current node used as the ImpTrans child.
   * @apilevel high-level
   */
  public State getImpTrans() {
    return (State) getChild(1);
  }
  /**
   * Retrieves the ImpTrans child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the ImpTrans child.
   * @apilevel low-level
   */
  public State getImpTransNoTransform() {
    return (State) getChildNoTransform(1);
  }
  /**
   * Replaces the ModTrans child.
   * @param node The new node to replace the ModTrans child.
   * @apilevel high-level
   */
  public void setModTrans(State node) {
    setChild(node, 2);
  }
  /**
   * Retrieves the ModTrans child.
   * @return The current node used as the ModTrans child.
   * @apilevel high-level
   */
  public State getModTrans() {
    return (State) getChild(2);
  }
  /**
   * Retrieves the ModTrans child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the ModTrans child.
   * @apilevel low-level
   */
  public State getModTransNoTransform() {
    return (State) getChildNoTransform(2);
  }
  /**
   * Replaces the VarTrans child.
   * @param node The new node to replace the VarTrans child.
   * @apilevel high-level
   */
  public void setVarTrans(State node) {
    setChild(node, 3);
  }
  /**
   * Retrieves the VarTrans child.
   * @return The current node used as the VarTrans child.
   * @apilevel high-level
   */
  public State getVarTrans() {
    return (State) getChild(3);
  }
  /**
   * Retrieves the VarTrans child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the VarTrans child.
   * @apilevel low-level
   */
  public State getVarTransNoTransform() {
    return (State) getChildNoTransform(3);
  }
  /**
   * Replaces the lexeme Final.
   * @param value The new value for the lexeme Final.
   * @apilevel high-level
   */
  public void setFinal(Boolean value) {
    tokenBoolean_Final = value;
  }
  /**
   * Retrieves the value for the lexeme Final.
   * @return The value for the lexeme Final.
   * @apilevel high-level
   */
  public Boolean getFinal() {
    return tokenBoolean_Final;
  }
  /**
   * @apilevel internal
   */
  protected java.util.Map resolve_String_Scope_visited;
  protected java.util.Map resolve_String_Scope_values;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Resolution.jrag:187
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
  private ArrayList<Scope> resolve_compute(String id, Scope currentScope) {
      System.out.println(Scope.indent() + "At the sink state. Nothing to do or return.");
      return new ArrayList<Scope>();
    }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
