# LM Language 4 Implementation with JastAdd
- An implementation of language 4 with JastAdd

### Running:
```bash
./compile
java -cp .:tools/beaver-rt.jar Compiler examples/modulesnestedsame.lm
```

### Concrete Syntax:
TODO

### Issues

##### ![ModulesNestedSame](examples/ModulesNestedSame.lm)
- Name resolution hangs here, because the result of the circular attribute resolutions switch between the two `A` modules.
- This is because the result of one iteration replaces the current result. Then the next iteration acts similarly, replacing the previous value with a new one.
- I.e.
  - Iteration 1 of `impScopes()` results in the `A` on line 1
  - Iteration 2 of `impScopes()` results in the `A` on line 2
  - Iteration 3 of `impScopes()` results in the `A` on line 1
  - ...

##### ![ModulesReachableVsVisible](examples/ModulesReachableVsVisible.lm)
- Resolution of the reference `x` will be either to the declaration on line 2, or that on line 7, depending on which way around the imports are.
- When `import A` is before `import B`, `x` resolves to the declaration on line 7. Otherwise it resolves to the `x` on line 2.