/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_LM.ast:20
 * @production ModRef : {@link ASTNode} ::= <span class="component">&lt;Id:String&gt;</span>;

 */
public class ModRef extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public ModRef clone() throws CloneNotSupportedException {
    ModRef node = (ModRef) super.clone();
    node.impScopes_visited = -1;
    node.impScopes_computed = false;
    node.impScopes_initialized = false;
    node.impScopes_value = null;
    node.ref_visited = -1;
    node.ref_computed = false;
    node.ref_value = null;
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
  public ModRef copy() {
    try {
      ModRef node = (ModRef) clone();
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
  public ModRef fullCopy() {
    ModRef tree = (ModRef) copy();
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/PrettyPrint.jrag:76
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("ModRef (\"").append(getId()).append("\")");
	}
  /**
   */
  public ModRef() {
    super();
  }
  /**
   * Initializes the child array to the correct size.
   * Initializes List and Opt nta children.
   * @apilevel internal
   * @ast method
   */
  public void init$Children() {
  }
  /**
   */
  public ModRef(String p0) {
    setId(p0);
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
    impScopes_visited = -1;
    impScopes_computed = false;
    impScopes_initialized = false;
    impScopes_value = null;
    ref_visited = -1;
    ref_computed = false;
    ref_value = null;
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
   * @apilevel internal
   */
  protected int impScopes_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean impScopes_computed = false;
  /**
   * @apilevel internal
   */
  protected boolean impScopes_initialized = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Scope> impScopes_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:114
   */
  public ArrayList<Scope> impScopes() {
    if(impScopes_computed) {
      return impScopes_value;
    }
    ASTNode$State state = state();
    if (!impScopes_initialized) {
      impScopes_initialized = true;
      impScopes_value = new ArrayList<Scope>();
    }
    if (!state.IN_CIRCLE) {
      state.IN_CIRCLE = true;
      int num = state.boundariesCrossed;
      boolean isFinal = this.is$Final();
      // TODO: fixme
      // state().CIRCLE_INDEX = 1;
      do {
        impScopes_visited = state.CIRCLE_INDEX;
        state.CHANGE = false;
        ArrayList<Scope> new_impScopes_value = impScopes_compute();
        if ((new_impScopes_value==null && impScopes_value!=null) || (new_impScopes_value!=null && !new_impScopes_value.equals(impScopes_value))) {
          state.CHANGE = true;
        }
        impScopes_value = new_impScopes_value;
        state.CIRCLE_INDEX++;
      } while (state.CHANGE);
      if(isFinal && num == state().boundariesCrossed) {
        impScopes_computed = true;
        state.LAST_CYCLE = true;
        impScopes_compute();
        state.LAST_CYCLE = false;
      } else {
        state.RESET_CYCLE = true;
        impScopes_compute();
        state.RESET_CYCLE = false;
        impScopes_computed = false;
        impScopes_initialized = false;
      }
      state.IN_CIRCLE = false;
      return impScopes_value;
    }
    if(impScopes_visited != state.CIRCLE_INDEX) {
      impScopes_visited = state.CIRCLE_INDEX;
      if (state.LAST_CYCLE) {
      impScopes_computed = true;
        ArrayList<Scope> new_impScopes_value = impScopes_compute();
        return new_impScopes_value;
      }
      if (state.RESET_CYCLE) {
        impScopes_computed = false;
        impScopes_initialized = false;
        impScopes_visited = -1;
        return impScopes_value;
      }
      ArrayList<Scope> new_impScopes_value = impScopes_compute();
      if ((new_impScopes_value==null && impScopes_value!=null) || (new_impScopes_value!=null && !new_impScopes_value.equals(impScopes_value))) {
        state.CHANGE = true;
      }
      impScopes_value = new_impScopes_value;
      return impScopes_value;
    }
    return impScopes_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Scope> impScopes_compute() {
  
      ArrayList<Scope> queryResult = ref().res();
  
      return queryResult;
  
    }
  /**
   * @apilevel internal
   */
  protected int ref_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean ref_computed = false;
  /**
   * @apilevel internal
   */
  protected Ref ref_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:124
   */
  public Ref ref() {
    if(ref_computed) {
      return ref_value;
    }
    ASTNode$State state = state();
    if (ref_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: ref in class: org.jastadd.ast.AST.SynDecl");
    }
    ref_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    ref_value = ref_compute();
    if(isFinal && num == state().boundariesCrossed) {
      ref_computed = true;
    } else {
    }

    ref_visited = -1;
    return ref_value;
  }
  /**
   * @apilevel internal
   */
  private Ref ref_compute() {
      RefImport r = new RefImport(getId(), scope());
      r.setParent(this);
      return r;
    }
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:110
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
  }}
