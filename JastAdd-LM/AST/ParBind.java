/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_LM.ast:18
 * @production ParBind : {@link ASTNode} ::= <span class="component">&lt;Id:String&gt;</span> <span class="component">Type:{@link Type}</span> <span class="component">Expr:{@link Expr}</span>;

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
    node.ok_visited = -1;
    node.ok_computed = false;
    node.ok_value = null;
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/PrettyPrint.jrag:67
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
    children = new ASTNode[2];
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
    ok_visited = -1;
    ok_computed = false;
    ok_value = null;
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
  protected Scope varScope_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:94
   */
  public Scope varScope() {
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
    if(isFinal && num == state().boundariesCrossed) {
      varScope_computed = true;
    } else {
    }

    varScope_visited = -1;
    return varScope_value;
  }
  /**
   * @apilevel internal
   */
  private Scope varScope_compute() {
      ScopeDatum s = new ScopeDatum();
      s.setName("VarScope_" + Integer.toString(Scope.scopeCount++));
      s.setParent(this);
      s.setDatum(new DatumVar(getId(), getType()));
      
      return s;
    }
  /**
   * @apilevel internal
   */
  protected int ok_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean ok_computed = false;
  /**
   * @apilevel internal
   */
  protected Boolean ok_value;
  /**
   * @attribute syn
   * @aspect Typing
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Typing.jrag:45
   */
  public Boolean ok() {
    if(ok_computed) {
      return ok_value;
    }
    ASTNode$State state = state();
    if (ok_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: ok in class: org.jastadd.ast.AST.SynDecl");
    }
    ok_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    ok_value = ok_compute();
    if(isFinal && num == state().boundariesCrossed) {
      ok_computed = true;
    } else {
    }

    ok_visited = -1;
    return ok_value;
  }
  /**
   * @apilevel internal
   */
  private Boolean ok_compute() {  return getExpr().type().getClass().equals(getType().getClass());  }
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:90
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
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }  protected void collect_contributors_Scope_varScopes() {
  /**
   * @attribute coll
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:103
   */
      {
        Scope ref = (Scope) (scope());
        if (ref != null) {
          ref.Scope_varScopes_contributors().add(this);
        }
      }
    super.collect_contributors_Scope_varScopes();
  }
  protected void contributeTo_Scope_Scope_varScopes(HashSet<Scope> collection) {
    super.contributeTo_Scope_Scope_varScopes(collection);
    collection.add(varScope());
  }

}
