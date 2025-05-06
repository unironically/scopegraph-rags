/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_LM.ast:10
 * @production DefDecl : {@link Decl} ::= <span class="component">Bind:{@link ParBind}</span>;

 */
public class DefDecl extends Decl implements Cloneable {
  /**
   * @apilevel internal
   */
  public DefDecl clone() throws CloneNotSupportedException {
    DefDecl node = (DefDecl) super.clone();
    node.vars_visited = -1;
    node.vars_computed = false;
    node.vars_value = null;
    node.impTentatives_visited = -1;
    node.impTentatives_computed = false;
    node.impTentatives_initialized = false;
    node.impTentatives_value = null;
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
  public DefDecl copy() {
    try {
      DefDecl node = (DefDecl) clone();
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
  public DefDecl fullCopy() {
    DefDecl tree = (DefDecl) copy();
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:39
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("DefDecl (\n");
		getBind().prettyPrint(sb, t+1);
		sb.append("\n").append(getIndent(t)).append(")");
	}
  /**
   */
  public DefDecl() {
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
  public DefDecl(ParBind p0) {
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
    vars_visited = -1;
    vars_computed = false;
    vars_value = null;
    impTentatives_visited = -1;
    impTentatives_computed = false;
    impTentatives_initialized = false;
    impTentatives_value = null;
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
   * Replaces the Bind child.
   * @param node The new node to replace the Bind child.
   * @apilevel high-level
   */
  public void setBind(ParBind node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the Bind child.
   * @return The current node used as the Bind child.
   * @apilevel high-level
   */
  public ParBind getBind() {
    return (ParBind) getChild(0);
  }
  /**
   * Retrieves the Bind child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Bind child.
   * @apilevel low-level
   */
  public ParBind getBindNoTransform() {
    return (ParBind) getChildNoTransform(0);
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:270
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
  private ArrayList<Edge> vars_compute() { return getBind().vars(); }
  /**
   * @apilevel internal
   */
  protected int impTentatives_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean impTentatives_computed = false;
  /**
   * @apilevel internal
   */
  protected boolean impTentatives_initialized = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Resolution> impTentatives_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:272
   */
  public ArrayList<Resolution> impTentatives() {
    if(impTentatives_computed) {
      return impTentatives_value;
    }
    ASTNode$State state = state();
    if (!impTentatives_initialized) {
      impTentatives_initialized = true;
      impTentatives_value = new ArrayList<Resolution>();
    }
    if (!state.IN_CIRCLE) {
      state.IN_CIRCLE = true;
      int num = state.boundariesCrossed;
      boolean isFinal = this.is$Final();
      // TODO: fixme
      // state().CIRCLE_INDEX = 1;
      do {
        impTentatives_visited = state.CIRCLE_INDEX;
        state.CHANGE = false;
        ArrayList<Resolution> new_impTentatives_value = impTentatives_compute();
        if ((new_impTentatives_value==null && impTentatives_value!=null) || (new_impTentatives_value!=null && !new_impTentatives_value.equals(impTentatives_value))) {
          state.CHANGE = true;
        }
        impTentatives_value = new_impTentatives_value;
        state.CIRCLE_INDEX++;
      } while (state.CHANGE);
      if(isFinal && num == state().boundariesCrossed) {
        impTentatives_computed = true;
        state.LAST_CYCLE = true;
        impTentatives_compute();
        state.LAST_CYCLE = false;
      } else {
        state.RESET_CYCLE = true;
        impTentatives_compute();
        state.RESET_CYCLE = false;
        impTentatives_computed = false;
        impTentatives_initialized = false;
      }
      state.IN_CIRCLE = false;
      return impTentatives_value;
    }
    if(impTentatives_visited != state.CIRCLE_INDEX) {
      impTentatives_visited = state.CIRCLE_INDEX;
      if (state.LAST_CYCLE) {
      impTentatives_computed = true;
        ArrayList<Resolution> new_impTentatives_value = impTentatives_compute();
        return new_impTentatives_value;
      }
      if (state.RESET_CYCLE) {
        impTentatives_computed = false;
        impTentatives_initialized = false;
        impTentatives_visited = -1;
        return impTentatives_value;
      }
      ArrayList<Resolution> new_impTentatives_value = impTentatives_compute();
      if ((new_impTentatives_value==null && impTentatives_value!=null) || (new_impTentatives_value!=null && !new_impTentatives_value.equals(impTentatives_value))) {
        state.CHANGE = true;
      }
      impTentatives_value = new_impTentatives_value;
      return impTentatives_value;
    }
    return impTentatives_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Resolution> impTentatives_compute() {  return new ArrayList<Resolution>();  }
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:274
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
  private ArrayList<MkVarRef> refs_compute() {  return getBind().refs();  }
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:276
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
  private ArrayList<Scope> scopes_compute() {  return getBind().scopes();  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:267
   * @apilevel internal
   */
  public Scope Define_Scope_scope(ASTNode caller, ASTNode child) {
    if (caller == getBindNoTransform()){ return scope(); }
    else {
      return getParent().Define_Scope_scope(this, caller);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
