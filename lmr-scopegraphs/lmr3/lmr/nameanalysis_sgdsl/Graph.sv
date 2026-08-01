grammar lmr3:lmr:nameanalysis_sgdsl;

----------

synthesized attribute name::String;
synthesized attribute count::Integer;

----------

-- no arrow means no data
abstract scope type LexScope;

-- maybe we only give attribute IDs in abstract scope types? ignore DclScope for now
--abstract scope type DclScope -> name;

-- no arrow means no data
scope type RegionScope;

-- maybe we only give a Decorated node type in 'concrete' scope types? implicit 'Decorated' instead?
scope type (DclScope) => VarScope -> Decorated Bind; -- name must occur on Bind

-- same questions as above
scope type (LexScope, DclScope) => ModScope -> Decorated Module;

----------

-- similar to link declarations in the software architecture graph grammars paper
-- give source, target scope types
edge type LexScope -[lex]-> LexScope; -- only edge pointing to an abstract scope type
edge type LexScope -[var]-> VarScope;
edge type LexScope -[mod]-> ModScope;
edge type LexScope -[imp]-> ModScope;

----------

{- what's a little odd is that in other Silver productions you always give the 
 - children as arguments, but here we want to give the LHS as an argument ang
 - generate the nodes/edges on the RHS.

{- implicitly the scope graph node on the LHS is kept. generative grammar. maybe
 - there is some syntax for stopping this from happening if the user wants it.
 -}

{- shouldn't be allowed to have an abstract scope type on RHS of a rule. only
 - 'concrete' scope types, since these are scopes that are being newly built.
 -}

graph production sgMkGlob
_ -> glob::RegionScope;

graph production sgMkVar
s::LexScope -> v::VarScope, s -[var]-> v;

graph production sgMkMod
s::LexScope -> m::ModScope, s -[mod]-> m, m -[lex]-> s;

{- this is a 'coordination' rule in the software architecture paper. but since
 - we choose in productions when to apply graph grammar rules, it can just be
 - one of those(?)
 -}

graph production sgMkImp
s::LexScope m::ModScope -> s -[imp]-> m;

graph production sgMkLex
s::LexScope -> s2::RegionScope, s2 -[lex]-> s;

----------

{- Similar comment to above about graph productions. We give `start` as the
 - argument in the below declarations. In the object language productions we
 - refer to the query result list by the query name e.g. `queryVar2`.
 -}

query type queryVar1
start::LexScope =(lex* imp? var, lex > imp > var)=> [VarScope];

query type queryVar2
start::LexScope =(lex* imp? var, lex > imp > var)=> [VarScope] with count, only
{ count = length(queryVar2);
   only = if queryVar2.count == 1 then just(head(queryVar2)) else nothing(); };

query type queryMod
start::LexScope =(lex* imp? mod, lex > imp > mod)=> [ModScope];
