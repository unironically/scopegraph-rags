/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_Scope.ast:9
 * @production Ref : {@link ASTNode} ::= <span class="component">&lt;Id:String&gt;</span> <span class="component">Scope:{@link Scope}</span>;

 */
public abstract class Ref extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Ref clone() throws CloneNotSupportedException {
    Ref node = (Ref) super.clone();
    node.dfa_visited = -1;
    node.dfa_computed = false;
    node.dfa_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   */
  public Ref() {
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
   */
  public Ref(String p0, Scope p1) {
    setId(p0);
    setChild(p1, 0);
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
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Resolution.jrag:194
   */
  public abstract ArrayList<Scope> res();
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Resolution.jrag:7
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
      SinkState sink = new SinkState();
      return new DFA(sink);
    }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
