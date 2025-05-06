/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_LM.ast:5
 * @production DeclsCons : {@link Decls} ::= <span class="component">D:{@link Decl}</span> <span class="component">Ds:{@link Decls}</span>;

 */
public class DeclsCons extends Decls implements Cloneable {
  /**
   * @apilevel internal
   */
  public DeclsCons clone() throws CloneNotSupportedException {
    DeclsCons node = (DeclsCons) super.clone();
    node.refs_visited = -1;
    node.refs_computed = false;
    node.refs_value = null;
    node.scopes_visited = -1;
    node.scopes_computed = false;
    node.scopes_value = null;
    node.vars_visited = -1;
    node.vars_computed = false;
    node.vars_value = null;
    node.mods_visited = -1;
    node.mods_computed = false;
    node.mods_value = null;
    node.impTentatives_visited = -1;
    node.impTentatives_computed = false;
    node.impTentatives_initialized = false;
    node.impTentatives_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public DeclsCons copy() {
    try {
      DeclsCons node = (DeclsCons) clone();
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
  public DeclsCons fullCopy() {
    DeclsCons tree = (DeclsCons) copy();
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:17
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("DeclsCons (\n");
		getD().prettyPrint(sb, t+1);
		sb.append(",\n");
		getDs().prettyPrint(sb, t+1);
		sb.append("\n").append(getIndent(t)).append(")");
	}
  /**
   */
  public DeclsCons() {
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
  public DeclsCons(Decl p0, Decls p1) {
    setChild(p0, 0);
    setChild(p1, 1);
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
    refs_visited = -1;
    refs_computed = false;
    refs_value = null;
    scopes_visited = -1;
    scopes_computed = false;
    scopes_value = null;
    vars_visited = -1;
    vars_computed = false;
    vars_value = null;
    mods_visited = -1;
    mods_computed = false;
    mods_value = null;
    impTentatives_visited = -1;
    impTentatives_computed = false;
    impTentatives_initialized = false;
    impTentatives_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * Replaces the D child.
   * @param node The new node to replace the D child.
   * @apilevel high-level
   */
  public void setD(Decl node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the D child.
   * @return The current node used as the D child.
   * @apilevel high-level
   */
  public Decl getD() {
    return (Decl) getChild(0);
  }
  /**
   * Retrieves the D child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the D child.
   * @apilevel low-level
   */
  public Decl getDNoTransform() {
    return (Decl) getChildNoTransform(0);
  }
  /**
   * Replaces the Ds child.
   * @param node The new node to replace the Ds child.
   * @apilevel high-level
   */
  public void setDs(Decls node) {
    setChild(node, 1);
  }
  /**
   * Retrieves the Ds child.
   * @return The current node used as the Ds child.
   * @apilevel high-level
   */
  public Decls getDs() {
    return (Decls) getChild(1);
  }
  /**
   * Retrieves the Ds child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Ds child.
   * @apilevel low-level
   */
  public Decls getDsNoTransform() {
    return (Decls) getChildNoTransform(1);
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:82
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
  private ArrayList<MkVarRef> refs_compute() {
      ArrayList<MkVarRef> bnds = new ArrayList<MkVarRef>();
      bnds.addAll(getD().refs());
      bnds.addAll(getDs().refs());
      return bnds;
    }
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:89
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
      ArrayList<Scope> bnds = new ArrayList<Scope>();
      bnds.addAll(getD().scopes());
      bnds.addAll(getDs().scopes());
      return bnds;
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:96
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
      ArrayList<Edge> comb = new ArrayList<Edge>();
      comb.addAll(getD().vars());
      comb.addAll(getDs().vars());
      return comb;
    }
  /**
   * @apilevel internal
   */
  protected int mods_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean mods_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Edge> mods_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:103
   */
  public ArrayList<Edge> mods() {
    if(mods_computed) {
      return mods_value;
    }
    ASTNode$State state = state();
    if (mods_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: mods in class: org.jastadd.ast.AST.SynDecl");
    }
    mods_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    mods_value = mods_compute();
    if(isFinal && num == state().boundariesCrossed) {
      mods_computed = true;
    } else {
    }

    mods_visited = -1;
    return mods_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Edge> mods_compute() {
      ArrayList<Edge> comb = new ArrayList<Edge>();
      comb.addAll(getD().mods());
      comb.addAll(getDs().mods());
      return comb;
    }
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:112
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
  private ArrayList<Resolution> impTentatives_compute() {
      ArrayList<Resolution> impTs = new ArrayList<Resolution>();
      impTs.addAll(getD().impTentatives());
      impTs.addAll(getDs().impTentatives());
      return impTs;
    }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
