/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_LM.ast:22
 * @production VarRef : {@link ASTNode} ::= <span class="component">&lt;Id:String&gt;</span>;

 */
public class VarRef extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public VarRef clone() throws CloneNotSupportedException {
    VarRef node = (VarRef) super.clone();
    node.ref_visited = -1;
    node.ref_computed = false;
    node.ref_value = null;
    node.type_visited = -1;
    node.type_computed = false;
    node.type_value = null;
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/PrettyPrint.jrag:81
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
    ref_visited = -1;
    ref_computed = false;
    ref_value = null;
    type_visited = -1;
    type_computed = false;
    type_value = null;
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
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:137
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
      RefSimple r = new RefSimple(getId(), scope());
      r.setParent(this);
      return r;
    }
  /**
   * @apilevel internal
   */
  protected int type_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean type_computed = false;
  /**
   * @apilevel internal
   */
  protected Type type_value;
  /**
   * @attribute syn
   * @aspect Typing
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Typing.jrag:52
   */
  public Type type() {
    if(type_computed) {
      return type_value;
    }
    ASTNode$State state = state();
    if (type_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: type in class: org.jastadd.ast.AST.SynDecl");
    }
    type_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    type_value = type_compute();
    if(isFinal && num == state().boundariesCrossed) {
      type_computed = true;
    } else {
    }

    type_visited = -1;
    return type_value;
  }
  /**
   * @apilevel internal
   */
  private Type type_compute() {
  
      ArrayList<Scope> queryResult = ref().res();
  
      Scope head;
  
      try {
        head = queryResult.get(0);
      } catch (Exception e) { 
        return new ErrType();
      }
  
      if (head instanceof ScopeDatum && ((ScopeDatum) head).getDatum() instanceof DatumVar) { 
        return ((DatumVar) ((ScopeDatum) head).getDatum()).getType();
      } 
  
      return new ErrType();
    }
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:133
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
