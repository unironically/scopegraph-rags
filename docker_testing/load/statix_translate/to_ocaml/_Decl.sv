grammar statix_translate:to_ocaml;

--------------------------------------------------

synthesized attribute ocaml_decl::String occurs on AG_Decl;
attribute knownNts occurs on AG_Decl;

aspect production functionDecl
top::AG_Decl ::= 
  name::String 
  retTy::AG_Type
  args::[(String, AG_Type)] 
  body::[AG_Eq]
{
  -- all locally defined names
  local locals::([(String, AG_Type)], [String]) = getLocals(body);
  local localEdgeLsts::[(String, AG_Type)] = locals.1;
  local localsRegular::[String] = locals.2;

  -- contribs for monoid locals
  local contribsAll::[(String, AG_Type, [AG_Expr])] = 
    map ((\attr::(String, AG_Type) -> (attr.1, attr.2, allContributionsForAttr(attr.1, body))),
         localEdgeLsts);
  local contribsTrans::[String] = 
    map (
      \p::(String, AG_Type, [AG_Expr]) ->
        case p.2 of
        | listTypeAG(scopeTypeAG()) -> 
            "AttrEq(" ++
              qualLHS(nameLHS("top"), p.1).ocaml_lhs ++ ", " ++
              combineEdgeContribs(p.3) ++
            ")"
        | boolTypeAG() ->
            "AttrEq(" ++
              qualLHS(nameLHS("top"), p.1).ocaml_lhs ++ ", " ++
              combineBoolContribs(p.3) ++
            ")"
        | _ -> error("functionDecl.contribsTrans")
        end,
      contribsAll);

  -- type of the function
  local funTy::String = "FunResult";

  -- arg names
  local argsStr::[String] = map(str, map(fst, args));

  -- local names
  local allLocals::[String] = map(str, map(fst, locals.1) ++ locals.2);

  top.ocaml_decl = "(" ++
    str(name) ++ ", " ++ str(funTy) ++ ", " ++                    -- name, ty
    "[" ++ implode("; ", argsStr) ++ "], " ++                     -- args
    "[" ++ implode("; ", allLocals) ++ "], " ++                   -- locals
    "[" ++ implode("; ", contribsTrans ++                         -- eqs from contribs
                         filterMap((.ocaml_eq), body)) ++ "]" ++  -- other eqs
  ")";

}

aspect production productionDecl
top::AG_Decl ::=
  name::String
  ty::AG_Type
  args::[(String, AG_Type)]
  body::[AG_Eq]
{
  -- todo, merge this and functiondecl

  local ntM::Maybe<AG_Decl> = lookupNt(ty.ocaml_type, top.knownNts);
  local nt::AG_Decl = if ntM.isJust then ntM.fromJust else error("Did not find NT " ++ ty.ocaml_type ++ " in ocaml!");
  local syns::[(String, AG_Type)] = case nt of nonterminalDecl(_, _, syns) -> syns 
                                             | _ -> error("productionDecl.syns") end;
  local synContribAttrs::[(String, AG_Type)] = getContribAttrs(syns);

  -- all locally defined names
  local locals::([(String, AG_Type)], [String]) = getLocals(body);
  local localEdgeLsts::[(String, AG_Type)] = locals.1;
  local localsRegular::[String] = locals.2;

  -- contribs for monoid locals
  local contribsAll::[(String, AG_Type, [AG_Expr])] = 
    map ((\attr::(String, AG_Type) -> (attr.1, attr.2, allContributionsForAttr(attr.1, body))),
         synContribAttrs ++ localEdgeLsts);

  local contribsTrans::[String] = 
    map (
      \p::(String, AG_Type, [AG_Expr]) ->
        case p.2 of
        | listTypeAG(scopeTypeAG()) -> 
            "AttrEq(" ++
              qualLHS(nameLHS("top"), p.1).ocaml_lhs ++ ", " ++
              combineEdgeContribs(p.3) ++ 
            ")"
        | boolTypeAG() ->
            "AttrEq(" ++
              qualLHS(nameLHS("top"), p.1).ocaml_lhs ++ ", " ++
              combineBoolContribs(p.3) ++ 
            ")"
        | _ -> error("productionDecl.contribsTrans")
        end,
      contribsAll);

  -- type of the function
  local prodTy::String = ty.ocaml_type;

  -- arg names
  local argsStr::[String] = map(str, map(fst, args));

  -- local names
  local allLocals::[String] = map(str, map(fst, locals.1) ++ locals.2);

  top.ocaml_decl = "(" ++
    str(name) ++ ", " ++ str(prodTy) ++ ", " ++                   -- name, ty
    "[" ++ implode("; ", argsStr) ++ "], " ++                     -- args
    "[" ++ implode("; ", allLocals) ++ "], " ++                   -- locals
    "[" ++ implode("; ", contribsTrans ++                         -- eqs from contribs
                         filterMap((.ocaml_eq), body)) ++ "]" ++  -- other eqs
  ")";

}

aspect production nonterminalDecl
top::AG_Decl ::=
  name::String
  inhs::[(String, AG_Type)]
  syns::[(String, AG_Type)]
{
  local attrs::[String] = map(str, map(fst, inhs++syns));
  top.ocaml_decl = "(" ++ str(name) ++ ", [" ++ implode("; ", attrs) ++ "])";
}

aspect production globalDecl
top::AG_Decl ::=
  name::String
  ty::AG_Type
  e::AG_Expr
{
  top.ocaml_decl = name ++ " todo";
}

aspect production eqInstanceDecl
top::AG_Decl ::=
  ty::AG_Type
  e::AG_Expr
{
  top.ocaml_decl = "";
}

--------------------------------------------------

function allContributionsForAttr
[AG_Expr] ::= attr::String eqs::[AG_Eq]
{
  return
    case eqs of
    | [] -> []
    | contributionEq(qualLHS(nameLHS("top"), attr_), expr)::t when attr == attr_ ->
        ^expr :: allContributionsForAttr(attr, t)
    | _::t -> allContributionsForAttr(attr, t)
    end;
}

-- monoids on left, others on right
function getLocals
([(String, AG_Type)], [String]) ::= eqs::[AG_Eq]
{
  return
    case eqs of
    | [] -> ([], [])
    | localDeclEq(l, ty)::t ->
        let rec::([(String, AG_Type)], [String]) = getLocals(t) in
          case ty of
          | listTypeAG(scopeTypeAG()) -> ((l, ^ty)::rec.1, rec.2)
          | boolTypeAG()           -> ((l, ^ty)::rec.1, rec.2)
          | _ -> (rec.1, l::rec.2)
          end
        end
    | _::t -> getLocals(t)
    end;
}

function getContribAttrs
[(String, AG_Type)] ::= attrs::[(String, AG_Type)]
{
  return 
    case attrs of
    | [] -> []
    | (n, ty)::t -> case ty of listTypeAG(scopeTypeAG()) -> (n, ty)::getContribAttrs(t)
                             | boolTypeAG() -> (n, ty)::getContribAttrs(t)
                             | _ -> getContribAttrs(t)
                    end
    end;
}

--------------------------------------------------

inherited attribute knownNts::AG_Decls occurs on AG_Decls;
propagate knownNts on AG_Decls;

synthesized attribute ocaml_decls::[String] occurs on AG_Decls;

aspect production agDeclsCons
top::AG_Decls ::= h::AG_Decl t::AG_Decls
{
  top.ocaml_decls = h.ocaml_decl :: t.ocaml_decls;
}

aspect production agDeclsNil
top::AG_Decls ::= 
{
  top.ocaml_decls = [];
}

--------------------------------------------------

function combineBoolContribs
String ::= contribs::[AG_Expr]
{
  return
    case contribs of
    | [] ->   "Bool(true)"
    | h::t -> "And(" ++ h.ocaml_expr ++ ", " ++ combineBoolContribs(t) ++ ")"
    end;
}

function combineEdgeContribs
String ::= contribs::[AG_Expr]
{
  return
    case contribs of
    | []    -> "Nil"
    | h::[] -> h.ocaml_expr
    | h::t  -> "Append(" ++ h.ocaml_expr ++ ", " ++ combineEdgeContribs(t) ++ ")"
    end;
}

fun str String ::= s::String = "\"" ++ s ++ "\"";

--------------------------------------------------