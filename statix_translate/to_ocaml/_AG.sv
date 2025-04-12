grammar statix_translate:to_ocaml;

--------------------------------------------------

synthesized attribute ocaml_ag::String occurs on AG;

aspect production ag
top::AG ::= 
  nts::AG_Decls
  globs::AG_Decls
  prods::AG_Decls
  funs::AG_Decls
{
  top.ocaml_ag = 
    nts.ocaml_decls ++ "\n" ++
    globs.ocaml_decls ++ "\n" ++
    prods.ocaml_decls ++ "\n" ++
    funs.ocaml_decls;

  prods.knownNts = ^nts;
  funs.knownNts  = ^nts;
  globs.knownNts = ^nts;
  nts.knownNts   = ^nts;
}

--------------------------------------------------

function lookupNt
Maybe<AG_Decl> ::= name::String lst::AG_Decls
{
  return
    case lst of
    | agDeclsCons(h, t) -> 
        case h of
        | nonterminalDecl(n, _, _) -> if n == name then just(^h) 
                                                   else lookupNt(name, ^t)
        | _ -> error("lookupNt")
        end
    | agDeclsNil() -> nothing()
    end;
}