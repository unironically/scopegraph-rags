package tests;

import testframework.*;
import AST.*;

public class BasicNameResolutionTests extends PicoJavaTestCase {
  
  private VarDecl declRx; // The declaration of x at the outeRmost level
  private IdUse xInR;     // The use of x at the outeRmost level
  private VarDecl declRz; // ...
  private IdUse zInR;
  private IdUse yInR;
  private IdUse yInA;     // The use of y inside class A
  private IdUse xInA;     // ...
  private VarDecl declAz;
  private IdUse zInA;     // The first use of z inside class A

  public void setUp() {
	Program ast = parse(
		"{"+
		    "int x;"+
		    "x = z;"+
		    "int z;"+
		    "y = x;"+
		    "class A {"+
		       "int z;"+
		       "x = z;"+
		       "y = z;"+
		    "}"+
		"}");

    declRx = (VarDecl) ast.getBlock().getBlockStmt(0);
    AssignStmt assignRx = (AssignStmt) ast.getBlock().getBlockStmt(1);
    xInR = (IdUse) assignRx.getVariable();
    zInR = (IdUse) assignRx.getValue();
    declRz = (VarDecl) ast.getBlock().getBlockStmt(2);
    AssignStmt assignRy = (AssignStmt) ast.getBlock().getBlockStmt(3);
    yInR = (IdUse) assignRy.getVariable();
    ClassDecl A = (ClassDecl) ast.getBlock().getBlockStmt(4);
    declAz = (VarDecl) A.getBody().getBlockStmt(0);
    AssignStmt assignAx = (AssignStmt) A.getBody().getBlockStmt(1);
    xInA = (IdUse) assignAx.getVariable();
    zInA = (IdUse) assignAx.getValue();
    AssignStmt assignAy = (AssignStmt) A.getBody().getBlockStmt(2);
    yInA = (IdUse) assignAy.getVariable();
  }
  
  
  public void testBindingInSameBlock() {
    assertEquals(declRx, xInR.decl());
  }
  
  public void testDeclarationOrderIrrelevant() {
    assertEquals(declRz, zInR.decl());
  }
  
  public void testMissingDecl() {
    assertTrue(yInR.decl().isUnknown());
    assertTrue(yInA.decl().isUnknown());
  }
  
  public void testBindingInOuterBlock() {
    assertEquals(declRx, xInA.decl());
  }
  
  public void testShadowingDeclaration() {
    assertEquals(declAz, zInA.decl());
  }

}
