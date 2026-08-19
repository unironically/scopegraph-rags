grammar lmr1:lmr:extension_records_sg;

--------
-- Scope

production scopeRec
top::Scope ::= x::String node::Decorated Record
{ forwards to scopeDefault(datumRec(x, node)); }

production scopeFld
top::Scope ::= x::String node::Decorated Fields
{ forwards to scopeDefault(datumFld(x, node)); }

-------
-- Data

production datumRec
top::Datum ::= x::String node::Decorated Record 
{ top.name = x; }

production datumFld
top::Datum ::= x::String node::Decorated Fields
{ top.name = x; }

-------------
-- Resolution

-- Demand rec edges
fun regexRecFun (ResPairList ::= ResPair) ::= =
  \p::ResPair ->
    map(\sf::Decorated Scope -> (sf, "rec"::p.2), p.1.edges.lookup("rec"));

-- Demand fld edges
fun regexFldFun (ResPairList ::= ResPair) ::= =
  \p::ResPair ->
    map(\sf::Decorated Scope -> (sf, "fld"::p.2), p.1.edges.lookup("fld"));
