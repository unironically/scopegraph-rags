grammar statix_translate:lang:concretesyntax;

{-terminal VarId_t /[a-z][a-zA-Z_0-9]*/
  submits to {
    True_t, False_t, Module_t, Import_t, Record_t, Def_t, If_t, Then_t, Else_t,
    Fun_t, Let_t, LetRec_t, LetPar_t, In_t, New_t, With_t, Do_t, IntType_t,
    BoolType_t
  };

terminal ModId_t /[A-Z][a-zA-Z_0-9]*/
  submits to {
    True_t, False_t, Module_t, Import_t, Record_t, Def_t, If_t, Then_t, Else_t,
    Fun_t, Let_t, LetRec_t, LetPar_t, In_t, New_t, With_t, Do_t, IntType_t,
    BoolType_t
  };

terminal Int_t /0|[1-9][0-9]*/;

terminal True_t 'true';
terminal False_t 'false';

terminal Module_t 'module';
terminal Import_t 'import';
terminal Record_t 'record';
terminal Def_t 'def';
terminal Bind_t '=' precedence = 8, association = left;

terminal If_t 'if';
terminal Then_t 'then';
terminal Else_t 'else' precedence = 8, association = left;

terminal Fun_t 'fun';

terminal Let_t 'let';
terminal LetRec_t 'letrec';
terminal LetPar_t 'letpar';
terminal In_t 'in' precedence = 8, association = left;

terminal New_t 'new';
terminal With_t 'with';
terminal Do_t 'do' precedence = 8, association = left;

terminal LBrace_t '{';
terminal RBrace_t '}';
terminal LParen_t '(';
terminal RParen_t ')';

terminal Comma_t ',' precedence = 9, association = left;
terminal Dot_t '.' precedence = 16, association = left;

terminal Colon_t ':' precedence = 15, association = right;
terminal Semi_t ';';

terminal App_t '$' precedence = 15, association = left;
terminal Mul_t '*' precedence = 14, association = left;
terminal Div_t '/' precedence = 14, association = left;
terminal Plus_t '+' precedence = 13, association = left;
terminal Sub_t '-' precedence = 13, association = left;
terminal Eq_t '==' precedence = 12, association = left;
terminal And_t '&' precedence = 11, association = left;
terminal Or_t '|' precedence = 10, association = left;

terminal IntType_t 'int';
terminal BoolType_t 'bool';
terminal Arrow_t '->' precedence = 8, association = right;-}

lexer class KWD;

terminal True_t      'true'           lexer classes {KWD};
terminal False_t     'false'          lexer classes {KWD};
terminal New_t       'new'            lexer classes {KWD};
terminal In_t        'in'             lexer classes {KWD};
terminal As_t        'as'             lexer classes {KWD};
terminal Where_t     'where'          lexer classes {KWD};
terminal Query_t     'query'          lexer classes {KWD};
terminal Only_t      'only'           lexer classes {KWD};
terminal Every_t     'every'          lexer classes {KWD};
terminal Inhabited_t 'inhabited'      lexer classes {KWD};
terminal Minus_t     'min'            lexer classes {KWD};
terminal Filter_t    'filter'         lexer classes {KWD};
terminal Match_t     'match'          lexer classes {KWD};
terminal Edge_t      'Edge'           lexer classes {KWD};
terminal End_t       'End'            lexer classes {KWD};

terminal Reverse_t   'reverse-lexico' lexer classes {KWD};
terminal Lexico_t    'lexico'         lexer classes {KWD};
terminal Eps_t       'e';             --lexer classes {KWD};
terminal Scala_t     'scala'          lexer classes {KWD};
terminal Import_t    'import'         lexer classes {KWD};
terminal Order_t     'order'          lexer classes {KWD};

terminal At_t        '@';
terminal Score_t     '_';
terminal Hyphen_t    '-';
terminal Lt_t        '<';
terminal Gt_t        '>';

terminal LeftArr_t   /(<\-)|(:\-)/;
terminal RightArr_t  '->';
terminal Colon_t     ':'              association = right;
terminal Semi_t      ';';
terminal OpenArr_t   '-[';
terminal CloseArr_t  ']->';
terminal OpenPar_t   '(';
terminal ClosePar_t  ')';
terminal OpenBr_t    '{';
terminal CloseBr_t   '}'              association = right;
terminal OpenSB_t    '[';
terminal CloseSB_t   ']';
terminal Eq_t        '==';
terminal NotEq_t     '!=';
terminal Tick_t      '`';

terminal Dot_t       '.';
terminal Comma_t     ','              association = right;

terminal Concat_t    ''               precedence = 1, association = right;
terminal Bar_t       '|'              precedence = 5, association = left;
terminal And_t       '&'              precedence = 5, association = left;
terminal Tilde_t     '~'              precedence = 10, association = left;
terminal Star_t      '*'              precedence = 10, association = left;
terminal Plus_t      '+'              precedence = 10, association = left;
terminal Question_t  '?'              precedence = 10, association = left;


ignore terminal Whitespace_t    /[\n\r\t ]+/;
ignore terminal LineComment_t   /\/\/.*/;
--ignore terminal Comment_t       /\/\*(\/\*([^\*]|\*+[^\/\*])*\*+\/|[^\*]|\*+[^\/\*])*\*+\//;

terminal String_t      /[\"]([^\r\n\"\\]|[\\][\"]|[\\][\\]|[\\]b|[\\]n|[\\]r|[\\]f|[\\]t)*[\"]/;
terminal Name_t        /[a-z][a-zA-Z_0-9_\-\']*/ submits to {KWD};
terminal Constructor_t /[A-Z][a-zA-Z_0-9_\-]*/ submits to {KWD};
terminal Quote_t       /\'/;