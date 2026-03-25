/*import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.util.Collection;

import java.util.*;

import beaver.Scanner.Exception;

import AST.*;

public class Compiler {
	public static void main(String[] args) {
		new Compiler().run(args);
	}		

	public void run(String[] args) {
		// Make sure there are arguments
		if (args.length == 0) {
			System.err.println("error : No arguments given");
			System.exit(1);
		}
		
		// check that the file exists
		File file = new File(args[0]);
	    if(!file.exists()) {
	    	System.err.println("error : file does not exist");
	    	System.exit(2);
	    }
				
		try {
			
			// scan, parse and build ast
			LMParser parser = new LMParser();
			Reader reader = new FileReader(args[0]);
			LMScanner scanner = new LMScanner(new BufferedReader(reader));
			Root p = (Root)parser.parse(scanner);
			reader.close();
			
			System.out.println("Analysis result: " + (p.ok() ? "ok" : "not ok"));

			//System.out.println(p.prettyPrint());
		} catch (IOException e) {
			System.err.println("error : " + e.getMessage());
			e.printStackTrace();
		} catch (beaver.Parser.Exception e) {
			System.err.println("error : " + e.getMessage());
			e.printStackTrace();
		} 
	}

}*/

package lm;

import java.io.FileReader;
import java.io.IOException;
import java.io.FileNotFoundException;

import lm.ast.Program;
import lm.ast.LMParser;
import lm.ast.LMScanner;

public class Compiler {

    public static Object CodeProber_parse(String[] args) throws Throwable {
        return parse(args);
    }

    public static Program parse(String[] args) throws IOException, beaver.Parser.Exception {
        String filename = args[args.length - 1]; // Assumes filename is the last argument
        LMScanner scanner = new LMScanner(new FileReader(filename));
        LMParser parser = new LMParser();
        Program program = (Program) parser.parse(scanner);
        return program;
    }

    public static void main(String[] args) {
        try {
            if (args.length != 1) {
                System.err.println(
                        "You must specify a source file on the command line!");
                System.exit(1);
                return;
            }
            
            Program program = parse(args);

            String resStr = (program.ok()) ? "ok" : "not ok";
            System.out.println("result: " + resStr);
            
        } catch (FileNotFoundException e) {
            System.out.println("File not found!");
            System.exit(1);
        } catch (IOException e) {
            System.out.println("Unexpected I/O exception. Perhaps permission problems?");
            e.printStackTrace();
            System.exit(1);
        } catch (beaver.Parser.Exception e) {
            System.out.println("Parsing failed!");
            e.printStackTrace();
            System.exit(1);
        }
    }

}
