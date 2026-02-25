package tests;

import AST.*;
import java.io.*;
import junit.framework.TestCase;

public class ParserTests extends TestCase {
  
  public void testSimpleBlock() {
    assertParseOk("{}");
  }
  public void testSimpleSemi() {
    assertParseError(";");
  }

  // Class declarations
  public void testClassDecl() {
    assertParseOk("{ class A { } }");
  }
  public void testClassDeclWithExtends() {
    assertParseOk("{ class A extends B { } }");
  }
  public void testClassDeclWithQualifiedExtends() { // TODO: should this be valid?
    assertParseError("{ class A extends A.B { } }");
  }
  public void testNestedClassDecl() {
    assertParseOk("{ class A { class B { } } }");
  }

  // Variable declarations
  public void testVarDecl() {
    assertParseOk("{ A a; }");
  }
  public void testVarDeclQualifiedType() {
    assertParseOk("{ A.B.C a; }");
  }
  public void testVarDeclComplexName() {
    assertParseError("{ A.B.C a.b; }");
  }

  // Assignment
  public void testAssignStmt() {
    assertParseOk("{ a = b; }");
  }
  public void testAssignStmtQualifiedLHS() {
    assertParseOk("{ a.b.c = b; }");
  }
  public void testAssignStmtQualifiedRHS() {
    assertParseOk("{ a = b.c.d; }");
  }

  // While statement
  public void testWhileStmt() {
    assertParseOk("{ while ( a ) a = b; }");
  }
  public void testWhileStmtBlock() { // TODO: should this be valid?
    assertParseError("{ while ( a ) { a = b; } }");
  }

  // TODO: Null literal
  // TODO: Boolean literals
  
  
  // utility asserts to test parser
  
  protected static void assertParseOk(String s) {
    try {
      parse(s);
    } catch (Throwable t) {
      fail(t.getMessage());
    }
  }
  
  protected static void assertParseError(String s) {
    try {
      parse(s);
    } catch (Throwable t) {
      return;
    }
    fail("Expected to find parse error in " + s);
  }
  
  protected static void parse(String s) throws Throwable {
    PicoJavaParser parser = new PicoJavaParser();
    Reader reader = new StringReader(s);
    PicoJavaScanner scanner = new PicoJavaScanner(new BufferedReader(reader));
    Program p = (Program)parser.parse(scanner);
    reader.close();
  }
}
