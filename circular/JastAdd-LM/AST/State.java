/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_DFA.ast:6
 * @production State : {@link ASTNode};

 */
public class State extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public State clone() throws CloneNotSupportedException {
    State node = (State) super.clone();
    node.decls_Ref_Scope_Path_visited = null;
    node.lexT_visited = -1;
    node.impT_visited = -1;
    node.varT_visited = -1;
    node.modT_visited = -1;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public State copy() {
    try {
      State node = (State) clone();
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
  public State fullCopy() {
    State tree = (State) copy();
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
   */
  public State() {
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
    decls_Ref_Scope_Path_visited = null;
    lexT_visited = -1;
    impT_visited = -1;
    varT_visited = -1;
    modT_visited = -1;
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
  protected java.util.Map decls_Ref_Scope_Path_visited;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:106
   */
  public ArrayList<Resolution> decls(Ref ref, Scope s, Path p) {
    java.util.List _parameters = new java.util.ArrayList(3);
    _parameters.add(ref);
    _parameters.add(s);
    _parameters.add(p);
    if(decls_Ref_Scope_Path_visited == null) decls_Ref_Scope_Path_visited = new java.util.HashMap(4);
    ASTNode$State state = state();
    if (Integer.valueOf(state().boundariesCrossed).equals(decls_Ref_Scope_Path_visited.get(_parameters))) {
      throw new RuntimeException("Circular definition of attr: decls in class: org.jastadd.ast.AST.SynDecl");
    }
    decls_Ref_Scope_Path_visited.put(_parameters, Integer.valueOf(state().boundariesCrossed));
    try {
    
        // System.out.println("Decls call for " + ref.pp());
        
        ArrayList<Resolution> varRes = new ArrayList<Resolution>();
    
        for (Edge eVar: s.var()) {
          varRes.addAll(this.varT().decls(ref, eVar.gettgtNoTransform(), new PathCons(eVar, p)));
        }
    
        ArrayList<Resolution> modRes = new ArrayList<Resolution>();
    
        for (Edge eMod: s.mod()) {
          modRes.addAll(this.modT().decls(ref, eMod.gettgtNoTransform(), new PathCons(eMod, p)));
        }
    
        ArrayList<Resolution> impRes = new ArrayList<Resolution>();
    
        for (Edge eImp: s.imp()) {
          impRes.addAll(this.impT().decls(ref, eImp.gettgtNoTransform(), new PathCons(eImp, p)));
        }
    
        ArrayList<Resolution> lexRes = new ArrayList<Resolution>();
    
        for (Edge eLex: s.lex()) {
          lexRes.addAll(this.lexT().decls(ref, eLex.gettgtNoTransform(), new PathCons(eLex, p)));
        }
    
        ArrayList<Resolution> allRes = new ArrayList<Resolution>();
    
        allRes.addAll(varRes);
        allRes.addAll(modRes);
        allRes.addAll(impRes);
        allRes.addAll(lexRes);
    
        // System.out.println("\tBottom with allRes size = " + Integer.toString(allRes.size()));
    
        return allRes;
    
      }
    finally {
      decls_Ref_Scope_Path_visited.remove(_parameters);
    }
  }
  /**
   * @attribute inh
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:101
   */
  public State lexT() {
    ASTNode$State state = state();
    if (lexT_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: lexT in class: org.jastadd.ast.AST.InhDecl");
    }
    lexT_visited = state().boundariesCrossed;
    State lexT_value = getParent().Define_State_lexT(this, null);

    lexT_visited = -1;
    return lexT_value;
  }
  /**
   * @apilevel internal
   */
  protected int lexT_visited = -1;
  /**
   * @attribute inh
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:102
   */
  public State impT() {
    ASTNode$State state = state();
    if (impT_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: impT in class: org.jastadd.ast.AST.InhDecl");
    }
    impT_visited = state().boundariesCrossed;
    State impT_value = getParent().Define_State_impT(this, null);

    impT_visited = -1;
    return impT_value;
  }
  /**
   * @apilevel internal
   */
  protected int impT_visited = -1;
  /**
   * @attribute inh
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:103
   */
  public State varT() {
    ASTNode$State state = state();
    if (varT_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: varT in class: org.jastadd.ast.AST.InhDecl");
    }
    varT_visited = state().boundariesCrossed;
    State varT_value = getParent().Define_State_varT(this, null);

    varT_visited = -1;
    return varT_value;
  }
  /**
   * @apilevel internal
   */
  protected int varT_visited = -1;
  /**
   * @attribute inh
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:104
   */
  public State modT() {
    ASTNode$State state = state();
    if (modT_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: modT in class: org.jastadd.ast.AST.InhDecl");
    }
    modT_visited = state().boundariesCrossed;
    State modT_value = getParent().Define_State_modT(this, null);

    modT_visited = -1;
    return modT_value;
  }
  /**
   * @apilevel internal
   */
  protected int modT_visited = -1;
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
