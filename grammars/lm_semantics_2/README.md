# LM without modules

### Cocnrete Syntax:
```
Main_c ::= 
  Decls_c

Decls_c ::= 
  Decl_c Decls_c
  | 

Decl_c ::= 
  'def' ParBind_c

Expr_c ::= 
    Int_t
  | 'true'
  | 'false'
  | VarRef_c
  | Expr_c '+' Expr_c
  | Expr_c '-' Expr_c
  | Expr_c '*' Expr_c
  | Expr_c '/' Expr_c
  | Expr_c '&' Expr_c
  | Expr_c '|' Expr_c
  | Expr_c '==' Expr_c
  | Expr_c '^' Expr_c
  | 'if' Expr_c 'then' Expr_c 'else' Expr_c
  | 'fun' '(' ArgDecl_c ')' '{' Expr_c '}'
  | 'let' SeqBinds_c 'in' Expr_c
  | 'letrec' ParBinds_c 'in' Expr_c
  | 'letpar' ParBinds_c 'in' Expr_c
  | '(' Expr_c ')'

SeqBinds_c ::=
    SeqBind_c ',' SeqBinds_c
  | SeqBind_c
  |

SeqBind_c ::= 
    VarId_t '=' Expr_c
  | Type_c ':' VarId_t '=' Expr_c

ParBinds_c ::=
    ParBind_c ',' ParBinds_c
  |

ParBind_c ::= 
    VarId_t '=' Expr_c
  | Type_c ':' VarId_t '=' Expr_c

ArgDecl_c ::= 
    VarId_t ':' Type_c

Type_c ::= 
    'int'
  | 'bool'
  | Type_c '->' Type_c
  | '(' Type_c ')'

VarRef_c ::= 
    VarId_t

---

terminal Int_t /0|[1-9][0-9]*/;

terminal VarId_t /[a-z][a-zA-Z_0-9]*/
```