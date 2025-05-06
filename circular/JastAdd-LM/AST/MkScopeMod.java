/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:4
 * @production MkScopeMod : {@link Scope} ::= <span class="component">&lt;id:String&gt;</span>;

 */
public class MkScopeMod extends Scope implements Cloneable {
  /**
   * @apilevel internal
   */
  public MkScopeMod clone() throws CloneNotSupportedException {
    MkScopeMod node = (MkScopeMod) super.clone();
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
  public MkScopeMod copy() {
    try {
      MkScopeMod node = (MkScopeMod) clone();
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
  public MkScopeMod fullCopy() {
    MkScopeMod tree = (MkScopeMod) copy();
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scope.jadd:51
   */
  public boolean equals(Object o) {
    if (!(o instanceof MkScopeMod)) return false;
    MkScopeMod other = (MkScopeMod) o;
    // System.out.println("MkScopeMod About to check equality of hashcodes for " + this.pp() + " and " + other.pp());
    boolean b = other.hashCode() == this.hashCode();
    // System.out.println("Result was " + Boolean.toString(b));
    return b;
  }
  /**
   */
  public MkScopeMod() {
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
  public MkScopeMod(String p0) {
    setid(p0);
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:110
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
  		return "MkScopeMod(" + getid() + ")_" + Integer.toString(this.getParent().getStartLine()) + "_" + Short.toString(this.getParent().getStartColumn());
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:415
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
      Datum dMod = new DatumMod(getid());
      dMod.setParent(this);
      return dMod;
    }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
