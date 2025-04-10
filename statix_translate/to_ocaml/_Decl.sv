grammar statix_translate:to_ocaml;

--------------------------------------------------

synthesized attribute ocaml_decl::String occurs on AG_Decl;

aspect production functionDecl
top::AG_Decl ::= 
  name::String 
  retTy::AG_Type
  args::[(String, AG_Type)] 
  body::[AG_Eq]
{
  -- all locally defined names
  local locals::([String], [String]) = getLocals(body);
  local localsRegular::[String] = locals.1;
  local localEdgeLsts::[String] = locals.2;

  -- contribs for monoid locals
  local contribsAll::[(String, [AG_Expr])] = 
    map ((\attr::String -> (attr, allContributionsForAttr(attr, body))),
         localEdgeLsts);

  top.ocaml_decl = "F(" ++ name ++ ") eqs: " ++
    implode("; ", filterMap((.ocaml_eq), body));
}

aspect production productionDecl
top::AG_Decl ::=
  name::String
  ty::AG_Type
  args::[(String, AG_Type)]
  body::[AG_Eq]
{
  -- locally defined names
  local locals::([String], [String]) = getLocals(body);
  local localsRegular::[String] = locals.1;
  local localEdgeLsts::[String] = locals.2;

  -- contribs for monoid locals
  local contribsAll::[(String, [AG_Expr])] = 
    map ((\attr::String -> (attr, allContributionsForAttr(attr, body))),
         localEdgeLsts);

  top.ocaml_decl = name ++ " todo";

}

aspect production nonterminalDecl
top::AG_Decl ::=
  name::String
  inhs::[(String, AG_Type)]
  syns::[(String, AG_Type)]
{
  top.ocaml_decl = name ++ " todo";
}

aspect production globalDecl
top::AG_Decl ::=
  name::String
  ty::AG_Type
  e::AG_Expr
{
  top.ocaml_decl = name ++ " todo";
}

--------------------------------------------------

function allContributionsForAttr
[AG_Expr] ::= attr::String eqs::[AG_Eq]
{
  return
    case eqs of
    | [] -> []
    | contributionEq(qualLHS(nameLHS("top"), attr), expr)::t ->
        ^expr :: allContributionsForAttr(attr, t)
    | _::t -> allContributionsForAttr(attr, t)
    end;
}

-- monoids on left, others on right
function getLocals
([String], [String]) ::= eqs::[AG_Eq]
{
  return
    case eqs of
    | [] -> ([], [])
    | localDeclEq(l, ty)::t ->
        let rec::([String], [String]) = getLocals(t) in
          case ty of
          | listTypeAG(nameTypeAG("Scope")) -> (l::rec.1, rec.2)
          | _ -> (rec.1, l::rec.2)
          end
        end
    | _::t -> getLocals(t)
    end;
}