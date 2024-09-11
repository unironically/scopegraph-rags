grammar lm_semantics_1:nameanalysis;

{-
abstract production mkScopeLet
top::Scope ::=
  lex::Decorated Scope
  var::[Decorated Scope]
{
  forwards to mkScope(just(lex), var, [], [], nothing(), location=top.location);
}

abstract production mkScopeGlobal
top::Scope ::=
  var::[Decorated Scope]
{
  forwards to mkScope(nothing(), var, [], [], nothing(), location=top.location);
}


abstract production mkScopeVar
top::Scope ::=
  datum::(String, Type)
{
  forwards to mkScope(nothing(), [], [], [], just(datumVar(fst(datum), snd(datum), location=top.location)), location=top.location);
}

abstract production mkScopeSeqBind
top::Scope ::=
  lex::Decorated Scope
  var::[Decorated Scope]
{
  forwards to mkScope(just(lex), var, [], [], nothing(), location=top.location);
}
-}

--------------------------------------------------

abstract production mkDeclVar
top::SGDecl ::=
  name::String
  ty::Type
{ forwards to 
  mkNode(just(datumVar(name, ty, location=top.location)), 
         location=top.location); }

--------------------------------------------------

abstract production datumVar
top::SGDatum ::= name::String ty::Type
{ forwards to datum(name, location=top.location); }

--------------------------------------------------

function printDecl
String ::= d::Decorated SGDecl
{
  return 
    case d of
    | mkDeclVar(name, _) -> name ++ "_" ++ 
        toString(d.location.line) ++ "_" ++ toString(d.location.column)
    | _ -> ""
    end;
}
