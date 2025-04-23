# Artifact Submission Template for SLE


## Author Information
- **Names:** 
   - Luke Bessant
   - Eric Van Wyk
- **Affiliations:** 
   - University of Minnesota
- **Emails:** 
   - bessa028@umn.edu
   - evw@umn.edu


## Associated Paper Information
- **Title:** 

Scheduling the Construction and Interrogation of Scope Graphs Using 
Attribute Grammars.

- **Abstract:** 

Recognizing that name binding, matching name references to
their declarations, is often done in an ad-hoc manner, Visser
and his colleagues introduced scope graphs as a uniform
representation of a program’s static binding structure along
with a generic means for interrogating that representation
to resolve name references to their declarations. A challenge
arises in scheduling the construction and querying actions so
that a name resolution is not performed before all requisite
information for that resolution is added to the scope graph.
For example the name of a module to be imported must
be resolved, and that resolution added to the scope graph,
before names that may depend on that imported module
are resolved. Visser et al. introduced a notion of weakly
critical edges to constrain the order in which name resolution
queries are performed to a correct one, but this has been
found to be somewhat restrictive.

Visser et al. also introduced Statix, a constraint solving
language for scope graph-based name resolution. We show
that specifications written in an annotated version of Statix
can be translated into reference attribute grammars, and that
the order in which equations are solved under demand driven
evaluation provides a valid order for solving constraints in
Statix. This formalizes what has been folklore in the attribute
grammar community for some time, that scope graphs are
naturally specified in reference attributes grammars.


## Documentation
- **Link to the code repository:**

TODO - create the repo, link here.

- Describe the structure of the artifact and provide a brief overview of the contents.

TODO - this will be the same as the "Paper abstract and short artifact
description" in the SLE HotCRP submission.

### Description

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

The artifact contains a number of scripts for translating Statix specifications
and running test cases through each of the translations. These are described
in the artifact structure outline below. For the reviewer, it should suffice to
execute the `test-all-specs` script, to run all test cases we have for all
Statix specifications. However, if the reviewer wishes to write their own
Statix specifications and test cases, they will want to use `test-one-spec`,
giving the specification and a directory containing the test cases as arguments.

### Artifact structure overview

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

---


## Artifact Evaluation Environment

### System Specifications Used by Authors
- **Operating System:**

EndeavourOS Linux x86_64 (Kernel: 6.14.2-arch1-1)

- **CPU:** 

11th Gen Intel i5-1135G7 (8) @ 4.200GHz

- **Memory:**

16GB DDR4

- **Disk Space:**

500 GB

- **GPU (if applicable):**

Not applicable.

### Estimated Hardware Requirements for Evaluation
- **Minimum required CPU:**

No strict requirements.

- **Minimum required Memory:**

1GB (Max memory usage of top-level script, rounded up to nearest GB)

- **Minimum required Disk Space:**

2.37GB (Docker image size)

- **Minimum required GPU (if applicable):**

Not applicable.

### Compatibility Considerations
- **Known compatibility issues of the container/VM:**

Not applicable.


## Kick-the-Tires
This section should provide a simple and quick way for the reviewer to check whether all dependencies are correctly installed and that all scripts run without errors. The goal is not to run the full evaluation but to verify that the artifact is functional.

### Steps to Perform a Quick Test
1. **Setup Instructions:** Describe the minimal steps needed to set up the environment.

   1. `docker load -i <hash>`: Loading the docker image stored in the tarball.
   2. `docker run -ti <hash> /bin/bash`: Logging into the image.

2. **Run a Sample Command:** Provide a single command or a few minimal commands that verify the artifact is working.

Reviewer should run the following script: `./test-all-specs` .
This is the top-level test script for our artifact. This runs all test inputs 
we have, for the three Statix specifications we provide. Before doing so, it
will build the translator if it has not been built already.

3. **Expected Output:** Describe what the expected output should be.

Firstly, the reviewer will see the `ant` build process for the translator, if 
it is not built already. Beginning with output of the form:

```
test-one-spec: Building translator...
Compiling statix_translate:driver
	[statix_translate/../statix_translate/driver/]
	[Main.sv]
...
```

And ending with output of the form:

```
BUILD SUCCESSFUL
```

Then, for each of the three Statix specification in `specifications`, for each 
input program test case in `specifications/testcases/lm`, a consistent result for 
each of the three evaluation systems we provide (Ministatix/OCaml AG/Silver AG). 
The results should reproduce the following:

- Under specification `lm-rec.mstx`
   1. For test case `specifications/testcases/lm/bad_module_simple_add`:
      - `Unsatisfiable by Ministatix`
      - `Unsatisfiable by OCaml AG (outer.ok == false)`
      - `Unsatisfiable by Silver AG (outer.ok == false)`
   2. For test case `specifications/testcases/lm/bad_simple_add`:
      - `Unsatisfiable by Ministatix`
      - `Unsatisfiable by OCaml AG (outer.ok == false)`
      - `Unsatisfiable by Silver AG (outer.ok == false)`
   3. For test case `specifications/testcases/lm/imp_par_not_seq`:
      - `Stuck in Ministatix`
      - `Cycle detected by OCaml AG`
      - `Cycle detected by Silver AG`
   4. For test case `specifications/testcases/lm/module_simple_add`:
      - `Satisfiable by Ministatix`
      - `Satisfiable by OCaml AG`
      - `Satisfiable by Silver AG`
   5. For test case `specifications/testcases/lm/nores_let`:
      - `Unsatisfiable by Ministatix`
      - `Unsatisfiable by OCaml AG (evaluation aborted)`
      - `Unsatisfiable by Silver AG (evaluation aborted)`
   6. For test case `specifications/testcases/lm/one_import`:
      - `Stuck in Ministatix`
      - `Cycle detected by OCaml AG`
      - `Cycle detected by Silver AG`
   7. For test case `specifications/testcases/lm/simple_add`:
      - `Satisfiable by Ministatix`
      - `Satisfiable by OCaml AG`
      - `Satisfiable by Silver AG`

- Under specification `lm-par.mstx`
   1. For test case `specifications/testcases/lm/bad_module_simple_add`:
      - `Unsatisfiable by Ministatix`
      - `Unsatisfiable by OCaml AG (outer.ok == false)`
      - `Unsatisfiable by Silver AG (outer.ok == false)`
   2. For test case `specifications/testcases/lm/bad_simple_add`:
      - `Unsatisfiable by Ministatix`
      - `Unsatisfiable by OCaml AG (outer.ok == false)`
      - `Unsatisfiable by Silver AG (outer.ok == false)`
   3. For test case `specifications/testcases/lm/imp_par_not_seq`:
      - `Satisfiable by Ministatix`
      - `Satisfiable by OCaml AG`
      - `Satisfiable by Silver AG`
   4. For test case `specifications/testcases/lm/module_simple_add`:
      - `Satisfiable by Ministatix`
      - `Satisfiable by OCaml AG`
      - `Satisfiable by Silver AG`
   5. For test case `specifications/testcases/lm/nores_let`:
      - `Unsatisfiable by Ministatix`
      - `Unsatisfiable by OCaml AG (evaluation aborted)`
      - `Unsatisfiable by Silver AG (evaluation aborted)`
   6. For test case `specifications/testcases/lm/one_import`:
      - `Satisfiable by Ministatix`
      - `Satisfiable by OCaml AG`
      - `Satisfiable by Silver AG`
   7. For test case `specifications/testcases/lm/simple_add`:
      - `Satisfiable by Ministatix`
      - `Satisfiable by OCaml AG`
      - `Satisfiable by Silver AG`

- Under specification `lm-seq.mstx`
   1. For test case `specifications/testcases/lm/bad_module_simple_add`:
      - `Unsatisfiable by Ministatix`
      - `Unsatisfiable by OCaml AG (outer.ok == false)`
      - `Unsatisfiable by Silver AG (outer.ok == false)`
   2. For test case `specifications/testcases/lm/bad_simple_add`:
      - `Unsatisfiable by Ministatix`
      - `Unsatisfiable by OCaml AG (outer.ok == false)`
      - `Unsatisfiable by Silver AG (outer.ok == false)`
   3. For test case `specifications/testcases/lm/imp_par_not_seq`:
      - `Unsatisfiable by Ministatix`
      - `Unsatisfiable by OCaml AG (outer.ok == false)`
      - `Unsatisfiable by Silver AG (outer.ok == false)`
   4. For test case `specifications/testcases/lm/module_simple_add`:
      - `Satisfiable by Ministatix`
      - `Satisfiable by OCaml AG`
      - `Satisfiable by Silver AG`
   5. For test case `specifications/testcases/lm/nores_let`:
      - `Unsatisfiable by Ministatix`
      - `Unsatisfiable by OCaml AG (evaluation aborted)`
      - `Unsatisfiable by Silver AG (evaluation aborted)`
   6. For test case `specifications/testcases/lm/one_import`:
      - `Satisfiable by Ministatix`
      - `Satisfiable by OCaml AG`
      - `Satisfiable by Silver AG`
   7. For test case `specifications/testcases/lm/simple_add`:
      - `Satisfiable by Ministatix`
      - `Satisfiable by OCaml AG`
      - `Satisfiable by Silver AG`

4. **Troubleshooting:** List common issues and their possible solutions if the setup fails.

No known issues.


## Full Evaluation

1. **Reference to the Experimental Claim:**

The claim we wish to validate with this artifact is a version of Theorem 2 of 
the paper which discounts the check that the scope graph is the same between
Statix and attribute grammar evaluation. We wish to show the following, for
a given Statix specification and input test case:

- If the input program is satisfiable by Ministatix, then it is satisfiable by
  both AG systems (case 1 of Theorem 2).
- If the input program is unsatisfiable by Ministatix, then it is unsatisfiable
  by both AG systems (cases 2/3 of Theorem 2).
- If Ministatix becomes stuck during execution, then both AG systems abort with
  a cycle detected (case 4 of Theorem 2).

We do this for three Statix specifications, each implementing a different
import semantics, these are:

- `specifications/lm-par.mstx`: 
   Specification of LM with parallel import semantics.

- `specifications/lm-rec.mstx`: 
   Specification of LM with recursive import semantics.

- `specifications/lm-seq.mstx`: 
   Specification of LM with sequential import semantics.

In evaluating a test case under Statix we use the Ministatix tool provided as
an artifact to Knowing When to Ask (Rouvoet et al.), as opposed to our an
implementation of our own based on the step rules given in the paper.

2. **Reproduction Steps:**

The reviewer need only run the following script to validate this theorem:

- `test-all-specs`

Which will, for each Statix specification we provide, translate that specification
to Ministatix, an OCaml AG representation, and a Silver AG. Then run all of our
input test cases through each system and check that the results are consistent
between each system. This script takes no arguments, thus all the reviewer need
do is execute this script: `./test-all-specs`.

There are a number of other scripts for running individual specifications or
test cases, which we describe below. The reviewer need only read the following
if they would like to write their own Statix specification for testing.

- `test-one-spec`:
   Takes two arguments, a Statix specification, and a directory to look for test
   cases. This script validates Theorem 2 for a particular LM specification that
   we provide, running all input test cases for that specification in Ministatix,
   OCaml, and Silver.
   E.g. `./test-one-spec specifications/lm-rec.mstx specifications/testcases/lm`.

The following scripts all depend on one having translated a specification,
thus are not recommended to run in isolation. If the reviewer wishes to
run these scripts manually, first execute the first 40 lines of `test-one-spec`.

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

3. **Expected Output:** Clearly describe what the expected output should be.

In executing `test-all-specs`, the output should match that given above, under
the "Kick-the-tyres" section.

4. **Estimated Runtime (Optional):** Provide an estimate of how long the full evaluation will take.

An execution of `./test-all-specs` on the sytem whose information is provided
earlier in this document completed in 940 seconds. Most of the time taken here
is due to us executing a build of the generated Silver-based attribute grammar
for each test case.

The OCaml AG evaluation is based on the small-step semantics we describe in the
paper which may also take a few seconds to complete for a few of the test cases,
due to our implementation of attribute grammar trees as lists.

Note that this is not related the performance claims in the paper. In fact we 
are moving that claim, based on reviewer comments to future work until we can 
gather real data.
  
5. **Potential Issues:**
   
No known issues.