package testframework;

import java.io.BufferedReader;
import java.io.Reader;
import java.io.StringReader;

import AST.*;
import junit.framework.TestCase;

public abstract class PicoJavaTestCase extends TestCase {

	  protected static Program parse(String s) {
		    try {
		      PicoJavaParser parser = new PicoJavaParser();
		      Reader reader = new StringReader(s);
		      PicoJavaScanner scanner = new PicoJavaScanner(new BufferedReader(reader));
		      Program p = (Program)parser.parse(scanner);
		      reader.close();
		      return p;
		    } catch (Throwable t) {
		      fail(t.getMessage());
		      throw new Error("This should not happen");
		    }
		  }
}
