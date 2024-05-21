/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/_AST_Scope.ast:1
 * @production Scope : {@link ASTNode} ::= <span class="component">&lt;Name:String&gt;</span>;

 */
public abstract class Scope extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Scope clone() throws CloneNotSupportedException {
    Scope node = (Scope) super.clone();
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @aspect Scope
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scope.jadd:4
   */
  public static int scopeCount = 0;
  /**
   * @aspect Scope
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scope.jadd:6
   */
  public static int subResCount = 0;
  /**
   * @aspect Scope
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scope.jadd:8
   */
  public static String indentBy(int indent) {
    String s = "";
    for (int i = 0; i < indent; i++) s += "\t";
    return s;
  }
  /**
   * @aspect Scope
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scope.jadd:14
   */
  public static String indent() {
    return Scope.indentBy(Scope.subResCount);
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
   */
  public Scope(String p0) {
    setName(p0);
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
    Scope_lexScopes_visited = -1;
    Scope_lexScopes_computed = false;
    Scope_lexScopes_value = null;
        Scope_lexScopes_contributors = null;
    Scope_modScopes_visited = -1;
    Scope_modScopes_computed = false;
    Scope_modScopes_value = null;
        Scope_modScopes_contributors = null;
    Scope_varScopes_visited = -1;
    Scope_varScopes_computed = false;
    Scope_varScopes_value = null;
        Scope_varScopes_contributors = null;
    Scope_impScopes_visited = -1;
    Scope_impScopes_computed = false;
    Scope_impScopes_initialized = false;
    Scope_impScopes_value = null;
        Scope_impScopes_contributors = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
    Scope_lexScopes_visited = -1;
    Scope_lexScopes_computed = false;
    Scope_lexScopes_value = null;
        Scope_lexScopes_contributors = null;
    Scope_modScopes_visited = -1;
    Scope_modScopes_computed = false;
    Scope_modScopes_value = null;
        Scope_modScopes_contributors = null;
    Scope_varScopes_visited = -1;
    Scope_varScopes_computed = false;
    Scope_varScopes_value = null;
        Scope_varScopes_contributors = null;
    Scope_impScopes_visited = -1;
    Scope_impScopes_computed = false;
    Scope_impScopes_initialized = false;
    Scope_impScopes_value = null;
        Scope_impScopes_contributors = null;
  }
  /**
   * Replaces the lexeme Name.
   * @param value The new value for the lexeme Name.
   * @apilevel high-level
   */
  public void setName(String value) {
    tokenString_Name = value;
  }
  /**
   * @apilevel internal
   */
  protected String tokenString_Name;
  /**
   * Retrieves the value for the lexeme Name.
   * @return The value for the lexeme Name.
   * @apilevel high-level
   */
  public String getName() {
    return tokenString_Name != null ? tokenString_Name : "";
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }  /**
   * @attribute coll
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:5
   */
  public HashSet<Scope> lexScopes() {
    if(Scope_lexScopes_computed) {
      return Scope_lexScopes_value;
    }
    ASTNode$State state = state();
    if (Scope_lexScopes_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: lexScopes in class: org.jastadd.ast.AST.CollDecl");
    }
    Scope_lexScopes_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    Scope_lexScopes_value = lexScopes_compute();
    if(isFinal && num == state().boundariesCrossed) {
      Scope_lexScopes_computed = true;
    } else {
    }

    Scope_lexScopes_visited = -1;
    return Scope_lexScopes_value;
  }
  java.util.Set Scope_lexScopes_contributors;

  /**
   * @apilevel internal
   * @return the contributor set for lexScopes
   */
  public java.util.Set Scope_lexScopes_contributors() {
    if(Scope_lexScopes_contributors == null)
      Scope_lexScopes_contributors  = new ASTNode$State.IdentityHashSet(4);
    return Scope_lexScopes_contributors;
  }

  /**
   * @apilevel internal
   */
  private HashSet<Scope> lexScopes_compute() {
    ASTNode node = this;
    while(node.getParent() != null && !(node instanceof Program)) {
      node = node.getParent();
    }
    Program root = (Program) node;
    root.collect_contributors_Scope_lexScopes();
    Scope_lexScopes_value = new HashSet<Scope>();
    if(Scope_lexScopes_contributors != null)
    for (java.util.Iterator iter = Scope_lexScopes_contributors.iterator(); iter.hasNext(); ) {
      ASTNode contributor = (ASTNode) iter.next();
      contributor.contributeTo_Scope_Scope_lexScopes(Scope_lexScopes_value);
    }
    // TODO: disabled temporarily since collections may not be cached
    //Scope_lexScopes_contributors = null;
    return Scope_lexScopes_value;
  }
  /**
   * @apilevel internal
   */
  protected int Scope_lexScopes_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean Scope_lexScopes_computed = false;
  /**
   * @apilevel internal
   */
  protected HashSet<Scope> Scope_lexScopes_value;
  /**
   * @attribute coll
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:6
   */
  public HashSet<Scope> modScopes() {
    if(Scope_modScopes_computed) {
      return Scope_modScopes_value;
    }
    ASTNode$State state = state();
    if (Scope_modScopes_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: modScopes in class: org.jastadd.ast.AST.CollDecl");
    }
    Scope_modScopes_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    Scope_modScopes_value = modScopes_compute();
    if(isFinal && num == state().boundariesCrossed) {
      Scope_modScopes_computed = true;
    } else {
    }

    Scope_modScopes_visited = -1;
    return Scope_modScopes_value;
  }
  java.util.Set Scope_modScopes_contributors;

  /**
   * @apilevel internal
   * @return the contributor set for modScopes
   */
  public java.util.Set Scope_modScopes_contributors() {
    if(Scope_modScopes_contributors == null)
      Scope_modScopes_contributors  = new ASTNode$State.IdentityHashSet(4);
    return Scope_modScopes_contributors;
  }

  /**
   * @apilevel internal
   */
  private HashSet<Scope> modScopes_compute() {
    ASTNode node = this;
    while(node.getParent() != null && !(node instanceof Program)) {
      node = node.getParent();
    }
    Program root = (Program) node;
    root.collect_contributors_Scope_modScopes();
    Scope_modScopes_value = new HashSet<Scope>();
    if(Scope_modScopes_contributors != null)
    for (java.util.Iterator iter = Scope_modScopes_contributors.iterator(); iter.hasNext(); ) {
      ASTNode contributor = (ASTNode) iter.next();
      contributor.contributeTo_Scope_Scope_modScopes(Scope_modScopes_value);
    }
    // TODO: disabled temporarily since collections may not be cached
    //Scope_modScopes_contributors = null;
    return Scope_modScopes_value;
  }
  /**
   * @apilevel internal
   */
  protected int Scope_modScopes_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean Scope_modScopes_computed = false;
  /**
   * @apilevel internal
   */
  protected HashSet<Scope> Scope_modScopes_value;
  /**
   * @attribute coll
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:7
   */
  public HashSet<Scope> varScopes() {
    if(Scope_varScopes_computed) {
      return Scope_varScopes_value;
    }
    ASTNode$State state = state();
    if (Scope_varScopes_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: varScopes in class: org.jastadd.ast.AST.CollDecl");
    }
    Scope_varScopes_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    Scope_varScopes_value = varScopes_compute();
    if(isFinal && num == state().boundariesCrossed) {
      Scope_varScopes_computed = true;
    } else {
    }

    Scope_varScopes_visited = -1;
    return Scope_varScopes_value;
  }
  java.util.Set Scope_varScopes_contributors;

  /**
   * @apilevel internal
   * @return the contributor set for varScopes
   */
  public java.util.Set Scope_varScopes_contributors() {
    if(Scope_varScopes_contributors == null)
      Scope_varScopes_contributors  = new ASTNode$State.IdentityHashSet(4);
    return Scope_varScopes_contributors;
  }

  /**
   * @apilevel internal
   */
  private HashSet<Scope> varScopes_compute() {
    ASTNode node = this;
    while(node.getParent() != null && !(node instanceof Program)) {
      node = node.getParent();
    }
    Program root = (Program) node;
    root.collect_contributors_Scope_varScopes();
    Scope_varScopes_value = new HashSet<Scope>();
    if(Scope_varScopes_contributors != null)
    for (java.util.Iterator iter = Scope_varScopes_contributors.iterator(); iter.hasNext(); ) {
      ASTNode contributor = (ASTNode) iter.next();
      contributor.contributeTo_Scope_Scope_varScopes(Scope_varScopes_value);
    }
    // TODO: disabled temporarily since collections may not be cached
    //Scope_varScopes_contributors = null;
    return Scope_varScopes_value;
  }
  /**
   * @apilevel internal
   */
  protected int Scope_varScopes_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean Scope_varScopes_computed = false;
  /**
   * @apilevel internal
   */
  protected HashSet<Scope> Scope_varScopes_value;
  /**
   * @apilevel internal
   */
  protected int Scope_impScopes_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean Scope_impScopes_computed = false;

  /**
   * @apilevel internal
   */
  protected boolean Scope_impScopes_initialized = false;

  /**
   * @apilevel internal
   */
  protected HashSet<Scope> Scope_impScopes_value;


  /**
   * @attribute coll
   * @aspect Scoping
   * @declaredat /home/luke/Academia/melt/downstreams/scopegraph-rags/JastAdd-LM/spec/Scoping.jrag:8
   */
  public HashSet<Scope> impScopes() {
    if(Scope_impScopes_computed) {
      return Scope_impScopes_value;
    }
    ASTNode node = this;
    while(node.getParent() != null && !(node instanceof Program))
      node = node.getParent();
    Program root = (Program) node;

    if(root.collecting_contributors_Scope_impScopes)
      throw new RuntimeException("Circularity during phase 1");
    root.collect_contributors_Scope_impScopes();

    if (!Scope_impScopes_initialized) {
      Scope_impScopes_initialized = true;
      Scope_impScopes_value = new HashSet<Scope>();
    }

    if (!state().IN_CIRCLE) {
      state().IN_CIRCLE = true;
      int num = state.boundariesCrossed;
      boolean isFinal = this.is$Final();
      state().CIRCLE_INDEX = 1;
      do {
        Scope_impScopes_visited = state().CIRCLE_INDEX;
        state().CHANGE = false;

        HashSet<Scope> new_Scope_impScopes_value = new HashSet<Scope>();
        combine_Scope_impScopes_contributions(new_Scope_impScopes_value);
        if ((new_Scope_impScopes_value==null && Scope_impScopes_value!=null) || (new_Scope_impScopes_value!=null && !new_Scope_impScopes_value.equals(Scope_impScopes_value))) {
          state().CHANGE = true;
        }
        Scope_impScopes_value = new_Scope_impScopes_value;
        state().CIRCLE_INDEX++;
      } while (state().CHANGE);

      if(isFinal && num == state().boundariesCrossed) {
        Scope_impScopes_computed = true;
        state.LAST_CYCLE = true;
        Scope_impScopes_value = combine_Scope_impScopes_contributions(new HashSet<Scope>());
        state.LAST_CYCLE = false;
      } else {
        state.RESET_CYCLE = true;
        Scope_impScopes_value = combine_Scope_impScopes_contributions(new HashSet<Scope>());
        state.RESET_CYCLE = false;
        Scope_impScopes_computed = false;
        Scope_impScopes_initialized = false;
      }
      state().IN_CIRCLE = false;
      return Scope_impScopes_value;
    }
    if(Scope_impScopes_visited != state().CIRCLE_INDEX) {
      Scope_impScopes_visited = state().CIRCLE_INDEX;
      if (state.LAST_CYCLE) {
      Scope_impScopes_computed = true;
        HashSet<Scope> new_Scope_impScopes_value = Scope_impScopes_value = combine_Scope_impScopes_contributions(new HashSet<Scope>());
        return new_Scope_impScopes_value;
      }
      if (state.RESET_CYCLE) {
        Scope_impScopes_computed = false;
        Scope_impScopes_initialized = false;
        Scope_impScopes_visited = -1;
        return Scope_impScopes_value;
      }
      HashSet<Scope> new_Scope_impScopes_value = new HashSet<Scope>();
      combine_Scope_impScopes_contributions(new_Scope_impScopes_value);
      if ((new_Scope_impScopes_value==null && Scope_impScopes_value!=null) || (new_Scope_impScopes_value!=null && !new_Scope_impScopes_value.equals(Scope_impScopes_value))) {
        state().CHANGE = true;
      }
      Scope_impScopes_value = new_Scope_impScopes_value;
      return Scope_impScopes_value;
    }
    return Scope_impScopes_value;
  }
  java.util.Set Scope_impScopes_contributors;

  /**
   * @apilevel internal
   * @return the contributor set for impScopes
   */
  public java.util.Set Scope_impScopes_contributors() {
    if(Scope_impScopes_contributors == null)
      Scope_impScopes_contributors  = new ASTNode$State.IdentityHashSet(4);
    return Scope_impScopes_contributors;
  }

  private HashSet<Scope> combine_Scope_impScopes_contributions(HashSet<Scope> h) {
    if(Scope_impScopes_contributors != null)
    for(java.util.Iterator iter = Scope_impScopes_contributors.iterator(); iter.hasNext(); ) {
      ASTNode contributor = (ASTNode) iter.next();
      contributor.contributeTo_Scope_Scope_impScopes(h);
    }
    // TODO: disabled temporarily since collections may not be cached
    //Scope_impScopes_contributors = null;
    return h;
  }

  public HashSet<Scope> getCurrentImpScopesValue() {
    if (Scope_impScopes_value == null) return new HashSet<Scope>();
    return Scope_impScopes_value;
  }
}
