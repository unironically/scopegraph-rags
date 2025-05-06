/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_LM.ast:1
 * @production Program : {@link ASTNode} ::= <span class="component">Ds:{@link Decls}</span> <span class="component">globalScope:{@link MkScope}</span>;

 */
public class Program extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Program clone() throws CloneNotSupportedException {
    Program node = (Program) super.clone();
    node.globalScope_visited = -1;
    node.globalScope_computed = false;
    node.globalScope_value = null;
    node.refs_visited = -1;
    node.refs_computed = false;
    node.refs_value = null;
    node.scopes_visited = -1;
    node.scopes_computed = false;
    node.scopes_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public Program copy() {
    try {
      Program node = (Program) clone();
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
  public Program fullCopy() {
    Program tree = (Program) copy();
    if (children != null) {
      for (int i = 0; i < children.length; ++i) {
        switch (i) {
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
   * @aspect PrettyPrint
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:4
   */
  public String prettyPrint() {
		StringBuilder sb = new StringBuilder();
		sb.append("Program (\n");
		getDs().prettyPrint(sb, 1);
		sb.append("\n").append(")");
		return sb.toString();
	}
  /**
   * @aspect Program
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Program.jadd:3
   */
  public static Boolean debug = false;
  /**
   */
  public Program() {
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
   */
  public Program(Decls p0) {
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
    globalScope_visited = -1;
    globalScope_computed = false;
    globalScope_value = null;
    refs_visited = -1;
    refs_computed = false;
    refs_value = null;
    scopes_visited = -1;
    scopes_computed = false;
    scopes_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * Replaces the Ds child.
   * @param node The new node to replace the Ds child.
   * @apilevel high-level
   */
  public void setDs(Decls node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the Ds child.
   * @return The current node used as the Ds child.
   * @apilevel high-level
   */
  public Decls getDs() {
    return (Decls) getChild(0);
  }
  /**
   * Retrieves the Ds child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Ds child.
   * @apilevel low-level
   */
  public Decls getDsNoTransform() {
    return (Decls) getChildNoTransform(0);
  }
  /**
   * Replaces the globalScope child.
   * @param node The new node to replace the globalScope child.
   * @apilevel high-level
   */
  public void setglobalScope(MkScope node) {
    setChild(node, 1);
  }
  /**
   * Retrieves the globalScope child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the globalScope child.
   * @apilevel low-level
   */
  public MkScope getglobalScopeNoTransform() {
    return (MkScope) getChildNoTransform(1);
  }
  /**
   * Retrieves the child position of the optional child globalScope.
   * @return The the child position of the optional child globalScope.
   * @apilevel low-level
   */
  protected int getglobalScopeChildPosition() {
    return 1;
  }
  /**
   * @apilevel internal
   */
  protected int globalScope_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean globalScope_computed = false;
  /**
   * @apilevel internal
   */
  protected MkScope globalScope_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:39
   */
  public MkScope globalScope() {
    if(globalScope_computed) {
      return globalScope_value;
    }
    ASTNode$State state = state();
    if (globalScope_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: globalScope in class: org.jastadd.ast.AST.SynDecl");
    }
    globalScope_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    globalScope_value = globalScope_compute();
    globalScope_value.setParent(this);
    globalScope_value.is$Final = true;
    if(true) {
      globalScope_computed = true;
    } else {
    }

    globalScope_visited = -1;
    return globalScope_value;
  }
  /**
   * @apilevel internal
   */
  private MkScope globalScope_compute() {
      MkScope s = new MkScope();
      this.setChild(s, 1);
      return s;
    }
  /**
   * @apilevel internal
   */
  protected int refs_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean refs_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<MkVarRef> refs_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:67
   */
  public ArrayList<MkVarRef> refs() {
    if(refs_computed) {
      return refs_value;
    }
    ASTNode$State state = state();
    if (refs_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: refs in class: org.jastadd.ast.AST.SynDecl");
    }
    refs_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    refs_value = refs_compute();
    if(isFinal && num == state().boundariesCrossed) {
      refs_computed = true;
    } else {
    }

    refs_visited = -1;
    return refs_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<MkVarRef> refs_compute() {  return getDs().refs();  }
  /**
   * @apilevel internal
   */
  protected int scopes_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean scopes_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Scope> scopes_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:69
   */
  public ArrayList<Scope> scopes() {
    if(scopes_computed) {
      return scopes_value;
    }
    ASTNode$State state = state();
    if (scopes_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: scopes in class: org.jastadd.ast.AST.SynDecl");
    }
    scopes_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    scopes_value = scopes_compute();
    if(isFinal && num == state().boundariesCrossed) {
      scopes_computed = true;
    } else {
    }

    scopes_visited = -1;
    return scopes_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Scope> scopes_compute() {
      ArrayList<Scope> ss = new ArrayList<Scope>();
      ss.add(globalScope());
      ss.addAll(getDs().scopes());
      return ss;
    }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:46
   * @apilevel internal
   */
  public Scope Define_Scope_scope(ASTNode caller, ASTNode child) {
    if (caller == getDsNoTransform()){ return globalScope(); }
    else {
      return getParent().Define_Scope_scope(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:49
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__lex(ASTNode caller, ASTNode child) {
    if (caller == getglobalScopeNoTransform()){ return new ArrayList<Edge>(); }
    else {
      return getParent().Define_ArrayList_Edge__lex(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:50
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__imp(ASTNode caller, ASTNode child) {
    if (caller == getglobalScopeNoTransform()){ return globalScope().impTentative(); }
    else {
      return getParent().Define_ArrayList_Edge__imp(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:51
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__var(ASTNode caller, ASTNode child) {
    if (caller == getglobalScopeNoTransform()){ return getDs().vars(); }
    else {
      return getParent().Define_ArrayList_Edge__var(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:52
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__mod(ASTNode caller, ASTNode child) {
    if (caller == getglobalScopeNoTransform()){ return getDs().mods(); }
    else {
      return getParent().Define_ArrayList_Edge__mod(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:53
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__impTentative(ASTNode caller, ASTNode child) {
    if (caller == getglobalScopeNoTransform()){ 
    ArrayList<Edge> impTentativeEdges = new ArrayList<Edge>();
    for (Resolution res: getDs().impTentatives()) {
      ImpTentEdge impTentativeEdge = new ImpTentEdge();
      ASTNode tmpPar = res.getpathNoTransform().tgt().getParent();
      impTentativeEdge.setsrc(this.globalScope());
      impTentativeEdge.settgt(res.getpathNoTransform().tgt());
      impTentativeEdges.add(impTentativeEdge);
      res.getpathNoTransform().tgt().setParent(tmpPar);
      this.globalScope().setParent(this);
    }
    return impTentativeEdges;
  }
    else {
      return getParent().Define_ArrayList_Edge__impTentative(this, caller);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
