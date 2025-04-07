grammar statix_translate:lang:analysis;

--------------------------------------------------

nonterminal Type;

--------------------------------------------------

abstract production nameType
top::Type ::= name::String
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
    | nameTypeAnn(n)         -> nameType(n)
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
    | listType(l1), listType(l2) -> eqType(^l1, ^l2)
    | setType(l1), setType(l2)   -> eqType(^l1, ^l2)
    | _, varType() -> true
    | varType(), _ -> true
    | _, _ -> false
    end;
}