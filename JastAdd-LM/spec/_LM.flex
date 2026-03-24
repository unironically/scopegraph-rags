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
{Integer}     { return sym(Terminals.INTEGER); }

{Comment}     { /* discard token */ }
{WhiteSpace}  { /* discard token */ }

.|\n          { throw new RuntimeException("Illegal character \""+yytext()+ "\" at line "+yyline+", column "+yycolumn); }
<<EOF>>       { return sym(Terminals.EOF); }
