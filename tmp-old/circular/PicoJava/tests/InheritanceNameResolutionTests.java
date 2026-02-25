package tests;

import AST.*;
import testframework.*;

public class InheritanceNameResolutionTests extends PicoJavaTestCase {
  private VarDecl declAa;
  private IdUse aInAA;
  private VarDecl declAAb;
  private IdUse bInAA;
  private ClassDecl declA;
  private IdUse AinB;
  private IdUse aInB;
  private VarDecl declBc;
  private IdUse cInB;
  private ClassDecl declAA;
  private IdUse AAinBB;
  private IdUse aInBB;
  private VarDecl declAAe;
  private IdUse eInBB;
  private IdUse fInBB;
  private VarDecl declBf;

  public void setUp() {
    Program ast = parse(
				"{"+
			      "class A {"+
			        "int a;"+
			        "int b;"+
			        "int c;"+
			        "class AA {"+
			          "int b;"+ // shadows A.b
			          "int d;"+
			          "int e;"+
			          "a = b;"+ // A.a = AA.b
			        "}"+
			      "}"+
			      "class B extends A {"+
			        "int c;"+ // shadows A.c
			        "int e;"+
			        "int f;"+
			        "a = c;"+ // A.a = B.c
			        "class BB extends AA {"+
			        "int d;"+ // shadows AA.d
			        "a = d;"+ // A.a = BB.d
			        "e = f;"+ // AA.e = B.f
			      "}"+
			    "}"+
	          "}");

    declA = (ClassDecl) ast.getBlock().getBlockStmt(0);
    declAa = (VarDecl) declA.getBody().getBlockStmt(0);
    declAA = (ClassDecl) declA.getBody().getBlockStmt(3);
    declAAb = (VarDecl) declAA.getBody().getBlockStmt(0);
    declAAe = (VarDecl) declAA.getBody().getBlockStmt(2);
    AssignStmt assignInAA = (AssignStmt) declAA.getBody().getBlockStmt(3);
    aInAA = (IdUse) assignInAA.getVariable();
    bInAA = (IdUse) assignInAA.getValue();
    ClassDecl B = (ClassDecl) ast.getBlock().getBlockStmt(1);
    AinB = B.getSuperclass();
    declBc = (VarDecl) B.getBody().getBlockStmt(0);
    declBf = (VarDecl) B.getBody().getBlockStmt(2);
    AssignStmt assignInB = (AssignStmt) B.getBody().getBlockStmt(3);
    aInB = (IdUse) assignInB.getVariable();
    cInB = (IdUse) assignInB.getValue();
    ClassDecl BB = (ClassDecl) B.getBody().getBlockStmt(4);
    AAinBB = BB.getSuperclass();
    AssignStmt firstAssignInBB = (AssignStmt) BB.getBody().getBlockStmt(1);
    aInBB = (IdUse) firstAssignInBB.getVariable();
    AssignStmt secondAssignInBB = (AssignStmt) BB.getBody().getBlockStmt(2);
    eInBB = (IdUse) secondAssignInBB.getVariable();
    fInBB = (IdUse) secondAssignInBB.getValue();
  }
  
  public void testBindingInOuterBlock() {
    assertEquals(declAa, aInAA.decl());
  }
  
  public void testBlockStructureShadowing() {
    assertEquals(declAAb, bInAA.decl());
  }
  
  public void testSuperclassBinding() {
    assertEquals(declA, AinB.decl());
  }
  
  public void testInheritance() {
    assertEquals(declAa, aInB.decl());
  }
  
  public void testInheritanceShadowing() {
    assertEquals(declBc, cInB.decl());
  }
  
  public void testSuperclassBindingOfInnerClass() {
    assertEquals(declAA, AAinBB.decl());
  }
  
  public void testInheritanceInOuterClass() {
    assertEquals(declAa, aInBB.decl());
  }
  
  public void testSuperclassShadowsOuterBlock() {
    assertEquals(declAAe, eInBB.decl());
  }
  
  public void testSuperclassDoesNotShadowOuterBlock() {
    assertEquals(declBf, fInBB.decl());
  }
}
