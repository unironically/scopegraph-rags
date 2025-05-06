/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_Scope.ast:17
 * @production Path : {@link ASTNode};

 */
public abstract class Path extends ASTNode<ASTNode> implements Cloneable {
  /**
   * @apilevel internal
   */
  public Path clone() throws CloneNotSupportedException {
    Path node = (Path) super.clone();
    node.tgt_visited = -1;
    node.tgt_computed = false;
    node.tgt_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @aspect Paths
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Paths.jadd:3
   */
  public static Path min(Path p1, Path p2) {

    Path p1rev = Path.rev(p1, new PathNil());
    Path p2rev = Path.rev(p2, new PathNil());

    Path p1tmp = p1rev;
    Path p2tmp = p2rev;

    while (!(p1tmp instanceof PathNil) && ! (p2tmp instanceof PathNil)) {

      if (p1tmp.getClass() != p2tmp.getClass()) {

        if (p1tmp.getChild(0) instanceof VarEdge) return p1;
        if (p2tmp.getChild(0) instanceof VarEdge) return p2;
        
        if (p1tmp.getChild(0) instanceof ModEdge) return p1;
        if (p2tmp.getChild(0) instanceof ModEdge) return p2;
        
        if (p1tmp.getChild(0) instanceof ImpEdge) return p1;
        if (p2tmp.getChild(0) instanceof ImpEdge) return p2;

      } else {

        p1tmp = (Path) p1tmp.getChild(1);
        p2tmp = (Path) p2tmp.getChild(1);

      }

    }

    if (p1tmp instanceof PathNil) return p1;
    return p2;

  }
  /**
   * @aspect Paths
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Paths.jadd:38
   */
  public static Path rev(Path p, Path acc) {
    if (p instanceof PathNil) return acc;
    return Path.rev((Path) p.getChild(1), new PathCons((Edge) p.getChild(0), acc));
  }
  /**
   * @aspect Paths
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Paths.jadd:116
   */
  public boolean equals(Object o) {
    if (!(o instanceof Path)) return false;

    //System.out.println("Testing path equality");

    if (this instanceof PathCons && o instanceof PathCons) {
      return ((Edge) this.getChild(0)).equals((Edge) ((Path) o).getChild(0)) &&
             ((Path) this.getChild(1)).equals((Path) ((Path) o).getChild(1));
    } else if (this instanceof PathNil && o instanceof PathNil) {
      return true;
    }

    return false;

  }
  /**
   */
  public Path() {
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
    tgt_visited = -1;
    tgt_computed = false;
    tgt_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
    super.flushCollectionCache();
  }
  /**
   * @attribute syn
   * @aspect PrettyPrint
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:140
   */
  public abstract String pp();
  /**
   * @apilevel internal
   */
  protected int tgt_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean tgt_computed = false;
  /**
   * @apilevel internal
   */
  protected Scope tgt_value;
  /**
   * @attribute syn
   * @aspect Resolution
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Resolution.jrag:262
   */
  public Scope tgt() {
    if(tgt_computed) {
      return tgt_value;
    }
    ASTNode$State state = state();
    if (tgt_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: tgt in class: org.jastadd.ast.AST.SynDecl");
    }
    tgt_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    tgt_value = tgt_compute();
    if(isFinal && num == state().boundariesCrossed) {
      tgt_computed = true;
    } else {
    }

    tgt_visited = -1;
    return tgt_value;
  }
  /**
   * @apilevel internal
   */
  private Scope tgt_compute() {
      if (this instanceof PathNil) return null;
      Edge e = (Edge) this.getChild(0);
      return e.gettgtNoTransform();
    }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
