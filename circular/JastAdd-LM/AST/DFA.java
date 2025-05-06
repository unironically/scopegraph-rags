/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_DFA.ast:1
 * @production DFA : {@link ASTNode} ::= <span class="component">sinkState:{@link State}</span> <span class="component">finalState:{@link State}</span> <span class="component">lexState:{@link State}</span> <span class="component">impState:{@link State}</span>;

 */
public abstract class DFA extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public DFA clone() throws CloneNotSupportedException {
    DFA node = (DFA) super.clone();
    node.decls_Ref_Scope_Path_visited = null;
    node.finalState_visited = -1;
    node.finalState_computed = false;
    node.finalState_value = null;
    node.sinkState_visited = -1;
    node.sinkState_computed = false;
    node.sinkState_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   */
  public DFA() {
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
    decls_Ref_Scope_Path_visited = null;
    finalState_visited = -1;
    finalState_computed = false;
    finalState_value = null;
    sinkState_visited = -1;
    sinkState_computed = false;
    sinkState_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * Replaces the sinkState child.
   * @param node The new node to replace the sinkState child.
   * @apilevel high-level
   */
  public void setsinkState(State node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the sinkState child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the sinkState child.
   * @apilevel low-level
   */
  public State getsinkStateNoTransform() {
    return (State) getChildNoTransform(0);
  }
  /**
   * Retrieves the child position of the optional child sinkState.
   * @return The the child position of the optional child sinkState.
   * @apilevel low-level
   */
  protected int getsinkStateChildPosition() {
    return 0;
  }
  /**
   * Replaces the finalState child.
   * @param node The new node to replace the finalState child.
   * @apilevel high-level
   */
  public void setfinalState(State node) {
    setChild(node, 1);
  }
  /**
   * Retrieves the finalState child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the finalState child.
   * @apilevel low-level
   */
  public State getfinalStateNoTransform() {
    return (State) getChildNoTransform(1);
  }
  /**
   * Retrieves the child position of the optional child finalState.
   * @return The the child position of the optional child finalState.
   * @apilevel low-level
   */
  protected int getfinalStateChildPosition() {
    return 1;
  }
  /**
   * Replaces the lexState child.
   * @param node The new node to replace the lexState child.
   * @apilevel high-level
   */
  public void setlexState(State node) {
    setChild(node, 2);
  }
  /**
   * Retrieves the lexState child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the lexState child.
   * @apilevel low-level
   */
  public State getlexStateNoTransform() {
    return (State) getChildNoTransform(2);
  }
  /**
   * Retrieves the child position of the optional child lexState.
   * @return The the child position of the optional child lexState.
   * @apilevel low-level
   */
  protected int getlexStateChildPosition() {
    return 2;
  }
  /**
   * Replaces the impState child.
   * @param node The new node to replace the impState child.
   * @apilevel high-level
   */
  public void setimpState(State node) {
    setChild(node, 3);
  }
  /**
   * Retrieves the impState child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the impState child.
   * @apilevel low-level
   */
  public State getimpStateNoTransform() {
    return (State) getChildNoTransform(3);
  }
  /**
   * Retrieves the child position of the optional child impState.
   * @return The the child position of the optional child impState.
   * @apilevel low-level
   */
  protected int getimpStateChildPosition() {
    return 3;
  }
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:11
   */
  public abstract State lexState();
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:12
   */
  public abstract State impState();
  /**
   * @apilevel internal
   */
  protected java.util.Map decls_Ref_Scope_Path_visited;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:7
   */
  public ArrayList<Resolution> decls(Ref ref, Scope current, Path p) {
    java.util.List _parameters = new java.util.ArrayList(3);
    _parameters.add(ref);
    _parameters.add(current);
    _parameters.add(p);
    if(decls_Ref_Scope_Path_visited == null) decls_Ref_Scope_Path_visited = new java.util.HashMap(4);
    ASTNode$State state = state();
    if (Integer.valueOf(state().boundariesCrossed).equals(decls_Ref_Scope_Path_visited.get(_parameters))) {
      throw new RuntimeException("Circular definition of attr: decls in class: org.jastadd.ast.AST.SynDecl");
    }
    decls_Ref_Scope_Path_visited.put(_parameters, Integer.valueOf(state().boundariesCrossed));
    try {  return lexState().decls(ref, current, p);  }
    finally {
      decls_Ref_Scope_Path_visited.remove(_parameters);
    }
  }
  /**
   * @apilevel internal
   */
  protected int finalState_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean finalState_computed = false;
  /**
   * @apilevel internal
   */
  protected FinalState finalState_value;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:14
   */
  public FinalState finalState() {
    if(finalState_computed) {
      return finalState_value;
    }
    ASTNode$State state = state();
    if (finalState_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: finalState in class: org.jastadd.ast.AST.SynDecl");
    }
    finalState_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    finalState_value = finalState_compute();
    finalState_value.setParent(this);
    finalState_value.is$Final = true;
    if(true) {
      finalState_computed = true;
    } else {
    }

    finalState_visited = -1;
    return finalState_value;
  }
  /**
   * @apilevel internal
   */
  private FinalState finalState_compute() {
      FinalState fs = new FinalState();
      this.setChild(fs, 1);
      return fs;
    }
  /**
   * @apilevel internal
   */
  protected int sinkState_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean sinkState_computed = false;
  /**
   * @apilevel internal
   */
  protected SinkState sinkState_value;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:20
   */
  public SinkState sinkState() {
    if(sinkState_computed) {
      return sinkState_value;
    }
    ASTNode$State state = state();
    if (sinkState_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: sinkState in class: org.jastadd.ast.AST.SynDecl");
    }
    sinkState_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    sinkState_value = sinkState_compute();
    sinkState_value.setParent(this);
    sinkState_value.is$Final = true;
    if(true) {
      sinkState_computed = true;
    } else {
    }

    sinkState_visited = -1;
    return sinkState_value;
  }
  /**
   * @apilevel internal
   */
  private SinkState sinkState_compute() {
      SinkState ss = new SinkState();
      this.setChild(ss, 0);
      return ss;
    }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:37
   * @apilevel internal
   */
  public State Define_State_lexT(ASTNode caller, ASTNode child) {
    if (caller == getsinkStateNoTransform()){ return this.sinkState(); }
    else if (caller == getfinalStateNoTransform()){ return this.sinkState(); }
    else {
      return getParent().Define_State_lexT(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:38
   * @apilevel internal
   */
  public State Define_State_impT(ASTNode caller, ASTNode child) {
    if (caller == getsinkStateNoTransform()){ return this.sinkState(); }
    else if (caller == getfinalStateNoTransform()){ return this.sinkState(); }
    else {
      return getParent().Define_State_impT(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:39
   * @apilevel internal
   */
  public State Define_State_varT(ASTNode caller, ASTNode child) {
    if (caller == getsinkStateNoTransform()){ return this.sinkState(); }
    else if (caller == getfinalStateNoTransform()){ return this.sinkState(); }
    else {
      return getParent().Define_State_varT(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:40
   * @apilevel internal
   */
  public State Define_State_modT(ASTNode caller, ASTNode child) {
    if (caller == getsinkStateNoTransform()){ return this.sinkState(); }
    else if (caller == getfinalStateNoTransform()){ return this.sinkState(); }
    else {
      return getParent().Define_State_modT(this, caller);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
