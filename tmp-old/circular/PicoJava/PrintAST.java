import AST.*;

public class PrintAST extends Compiler {
	public static void main(String[] args) {
		new PrintAST().run(args);
	}

	public void runPreErrorCheck(Program p) {
		System.out.println(p.printAST());
	}		
}
