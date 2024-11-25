grammar lm_semantics_4:nameanalysis;

--------------------------------------------------

{-abstract production mkDeclVar
top::SGDecl ::=
  --name::String
  --ty::Type
{ forwards to 
  mkNode(just(datumVar(name, ty, location=top.location)), 
         location=top.location); }

abstract production mkDeclMod
top::SGDecl ::=
  name::String
{ forwards to 
  mkNode(just(datumMod(name, location=top.location)), 
         location=top.location); }-}

--------------------------------------------------

abstract production datumVar
top::SGDatum ::= name::String ty::Type
{ forwards to datum(name, location=top.location); }

abstract production datumMod
top::SGDatum ::= name::String mod::Decorated SGScope
{ forwards to datum(name, location=top.location); }

--------------------------------------------------

function printDecl
String ::= s::Decorated SGScope
{
  return 
    case s.datum of
    | datumNone() -> ""
    | d -> d.name ++ "_" ++ 
        toString(d.location.line) ++ "_" ++ toString(d.location.column)
    end;
}
