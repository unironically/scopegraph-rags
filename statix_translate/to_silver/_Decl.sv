grammar statix_translate:to_silver;

--------------------------------------------------

global preNt::String = "Nt_";
global preProd::String = "pf_";

--------------------------------------------------

attribute knownNts occurs on AG_Decl;
propagate knownNts on AG_Decl;

synthesized attribute silver_decl::String occurs on AG_Decl;

aspect production functionDecl
top::AG_Decl ::= 
  name::String 
  retTy::AG_Type
  args::[(String, AG_Type)] 
  body::[AG_Eq]
{
  top.silver_decl = "function " ++ preProd ++ name ++ "\n" ++ 
    retTy.silver_type ++ " ::= " ++ 
    implode(" ", map(\arg::(String, AG_Type) -> arg.1 ++ "::" ++ 
                                                arg.2.silver_type, args)) ++ 
  " {\n\t" ++
    implode("\n\t", filterMap((.silver_eq), body) ++ contribsTrans) ++
  "}";

  -- contribs for monoid locals
  local contribsAll::[(String, AG_Type, [AG_Expr])] = 
    map ((\attr::(String, AG_Type) -> 
          (attr.1, attr.2, allContributionsForAttr(attr.1, body))),
         localEdgeLsts);
  local locals::([(String, AG_Type)], [String]) = getLocals(body);
  local localEdgeLsts::[(String, AG_Type)] = locals.1;
  local regularLocals::[String] = locals.2;
  local contribsTrans::[String] = 
    map (
      \p::(String, AG_Type, [AG_Expr]) ->
        case p.2 of
        | listTypeAG(scopeTypeAG()) -> 
            qualLHS(nameLHS("top"), p.1).silver_lhs ++ " = " ++
            combineEdgeContribs(p.3) ++ ";"
        | boolTypeAG() ->
            qualLHS(nameLHS("top"), p.1).silver_lhs ++ " = " ++
            combineBoolContribs(p.3) ++ ";"
        | _ -> error("productionDecl.contribsTrans")
        end,
      contribsAll);



}

aspect production productionDecl
top::AG_Decl ::=
  name::String
  ty::AG_Type
  args::[(String, AG_Type)]
  body::[AG_Eq]
{
  top.silver_decl = "abstract production " ++ preProd ++ name ++ "\n" ++ 
    "top::" ++ ty.nta_type ++ " ::= " ++ 
    implode(" ", map(\arg::(String, AG_Type) -> arg.1 ++ "::" ++ 
                                                arg.2.silver_type, args)) ++ 
  " {\n\t" ++
    implode("\n\t", filterMap((.silver_eq), body) ++ contribsTrans) ++ "\n" ++
  "}";

  -- contribs for monoid locals
  local ntM::Maybe<AG_Decl> = lookupNt(ty.nta_type, top.knownNts);
  local nt::AG_Decl = if ntM.isJust then ntM.fromJust else error("Did not find NT " ++ ty.nta_type ++ " in silver!");
  local syns::[(String, AG_Type)] = case nt of nonterminalDecl(_, _, syns) -> syns 
                                             | _ -> error("productionDecl.syns") end;
  local contribsAll::[(String, AG_Type, [AG_Expr])] = 
    map ((\attr::(String, AG_Type) -> (attr.1, attr.2, allContributionsForAttr(attr.1, body))),
         synContribAttrs ++ localEdgeLsts);
  local synContribAttrs::[(String, AG_Type)] = getContribAttrs(syns);
  local locals::([(String, AG_Type)], [String]) = getLocals(body);
  local localEdgeLsts::[(String, AG_Type)] = locals.1;
  local regularLocals::[String] = locals.2;
  local contribsTrans::[String] = 
    map (
      \p::(String, AG_Type, [AG_Expr]) ->
        case p.2 of
        | listTypeAG(scopeTypeAG()) -> 
            qualLHS(nameLHS("top"), p.1).silver_lhs ++ " = " ++
            combineEdgeContribs(p.3) ++ ";"
        | boolTypeAG() ->
            qualLHS(nameLHS("top"), p.1).silver_lhs ++ " = " ++
            combineBoolContribs(p.3) ++ ";"
        | _ -> error("productionDecl.contribsTrans")
        end,
      contribsAll);

}


aspect production nonterminalDecl
top::AG_Decl ::=
  name::String
  inhs::[(String, AG_Type)]
  syns::[(String, AG_Type)]
{
  top.silver_decl = "nonterminal " ++ preNt ++ name ++ " with " ++
    implode(", ", 
      map(\attr::(String, AG_Type) -> attr.1, inhs++syns)) ++
  ";";
}


aspect production globalDecl
top::AG_Decl ::=
  name::String
  ty::AG_Type
  e::AG_Expr
{
  top.silver_decl = "global " ++ name ++ "::" ++ ty.silver_type ++ 
    e.silver_expr ++
  ";";
}

--------------------------------------------------

inherited attribute knownNts::AG_Decls occurs on AG_Decls;
propagate knownNts on AG_Decls;

synthesized attribute silver_decls::String occurs on AG_Decls;

aspect production agDeclsCons
top::AG_Decls ::= h::AG_Decl t::AG_Decls
{
  top.silver_decls = h.silver_decl ++ "\n" ++ t.silver_decls;
}

aspect production agDeclsNil
top::AG_Decls ::= 
{
  top.silver_decls = "";
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

function combineBoolContribs
String ::= contribs::[AG_Expr]
{
  return
    case contribs of
    | []    ->   "true"
    | h::[] -> h.silver_expr
    | h::t  -> h.silver_expr ++ " && " ++ combineBoolContribs(t)
    end;
}

function combineEdgeContribs
String ::= contribs::[AG_Expr]
{
  return
    case contribs of
    | []    -> "[]"
    | h::[] -> "(" ++ h.silver_expr ++ ")"
    | h::t  -> "(" ++ h.silver_expr ++ ")" ++ " ++ " ++ combineEdgeContribs(t)
    end;
}

fun str String ::= s::String = "\"" ++ s ++ "\"";

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

--------------------------------------------------