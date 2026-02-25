package exampleprogs;
import AST.*;
import java.io.*;

public class Compiler {

    public static void main(String[] args) {
        String filename = getFilename(args);
        
        // Construct the AST
        StateMachine m = parse(filename); 
        
        // Prettyprint the AST
        m.pp();
        System.out.println();

        // Print reachable information for all states
        m.printReachable();
        System.out.println();
        
        // Exercise 2: Print info about what states are on cycles
        m.printInfoAboutCycles();
    }
    
    public static String getFilename(String[] args) {
        if(args.length != 1) {
            System.out.println("Usage: java Compiler filename");
            System.exit(1);
        }
        return args[0];
    }
    
    public static StateMachine parse(String filename) {
        try {
            FileReader reader = new FileReader(filename);
            StateMachineScanner scanner = new StateMachineScanner(reader);
            StateMachineParser parser = new StateMachineParser();
            StateMachine result = (StateMachine)parser.parse(scanner);
            return result;
        }
        catch(Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
