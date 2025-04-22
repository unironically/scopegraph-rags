grammar statix_translate:to_ocaml;

--------------------------------------------------

synthesized attribute ocaml_ag::String occurs on AG;

aspect production ag
top::AG ::= 
  nts::AG_Decls
  globs::AG_Decls
  prods::AG_Decls
  funs::AG_Decls
  inhs::[(String, AG_Type)]
  syns::[(String, AG_Type)]
  labs::[Label]
{
  top.ocaml_ag = 
    --labelsOCamlList ++ "\n" ++ implode(";\n", (nts.ocaml_decls ++ globs.ocaml_decls ++
    --               prods.ocaml_decls ++ funs.ocaml_decls));
    genAgFile(labelsOCamlList, nts.ocaml_decls, prods.ocaml_decls ++ funs.ocaml_decls);

  local builtinPlusFoundNts::AG_Decls = agDeclsCons (
    nonterminalDecl("datum", [("data", nameTypeAG("actualData"))], []),
    agDeclsCons(
      nonterminalDecl("actualData", [], []),
      ^nts
    )
  );

  prods.knownNts = ^builtinPlusFoundNts;
  funs.knownNts  = ^builtinPlusFoundNts;
  globs.knownNts = ^builtinPlusFoundNts;
  nts.knownNts   = ^builtinPlusFoundNts;

  local labelsStr::[String] = map(\l::Label -> case l of label(n) -> n end, labs);
  local labelsOCamlList::String = "let label_set = " ++ ocamlLabels(labelsStr);
}

--------------------------------------------------

function ocamlLabels
String ::= labs::[String]
{
  return "[" ++ implode("; ", map(str(_), labs)) ++ "]";
}

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

function genAgFile
String ::= labs::String nts::[String] prods::[String]
{
  return
    "open Ocaml_ag_syntax\nopen Ocaml_ag_spec\nopen Ocaml_ag_eval\n\n" ++
    "module Spec : AG_Spec = struct\n\n" ++

    "\t(* label set *)\n\t" ++ labs ++ "\n" ++

    "\t(* nonterminal set *)\n\tlet nt_set = [\n\t" ++

      implode(";\n\t", nts) ++

    "\t]\n\n\t(* production/function set *)\n\tlet prod_set = [\n\t" ++

      implode(";\n\t", prods) ++

    "\t]\n\nend\n\nmodule AG_Full = AG(Spec)";
}