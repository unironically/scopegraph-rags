package lm.ast; // The generated scanner will belong to the package lm.ast

import lm.ast.LMParser.Terminals; // The terminals are implicitly defined in the parser
import lm.ast.LMParser.SyntaxError;

%%

// define the signature for the generated scanner
%public
%final
%class LMScanner
%extends beaver.Scanner

// the interface between the scanner and the parser is the nextToken() method
%type beaver.Symbol
%function nextToken

// store line and column information in the tokens
%line
%column

// this code will be inlined in the body of the generated scanner class
%{
  private beaver.Symbol sym(short id) {
    return new beaver.Symbol(id, yyline + 1, yycolumn + 1, yylength(), yytext());
  }
%}

// macros

WhiteSpace = [ ] | \t | \f | \n | \r
Identifier = [a-z]([:letter:] | [:digit:])*
Numeral = (0|[1-9][0-9]*)

%%

{WhiteSpace}  { /* discard token */ }

"true"        { return sym(Terminals.TRUE); }
"false"       { return sym(Terminals.FALSE); }

"="           { return sym(Terminals.ASSIGN); }

"def"         { return sym(Terminals.DEF); }
"mod"         { return sym(Terminals.MODULE); }
"imp"         { return sym(Terminals.IMPORT); }

"="           { return sym(Terminals.ASSIGN); }
"+"           { return sym(Terminals.PLUS); }

":"           { return sym(Terminals.COLON); }

"{"           { return sym(Terminals.LBRACE); }
"}"           { return sym(Terminals.RBRACE); }

"bool"        { return sym(Terminals.BOOLTY); }
"int"         { return sym(Terminals.INTTY); }

{Identifier}  { return sym(Terminals.IDENTIFIER); }
{Numeral}     { return sym(Terminals.INTEGER); }

<<EOF>>       { return sym(Terminals.EOF); }

/* error fallback */
[^]           { throw new SyntaxError("Illegal character <"+yytext()+">"); }