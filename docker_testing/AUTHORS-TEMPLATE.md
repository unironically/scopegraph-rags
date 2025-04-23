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
- Describe the structure of the artifact and provide a brief overview of the contents.

TODO

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

   1. `./test-all-specs`: Top-level test script for our artifact. This runs
      all test cases we have, for all Statix specifications we provide.

3. **Expected Output:** Describe what the expected output should be.

For each of the three Statix specification in `specifications`, for each input 
program test case in `specifications/testcases/lm`, a consistent result for 
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
For all experimental claims made in the paper, please provide the following:

1. **Reference to the Experimental Claim:** Quote or reference the claim from the paper.
2. **Reproduction Steps:** Explain how this claim can be reproduced using the artifact.
   - Example: *“The results presented in Figure 3 can be reproduced by executing `run_experiment.sh` with the configuration file `config_figure3.json`.”*
3. **Expected Output:** Clearly describe what the expected output should be.
4. **Estimated Runtime (Optional):** Provide an estimate of how long the full evaluation will take.
5. **Potential Issues:** List any known challenges in reproducing the results and how to mitigate them.