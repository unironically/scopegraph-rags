

import java.io.BufferedReader;
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
			System.err.println("error (PrettyPrint) : No arguments given");
			System.exit(1);
		}
		
		// check that the file exists
		File file = new File(args[0]);
	    if(!file.exists()) {
	    	System.err.println("error (PrettyPrint) : file does not exist");
	    	System.exit(2);
	    }
		
		for (String s: args) {
			if (s.equals("-d") || s.equals("--debug"))
				Program.debug = true;
		}
	    		
		try {
			
			// scan, parse and build ast
			LMParser parser = new LMParser();
			Reader reader = new FileReader(args[0]);
			LMScanner scanner = new LMScanner(new BufferedReader(reader));
			Program p = (Program)parser.parse(scanner);
			reader.close();
			
			runPreErrorCheck(p);

			System.out.println("IMP edges in graph:");

			for (Scope s: p.scopes()) {
				ArrayList<Edge> impEdges = s.imp();
				if (impEdges.size() <= 0) continue;
				System.out.print("\t- " + s.pp() + " --IMP-> ");
				for (Edge e: s.imp()) {
					System.out.print(e.gettgtNoTransform().pp() + ", ");
				}
				System.out.println();
			}

			System.out.println("VarRef resolutions in graph:");

			for (MkVarRef ref: p.refs()) {
				ArrayList<Resolution> refRes = ref.resolution();
				//if (refRes.size() <= 0) continue;

				//Ref r = res.getrefNoTransform();
				//Scope s = res.getpathNoTransform().tgt();

				System.out.print("\t- " + ref.pp() + " |-> ");

				for (Resolution res: refRes) {
					System.out.print(res.getpathNoTransform().tgt().pp() + ", ");
				}

				System.out.println();

			}

			//System.out.println(p.prettyPrint());
		} catch (IOException e) {
			System.err.println("error (PrettyPrint) : " + e.getMessage());
			e.printStackTrace();
		} catch (beaver.Parser.Exception e) {
			System.err.println("error (PrettyPrint) : " + e.getMessage());
			e.printStackTrace();
		} 
	}

	public void runPreErrorCheck(Program p) {
	}
}
