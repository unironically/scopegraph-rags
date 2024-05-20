/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_LM.ast:9
 * @production ImportDecl : {@link Decl} ::= <span class="component">Ref:{@link ModRef}</span>;

 */
public class ImportDecl extends Decl implements Cloneable {
  /**
   * @apilevel internal
   */
  public ImportDecl clone() throws CloneNotSupportedException {
    ImportDecl node = (ImportDecl) super.clone();
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
  public ImportDecl copy() {
    try {
      ImportDecl node = (ImportDecl) clone();
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
  public ImportDecl fullCopy() {
    ImportDecl tree = (ImportDecl) copy();
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/PrettyPrint.jrag:34
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("ImportDecl (\n");
		getRef().prettyPrint(sb, t+1);
		sb.append("\n").append(getIndent(t)).append(")");
	}
  /**
   */
  public ImportDecl() {
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
  public ImportDecl(ModRef p0) {
    setChild(p0, 0);
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
   * Replaces the Ref child.
   * @param node The new node to replace the Ref child.
   * @apilevel high-level
   */
  public void setRef(ModRef node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the Ref child.
   * @return The current node used as the Ref child.
   * @apilevel high-level
   */
  public ModRef getRef() {
    return (ModRef) getChild(0);
  }
  /**
   * Retrieves the Ref child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Ref child.
   * @apilevel low-level
   */
  public ModRef getRefNoTransform() {
    return (ModRef) getChildNoTransform(0);
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Typing.jrag:21
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
  private Boolean ok_compute() {  return !getRef().impScopes().isEmpty();  }
  /**
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:62
   * @apilevel internal
   */
  public Scope Define_Scope_scope(ASTNode caller, ASTNode child) {
    if (caller == getRefNoTransform()){
    return scope();
  }
    else {
      return getParent().Define_Scope_scope(this, caller);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }  protected void collect_contributors_Scope_impScopes() {
  /**
   * @attribute coll
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:66
   */
      {
        Scope ref = (Scope) (scope());
        if (ref != null) {
          ref.Scope_impScopes_contributors().add(this);
        }
      }
    super.collect_contributors_Scope_impScopes();
  }
  protected void contributeTo_Scope_Scope_impScopes(HashSet<Scope> collection) {
    super.contributeTo_Scope_Scope_impScopes(collection);
    collection.addAll(getRef().impScopes());
  }

}
