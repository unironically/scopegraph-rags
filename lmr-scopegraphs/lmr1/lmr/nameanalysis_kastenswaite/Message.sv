grammar lmr1:lmr:nameanalysis_kastenswaite;

import silver:langutil; -- for location.unparse

--------------------------------------------------

function err
String ::= msg::String loc::Location
{
  return loc.unparse ++ ": error: " ++ msg ++ "\n"; 
}

function warn
String ::= msg::String loc::Location
{
  return loc.unparse ++ ": warning: " ++ msg ++ "\n"; 
}
