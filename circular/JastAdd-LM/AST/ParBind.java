/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_LM.ast:19
 * @production ParBind : {@link ASTNode} ::= <span class="component">&lt;Id:String&gt;</span> <span class="component">Type:{@link Type}</span> <span class="component">Expr:{@link Expr}</span> <span class="component">varScope:{@link MkScopeVar}</span>;

 */
public class ParBind extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public ParBind clone() throws CloneNotSupportedException {
    ParBind node = (ParBind) super.clone();
    node.varScope_visited = -1;
    node.varScope_computed = false;
    node.varScope_value = null;
    node.vars_visited = -1;
    node.vars_computed = false;
    node.vars_value = null;
    node.refs_visited = -1;
    node.refs_computed = false;
    node.refs_value = null;
    node.scopes_visited = -1;
    node.scopes_computed = false;
    node.scopes_value = null;
    node.scope_visited = -1;
    node.scope_computed = false;
    node.scope_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public ParBind copy() {
    try {
      ParBind node = (ParBind) clone();
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
  public ParBind fullCopy() {
    ParBind tree = (ParBind) copy();
    if (children != null) {
      for (int i = 0; i < children.length; ++i) {
        switch (i) {
        case 2:
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:67
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("ParBind (\n");
		sb.append(getIndent(t+1)).append("\"").append(getId()).append("\"");
		sb.append(",\n");
		getExpr().prettyPrint(sb, t+1);
		sb.append("\n").append(getIndent(t)).append(")");
	}
  /**
   */
  public ParBind() {
    super();
  }
  /**
   * Initializes the child array to the correct size.
   * Initializes List and Opt nta children.
   * @apilevel internal
   * @ast method
   */
  public void init$Children() {
    children = new ASTNode[3];
  }
  /**
   */
  public ParBind(String p0, Type p1, Expr p2) {
    setId(p0);
    setChild(p1, 0);
    setChild(p2, 1);
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
    varScope_visited = -1;
    varScope_computed = false;
    varScope_value = null;
    vars_visited = -1;
    vars_computed = false;
    vars_value = null;
    refs_visited = -1;
    refs_computed = false;
    refs_value = null;
    scopes_visited = -1;
    scopes_computed = false;
    scopes_value = null;
    scope_visited = -1;
    scope_computed = false;
    scope_value = null;
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
   * Replaces the Type child.
   * @param node The new node to replace the Type child.
   * @apilevel high-level
   */
  public void setType(Type node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the Type child.
   * @return The current node used as the Type child.
   * @apilevel high-level
   */
  public Type getType() {
    return (Type) getChild(0);
  }
  /**
   * Retrieves the Type child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Type child.
   * @apilevel low-level
   */
  public Type getTypeNoTransform() {
    return (Type) getChildNoTransform(0);
  }
  /**
   * Replaces the Expr child.
   * @param node The new node to replace the Expr child.
   * @apilevel high-level
   */
  public void setExpr(Expr node) {
    setChild(node, 1);
  }
  /**
   * Retrieves the Expr child.
   * @return The current node used as the Expr child.
   * @apilevel high-level
   */
  public Expr getExpr() {
    return (Expr) getChild(1);
  }
  /**
   * Retrieves the Expr child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Expr child.
   * @apilevel low-level
   */
  public Expr getExprNoTransform() {
    return (Expr) getChildNoTransform(1);
  }
  /**
   * Replaces the varScope child.
   * @param node The new node to replace the varScope child.
   * @apilevel high-level
   */
  public void setvarScope(MkScopeVar node) {
    setChild(node, 2);
  }
  /**
   * Retrieves the varScope child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the varScope child.
   * @apilevel low-level
   */
  public MkScopeVar getvarScopeNoTransform() {
    return (MkScopeVar) getChildNoTransform(2);
  }
  /**
   * Retrieves the child position of the optional child varScope.
   * @return The the child position of the optional child varScope.
   * @apilevel low-level
   */
  protected int getvarScopeChildPosition() {
    return 2;
  }
  /**
   * @apilevel internal
   */
  protected int varScope_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean varScope_computed = false;
  /**
   * @apilevel internal
   */
  protected MkScopeVar varScope_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:305
   */
  public MkScopeVar varScope() {
    if(varScope_computed) {
      return varScope_value;
    }
    ASTNode$State state = state();
    if (varScope_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: varScope in class: org.jastadd.ast.AST.SynDecl");
    }
    varScope_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    varScope_value = varScope_compute();
    varScope_value.setParent(this);
    varScope_value.is$Final = true;
    if(true) {
      varScope_computed = true;
    } else {
    }

    varScope_visited = -1;
    return varScope_value;
  }
  /**
   * @apilevel internal
   */
  private MkScopeVar varScope_compute() {
      MkScopeVar s = new MkScopeVar(getId(), getType());
      this.setChild(s, 2);
      return s;
    }
  /**
   * @apilevel internal
   */
  protected int vars_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean vars_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Edge> vars_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:321
   */
  public ArrayList<Edge> vars() {
    if(vars_computed) {
      return vars_value;
    }
    ASTNode$State state = state();
    if (vars_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: vars in class: org.jastadd.ast.AST.SynDecl");
    }
    vars_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    vars_value = vars_compute();
    if(isFinal && num == state().boundariesCrossed) {
      vars_computed = true;
    } else {
    }

    vars_visited = -1;
    return vars_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Edge> vars_compute() {
      ArrayList<Edge> varEdges = new ArrayList<Edge>();
      VarEdge varEdge = new VarEdge();
      ASTNode tmpPar = this.scope().getParent();
      varEdge.setsrc(this.scope());
      varEdge.settgt(this.varScope());
      varEdges.add(varEdge);
  
      this.scope().setParent(tmpPar);
      this.varScope().setParent(this);
  
      return varEdges;
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:335
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
  private ArrayList<MkVarRef> refs_compute() {  return getExpr().refs();  }
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:337
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
      ss.add(varScope());
      return ss;
    }
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:297
   */
  public Scope scope() {
    if(scope_computed) {
      return scope_value;
    }
    ASTNode$State state = state();
    if (scope_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: scope in class: org.jastadd.ast.AST.InhDecl");
    }
    scope_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    scope_value = getParent().Define_Scope_scope(this, null);
    if(isFinal && num == state().boundariesCrossed) {
      scope_computed = true;
    } else {
    }

    scope_visited = -1;
    return scope_value;
  }
  /**
   * @apilevel internal
   */
  protected int scope_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean scope_computed = false;
  /**
   * @apilevel internal
   */
  protected Scope scope_value;
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:312
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__lex(ASTNode caller, ASTNode child) {
    if (caller == getvarScopeNoTransform()){ return new ArrayList<Edge>(); }
    else {
      return getParent().Define_ArrayList_Edge__lex(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:313
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__imp(ASTNode caller, ASTNode child) {
    if (caller == getvarScopeNoTransform()){ return new ArrayList<Edge>(); }
    else {
      return getParent().Define_ArrayList_Edge__imp(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:314
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__var(ASTNode caller, ASTNode child) {
    if (caller == getvarScopeNoTransform()){ return new ArrayList<Edge>(); }
    else {
      return getParent().Define_ArrayList_Edge__var(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:315
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__mod(ASTNode caller, ASTNode child) {
    if (caller == getvarScopeNoTransform()){ return new ArrayList<Edge>(); }
    else {
      return getParent().Define_ArrayList_Edge__mod(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:316
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__impTentative(ASTNode caller, ASTNode child) {
    if (caller == getvarScopeNoTransform()){ return new ArrayList<Edge>(); }
    else {
      return getParent().Define_ArrayList_Edge__impTentative(this, caller);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
