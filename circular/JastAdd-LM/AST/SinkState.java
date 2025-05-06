/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_DFA.ast:8
 * @production SinkState : {@link State};

 */
public class SinkState extends State implements Cloneable {
  /**
   * @apilevel internal
   */
  public SinkState clone() throws CloneNotSupportedException {
    SinkState node = (SinkState) super.clone();
    node.decls_Ref_Scope_Path_visited = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public SinkState copy() {
    try {
      SinkState node = (SinkState) clone();
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
  public SinkState fullCopy() {
    SinkState tree = (SinkState) copy();
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
  public SinkState() {
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
    
        // System.out.println("\tSink state");
    
        return new ArrayList<Resolution>();
    
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
