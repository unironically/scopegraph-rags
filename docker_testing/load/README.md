# SLE 2025 Artifact Submission: Scheduling the Construction and Interrogation of Scope Graphs Using Attribute Grammars

**NOTE:** this is not intented as the overview of the artifact for the reviwer,
please see [AUTHORS-TEMPLATE.MD](AUTHORS-TEMPLATE.md).

This repository provides an artifact for our paper, Scheduling the Construction 
and Interrogation of Scope Graphs Using Attribute Grammars. It is designed to be
self-contained, being the target of a Docker image, and therefore includes a 
Ministatix binary as well as jars belonging to the Silver attribute grammar system.

## Description

The artifact provided has the primary purpose of validating Theorem 2 of our
paper. Namely, that the results of running Statix for a given specification and
input program are consistent with the results we get on the same input progam,
with the translation of that specification to a demand-driven attribute grammar.
We have created a slightly modified version of Statix that includes
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

Ministatix can be found here: https://github.com/metaborg/ministatix.hs,
and Silver at: https://github.com/melt-umn/silver/.

However, these tools are included in the Docker image and do not need to be 
downloaded by the reviewer.

If all results are consistent, then all tests pass. 
Consistent results are defined by:

- If the input program is satisfiable by Ministatix, then it is satisfiable by
  both AG systems (case 1 of Theorem 2). This indicates that the
  program has no name-binding or type errors.

- If the input program is unsatisfiable by Ministatix, then it is unsatisfiable
  by both AG systems (cases 2/3 of Theorem 2), indicating a static error.

- If Ministatix becomes stuck during execution, then both AG systems abort with
  a cycle detected (case 4 of Theorem 2). This is for specifications
  that cannot be solved by either approach.

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

## Structure overview

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
        **NOTE** that each of these files (`mstx.aterm`, `ag_test.ml`, `Main.sv`)
        are formatted slightly differently to account for the three different
        evaluation systems, however one should see that all of the abstract
        syntax terms are equivalent for each testcase directory.

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

### Execution

You need only run the following script to validate Theorem 2 of the paper:

- `test-all-specs`

Which will, for each Statix specification we provide, translate that specification
to Ministatix, an OCaml AG representation, and a Silver AG. Then run all of our
input test cases through each system and check that the results are consistent
between each system. This script takes no arguments, thus all the one needs to
do is execute this script: `./test-all-specs`.

There are a number of other scripts for running individual specifications or
test cases, which we describe below. You need only read the following
if they would like to write their own Statix specification for testing.

- `test-one-spec`:
   Takes two arguments, a Statix specification, and a directory to look for test
   cases. This script validates Theorem 2 for a particular LM specification that
   we provide, running all input test cases for that specification in Ministatix,
   OCaml, and Silver.
   E.g. `./test-one-spec specifications/lm-rec.mstx specifications/testcases/lm`.

The following scripts all depend on one having translated a specification,
thus are not recommended to run in isolation. If you wishe to run these scripts 
manually, first execute the first 40 lines of `test-one-spec`.

- `try-all-inputs`:
   Takes one argument, a directory to look for test cases. Assumes that the
   translation has already happened for some specification, and all necessary
   files are in place.
   Not recommended to run without first having executed the commands in
   `test-one-spec` up to line 40.
   E.g. `./try-all-inputs specifications/testcases/lm`.

- `try-one-input`:
   Takes one argument the directory containing one test case. Assumes that the
   translation has already happened for some specification, and all necessary
   files are in place.
   Not recommended to run without first having executed the commands in
   `test-one-spec` up to line 41.
   E.g. `try-one-input specifications/testcases/lm/simple_add`.

The following three scripts simply test the evaluation of Ministatix, the OCaml
AG, and the Silver AG for a particular test case that has already been loaded
into the correct location.

- `./test-mstx`
- `./test-ocaml`
- `./test-silver`

### Future development

The following points outline some future work in this repository:

- Lifting restrictions on Statix specifications outlined in the paper so that
  a greater number of Statix specifications are supported.

- Evaluation of the performance of this artifact versus the same in Ministatix,
  following optimizations to the OCaml operational semantics system in particular.