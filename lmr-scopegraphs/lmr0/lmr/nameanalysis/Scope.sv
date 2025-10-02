grammar lmr0:lmr:nameanalysis;

--------------------------------------------------

abstract production mkDeclVar
top::SGScope ::=
  name::String
  ty::Type
{ forwards to 
  mkScopeDatum(datumVar(name, ^ty, location=top.location), 
               location=top.location); }

--------------------------------------------------

abstract production datumVar
top::SGDatum ::= name::String ty::Type
{ forwards to datum(name, location=top.location); }

--------------------------------------------------

function printDecl
String ::= d::Decorated SGScope
{
  return 
    case d of
    | mkDeclVar(name, _) -> name ++ "_" ++ 
        toString(d.location.line) ++ "_" ++ toString(d.location.column)
    | _ -> ""
    end;
}
