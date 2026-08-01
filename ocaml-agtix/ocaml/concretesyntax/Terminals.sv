grammar ocaml:concretesyntax;

-- https://ocaml.org/manual/5.4/language.html

------------
-- Terminals

ignore terminal WhiteSpace_t /[\n\r\t\ ]+/;
ignore terminal Comment_t /\(\*([^\*]*|\*[^\)])*\*\)/;

--

lexer class KEYWORD;

terminal Let_t 'let' lexer classes {KEYWORD};
terminal Rec_t 'rec' lexer classes {KEYWORD};
terminal In_t  'in'  lexer classes {KEYWORD}, precedence = 0;

terminal If_t   'if'   lexer classes {KEYWORD};
terminal Then_t 'then' lexer classes {KEYWORD};
terminal Else_t 'else' lexer classes {KEYWORD}, precedence = 0;

terminal Fun_t 'fun' lexer classes {KEYWORD};

terminal Match_t 'match' lexer classes {KEYWORD};
terminal With_t  'with'  lexer classes {KEYWORD};
terminal When_t  'when'  lexer classes {KEYWORD};

terminal Type_t 'type' lexer classes {KEYWORD}; 

terminal Of_t 'of' lexer classes {KEYWORD};

terminal App_t '' precedence = 15;

--

terminal Identifier_t /[A-Za-z_][A-Za-z0-9_]*/ submits to {KEYWORD};
terminal IdentifierUpper_t /[A-Z][A-Za-z0-9_]*/ submits to {KEYWORD};

--

terminal Int_t    /-?[0-9]+/;
terminal String_t  /[\"]([^\r\n\"\\]|[\\][\"]|[\\][\\]|[\\]b|[\\]n|[\\]r|[\\]f|[\\]t)*[\"]/;

terminal True_t  'true'  lexer classes {KEYWORD};
terminal False_t 'false' lexer classes {KEYWORD};

--

terminal Bar_t '|' precedence = 8, association = left;
terminal Arrow_t '->' precedence = 1, association = right;

terminal LParen_t '(';
terminal RParen_t ')';

terminal LBracket_t '[';
terminal RBracket_t ']';

terminal Underscore_t '_';

terminal SemiColon_t ';' precedence = 1, association = right;
terminal SemiColonMaybe_t /[ ;]/;

terminal DoubleSemiColon_t ';;';

terminal Comma_t ',' association = left, precedence = 5;

terminal Cons_t '::';

terminal Eq_t '=';

terminal Tick_t /'/; -- '

terminal Star_t '*';

terminal Colon_t ':';

--

disambiguate Underscore_t, Identifier_t {
  pluck Underscore_t;
}

disambiguate SemiColon_t, SemiColonMaybe_t {
  pluck SemiColon_t;
}

disambiguate Identifier_t, IdentifierUpper_t {
  pluck IdentifierUpper_t;
}