/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_LM.ast:22
 * @production VarRef : {@link ASTNode} ::= <span class="component">&lt;Id:String&gt;</span> <span class="component">r:{@link MkVarRef}</span>;

 */
public class VarRef extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public VarRef clone() throws CloneNotSupportedException {
    VarRef node = (VarRef) super.clone();
    node.r_visited = -1;
    node.r_computed = false;
    node.r_value = null;
    node.refs_visited = -1;
    node.refs_computed = false;
    node.refs_value = null;
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
  public VarRef copy() {
    try {
      VarRef node = (VarRef) clone();
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
  public VarRef fullCopy() {
    VarRef tree = (VarRef) copy();
    if (children != null) {
      for (int i = 0; i < children.length; ++i) {
        switch (i) {
        case 0:
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:81
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("VarRef (\"").append(getId()).append("\")");
	}
  /**
   */
  public VarRef() {
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
  public VarRef(String p0) {
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
    r_visited = -1;
    r_computed = false;
    r_value = null;
    refs_visited = -1;
    refs_computed = false;
    refs_value = null;
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
   * Replaces the r child.
   * @param node The new node to replace the r child.
   * @apilevel high-level
   */
  public void setr(MkVarRef node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the r child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the r child.
   * @apilevel low-level
   */
  public MkVarRef getrNoTransform() {
    return (MkVarRef) getChildNoTransform(0);
  }
  /**
   * Retrieves the child position of the optional child r.
   * @return The the child position of the optional child r.
   * @apilevel low-level
   */
  protected int getrChildPosition() {
    return 0;
  }
  /**
   * @apilevel internal
   */
  protected int r_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean r_computed = false;
  /**
   * @apilevel internal
   */
  protected MkVarRef r_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:348
   */
  public MkVarRef r() {
    if(r_computed) {
      return r_value;
    }
    ASTNode$State state = state();
    if (r_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: r in class: org.jastadd.ast.AST.SynDecl");
    }
    r_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    r_value = r_compute();
    r_value.setParent(this);
    r_value.is$Final = true;
    if(true) {
      r_computed = true;
    } else {
    }

    r_visited = -1;
    return r_value;
  }
  /**
   * @apilevel internal
   */
  private MkVarRef r_compute() {
      MkVarRef r = new MkVarRef(getId());
      this.setChild(r, 0);
      return r;
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:365
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
      ArrayList<MkVarRef> refsRet = new ArrayList<MkVarRef>();
      refsRet.add(this.r());
      return refsRet;
    }
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:346
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:355
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__lex(ASTNode caller, ASTNode child) {
    if (caller == getrNoTransform()){ ArrayList<Edge> lexEdges = new ArrayList<Edge>();
                        LexEdgeRef lexEdge = new LexEdgeRef();
                        ASTNode tmpPar = this.scope().getParent();
                        lexEdge.setsrc(this.r());
                        lexEdge.settgt(this.scope());
                        lexEdges.add(lexEdge);
                        this.scope().setParent(tmpPar);
                        this.r().setParent(this);
                        return lexEdges; }
    else {
      return getParent().Define_ArrayList_Edge__lex(this, caller);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
