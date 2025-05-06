/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:1
 * @production Scope : {@link ASTNode};

 */
public abstract class Scope extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Scope clone() throws CloneNotSupportedException {
    Scope node = (Scope) super.clone();
    node.pp_visited = -1;
    node.pp_computed = false;
    node.pp_value = null;
    node.datum_visited = -1;
    node.datum_computed = false;
    node.datum_value = null;
    node.impTentative_visited = -1;
    node.impTentative_computed = false;
    node.impTentative_initialized = false;
    node.impTentative_value = null;
    node.lex_visited = -1;
    node.lex_computed = false;
    node.lex_value = null;
    node.imp_visited = -1;
    node.imp_computed = false;
    node.imp_initialized = false;
    node.imp_value = null;
    node.var_visited = -1;
    node.var_computed = false;
    node.var_value = null;
    node.mod_visited = -1;
    node.mod_computed = false;
    node.mod_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @aspect Scope
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scope.jadd:3
   */
  public static int scopeCount = 0;
  /**
   * @aspect Scope
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scope.jadd:28
   */
  public boolean equals(Object o) {
    // System.out.println("This should never be called");
    return false;
  }
  /**
   */
  public Scope() {
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
    impTentative_visited = -1;
    impTentative_computed = false;
    impTentative_initialized = false;
    impTentative_value = null;
    lex_visited = -1;
    lex_computed = false;
    lex_value = null;
    imp_visited = -1;
    imp_computed = false;
    imp_initialized = false;
    imp_value = null;
    var_visited = -1;
    var_computed = false;
    var_value = null;
    mod_visited = -1;
    mod_computed = false;
    mod_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:98
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
  		return "Scope_" + Integer.toString(this.getParent().getStartLine()) + "_" + Short.toString(this.getParent().getStartColumn());
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:403
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
      Datum dNone = new DatumNone();
      dNone.setParent(this);
      return dNone;
    }
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:16
   */
  public ArrayList<Edge> impTentative() {
    if(impTentative_computed) {
      return impTentative_value;
    }
    ASTNode$State state = state();
    if (!impTentative_initialized) {
      impTentative_initialized = true;
      impTentative_value = new ArrayList<Edge>();
    }
    if (!state.IN_CIRCLE) {
      state.IN_CIRCLE = true;
      int num = state.boundariesCrossed;
      boolean isFinal = this.is$Final();
      // TODO: fixme
      // state().CIRCLE_INDEX = 1;
      do {
        impTentative_visited = state.CIRCLE_INDEX;
        state.CHANGE = false;
        ArrayList<Edge> new_impTentative_value = getParent().Define_ArrayList_Edge__impTentative(this, null);
        if ((new_impTentative_value==null && impTentative_value!=null) || (new_impTentative_value!=null && !new_impTentative_value.equals(impTentative_value))) {
          state.CHANGE = true;
        }
        impTentative_value = new_impTentative_value;
        state.CIRCLE_INDEX++;
      } while (state.CHANGE);
      if(isFinal && num == state().boundariesCrossed) {
        impTentative_computed = true;
        state.LAST_CYCLE = true;
        getParent().Define_ArrayList_Edge__impTentative(this, null);
        state.LAST_CYCLE = false;
      } else {
        state.RESET_CYCLE = true;
        getParent().Define_ArrayList_Edge__impTentative(this, null);
        state.RESET_CYCLE = false;
        impTentative_computed = false;
        impTentative_initialized = false;
      }
      state.IN_CIRCLE = false;
      return impTentative_value;
    }
    if(impTentative_visited != state.CIRCLE_INDEX) {
      impTentative_visited = state.CIRCLE_INDEX;
      if (state.LAST_CYCLE) {
      impTentative_computed = true;
        ArrayList<Edge> new_impTentative_value = getParent().Define_ArrayList_Edge__impTentative(this, null);
        return new_impTentative_value;
      }
      if (state.RESET_CYCLE) {
        impTentative_computed = false;
        impTentative_initialized = false;
        impTentative_visited = -1;
        return impTentative_value;
      }
      ArrayList<Edge> new_impTentative_value = getParent().Define_ArrayList_Edge__impTentative(this, null);
      if ((new_impTentative_value==null && impTentative_value!=null) || (new_impTentative_value!=null && !new_impTentative_value.equals(impTentative_value))) {
        state.CHANGE = true;
      }
      impTentative_value = new_impTentative_value;
      return impTentative_value;
    }
    return impTentative_value;
  }
  /**
   * @apilevel internal
   */
  protected int impTentative_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean impTentative_computed = false;
  /**
   * @apilevel internal
   */
  protected boolean impTentative_initialized = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Edge> impTentative_value;
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:17
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
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:18
   */
  public ArrayList<Edge> imp() {
    if(imp_computed) {
      return imp_value;
    }
    ASTNode$State state = state();
    if (!imp_initialized) {
      imp_initialized = true;
      imp_value = new ArrayList<Edge>();
    }
    if (!state.IN_CIRCLE) {
      state.IN_CIRCLE = true;
      int num = state.boundariesCrossed;
      boolean isFinal = this.is$Final();
      // TODO: fixme
      // state().CIRCLE_INDEX = 1;
      do {
        imp_visited = state.CIRCLE_INDEX;
        state.CHANGE = false;
        ArrayList<Edge> new_imp_value = getParent().Define_ArrayList_Edge__imp(this, null);
        if ((new_imp_value==null && imp_value!=null) || (new_imp_value!=null && !new_imp_value.equals(imp_value))) {
          state.CHANGE = true;
        }
        imp_value = new_imp_value;
        state.CIRCLE_INDEX++;
      } while (state.CHANGE);
      if(isFinal && num == state().boundariesCrossed) {
        imp_computed = true;
        state.LAST_CYCLE = true;
        getParent().Define_ArrayList_Edge__imp(this, null);
        state.LAST_CYCLE = false;
      } else {
        state.RESET_CYCLE = true;
        getParent().Define_ArrayList_Edge__imp(this, null);
        state.RESET_CYCLE = false;
        imp_computed = false;
        imp_initialized = false;
      }
      state.IN_CIRCLE = false;
      return imp_value;
    }
    if(imp_visited != state.CIRCLE_INDEX) {
      imp_visited = state.CIRCLE_INDEX;
      if (state.LAST_CYCLE) {
      imp_computed = true;
        ArrayList<Edge> new_imp_value = getParent().Define_ArrayList_Edge__imp(this, null);
        return new_imp_value;
      }
      if (state.RESET_CYCLE) {
        imp_computed = false;
        imp_initialized = false;
        imp_visited = -1;
        return imp_value;
      }
      ArrayList<Edge> new_imp_value = getParent().Define_ArrayList_Edge__imp(this, null);
      if ((new_imp_value==null && imp_value!=null) || (new_imp_value!=null && !new_imp_value.equals(imp_value))) {
        state.CHANGE = true;
      }
      imp_value = new_imp_value;
      return imp_value;
    }
    return imp_value;
  }
  /**
   * @apilevel internal
   */
  protected int imp_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean imp_computed = false;
  /**
   * @apilevel internal
   */
  protected boolean imp_initialized = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Edge> imp_value;
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:19
   */
  public ArrayList<Edge> var() {
    if(var_computed) {
      return var_value;
    }
    ASTNode$State state = state();
    if (var_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: var in class: org.jastadd.ast.AST.InhDecl");
    }
    var_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    var_value = getParent().Define_ArrayList_Edge__var(this, null);
    if(isFinal && num == state().boundariesCrossed) {
      var_computed = true;
    } else {
    }

    var_visited = -1;
    return var_value;
  }
  /**
   * @apilevel internal
   */
  protected int var_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean var_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Edge> var_value;
  /**
   * @attribute inh
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:20
   */
  public ArrayList<Edge> mod() {
    if(mod_computed) {
      return mod_value;
    }
    ASTNode$State state = state();
    if (mod_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: mod in class: org.jastadd.ast.AST.InhDecl");
    }
    mod_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    mod_value = getParent().Define_ArrayList_Edge__mod(this, null);
    if(isFinal && num == state().boundariesCrossed) {
      mod_computed = true;
    } else {
    }

    mod_visited = -1;
    return mod_value;
  }
  /**
   * @apilevel internal
   */
  protected int mod_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean mod_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Edge> mod_value;
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
