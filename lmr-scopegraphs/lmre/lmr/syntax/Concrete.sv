grammar lmre:lmr:syntax;

exports syntax:lmr0:lmr:driver;
exports syntax:lmr0:lmr:concretesyntax;

--

concrete production declMod_c
top::Decl_c ::= 'module' id::ModId_t '{' ds::Decls_c '}'
{
  top.ast = declMod(id.lexeme, ds.ast, location=top.location);
}

concrete production declImp_c
top::Decl_c ::= 'import' id::ModId_t
{
  top.ast = declImp(id.lexeme, location=top.location);
}