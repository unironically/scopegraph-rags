# LM without modules - language 0
- An implementation of language 0, where the only LM declarations allowed are `def`s.

### Running:
```bash
./clone-and-build-ministatix                        # Build Ministatix
./build-lm-compiler                                 # Compile and copy over the Silver generated compiler for LM 1
java -jar lm_language1.jar inputs/letseq.lm         # Compile an example program
./run-ministatix out/letseq.aterm                   # Run Ministatix on the Statix aterm which the Silver compiler produces
```

- After compiling the example program with silver, the following files will also be produced:
  - `out/SilverEquations.md`
  - `out/StatixConstraints.md`
- Note that, when the bindings are being printed, each identifier is given in the form `id_line:column`.

### Directories of interest:
- `statix-spec/`: here lives the Statix specification for language 1.
- `silver-grammar/`: a link to the directory holding the Silver abstract grammar for this language (`../grammars/lm_semantics_0`).
- `inputs/`: a link to the LM example inputs directory at `../grammars/lm_syntax_0/inputs`.
- `out/`: dumping ground for the LM compiler output files. This directory is created by the LM compiler if it does not already exist.
- `../ministatix.hs/`: where Ministatix is cloned to.
- `../grammars/`: assorted Silver grammars. Those of interest to this language are `lm_syntax_0/` and `lm_semantics_0/`.

### Concrete Syntax:
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
  | Expr_c '$' Expr_c
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