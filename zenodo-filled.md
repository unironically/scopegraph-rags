# Info for the zenodo.org site

## Files

Docker image
AUTHOR-TEMPLATE.md

## DOI

10.5281/zenodo.15272587

## Resource Type

Software

## Title

Artifact: Scheduling the Construction and Interrogation of Scope
Graphs Using Attribute Grammars

## Publication date

April 23, 2025

## Description

The artifact provided has the primary purpose of validating Theorem 2 of our
paper. Namely, that the results of running Statix for a given specification and
input program are consistent with the results we get on the same input progam,
with the translation of that specification to a demand-driven attribute grammar.
The artifact will, for a given Statix specification, translate that specification
to; 1) an equivalent Ministatix specification, 2) an attribute grammar in our
OCaml representation, 3) a Silver attribute grammar. It will then run a number 
of input program test cases through each system, record the results of each,
and check whether those results are consistent. If all are consistent, then all 
tests pass. Consistent results are defined by:

- If the input program is satisfiable by Ministatix, then it is satisfiable by
  both AG systems (case 1 of Theorem 2).

- If the input program is unsatisfiable by Ministatix, then it is unsatisfiable
  by both AG systems (cases 2/3 of Theorem 2).

- If Ministatix becomes stuck during execution, then both AG systems abort with
  a cycle detected (case 4 of Theorem 2).

Please note that each input test case directory in `specifications/testcases/lm`
has a `README.md` outlining the expected results for that test case under each
LM specification we provide, stating which case of the Theorem 2 they validate
for each.

The artifact contains a number of scripts for translating Statix specifications
and running test cases through each of the translations. These are described
in the artifact structure outline below. For the reviewer, it should suffice to
execute the `test-all-specs` script, to run all test cases we have for all
Statix specifications. However, if the reviewer wishes to write their own
Statix specifications and test cases, they will want to use `test-one-spec`,
giving the specification and a directory containing the test cases as arguments.

**Artifact structure overview**

The interesting artifact structure is outlined below.

- `test-all-specs`: Top-level script for running all input test cases in 
  `specifications/testcases/lm` through all translations for the three Statix 
  specifications we provide in `specifications/`, for each of; Ministatix, our 
  OCaml AG implementation, the Silver AG system.

- `test-one-spec`: Takes two arguments; the path to a Statix specification
  (e.g. `specifications/lm-rec.mstx`), and the path of a directory containing
  input test cases (e.g. `specifications/testcases/lm`).
  Translates the Statix specification to; the same specification
  in Statix syntax satisfying the Knowing When to Ask artifact (Ministatix),
  an OCaml-based translation of that specification, and a Silver-based 
  translation. Then run all test cases in the directory given as the second
  argument for each translation.

- `try-all-inputs`: Takes one argument, a directory to look for test case 
  programs. Runs each test case found through each of the three systems and
  outputs the results of each.

- `try-one-input`: Takes one argument, a directory representing one test case. 
  Runs that test case through each of the three systems and outputs the results
  of each.

- `test-mstx`: For a particular test case input, run it through Ministatix using
  the generated Ministatix specification.

- `test-ocaml`: For a particular test case input, run it through the OCaml AG
  using the generated OCaml AG representation.

- `test-silver`: For a particular test case input, run it through the Silver AG
  using the generated Silver AG.

- `lib/`:
   - `mstx_lib/`: Contains the Ministatix binary. 
   - `ocaml_lib/`: Contains the OCaml AG environment.
   - `silver_lib/`: Contains the Silver AG environment for our generated AGs,
     including a scope graphs implementation.

- `specifications/`:
   - `lm-par.mstx`: Specification of LM with parallel imports.
   - `lm-rec.mstx`: Specification of LM with recursive imports.
   - `lm-seq.mstx`: Specification of LM with sequential imports.
   - `testcases/`: Home for input program test cases.
      - `lm/`: Directories containing test cases for LM. Each has a Ministatix
        input term `mstx.aterm`, an OCaml input term `ag_test.ml`, and a Silver
        input term `Main.sv`. As well as these, a `README.md` describing the
        test case and expected results, and `concrete-syntax.lm` giving the
        concrete syntax of that test case.

- `statix_translate/`: The implementation of the translator of Statix 
  specifications in our syntax, to Ministatix specifications, OCaml attribute
  grammars, and Silver attribute grammars.
  - `compile`: Script to compile the translator.
  - `clean`: cleanup (remove generated `.jar` and build files)
  - `driver/`: Contains the main file for invoking the translator.
  - `lang/`: Definition of our version of Statix in concrete and abstract
    syntax, as well as basic well-formedness analyses.
  - `to_ministatix/`: Implementation of translation to Ministatix syntax.
  - `to_ag/`: Implementation of translation to an intermediate AG form.
  - `to_ocaml/`: Implementation of a translation to OCaml AG form.
  - `to_silver/`: Implementation of a translation to Silver AG form.


## Contributors

Name: Eric Van Wyk
Identifiers: 0000-0002-5611-8687
Affiliations: University of Minnesota
Role: Researcher

## Funding

Nothing

## Alternate identifiers

Nothing

## Related works

Nothing

## References

Nothing

## Repository URL

https://github.com/melt-umn/statix-in-ags

## Publishing Info
- nothing here

## Conference

Title: ACM International Conference on Software Language Engineering
Acronym: SLE
Place: Koblenz, Germany
Dates: June 12-13, 2025
Website: sleconf.org

## Domain specific fields

Nothing