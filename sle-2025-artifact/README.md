# SLE 2025 Artifact

The artifact provided here has the 
primary purpose of validating Theorem 2 of our paper. Namely, that the results
of running Statix for a given specification and input program are consistent
with the results we get on the same input progam, with the translation of that
specification to a demand-driven attribute grammar.
We created a slightly modified version of Statix that includes
some annotations to assist in the translation to attribute grammars.
The artifact will, for one of these Statix specifications, translate that specification
to; 1) an equivalent Ministatix specification, 2) an attribute grammar in our
OCaml representation, 3) a Silver attribute grammar. It will then run a number 
of input program test cases through each system, record the results of each,
and check whether those results are consistent. 

Ministatix is a playground implementation of Statix, introduced as an artifact
of Knowing When to Ask (Rouvoet et al.). The OCaml AG representation encodes
an attribute grammar system defined by the demand-driven operational semantics
defined in the paper. On the other hand, Silver is an established demand-driven
reference attribute grammar language developed by our research group.

- Silver installation guide here: https://melt.cs.umn.edu/silver/install-guide/
- Ministatix can be found here: https://github.com/metaborg/ministatix.hs.

The Docker image contains executables for Ministatix and Silver, so these do not
need to be installed.

More information [here](./load/README.md), and detailed
instructions for test cases [here](./load/AUTHORS-TEMPLATE.md).