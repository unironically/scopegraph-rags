grammar statix_translate:lang:analysis;

--------------------------------------------------

nonterminal Type;

--------------------------------------------------

abstract production nameType
top::Type ::= name::String
{}

abstract production stringType
top::Type ::=
{}

abstract production boolType
top::Type ::=
{}

abstract production scopeType
top::Type ::=
{}

abstract production datumType
top::Type ::=
{}

abstract production pathType
top::Type ::=
{}

abstract production labelType
top::Type ::=
{}

abstract production listType
top::Type ::= ty::Type
{}

abstract production setType
top::Type ::= ty::Type
{}

abstract production tupleType
top::Type ::= tys::[Type]
{}

abstract production varType
top::Type ::=
{}

--------------------------------------------------

function toType
Type ::= tyAnn::TypeAnn
{
  return
    case tyAnn of
    | nameTypeAnn(n)         ->
        if n == "string" then stringType()
        else if n == "boolean" then boolType()
        else if n == "scope" then scopeType()
        else if n == "datum" then datumType()
        else if n == "path" then pathType()
        else if n == "label" then labelType()
        else nameType(n)
    | listTypeAnn(tyAnnElem) -> listType(toType(^tyAnnElem))
    | setTypeAnn(tyAnnElem)  -> setType(toType(^tyAnnElem))
    end;
}

function eqType
Boolean ::= ty1::Type ty2::Type
{
  return
    case ty1, ty2 of
    | nameType(n1), nameType(n2) -> n1 == n2
    | stringType(), stringType() -> true
    | boolType(), boolType()     -> true
    | scopeType(), scopeType()   -> true
    | datumType(), datumType()   -> true
    | labelType(), labelType()   -> true
    | pathType(), pathType()     -> true
    | listType(l1), listType(l2) -> eqType(^l1, ^l2)
    | setType(l1), setType(l2)   -> eqType(^l1, ^l2)
    | _, varType() -> true
    | varType(), _ -> true
    | _, _ -> false
    end;
}

function eqTys
Boolean ::= tysP::[Type] tysM::[Maybe<Type>]
{
  return
    case tysP, tysM of
    | [], [] -> true
    | h1::t1, [] -> false
    | [], h2::t2 -> false
    | _::_, nothing()::_ -> false
    | h1::t1, just(h2)::t2 -> eqType(h1, h2) && eqTys(t1, t2)
    end;

}

function eqTypePair
Boolean ::= pair::(Type, Type)
{
  return eqType(pair.1, pair.2);
}

function typeStr
String ::= t::Type
{
  return
    case t of
    | nameType(s)  -> s
    | stringType() -> "string"
    | boolType()   -> "boolean"
    | scopeType()  -> "scope"
    | datumType()  -> "datum"
    | pathType()   -> "path"
    | labelType()  -> "label"
    | listType(lt) -> "[" ++ typeStr(^lt) ++ "]"
    | setType(st)  -> "{" ++ typeStr(^st) ++ "}"
    | tupleType(ts)-> "(" ++ implode(", ", map(typeStr, ts)) ++ ")"
    | varType()    -> "'t"
    end;
}