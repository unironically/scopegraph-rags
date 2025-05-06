/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_DFA.ast:7
 * @production ModState : {@link State};

 */
public class ModState extends State implements Cloneable {
  /**
   * @apilevel internal
   */
  public ModState clone() throws CloneNotSupportedException {
    ModState node = (ModState) super.clone();
    node.decls_Ref_Scope_Path_visited = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public ModState copy() {
    try {
      ModState node = (ModState) clone();
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
  public ModState fullCopy() {
    ModState tree = (ModState) copy();
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
  public ModState() {
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
    
        //System.out.println("ModState.decls call for " + ref.pp() + " in " + s.pp());
    
        try {
          Thread.sleep(10);
        } catch (InterruptedException e) {
          Thread.currentThread().interrupt();
        }
        
        ArrayList<Resolution> varRes = new ArrayList<Resolution>();
    
        for (Edge eVar: s.var()) {
          varRes.addAll(this.varT().decls(ref, eVar.gettgtNoTransform(), new PathCons(eVar, p)));
        }
    
        ArrayList<Resolution> modRes = new ArrayList<Resolution>();
    
        for (Edge eMod: s.mod()) {
          modRes.addAll(this.modT().decls(ref, eMod.gettgtNoTransform(), new PathCons(eMod, p)));
        }
    
        ArrayList<Resolution> impTentativeRes = new ArrayList<Resolution>();
    
        for (Edge eImpTentative: s.impTentative()) {
          impTentativeRes.addAll(this.impT().decls(ref, eImpTentative.gettgtNoTransform(), new PathCons(eImpTentative, p)));
        }
    
        ArrayList<Resolution> lexRes = new ArrayList<Resolution>();
    
        for (Edge eLex: s.lex()) {
          lexRes.addAll(this.lexT().decls(ref, eLex.gettgtNoTransform(), new PathCons(eLex, p)));
        }
    
        ArrayList<Resolution> allRes = new ArrayList<Resolution>();
    
        allRes.addAll(varRes);
        allRes.addAll(modRes);
        allRes.addAll(impTentativeRes);
        allRes.addAll(lexRes);
    
        return allRes;
    
      }
    finally {
      decls_Ref_Scope_Path_visited.remove(_parameters);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
