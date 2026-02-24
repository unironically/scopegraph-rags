# SLE 2026 Tool Paper
Silver + Statix - do we need a name for this extension/system?


## What: combine AG specs and Statix scope graph constraints

Some Statix constraints can be written in place of equations.
These constraint types are:
- scope assertions
- edge assertions
- scope "existence" declarations
- others?

Additional features at the "AGDcl" level include
- declaration of edge labels
- declaration of ordering on edge labels, or are these
  also on queries in Statix?

Features at the expression level include
- queries, with regular expressions, and label orders

Ability to have multiple / named scope graphs
- e.g. `LMGraph:s`


### Questions
- Do/Can we propagate scope attributes down the tree?
  I see only explicit copy equations for these.

- Scope attribute seem to be inherited. Can they be synthesized?
  This would be useful in the sequential let bindings, right?

- The LMGRraph declaration also yields a type synonym for a collection
  of inh attributes? This gets used in things like

  `[Decoarated Scope with LMGraph]`


## Why are we doing this? What is gained by the combination?
- concise Statix constraint specifications
  - produces stand-alone scope graph, useful for different
    purposes

- flexibility of AGs.
  - for more general purpose analysis and translation all in one 
    system


## Comparing approaches

### Silver is extensible
- so domain-specific constructs can be easily added
  - including for scope graphs
- relies on new syntax, new analyses, 
  overloading existing operators

### Spoofax is a collection of DSLs
- name some and their use
  - Statix, Stratego, SDF3, DynSem, others?

- some documentation suggests that different "sections" in a Spoofax
  file (if there is such a thing) can be for specs in these different
  DSLs. So still a coarser grain organization than in AGs

### RAGs/JastAdd
- probably something from the SLE paper would suffice


## Demo
- need good demo of this, in the paper and the appendix

- datum could include references to AST nodes, more inline with what 
  RAGS do well

- need to generate nice error messages. Not just fail on the first
  error but collect and organize them

- need queries for generating hints when errors are encountered.

- need to do something with types, perhaps translation to some other
  language that depends on types.

  Maybe OCaml in which `+` is not overloaded and we need `+.` for
  floats. 



## Past Work
- translating Statix to RAGs, monolithically

- had limitations
  - scope nodes asserted at top of their scope region.
    - We fix this in this work
  - no unification of terms
    - We don't fix this
  - other limitations in the SLE paper we should mention?

- translation to AGs was rather verbose
  - not as verbose as a traditional name binding implementation of
    passing an environment down as a list
  - or as passing down a reference to the enclosing scope



## Open Questions

- how does Statix, in Eclipse, handle error messages?
  - it must do this

- how does JastAdd prefer to write name binding? I believe it is with
  references to enclosing scopes as the first place to go look for a
  name. The methods/parameterized attributes here take a name to look
  for and find it locally or ask the right node for it instead -
  either imported modules or lexical parent. The order in which this
  is done is driven by the same factors that drive the writing of
  regexs in Statix.


