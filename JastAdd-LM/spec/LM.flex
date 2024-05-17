package AST;

import beaver.Symbol;
import beaver.Scanner;
import AST.LMParser.Terminals;

%%

%public
%final
%class LMScanner
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
Integer = 0|[1-9][0-9]*

%% // Rules
/*
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
*/

"module"      { return sym(Terminals.MODULE); }
"import"      { return sym(Terminals.IMPORT); }
"def"         { return sym(Terminals.DEF); }

"="           { return sym(Terminals.ASSIGN); }
"+"           { return sym(Terminals.PLUS); }

"{"           { return sym(Terminals.LBRACE); }
"}"           { return sym(Terminals.RBRACE); }

{Identifier}  { return sym(Terminals.IDENTIFIER); }
{Integer}     { return sym(Terminals.INTEGER); }

{Comment}     { /* discard token */ }
{WhiteSpace}  { /* discard token */ }

.|\n          { throw new RuntimeException("Illegal character \""+yytext()+ "\" at line "+yyline+", column "+yycolumn); }
<<EOF>>       { return sym(Terminals.EOF); }