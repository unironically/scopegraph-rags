/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:3
 * @production MkScopeVar : {@link Scope} ::= <span class="component">&lt;id:String&gt;</span> <span class="component">t:{@link Type}</span>;

 */
public class MkScopeVar extends Scope implements Cloneable {
  /**
   * @apilevel internal
   */
  public MkScopeVar clone() throws CloneNotSupportedException {
    MkScopeVar node = (MkScopeVar) super.clone();
    node.pp_visited = -1;
    node.pp_computed = false;
    node.pp_value = null;
    node.datum_visited = -1;
    node.datum_computed = false;
    node.datum_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public MkScopeVar copy() {
    try {
      MkScopeVar node = (MkScopeVar) clone();
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
  public MkScopeVar fullCopy() {
    MkScopeVar tree = (MkScopeVar) copy();
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
   * @aspect Scope
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scope.jadd:42
   */
  public boolean equals(Object o) {
    if (!(o instanceof MkScopeVar)) return false;
    MkScopeVar other = (MkScopeVar) o;
    // System.out.println("MkScopeVar About to check equality of hashcodes for " + this.pp() + " and " + other.pp());
    boolean b = other.hashCode() == this.hashCode();
    // System.out.println("Result was " + Boolean.toString(b));
    return b;
  }
  /**
   */
  public MkScopeVar() {
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
  public MkScopeVar(String p0, Type p1) {
    setid(p0);
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
    pp_visited = -1;
    pp_computed = false;
    pp_value = null;
    datum_visited = -1;
    datum_computed = false;
    datum_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * Replaces the lexeme id.
   * @param value The new value for the lexeme id.
   * @apilevel high-level
   */
  public void setid(String value) {
    tokenString_id = value;
  }
  /**
   * @apilevel internal
   */
  protected String tokenString_id;
  /**
   * Retrieves the value for the lexeme id.
   * @return The value for the lexeme id.
   * @apilevel high-level
   */
  public String getid() {
    return tokenString_id != null ? tokenString_id : "";
  }
  /**
   * Replaces the t child.
   * @param node The new node to replace the t child.
   * @apilevel high-level
   */
  public void sett(Type node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the t child.
   * @return The current node used as the t child.
   * @apilevel high-level
   */
  public Type gett() {
    return (Type) getChild(0);
  }
  /**
   * Retrieves the t child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the t child.
   * @apilevel low-level
   */
  public Type gettNoTransform() {
    return (Type) getChildNoTransform(0);
  }
  /**
   * @apilevel internal
   */
  protected int pp_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean pp_computed = false;
  /**
   * @apilevel internal
   */
  protected String pp_value;
  /**
   * @attribute syn
   * @aspect PrettyPrint
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:106
   */
  public String pp() {
    if(pp_computed) {
      return pp_value;
    }
    ASTNode$State state = state();
    if (pp_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: pp in class: org.jastadd.ast.AST.SynDecl");
    }
    pp_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    pp_value = pp_compute();
    if(isFinal && num == state().boundariesCrossed) {
      pp_computed = true;
    } else {
    }

    pp_visited = -1;
    return pp_value;
  }
  /**
   * @apilevel internal
   */
  private String pp_compute() {
  		return "MkScopeVar(" + getid() + ")_" + Integer.toString(this.getParent().getStartLine()) + "_" + Short.toString(this.getParent().getStartColumn());
  	}
  /**
   * @apilevel internal
   */
  protected int datum_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean datum_computed = false;
  /**
   * @apilevel internal
   */
  protected Datum datum_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:409
   */
  public Datum datum() {
    if(datum_computed) {
      return datum_value;
    }
    ASTNode$State state = state();
    if (datum_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: datum in class: org.jastadd.ast.AST.SynDecl");
    }
    datum_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    datum_value = datum_compute();
    if(isFinal && num == state().boundariesCrossed) {
      datum_computed = true;
    } else {
    }

    datum_visited = -1;
    return datum_value;
  }
  /**
   * @apilevel internal
   */
  private Datum datum_compute() {
      Datum dVar = new DatumVar(getid(), gett());
      dVar.setParent(this);
      return dVar;
    }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
