grammar lmr3:lmr:nameanalysis_extension1;

imports sg_lib3:src;

--

{- `scope graph LMGraph with {lex, var -> (String, Type), mod -> String, imp -> as mod};` generates:
 - The below inherited attribute set type alias
 - An inherited attribute for each label
 - A Label production for each label
 - Below datum productions
-}

type LMGraph = {lex, var, mod, imp};
type LMGraph_Scope = Decorated Scope with LMGraph;


inherited attribute lex::[Decorated Scope with LMGraph] with ++ occurs on Scope;

production lexLabel
top::Label<LMGraph> ::=
{ top.name = "lex";
  top.demand = \s::Decorated Scope with LMGraph -> s.lex; }

production datumLex
top::Datum ::= d::Unit
{}

inherited attribute var::[Decorated Scope with LMGraph] with ++ occurs on Scope;

production varLabel
top::Label<LMGraph> ::=
{ top.name = "var";
  top.demand = \s::Decorated Scope with LMGraph -> s.var; }

production datumVar
top::Datum ::= d::(String, Type)
{}

inherited attribute mod::[Decorated Scope with LMGraph] with ++ occurs on Scope;

production modLabel
top::Label<LMGraph> ::=
{ top.name = "mod";
  top.demand = \s::Decorated Scope with LMGraph -> s.mod; }

production datumMod
top::Datum ::= d::String
{}

inherited attribute imp::[Decorated Scope with LMGraph] with ++ occurs on Scope;

production impLabel
top::Label<LMGraph> ::=
{ top.name = "imp";
  top.demand = \s::Decorated Scope with LMGraph -> s.imp; }

--

{- `order LMGraph lmOrd { lex < var, lex < mod, imp < var, imp < mod }` generates:
 - The following global
 - The same lambda expression would be generated if the above is written as an
   expression and given as argument to a query
-}

global lmOrd::Ordering<LMGraph> = \left::Label<LMGraph> right::Label<LMGraph> ->
  case left, right of
  | lexLabel(), varLabel() -> 1 | varLabel(), lexLabel() -> -1
  | lexLabel(), modLabel() -> 1 | modLabel(), lexLabel() -> -1
  | impLabel(), varLabel() -> 1 | varLabel(), impLabel() -> -1
  | impLabel(), modLabel() -> 1 | modLabel(), impLabel() -> -1
  | _, _ -> 0
  end;

--

{- `regex LMGraph lmVarRx `lex* . imp? . var` generates:
 - The following global
 - The same regex would be generated if the above is written as an expression
   and given as argument to a query
-}

global lmVarRx::Regex<LMGraph> =
  regexCat(
    regexStar(
      regexLabel(
        lexLabel()
      )
    ),
    regexCat(
      regexMaybe(
        regexLabel(
          impLabel()
        )
      ),
      regexLabel(
        varLabel()
      )
    )
  );

{- `regex LMGraph lmModRx `lex* . imp? . mod` generates:
 - The following global
 - The same regex would be generated if the above is written as an expression
   and given as argument to a query
-}

global lmModRx::Regex<LMGraph> =
  regexCat(
    regexStar(
      regexLabel(
        lexLabel()
      )
    ),
    regexCat(
      regexMaybe(
        regexLabel(
          impLabel()
        )
      ),
      regexLabel(
        modLabel()
      )
    )
  );

--

{- Generated?
-}

global blankScope::Decorated Scope with LMGraph =
  decorate scope(error("Demanded datum of blankScope")) with {
    lex = []; var = []; mod = []; imp = [];
  };
