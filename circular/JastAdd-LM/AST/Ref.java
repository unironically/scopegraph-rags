/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:11
 * @production Ref : {@link ASTNode} ::= <span class="component">&lt;id:String&gt;</span>;

 */
public abstract class Ref extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Ref clone() throws CloneNotSupportedException {
    Ref node = (Ref) super.clone();
    node.pp_visited = -1;
    node.pp_computed = false;
    node.pp_value = null;
    node.str_visited = -1;
    node.str_computed = false;
    node.str_value = null;
    node.lex_visited = -1;
    node.lex_computed = false;
    node.lex_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @aspect Scope
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scope.jadd:5
   */
  public boolean equals(Object o) {
    System.out.println("This should never be called");
    return false;
  }
  /**
   */
  public Ref() {
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
  public Ref(String p0) {
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
    str_visited = -1;
    str_computed = false;
    str_value = null;
    lex_visited = -1;
    lex_computed = false;
    lex_value = null;
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:118
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
  		return "Ref(" + getid() + ")_" + Integer.toString(this.getParent().getStartLine()) + "_" + Short.toString(this.getParent().getStartColumn());
  	}
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:445
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
      return "";
    }
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:441
   */
  public ArrayList<Edge> lex() {
    if(lex_computed) {
      return lex_value;
    }
    ASTNode$State state = state();
    if (lex_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: lex in class: org.jastadd.ast.AST.InhDecl");
    }
    lex_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    lex_value = getParent().Define_ArrayList_Edge__lex(this, null);
    if(isFinal && num == state().boundariesCrossed) {
      lex_computed = true;
    } else {
    }

    lex_visited = -1;
    return lex_value;
  }
  /**
   * @apilevel internal
   */
  protected int lex_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean lex_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Edge> lex_value;
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
