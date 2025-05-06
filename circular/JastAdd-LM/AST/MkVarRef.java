/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:12
 * @production MkVarRef : {@link Ref} ::= <span class="component">dfa:{@link VarDFA}</span>;

 */
public class MkVarRef extends Ref implements Cloneable {
  /**
   * @apilevel internal
   */
  public MkVarRef clone() throws CloneNotSupportedException {
    MkVarRef node = (MkVarRef) super.clone();
    node.pp_visited = -1;
    node.pp_computed = false;
    node.pp_value = null;
    node.dfa_visited = -1;
    node.dfa_computed = false;
    node.dfa_value = null;
    node.resolution_visited = -1;
    node.resolution_computed = false;
    node.resolution_value = null;
    node.str_visited = -1;
    node.str_computed = false;
    node.str_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public MkVarRef copy() {
    try {
      MkVarRef node = (MkVarRef) clone();
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
  public MkVarRef fullCopy() {
    MkVarRef tree = (MkVarRef) copy();
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
   * @aspect Scope
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scope.jadd:10
   */
  public boolean equals(Object o) {
    if (!(o instanceof MkVarRef)) return false;
    MkVarRef other = (MkVarRef) o;
    // System.out.println("MkVarRef About to check equality of hashcodes for " + this.pp() + " and " + other.pp());
    boolean b = other.hashCode() == this.hashCode();
    // System.out.println("Result was " + Boolean.toString(b));
    return b;
  }
  /**
   */
  public MkVarRef() {
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
  public MkVarRef(String p0) {
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
    dfa_visited = -1;
    dfa_computed = false;
    dfa_value = null;
    resolution_visited = -1;
    resolution_computed = false;
    resolution_value = null;
    str_visited = -1;
    str_computed = false;
    str_value = null;
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
   * Retrieves the value for the lexeme id.
   * @return The value for the lexeme id.
   * @apilevel high-level
   */
  public String getid() {
    return tokenString_id != null ? tokenString_id : "";
  }
  /**
   * Replaces the dfa child.
   * @param node The new node to replace the dfa child.
   * @apilevel high-level
   */
  public void setdfa(VarDFA node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the dfa child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the dfa child.
   * @apilevel low-level
   */
  public VarDFA getdfaNoTransform() {
    return (VarDFA) getChildNoTransform(0);
  }
  /**
   * Retrieves the child position of the optional child dfa.
   * @return The the child position of the optional child dfa.
   * @apilevel low-level
   */
  protected int getdfaChildPosition() {
    return 0;
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:122
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
  		return "MkVarRef(" + getid() + ")_" + Integer.toString(this.getParent().getStartLine()) + "_" + Short.toString(this.getParent().getStartColumn());
  	}
  /**
   * @apilevel internal
   */
  protected int dfa_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean dfa_computed = false;
  /**
   * @apilevel internal
   */
  protected DFA dfa_value;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:225
   */
  public DFA dfa() {
    if(dfa_computed) {
      return dfa_value;
    }
    ASTNode$State state = state();
    if (dfa_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: dfa in class: org.jastadd.ast.AST.SynDecl");
    }
    dfa_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    dfa_value = dfa_compute();
    dfa_value.setParent(this);
    dfa_value.is$Final = true;
    if(true) {
      dfa_computed = true;
    } else {
    }

    dfa_visited = -1;
    return dfa_value;
  }
  /**
   * @apilevel internal
   */
  private DFA dfa_compute() {  return new VarDFA();  }
  /**
   * @apilevel internal
   */
  protected int resolution_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean resolution_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Resolution> resolution_value;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:234
   */
  public ArrayList<Resolution> resolution() {
    if(resolution_computed) {
      return resolution_value;
    }
    ASTNode$State state = state();
    if (resolution_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: resolution in class: org.jastadd.ast.AST.SynDecl");
    }
    resolution_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    resolution_value = resolution_compute();
    if(isFinal && num == state().boundariesCrossed) {
      resolution_computed = true;
    } else {
    }

    resolution_visited = -1;
    return resolution_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Resolution> resolution_compute() { return dfa().decls(this, this.lex().get(0).gettgtNoTransform(), new PathCons(this.lex().get(0), new PathNil())); }
  /**
   * @apilevel internal
   */
  protected int str_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean str_computed = false;
  /**
   * @apilevel internal
   */
  protected String str_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:449
   */
  public String str() {
    if(str_computed) {
      return str_value;
    }
    ASTNode$State state = state();
    if (str_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: str in class: org.jastadd.ast.AST.SynDecl");
    }
    str_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    str_value = str_compute();
    if(isFinal && num == state().boundariesCrossed) {
      str_computed = true;
    } else {
    }

    str_visited = -1;
    return str_value;
  }
  /**
   * @apilevel internal
   */
  private String str_compute() {
      return getid();
    }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
