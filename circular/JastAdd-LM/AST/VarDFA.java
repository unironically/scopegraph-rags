/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_DFA.ast:4
 * @production VarDFA : {@link DFA};

 */
public class VarDFA extends DFA implements Cloneable {
  /**
   * @apilevel internal
   */
  public VarDFA clone() throws CloneNotSupportedException {
    VarDFA node = (VarDFA) super.clone();
    node.lexState_visited = -1;
    node.lexState_computed = false;
    node.lexState_value = null;
    node.impState_visited = -1;
    node.impState_computed = false;
    node.impState_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public VarDFA copy() {
    try {
      VarDFA node = (VarDFA) clone();
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
  public VarDFA fullCopy() {
    VarDFA tree = (VarDFA) copy();
    if (children != null) {
      for (int i = 0; i < children.length; ++i) {
        switch (i) {
        case 0:
        case 1:
        case 2:
        case 3:
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
  public VarDFA() {
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
    lexState_visited = -1;
    lexState_computed = false;
    lexState_value = null;
    impState_visited = -1;
    impState_computed = false;
    impState_value = null;
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
   * @apilevel internal
   */
  protected int lexState_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean lexState_computed = false;
  /**
   * @apilevel internal
   */
  protected State lexState_value;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:44
   */
  public State lexState() {
    if(lexState_computed) {
      return lexState_value;
    }
    ASTNode$State state = state();
    if (lexState_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: lexState in class: org.jastadd.ast.AST.SynDecl");
    }
    lexState_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    lexState_value = lexState_compute();
    lexState_value.setParent(this);
    lexState_value.is$Final = true;
    if(true) {
      lexState_computed = true;
    } else {
    }

    lexState_visited = -1;
    return lexState_value;
  }
  /**
   * @apilevel internal
   */
  private State lexState_compute() {
      State s = new State();
      this.setChild(s, 2);
      return s;
    }
  /**
   * @apilevel internal
   */
  protected int impState_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean impState_computed = false;
  /**
   * @apilevel internal
   */
  protected State impState_value;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:50
   */
  public State impState() {
    if(impState_computed) {
      return impState_value;
    }
    ASTNode$State state = state();
    if (impState_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: impState in class: org.jastadd.ast.AST.SynDecl");
    }
    impState_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    impState_value = impState_compute();
    impState_value.setParent(this);
    impState_value.is$Final = true;
    if(true) {
      impState_computed = true;
    } else {
    }

    impState_visited = -1;
    return impState_value;
  }
  /**
   * @apilevel internal
   */
  private State impState_compute() {
      State s = new State();
      this.setChild(s, 3);
      return s;
    }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:66
   * @apilevel internal
   */
  public State Define_State_lexT(ASTNode caller, ASTNode child) {
    if (caller == getimpStateNoTransform()){ return this.sinkState(); }
    else if (caller == getlexStateNoTransform()){ return this.lexState(); }
    else {
      return super.Define_State_lexT(caller, child);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:67
   * @apilevel internal
   */
  public State Define_State_impT(ASTNode caller, ASTNode child) {
    if (caller == getimpStateNoTransform()){ return this.impState(); }
    else if (caller == getlexStateNoTransform()){ return this.impState(); }
    else {
      return super.Define_State_impT(caller, child);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:68
   * @apilevel internal
   */
  public State Define_State_varT(ASTNode caller, ASTNode child) {
    if (caller == getimpStateNoTransform()){ return this.finalState(); }
    else if (caller == getlexStateNoTransform()){ return this.finalState(); }
    else {
      return super.Define_State_varT(caller, child);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:69
   * @apilevel internal
   */
  public State Define_State_modT(ASTNode caller, ASTNode child) {
    if (caller == getimpStateNoTransform()){ return this.sinkState(); }
    else if (caller == getlexStateNoTransform()){ return this.sinkState(); }
    else {
      return super.Define_State_modT(caller, child);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
