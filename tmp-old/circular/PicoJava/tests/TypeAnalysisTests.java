package tests;

import testframework.*;
import AST.*;


public class TypeAnalysisTests extends PicoJavaTestCase {
  
  public void testVarDeclType() {
    Program p = parse("{ class A {} A a; }");
    ClassDecl typeA = (ClassDecl)p.getBlock().localLookup("A");
    VarDecl a = (VarDecl)p.getBlock().localLookup("a");
    assertEquals(typeA, a.type());
  }
  
  public void testVarDeclPrimitiveType() {
    Program p = parse("{ boolean a; }");
    VarDecl a = (VarDecl)p.getBlock().localLookup("a");
    assertEquals(p.booleanType(), a.type());
  }
  
  public void testQualifiedNameType() {
    Program p = parse("{ class A { A a; } class B extends A { B b; } B o; o = o.b.a; }");
    ClassDecl typeA = (ClassDecl)p.getBlock().localLookup("A");
    ClassDecl typeB = (ClassDecl)p.getBlock().localLookup("B");
    AssignStmt assign = (AssignStmt)p.getBlock().getBlockStmt(3);
    Dot rhs = (Dot)assign.getValue();
    IdUse lhs = (IdUse)assign.getVariable();
    assertEquals(typeA, rhs.type());
    assertEquals(typeB, lhs.type());
  }

  public void testSubtypeOfSelf() {
    Program p = parse("{ class A {} }");
    ClassDecl typeA = (ClassDecl)p.getBlock().localLookup("A");
    assertTrue(typeA.isSubtypeOf(typeA));
  }
  
  public void testDirectSubtype() {
    Program p = parse("{ class A {} class B extends A {} }");
    ClassDecl typeA = (ClassDecl)p.getBlock().localLookup("A");
    ClassDecl typeB = (ClassDecl)p.getBlock().localLookup("B");
    assertTrue(typeB.isSubtypeOf(typeA));
    assertFalse(typeA.isSubtypeOf(typeB));
  }
  
  public void testSubtype() {
    Program p = parse("{ class A {} class B extends A {} class C extends B {} }");
    ClassDecl typeA = (ClassDecl)p.getBlock().localLookup("A");
    ClassDecl typeC = (ClassDecl)p.getBlock().localLookup("C");
    assertTrue(typeC.isSubtypeOf(typeA));
    assertFalse(typeA.isSubtypeOf(typeC));
  }

  public void testSubtypeUnrelated() {
    Program p = parse("{ class A {} class B {} }");
    ClassDecl typeA = (ClassDecl)p.getBlock().localLookup("A");
    ClassDecl typeB = (ClassDecl)p.getBlock().localLookup("B");
    assertFalse(typeA.isSubtypeOf(typeB));
    assertFalse(typeB.isSubtypeOf(typeA));
  }
  
  public void testSubtypeSiebling() {
    Program p = parse("{ class A {} class B extends A {} class C extends A {} }");
    ClassDecl typeA = (ClassDecl)p.getBlock().localLookup("A");
    ClassDecl typeB = (ClassDecl)p.getBlock().localLookup("B");
    ClassDecl typeC = (ClassDecl)p.getBlock().localLookup("C");
    assertTrue(typeB.isSubtypeOf(typeA));
    assertTrue(typeC.isSubtypeOf(typeA));
    assertFalse(typeA.isSubtypeOf(typeB));
    assertFalse(typeC.isSubtypeOf(typeB));
  }
  
  public void testCyclicClassHierarchy() {
    Program p = parse("{ class A extends B {} class B extends A {} }");
    ClassDecl a = (ClassDecl)p.getBlock().localLookup("A");
    ClassDecl b = (ClassDecl)p.getBlock().localLookup("B");
    // detect cycles in class hierarchies
    assertTrue(a.hasCycleOnSuperclassChain());
    assertTrue(b.hasCycleOnSuperclassChain());
    // classes in cyclic hierarchies are regarded as not having a superclass
    assertEquals(null, a.superClass());
    assertEquals(null, b.superClass());
  }

  public void testSubtypeUnknown() {
    Program p = parse("{ class A {} B b; }");
    ClassDecl typeA = (ClassDecl)p.getBlock().localLookup("A");
    VarDecl b = (VarDecl)p.getBlock().localLookup("b");
    // all types are subtypes of unknown
    assertTrue(typeA.isSubtypeOf(p.unknownDecl()));
    // unknown is a subtype of all types
    assertTrue(b.type().isSubtypeOf(typeA));
  }
  
  public void testVarDeclUnknownType() {
    Program p = parse("{ A a; }");
    VarDecl a = (VarDecl)p.getBlock().localLookup("a");
    // unbound type names have the type unknown
    assertEquals(p.unknownDecl(), a.type());
  }
}
