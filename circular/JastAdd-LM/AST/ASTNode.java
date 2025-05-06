/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @production ASTNode;

 */
public class ASTNode<T extends ASTNode> implements Cloneable, Iterable<T> {
  /**
   * @apilevel internal
   */
  public ASTNode<T> clone() throws CloneNotSupportedException {
    ASTNode node = (ASTNode) super.clone();
    node.imps_visited = -1;
    node.imps_computed = false;
    node.imps_value = null;
    node.mods_visited = -1;
    node.mods_computed = false;
    node.mods_value = null;
    node.vars_visited = -1;
    node.vars_computed = false;
    node.vars_value = null;
    node.refs_visited = -1;
    node.refs_computed = false;
    node.refs_value = null;
    node.scopes_visited = -1;
    node.scopes_computed = false;
    node.scopes_value = null;
    node.in$Circle(false);
    node.is$Final(false);
    return node;
  }
  /**
   * @apilevel internal
   */
  public ASTNode<T> copy() {
    try {
      ASTNode node = (ASTNode) clone();
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
  public ASTNode<T> fullCopy() {
    ASTNode tree = (ASTNode) copy();
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
   * @aspect PrettyPrint
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:86
   */
  public String getIndent(int t) {
		String s = "";
		for (int i = 0; i < t; i++) {
			s += "  ";
		}
		return s;
	}
  /**
   */
  public ASTNode() {
    super();
    init$Children();
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
   * @apilevel internal
   */
  private int childIndex;
  /**
   * @apilevel low-level
   */
  public int getIndexOfChild(ASTNode node) {
    if (node == null) {
      return -1;
    }
    if (node.childIndex < numChildren && node == children[node.childIndex]) {
      return node.childIndex;
    }
    for(int i = 0; children != null && i < children.length; i++) {
      if(children[i] == node) {
        node.childIndex = i;
        return i;
      }
    }
    return -1;
  }
  /**
   * @apilevel internal
   */
  public static final boolean generatedWithCircularEnabled = true;
  /**
   * @apilevel internal
   */
  public static final boolean generatedWithCacheCycle = true;
  /**
   * @apilevel internal
   */
  public static final boolean generatedWithComponentCheck = false;
  /**
   * Parent pointer
   * @apilevel low-level
   */
  protected ASTNode parent;
  /**
   * Child array
   * @apilevel low-level
   */
  protected ASTNode[] children;
  /**
   * @apilevel internal
   */
  protected static ASTNode$State state = new ASTNode$State();
  /**
   * @apilevel internal
   */
  public final ASTNode$State state() {
    return state;
  }
  /**
   * @apilevel internal
   */
  public boolean in$Circle = false;
  /**
   * @apilevel internal
   */
  public boolean in$Circle() {
    return in$Circle;
  }
  /**
   * @apilevel internal
   */
  public void in$Circle(boolean b) {
    in$Circle = b;
  }
  /**
   * @apilevel internal
   */
  public boolean is$Final = false;
  /**
   * @apilevel internal
   */
  public boolean is$Final() { return is$Final; }
  /**
   * @apilevel internal
   */
  public void is$Final(boolean b) { is$Final = b; }
  /**
   * @apilevel low-level
   */
  public T getChild(int i) {

    ASTNode node = this.getChildNoTransform(i);
    if(node == null) {
      return null;
    }
    if(node.is$Final()) {
      return (T) node;
    }
    if(!node.mayHaveRewrite()) {
      node.is$Final(this.is$Final());
      return (T) node;
    }
    if(!node.in$Circle()) {
      int rewriteState;
      int num = this.state().boundariesCrossed;
      do {
        this.state().push(ASTNode$State.REWRITE_CHANGE);
        ASTNode oldNode = node;
        oldNode.in$Circle(true);
        node = node.rewriteTo();
        if(node != oldNode) {
          this.setChild(node, i);
        }
        oldNode.in$Circle(false);
        rewriteState = this.state().pop();
      } while(rewriteState == ASTNode$State.REWRITE_CHANGE);
      if(rewriteState == ASTNode$State.REWRITE_NOCHANGE && this.is$Final()) {
        node.is$Final(true);
        this.state().boundariesCrossed = num;
      } else {
      }
    } else if(this.is$Final() != node.is$Final()) {
      this.state().boundariesCrossed++;
    } else {
    }
    return (T) node;


  }
  /**
   * @apilevel low-level
   */
  public void addChild(T node) {
    setChild(node, getNumChildNoTransform());
  }
  /**
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @apilevel low-level
   */
  public final T getChildNoTransform(int i) {
    if (children == null) {
      return null;
    }
    T child = (T)children[i];
    return child;
  }
  /**
   * @apilevel low-level
   */
  protected int numChildren;
  /**
   * @apilevel low-level
   */
  protected int numChildren() {
    return numChildren;
  }
  /**
   * @apilevel low-level
   */
  public int getNumChild() {
    return numChildren();
  }
  /**
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @apilevel low-level
   */
  public final int getNumChildNoTransform() {
    return numChildren();
  }
  /**
   * @apilevel low-level
   */
  public void setChild(ASTNode node, int i) {
    if(children == null) {
      children = new ASTNode[(i+1>4 || !(this instanceof List))?i+1:4];
    } else if (i >= children.length) {
      ASTNode c[] = new ASTNode[i << 1];
      System.arraycopy(children, 0, c, 0, children.length);
      children = c;
    }
    children[i] = node;
    if(i >= numChildren) {
      numChildren = i+1;
    }
    if(node != null) {
      node.setParent(this);
      node.childIndex = i;
    }
  }
  /**
   * @apilevel low-level
   */
  public void insertChild(ASTNode node, int i) {
    if(children == null) {
      children = new ASTNode[(i+1>4 || !(this instanceof List))?i+1:4];
      children[i] = node;
    } else {
      ASTNode c[] = new ASTNode[children.length + 1];
      System.arraycopy(children, 0, c, 0, i);
      c[i] = node;
      if(i < children.length) {
        System.arraycopy(children, i, c, i+1, children.length-i);
        for(int j = i+1; j < c.length; ++j) {
          if(c[j] != null) {
            c[j].childIndex = j;
          }
        }
      }
      children = c;
    }
    numChildren++;
    if(node != null) {
      node.setParent(this);
      node.childIndex = i;
    }
  }
  /**
   * @apilevel low-level
   */
  public void removeChild(int i) {
    if(children != null) {
      ASTNode child = (ASTNode) children[i];
      if(child != null) {
        child.parent = null;
        child.childIndex = -1;
      }
      // Adding a check of this instance to make sure its a List, a move of children doesn't make
      // any sense for a node unless its a list. Also, there is a problem if a child of a non-List node is removed
      // and siblings are moved one step to the right, with null at the end.
      if (this instanceof List || this instanceof Opt) {
        System.arraycopy(children, i+1, children, i, children.length-i-1);
        children[children.length-1] = null;
        numChildren--;
        // fix child indices
        for(int j = i; j < numChildren; ++j) {
          if(children[j] != null) {
            child = (ASTNode) children[j];
            child.childIndex = j;
          }
        }
      } else {
        children[i] = null;
      }
    }
  }
  /**
   * @apilevel low-level
   */
  public ASTNode getParent() {
    if(parent != null && ((ASTNode) parent).is$Final() != is$Final()) {
      state().boundariesCrossed++;
    }
    ;
    return (ASTNode) parent;
  }
  /**
   * @apilevel low-level
   */
  public void setParent(ASTNode node) {
    parent = node;
  }
  /**
   * Line and column information.
   */
  protected int startLine;
  /**
   */
  protected short startColumn;
  /**
   */
  protected int endLine;
  /**
   */
  protected short endColumn;
  /**
   */
  public int getStartLine() {
    return startLine;
  }
  /**
   */
  public short getStartColumn() {
    return startColumn;
  }
  /**
   */
  public int getEndLine() {
    return endLine;
  }
  /**
   */
  public short getEndColumn() {
    return endColumn;
  }
  /**
   */
  public void setStart(int startLine, short startColumn) {
    this.startLine = startLine;
    this.startColumn = startColumn;
  }
  /**
   */
  public void setEnd(int endLine, short endColumn) {
    this.endLine = endLine;
    this.endColumn = endColumn;
  }
  /**
   * @apilevel low-level
   */
  public java.util.Iterator<T> iterator() {
    return new java.util.Iterator<T>() {
      private int counter = 0;
      public boolean hasNext() {
        return counter < getNumChild();
      }
      public T next() {
        if(hasNext())
          return (T)getChild(counter++);
        else
          return null;
      }
      public void remove() {
        throw new UnsupportedOperationException();
      }
    };
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
    imps_visited = -1;
    imps_computed = false;
    imps_value = null;
    mods_visited = -1;
    mods_computed = false;
    mods_value = null;
    vars_visited = -1;
    vars_computed = false;
    vars_value = null;
    refs_visited = -1;
    refs_computed = false;
    refs_value = null;
    scopes_visited = -1;
    scopes_computed = false;
    scopes_value = null;
  }
  /**
   * @apilevel internal
   */
  public void flushCollectionCache() {
  }
  /**
   * @apilevel internal
   */
  protected int imps_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean imps_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Edge> imps_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:6
   */
  public ArrayList<Edge> imps() {
    if(imps_computed) {
      return imps_value;
    }
    ASTNode$State state = state();
    if (imps_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: imps in class: org.jastadd.ast.AST.SynDecl");
    }
    imps_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    imps_value = imps_compute();
    if(isFinal && num == state().boundariesCrossed) {
      imps_computed = true;
    } else {
    }

    imps_visited = -1;
    return imps_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Edge> imps_compute() { return new ArrayList<Edge>(); }
  /**
   * @apilevel internal
   */
  protected int mods_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean mods_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Edge> mods_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:11
   */
  public ArrayList<Edge> mods() {
    if(mods_computed) {
      return mods_value;
    }
    ASTNode$State state = state();
    if (mods_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: mods in class: org.jastadd.ast.AST.SynDecl");
    }
    mods_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    mods_value = mods_compute();
    if(isFinal && num == state().boundariesCrossed) {
      mods_computed = true;
    } else {
    }

    mods_visited = -1;
    return mods_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Edge> mods_compute() { return new ArrayList<Edge>(); }
  /**
   * @apilevel internal
   */
  protected int vars_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean vars_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Edge> vars_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:14
   */
  public ArrayList<Edge> vars() {
    if(vars_computed) {
      return vars_value;
    }
    ASTNode$State state = state();
    if (vars_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: vars in class: org.jastadd.ast.AST.SynDecl");
    }
    vars_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    vars_value = vars_compute();
    if(isFinal && num == state().boundariesCrossed) {
      vars_computed = true;
    } else {
    }

    vars_visited = -1;
    return vars_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Edge> vars_compute() { return new ArrayList<Edge>(); }
  /**
   * @apilevel internal
   */
  protected int refs_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean refs_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<MkVarRef> refs_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:23
   */
  public ArrayList<MkVarRef> refs() {
    if(refs_computed) {
      return refs_value;
    }
    ASTNode$State state = state();
    if (refs_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: refs in class: org.jastadd.ast.AST.SynDecl");
    }
    refs_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    refs_value = refs_compute();
    if(isFinal && num == state().boundariesCrossed) {
      refs_computed = true;
    } else {
    }

    refs_visited = -1;
    return refs_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<MkVarRef> refs_compute() { return new ArrayList<MkVarRef>(); }
  /**
   * @apilevel internal
   */
  protected int scopes_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean scopes_computed = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Scope> scopes_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:26
   */
  public ArrayList<Scope> scopes() {
    if(scopes_computed) {
      return scopes_value;
    }
    ASTNode$State state = state();
    if (scopes_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: scopes in class: org.jastadd.ast.AST.SynDecl");
    }
    scopes_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    scopes_value = scopes_compute();
    if(isFinal && num == state().boundariesCrossed) {
      scopes_computed = true;
    } else {
    }

    scopes_visited = -1;
    return scopes_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Scope> scopes_compute() { return new ArrayList<Scope>(); }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    if(state().peek() == ASTNode$State.REWRITE_CHANGE) {
      state().pop();
      state().push(ASTNode$State.REWRITE_NOCHANGE);
    }
    return this;
  }  /**
   * @apilevel internal
   */
  public State Define_State_lexT(ASTNode caller, ASTNode child) {
    return getParent().Define_State_lexT(this, caller);
  }
  /**
   * @apilevel internal
   */
  public State Define_State_impT(ASTNode caller, ASTNode child) {
    return getParent().Define_State_impT(this, caller);
  }
  /**
   * @apilevel internal
   */
  public State Define_State_varT(ASTNode caller, ASTNode child) {
    return getParent().Define_State_varT(this, caller);
  }
  /**
   * @apilevel internal
   */
  public State Define_State_modT(ASTNode caller, ASTNode child) {
    return getParent().Define_State_modT(this, caller);
  }
  /**
   * @apilevel internal
   */
  public Scope Define_Scope_scope(ASTNode caller, ASTNode child) {
    return getParent().Define_Scope_scope(this, caller);
  }
  /**
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__lex(ASTNode caller, ASTNode child) {
    return getParent().Define_ArrayList_Edge__lex(this, caller);
  }
  /**
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__imp(ASTNode caller, ASTNode child) {
    return getParent().Define_ArrayList_Edge__imp(this, caller);
  }
  /**
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__var(ASTNode caller, ASTNode child) {
    return getParent().Define_ArrayList_Edge__var(this, caller);
  }
  /**
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__mod(ASTNode caller, ASTNode child) {
    return getParent().Define_ArrayList_Edge__mod(this, caller);
  }
  /**
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__impTentative(ASTNode caller, ASTNode child) {
    return getParent().Define_ArrayList_Edge__impTentative(this, caller);
  }
}
