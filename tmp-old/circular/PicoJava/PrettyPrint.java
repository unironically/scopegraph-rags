import AST.*;

public class PrettyPrint extends Compiler {
	public static void main(String[] args) {
		new PrettyPrint().run(args);
	}

	public void runPreErrorCheck(Program p) {
		System.out.println(p.prettyPrint());
	}		
}
