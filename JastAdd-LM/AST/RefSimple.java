/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_Scope.ast:10
 * @production RefSimple : {@link Ref};

 */
public class RefSimple extends Ref implements Cloneable {
  /**
   * @apilevel internal
   */
  public RefSimple clone() throws CloneNotSupportedException {
    RefSimple node = (RefSimple) super.clone();
    node.dfa_visited = -1;
    node.dfa_computed = false;
    node.dfa_value = null;
    node.res_visited = -1;
    node.res_computed = false;
    node.res_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public RefSimple copy() {
    try {
      RefSimple node = (RefSimple) clone();
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
  public RefSimple fullCopy() {
    RefSimple tree = (RefSimple) copy();
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
  public RefSimple() {
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
  public RefSimple(String p0, Scope p1) {
    setId(p0);
    setChild(p1, 0);
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
    dfa_visited = -1;
    dfa_computed = false;
    dfa_value = null;
    res_visited = -1;
    res_computed = false;
    res_value = null;
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
   * Retrieves the value for the lexeme Id.
   * @return The value for the lexeme Id.
   * @apilevel high-level
   */
  public String getId() {
    return tokenString_Id != null ? tokenString_Id : "";
  }
  /**
   * Replaces the Scope child.
   * @param node The new node to replace the Scope child.
   * @apilevel high-level
   */
  public void setScope(Scope node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the Scope child.
   * @return The current node used as the Scope child.
   * @apilevel high-level
   */
  public Scope getScope() {
    return (Scope) getChild(0);
  }
  /**
   * Retrieves the Scope child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Scope child.
   * @apilevel low-level
   */
  public Scope getScopeNoTransform() {
    return (Scope) getChildNoTransform(0);
  }
  /**
   * @apilevel internal
   */
  protected int dfa_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean dfa_computed = false;
  /**
   * @apilevel internal
   */
  protected DFA dfa_value;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Resolution.jrag:59
   */
  public DFA dfa() {
    if(dfa_computed) {
      return dfa_value;
    }
    ASTNode$State state = state();
    if (dfa_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: dfa in class: org.jastadd.ast.AST.SynDecl");
    }
    dfa_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    dfa_value = dfa_compute();
    if(isFinal && num == state().boundariesCrossed) {
      dfa_computed = true;
    } else {
    }

    dfa_visited = -1;
    return dfa_value;
  }
  /**
   * @apilevel internal
   */
  private DFA dfa_compute() {
  
      // LEX* IMP? VAR
      
      State state0 = new State();
      State state1 = new State();
      FinalState state2 = new FinalState();
      SinkState sink = new SinkState();
  
      state0.setId(0);
      state0.setLexTrans(state0);
      state0.setImpTrans(state1);
      state0.setModTrans(sink);
      state0.setVarTrans(state2);
  
      state1.setId(1);
      state1.setLexTrans(sink);
      state1.setImpTrans(sink);
      state1.setModTrans(sink);
      state1.setVarTrans(state2);
  
      state2.setId(2);
      state2.setLexTrans(sink);
      state2.setImpTrans(sink);
      state2.setModTrans(sink);
      state2.setVarTrans(sink);
  
      sink.setId(-1);
      sink.setLexTrans(sink);
      sink.setImpTrans(sink);
      sink.setModTrans(sink);
      sink.setVarTrans(sink);
  
      state0.setFinal(false);
      state1.setFinal(false);
      state2.setFinal(true);
      sink.setFinal(false);
  
      return new DFA(state0);
  
    }
  /**
   * @apilevel internal
   */
  protected int res_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean res_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Scope> res_value;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Resolution.jrag:196
   */
  public ArrayList<Scope> res() {
    if(res_computed) {
      return res_value;
    }
    ASTNode$State state = state();
    if (res_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: res in class: org.jastadd.ast.AST.SynDecl");
    }
    res_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    res_value = res_compute();
    if(isFinal && num == state().boundariesCrossed) {
      res_computed = true;
    } else {
    }

    res_visited = -1;
    return res_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Scope> res_compute() {
  
      try {
        Thread.sleep(1000);
      } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
      }
  
      System.out.println(Scope.indent() + "Beginning resolution of " + getId() + "\"");
  
      Scope.subResCount++;
  
      ArrayList<Scope> res = dfa().resolve(getId(), getScope());
  
      Scope.subResCount--;
  
      System.out.print(Scope.indent() + "Ending resolution of \"" + getId() + "\". Found : [");
      for (Scope s: res) {
        System.out.print("\"" + s.getName() + "\", ");
      }
      System.out.println("].");
  
      return res;
    }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
