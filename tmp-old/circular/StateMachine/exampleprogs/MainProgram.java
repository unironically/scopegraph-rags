package exampleprogs;
import AST.*;

public class MainProgram {

    public static void main(String[] args) {
        // Construct the AST
        StateMachine m = new StateMachine(); 
        m.addDeclaration(new State("S1")); 
        m.addDeclaration(new State("S2")); 
        m.addDeclaration(new State("S3")); 
        m.addDeclaration(new Transition("a", "S1", "S2")); 
        m.addDeclaration(new Transition("b", "S2", "S1")); 
        m.addDeclaration(new Transition("a", "S2", "S3")); 

        // Print reachable information for all states
        m.printReachable();

    }

}
