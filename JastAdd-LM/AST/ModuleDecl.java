/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_LM.ast:8
 * @production ModuleDecl : {@link Decl} ::= <span class="component">&lt;Id:String&gt;</span> <span class="component">Ds:{@link Decls}</span>;

 */
public class ModuleDecl extends Decl implements Cloneable {
  /**
   * @apilevel internal
   */
  public ModuleDecl clone() throws CloneNotSupportedException {
    ModuleDecl node = (ModuleDecl) super.clone();
    node.modScope_visited = -1;
    node.modScope_computed = false;
    node.modScope_value = null;
    node.ok_visited = -1;
    node.ok_computed = false;
    node.ok_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public ModuleDecl copy() {
    try {
      ModuleDecl node = (ModuleDecl) clone();
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
  public ModuleDecl fullCopy() {
    ModuleDecl tree = (ModuleDecl) copy();
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/PrettyPrint.jrag:27
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("ModuleDecl (\n");
		sb.append(getIndent(t+1)).append("\"").append(getId()).append("\"");
		sb.append(",\n");
		getDs().prettyPrint(sb, t+1);
		sb.append("\n").append(getIndent(t)).append(")");
	}
  /**
   */
  public ModuleDecl() {
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
  public ModuleDecl(String p0, Decls p1) {
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
    modScope_visited = -1;
    modScope_computed = false;
    modScope_value = null;
    ok_visited = -1;
    ok_computed = false;
    ok_value = null;
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
   * @apilevel internal
   */
  protected int modScope_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean modScope_computed = false;
  /**
   * @apilevel internal
   */
  protected Scope modScope_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:39
   */
  public Scope modScope() {
    if(modScope_computed) {
      return modScope_value;
    }
    ASTNode$State state = state();
    if (modScope_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: modScope in class: org.jastadd.ast.AST.SynDecl");
    }
    modScope_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    modScope_value = modScope_compute();
    if(isFinal && num == state().boundariesCrossed) {
      modScope_computed = true;
    } else {
    }

    modScope_visited = -1;
    return modScope_value;
  }
  /**
   * @apilevel internal
   */
  private Scope modScope_compute() {
      ScopeDatum s = new ScopeDatum();
      s.setName("ModScope_" + Integer.toString(Scope.scopeCount++));
      s.setParent(this);
      s.setDatum(new DatumMod(getId()));
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Typing.jrag:20
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
  private Boolean ok_compute() {  return getDs().ok();  }
  /**
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:47
   * @apilevel internal
   */
  public Scope Define_Scope_scope(ASTNode caller, ASTNode child) {
    if (caller == getDsNoTransform()){
    return modScope();
  }
    else {
      return getParent().Define_Scope_scope(this, caller);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }  protected void collect_contributors_Scope_modScopes() {
  /**
   * @attribute coll
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:51
   */
      {
        Scope ref = (Scope) (scope());
        if (ref != null) {
          ref.Scope_modScopes_contributors().add(this);
        }
      }
    super.collect_contributors_Scope_modScopes();
  }
  protected void collect_contributors_Scope_lexScopes() {
  /**
   * @attribute coll
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:55
   */
      {
        Scope ref = (Scope) (modScope());
        if (ref != null) {
          ref.Scope_lexScopes_contributors().add(this);
        }
      }
    super.collect_contributors_Scope_lexScopes();
  }
  protected void contributeTo_Scope_Scope_modScopes(HashSet<Scope> collection) {
    super.contributeTo_Scope_Scope_modScopes(collection);
    collection.add(modScope());
  }

  protected void contributeTo_Scope_Scope_lexScopes(HashSet<Scope> collection) {
    super.contributeTo_Scope_Scope_lexScopes(collection);
    collection.add(scope());
  }

}
