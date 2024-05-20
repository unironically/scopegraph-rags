/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_LM.ast:1
 * @production Program : {@link ASTNode} ::= <span class="component">Ds:{@link Decls}</span>;

 */
public class Program extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Program clone() throws CloneNotSupportedException {
    Program node = (Program) super.clone();
    node.topScope_visited = -1;
    node.topScope_computed = false;
    node.topScope_value = null;
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/PrettyPrint.jrag:4
   */
  public String prettyPrint() {
		StringBuilder sb = new StringBuilder();
		sb.append("Program (\n");
		getDs().prettyPrint(sb, 1);
		sb.append("\n").append(")");
		return sb.toString();
	}
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
    children = new ASTNode[1];
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
    topScope_visited = -1;
    topScope_computed = false;
    topScope_value = null;
    ok_visited = -1;
    ok_computed = false;
    ok_value = null;
        collect_contributors_Scope_lexScopes = false;
        collect_contributors_Scope_modScopes = false;
        collect_contributors_Scope_varScopes = false;
        collect_contributors_Scope_impScopes = false;
        collecting_contributors_Scope_impScopes = false;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
        collect_contributors_Scope_lexScopes = false;
        collect_contributors_Scope_modScopes = false;
        collect_contributors_Scope_varScopes = false;
        collect_contributors_Scope_impScopes = false;
        collecting_contributors_Scope_impScopes = false;
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
   * @aspect <NoAspect>
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:5
   */
    private boolean collect_contributors_Scope_lexScopes = false;
  protected void collect_contributors_Scope_lexScopes() {
    if(collect_contributors_Scope_lexScopes) return;
    super.collect_contributors_Scope_lexScopes();
    collect_contributors_Scope_lexScopes = true;
  }

  /**
   * @aspect <NoAspect>
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:6
   */
    private boolean collect_contributors_Scope_modScopes = false;
  protected void collect_contributors_Scope_modScopes() {
    if(collect_contributors_Scope_modScopes) return;
    super.collect_contributors_Scope_modScopes();
    collect_contributors_Scope_modScopes = true;
  }

  /**
   * @aspect <NoAspect>
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:7
   */
    private boolean collect_contributors_Scope_varScopes = false;
  protected void collect_contributors_Scope_varScopes() {
    if(collect_contributors_Scope_varScopes) return;
    super.collect_contributors_Scope_varScopes();
    collect_contributors_Scope_varScopes = true;
  }

  /**
   * @aspect <NoAspect>
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:8
   */
    private boolean collect_contributors_Scope_impScopes = false;

  public boolean collecting_contributors_Scope_impScopes = false;

  protected void collect_contributors_Scope_impScopes() {
    if (!collect_contributors_Scope_impScopes) {
      collecting_contributors_Scope_impScopes = true;
      super.collect_contributors_Scope_impScopes();
      collecting_contributors_Scope_impScopes = false;
      collect_contributors_Scope_impScopes = true;
    }
  }

  /**
   * @apilevel internal
   */
  protected int topScope_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean topScope_computed = false;
  /**
   * @apilevel internal
   */
  protected Scope topScope_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:16
   */
  public Scope topScope() {
    if(topScope_computed) {
      return topScope_value;
    }
    ASTNode$State state = state();
    if (topScope_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: topScope in class: org.jastadd.ast.AST.SynDecl");
    }
    topScope_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    topScope_value = topScope_compute();
    if(isFinal && num == state().boundariesCrossed) {
      topScope_computed = true;
    } else {
    }

    topScope_visited = -1;
    return topScope_value;
  }
  /**
   * @apilevel internal
   */
  private Scope topScope_compute() {
      Scope topScope =  new ScopeNoDatum();
      topScope.setName("GlobalScope_" + Integer.toString(Scope.scopeCount++));
      topScope.setParent(this);
  
      return topScope;
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Typing.jrag:7
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:24
   * @apilevel internal
   */
  public Scope Define_Scope_scope(ASTNode caller, ASTNode child) {
    if (caller == getDsNoTransform()){ return topScope(); }
    else {
      return getParent().Define_Scope_scope(this, caller);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
