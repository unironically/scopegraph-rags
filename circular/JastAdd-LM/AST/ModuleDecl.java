/* This file was generated with JastAdd2 (http://jastadd.org) version 2.1.3 */
package AST;

import java.util.*;
/**
 * @ast node
 * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/_AST_LM.ast:8
 * @production ModuleDecl : {@link Decl} ::= <span class="component">&lt;Id:String&gt;</span> <span class="component">Ds:{@link Decls}</span> <span class="component">modScope:{@link MkScopeMod}</span>;

 */
public class ModuleDecl extends Decl implements Cloneable {
  /**
   * @apilevel internal
   */
  public ModuleDecl clone() throws CloneNotSupportedException {
    ModuleDecl node = (ModuleDecl) super.clone();
    node.modScope_visited = -1;
    node.modScope_computed = false;
    node.modScope_value = null;
    node.mods_visited = -1;
    node.mods_computed = false;
    node.mods_value = null;
    node.impTentatives_visited = -1;
    node.impTentatives_computed = false;
    node.impTentatives_initialized = false;
    node.impTentatives_value = null;
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
  public ModuleDecl copy() {
    try {
      ModuleDecl node = (ModuleDecl) clone();
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
  public ModuleDecl fullCopy() {
    ModuleDecl tree = (ModuleDecl) copy();
    if (children != null) {
      for (int i = 0; i < children.length; ++i) {
        switch (i) {
        case 1:
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
   * @aspect PrettyPrint
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/PrettyPrint.jrag:27
   */
  public void prettyPrint(StringBuilder sb, int t) {
		sb.append(getIndent(t)).append("ModuleDecl (\n");
		sb.append(getIndent(t+1)).append("\"").append(getId()).append("\"");
		sb.append(",\n");
		getDs().prettyPrint(sb, t+1);
		sb.append("\n").append(getIndent(t)).append(")");
	}
  /**
   */
  public ModuleDecl() {
    super();
  }
  /**
   * Initializes the child array to the correct size.
   * Initializes List and Opt nta children.
   * @apilevel internal
   * @ast method
   */
  public void init$Children() {
    children = new ASTNode[2];
  }
  /**
   */
  public ModuleDecl(String p0, Decls p1) {
    setId(p0);
    setChild(p1, 0);
  }
  /**
   * @apilevel low-level
   */
  protected int numChildren() {
    return 1;
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
    modScope_visited = -1;
    modScope_computed = false;
    modScope_value = null;
    mods_visited = -1;
    mods_computed = false;
    mods_value = null;
    impTentatives_visited = -1;
    impTentatives_computed = false;
    impTentatives_initialized = false;
    impTentatives_value = null;
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
    super.flushCollectionCache();
  }
  /**
   * Replaces the lexeme Id.
   * @param value The new value for the lexeme Id.
   * @apilevel high-level
   */
  public void setId(String value) {
    tokenString_Id = value;
  }
  /**
   * @apilevel internal
   */
  protected String tokenString_Id;
  /**
   * Retrieves the value for the lexeme Id.
   * @return The value for the lexeme Id.
   * @apilevel high-level
   */
  public String getId() {
    return tokenString_Id != null ? tokenString_Id : "";
  }
  /**
   * Replaces the Ds child.
   * @param node The new node to replace the Ds child.
   * @apilevel high-level
   */
  public void setDs(Decls node) {
    setChild(node, 0);
  }
  /**
   * Retrieves the Ds child.
   * @return The current node used as the Ds child.
   * @apilevel high-level
   */
  public Decls getDs() {
    return (Decls) getChild(0);
  }
  /**
   * Retrieves the Ds child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the Ds child.
   * @apilevel low-level
   */
  public Decls getDsNoTransform() {
    return (Decls) getChildNoTransform(0);
  }
  /**
   * Replaces the modScope child.
   * @param node The new node to replace the modScope child.
   * @apilevel high-level
   */
  public void setmodScope(MkScopeMod node) {
    setChild(node, 1);
  }
  /**
   * Retrieves the modScope child.
   * <p><em>This method does not invoke AST transformations.</em></p>
   * @return The current node used as the modScope child.
   * @apilevel low-level
   */
  public MkScopeMod getmodScopeNoTransform() {
    return (MkScopeMod) getChildNoTransform(1);
  }
  /**
   * Retrieves the child position of the optional child modScope.
   * @return The the child position of the optional child modScope.
   * @apilevel low-level
   */
  protected int getmodScopeChildPosition() {
    return 1;
  }
  /**
   * @apilevel internal
   */
  protected int modScope_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean modScope_computed = false;
  /**
   * @apilevel internal
   */
  protected MkScopeMod modScope_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:134
   */
  public MkScopeMod modScope() {
    if(modScope_computed) {
      return modScope_value;
    }
    ASTNode$State state = state();
    if (modScope_visited == state().boundariesCrossed) {
      throw new RuntimeException("Circular definition of attr: modScope in class: org.jastadd.ast.AST.SynDecl");
    }
    modScope_visited = state().boundariesCrossed;
    int num = state.boundariesCrossed;
    boolean isFinal = this.is$Final();
    modScope_value = modScope_compute();
    modScope_value.setParent(this);
    modScope_value.is$Final = true;
    if(true) {
      modScope_computed = true;
    } else {
    }

    modScope_visited = -1;
    return modScope_value;
  }
  /**
   * @apilevel internal
   */
  private MkScopeMod modScope_compute() {
      MkScopeMod s = new MkScopeMod(getId());
      this.setChild(s, 1);
      return s;
    }
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:230
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
  private ArrayList<Edge> mods_compute() { ArrayList<Edge> modEdges = new ArrayList<Edge>(); 
                           ModEdge modEdge = new ModEdge();
                           ASTNode tmpPar = this.scope().getParent();
                           modEdge.setsrc(this.scope());
                           modEdge.settgt(this.modScope());
                           modEdges.add(modEdge); 
                           this.scope().setParent(tmpPar);
                           this.modScope().setParent(this);
                           return modEdges; }
  /**
   * @apilevel internal
   */
  protected int impTentatives_visited = -1;
  /**
   * @apilevel internal
   */
  protected boolean impTentatives_computed = false;
  /**
   * @apilevel internal
   */
  protected boolean impTentatives_initialized = false;
  /**
   * @apilevel internal
   */
  protected ArrayList<Resolution> impTentatives_value;
  /**
   * @attribute syn
   * @aspect Scoping
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:240
   */
  public ArrayList<Resolution> impTentatives() {
    if(impTentatives_computed) {
      return impTentatives_value;
    }
    ASTNode$State state = state();
    if (!impTentatives_initialized) {
      impTentatives_initialized = true;
      impTentatives_value = new ArrayList<Resolution>();
    }
    if (!state.IN_CIRCLE) {
      state.IN_CIRCLE = true;
      int num = state.boundariesCrossed;
      boolean isFinal = this.is$Final();
      // TODO: fixme
      // state().CIRCLE_INDEX = 1;
      do {
        impTentatives_visited = state.CIRCLE_INDEX;
        state.CHANGE = false;
        ArrayList<Resolution> new_impTentatives_value = impTentatives_compute();
        if ((new_impTentatives_value==null && impTentatives_value!=null) || (new_impTentatives_value!=null && !new_impTentatives_value.equals(impTentatives_value))) {
          state.CHANGE = true;
        }
        impTentatives_value = new_impTentatives_value;
        state.CIRCLE_INDEX++;
      } while (state.CHANGE);
      if(isFinal && num == state().boundariesCrossed) {
        impTentatives_computed = true;
        state.LAST_CYCLE = true;
        impTentatives_compute();
        state.LAST_CYCLE = false;
      } else {
        state.RESET_CYCLE = true;
        impTentatives_compute();
        state.RESET_CYCLE = false;
        impTentatives_computed = false;
        impTentatives_initialized = false;
      }
      state.IN_CIRCLE = false;
      return impTentatives_value;
    }
    if(impTentatives_visited != state.CIRCLE_INDEX) {
      impTentatives_visited = state.CIRCLE_INDEX;
      if (state.LAST_CYCLE) {
      impTentatives_computed = true;
        ArrayList<Resolution> new_impTentatives_value = impTentatives_compute();
        return new_impTentatives_value;
      }
      if (state.RESET_CYCLE) {
        impTentatives_computed = false;
        impTentatives_initialized = false;
        impTentatives_visited = -1;
        return impTentatives_value;
      }
      ArrayList<Resolution> new_impTentatives_value = impTentatives_compute();
      if ((new_impTentatives_value==null && impTentatives_value!=null) || (new_impTentatives_value!=null && !new_impTentatives_value.equals(impTentatives_value))) {
        state.CHANGE = true;
      }
      impTentatives_value = new_impTentatives_value;
      return impTentatives_value;
    }
    return impTentatives_value;
  }
  /**
   * @apilevel internal
   */
  private ArrayList<Resolution> impTentatives_compute() {  return new ArrayList<Resolution>();  }
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:242
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
  private ArrayList<MkVarRef> refs_compute() {  return getDs().refs();  }
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
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:244
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
  private ArrayList<Scope> scopes_compute() {
      ArrayList<Scope> ss = new ArrayList<Scope>();
      ss.add(modScope());
      ss.addAll(getDs().scopes());
      return ss;
    }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:141
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__lex(ASTNode caller, ASTNode child) {
    if (caller == getmodScopeNoTransform()){
    ArrayList<Edge> lexEdges = new ArrayList<Edge>();
    LexEdge lexEdge = new LexEdge();
    ASTNode tmpPar = this.scope().getParent();
    lexEdge.setsrc(this.modScope());
    lexEdge.settgt(this.scope());
    lexEdges.add(lexEdge);
    this.scope().setParent(tmpPar);
    this.modScope().setParent(this);
    return lexEdges;
  }
    else {
      return getParent().Define_ArrayList_Edge__lex(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:154
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__imp(ASTNode caller, ASTNode child) {
    if (caller == getmodScopeNoTransform()){

    //System.out.println("imp for " + modScope().pp());

    ArrayList<Edge> impEdges   = new ArrayList<Edge>();
    ArrayList<Resolution> ress = getDs().impTentatives();

    // Temporarily printing all tentative imp edges
    String resStr = "";
    for (int i = 0; i < ress.size(); i++)
      resStr += ress.get(i).pp() + (i < ress.size() - 1 ? ", " : "");
    //System.out.println("getDs().impTentatives(): [" + resStr + "]");

    ArrayList<String> modRefs = new ArrayList<String>();
    modRefs.add("A");  // todo, don't hardcode these...
    modRefs.add("B"); 
    modRefs.add("C");

    // THE BELOW CODE IMPLEMENTS RECURSIVE IMPORTS:
    // 1. loop over all module references:
    //  1.1. set minimum path found `min` to null
    //  1.2. loop over all tentative imp edges:
    //    1.2.1. if that imp edge started from the current module reference
    //      1.2.1.1. set `min` to the minimum of `min` and current resolution
    //      1.2.1.1. otherwise do nothing
    //  1.3. we now have the minimum path for the module reference
    //  1.4. make the new corresponding real IMP edge from its discovered target
    for (String modRef: modRefs) {
      Path min = null;
      for (Resolution res: ress) {
        if (res.getrefNoTransform().str().equals(modRef)) {
          Path resPath = res.getpathNoTransform();
          if (min != null) min = Path.min(min, resPath);
          else min = resPath;
        }
      }
      if (min == null)  continue;
      ImpTentEdge impTentativeEdge = new ImpTentEdge();
      ASTNode tmpPar = min.tgt().getParent();
      impTentativeEdge.setsrc(this.modScope());
      impTentativeEdge.settgt(min.tgt());
      min.tgt().setParent(tmpPar);
      this.modScope().setParent(this);
      impEdges.add(impTentativeEdge);
    }
    // THE ABOVE CODE IMPLEMENTS RECURSIVE IMPORTS:
    

    // THE BELOW CODE IMPLEMENTS UNORDERED IMPORTS:
    // todo
    // THE ABOVE CODE IMPLEMENTS UNORDERED IMPORTS:

    return impEdges;
  }
    else {
      return getParent().Define_ArrayList_Edge__imp(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:210
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__var(ASTNode caller, ASTNode child) {
    if (caller == getmodScopeNoTransform()){ return getDs().vars(); }
    else {
      return getParent().Define_ArrayList_Edge__var(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:211
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__mod(ASTNode caller, ASTNode child) {
    if (caller == getmodScopeNoTransform()){ return getDs().mods(); }
    else {
      return getParent().Define_ArrayList_Edge__mod(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:213
   * @apilevel internal
   */
  public ArrayList<Edge> Define_ArrayList_Edge__impTentative(ASTNode caller, ASTNode child) {
    if (caller == getmodScopeNoTransform()){
    ArrayList<Edge> impTentativeEdges = new ArrayList<Edge>();
    for (Resolution res: getDs().impTentatives()) {
      ImpTentEdge impTentativeEdge = new ImpTentEdge();
      ASTNode tmpPar = res.getpathNoTransform().tgt().getParent();
      impTentativeEdge.setsrc(this.modScope());
      impTentativeEdge.settgt(res.getpathNoTransform().tgt());
      res.getpathNoTransform().tgt().setParent(tmpPar);
      this.modScope().setParent(this);
      impTentativeEdges.add(impTentativeEdge);
    }
    return impTentativeEdges;
  }
    else {
      return getParent().Define_ArrayList_Edge__impTentative(this, caller);
    }
  }
  /**
   * @declaredat /home/luke/Academia/personal/scopegraph-rags/circular/JastAdd-LM/spec/Scoping.jrag:228
   * @apilevel internal
   */
  public Scope Define_Scope_scope(ASTNode caller, ASTNode child) {
    if (caller == getDsNoTransform()){ return modScope(); }
    else {
      return getParent().Define_Scope_scope(this, caller);
    }
  }
  /**
   * @apilevel internal
   */
  public ASTNode rewriteTo() {    return super.rewriteTo();
  }}
