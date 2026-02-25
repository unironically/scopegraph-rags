package tests;

import testframework.*;
import AST.*;

public class DotNameResolutionTests extends PicoJavaTestCase {
  
  private IdUse axInA;
  private VarDecl declAAx;
  private IdUse bxInBB;
  private IdUse byInBB;


  public void setUp() {
    Program ast = parse(
				"{"+
			      "class A {"+
			        "int y;"+
			        "AA a;"+
			        "y = a.x;"+
			        "class AA {"+
			          "int x;"+
			        "}"+
			        "class BB extends AA {"+
			          "BB b;"+
			          "b.y = b.x;"+
			        "}"+
			      "}"+
				"}");

    ClassDecl A = (ClassDecl) ast.getBlock().getBlockStmt(0);
    ClassDecl AA = (ClassDecl) A.getBody().getBlockStmt(3);
    ClassDecl BB = (ClassDecl) A.getBody().getBlockStmt(4);
    declAAx = (VarDecl) AA.getBody().getBlockStmt(0);
    axInA = ((Dot) ((AssignStmt) A.getBody().getBlockStmt(2)).getValue()).getIdUse();
    AssignStmt assignInBB = (AssignStmt) BB.getBody().getBlockStmt(1);
    bxInBB = ((Dot) assignInBB.getValue()).getIdUse();
    byInBB = ((Dot) assignInBB.getVariable()).getIdUse();
   }
  
  
  public void testSimpleDot() {
    assertEquals(declAAx, axInA.decl());
  }
   
   public void testInheritedDot() {
     assertEquals(declAAx, bxInBB.decl());
   }
   
   public void testSurroundingContextIsNotVisible() {
     assertTrue(byInBB.decl().isUnknown());
   }

}
