package tests;

import AST.*;
import testframework.*;
import java.util.*;

public class ErrorCheckTests extends PicoJavaTestCase {
  
  public void testCorrectProgram() {
    Program p = parse("{ class A {} A a; }");
    assertTrue(p.errors().isEmpty());
  }
  
  public void testExtendingUndeclaredType() {
    Program p = parse("{ class A extends B {} }");
    assertTrue(p.errors().size() == 1);
    assertEquals("Unknown identifier B", p.errors().iterator().next());
  }
  
  public void testUsingUndeclaredVariable() {
    Program p = parse("{ class A {} A a; a = b; }");
    assertTrue(p.errors().size() == 1);
    assertEquals("Unknown identifier b", p.errors().iterator().next());
  }

  public void testUsingChainsOfUndeclaredVariables() {
    // only the first unbound name results in an error
    Program p = parse("{ class A { A b; } A a; a = a.b.c.d.e.f; }");
    assertTrue(p.errors().size() == 1);
    assertEquals("Unknown identifier c", p.errors().iterator().next());
  }
  
  public void testTypesInAssignStmt() {
    // same primitive type
    Program p = parse("{ boolean a; boolean b; a = b; }");
    assertTrue(p.errors().size() == 0);

    // one type is unknown, only name error visible
    p = parse("{ boolean a; a = b; }");
    assertTrue(p.errors().size() == 1);
    assertEquals("Unknown identifier b", p.errors().iterator().next());
    
    // user defined vs primitive
    p = parse("{ class A {} A a; boolean b; a = b; }");
    assertTrue(p.errors().size() == 1);
    assertEquals("Can not assign a variable of type A to a value of type boolean", p.errors().iterator().next());
    
    // non related user defined
    p = parse("{ class A {} class B {} A a; B b; a = b; }");
    assertTrue(p.errors().size() == 1);
    assertEquals("Can not assign a variable of type A to a value of type B", p.errors().iterator().next());
  }

  public void testCyclicInheritance() {
    Program p = parse("{ class A extends B {} class B extends A {} }");
    assertTrue(p.errors().size() == 2);
    Iterator iter = p.errors().iterator();
    assertEquals("Cyclic inheritance chain for class A", iter.next());
    assertEquals("Cyclic inheritance chain for class B", iter.next());
  }

  public void testBooleanConditionInWhileStmt() {
    Program p = parse("{ class A {} A a; while (a) a = a; }");
    assertTrue(p.errors().size() == 1);
    assertEquals("Condition must be a boolean expression", p.errors().iterator().next());
  }
  
  public void testValueConditionInWhileStmt() {
    Program p = parse("{ class A {} A a; while (boolean) a = a; }");
    assertTrue(p.errors().size() == 1);
    assertEquals("Condition must be a value", p.errors().iterator().next());
  }
}
