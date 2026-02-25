package AST;

import beaver.Symbol;
import beaver.Scanner;
import AST.PicoJavaParser.Terminals;

%%

%public
%final
%class PicoJavaScanner
%extends Scanner
%unicode
%function nextToken
%type Symbol
%yylexthrow Scanner.Exception
%line
%column
%char

%{
  private Symbol sym(short id) {
    return new Symbol(id, yyline + 1, yycolumn + 1, yylength(), yytext());
  }
%}

// Helper Definitions

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

WhiteSpace = {LineTerminator} | [ \t\f]
Comment = "//" {InputCharacter}* {LineTerminator}?

Identifier = [:letter:]([:letter:] | [:digit:])*

%% // Rules

"class"       { return sym(Terminals.CLASS); }
"extends"     { return sym(Terminals.EXTENDS); }
"while"       { return sym(Terminals.WHILE); }

"true"        { return sym(Terminals.BOOLEAN_LITERAL); }
"false"       { return sym(Terminals.BOOLEAN_LITERAL); }

"("           { return sym(Terminals.LPAREN); }
")"           { return sym(Terminals.RPAREN); }
"{"           { return sym(Terminals.LBRACE); }
"}"           { return sym(Terminals.RBRACE); }
";"           { return sym(Terminals.SEMICOLON); }
"."           { return sym(Terminals.DOT); }

"="           { return sym(Terminals.ASSIGN); }

{Comment}     { /* discard token */ }
{WhiteSpace}  { /* discard token */ }
{Identifier}  { return sym(Terminals.IDENTIFIER); }

.|\n          { throw new RuntimeException("Illegal character \""+yytext()+ "\" at line "+yyline+", column "+yycolumn); }
<<EOF>>       { return sym(Terminals.EOF); }
