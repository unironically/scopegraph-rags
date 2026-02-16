grammar lmr3:lmr:nameanalysis_extension0;

imports sg_lib3:src;

--

{- `scope graph LMGraph with {lex, var, mod, imp};` generates:
 - The below inherited attribute set type alias
 - An inherited attribute for each label
 - A Label production for each label
-}

type LMGraph = {lex, var, mod, imp};


inherited attribute lex::[Decorated Scope with LMGraph] with ++ occurs on Scope;

production lexLabel
top::Label<LMGraph> ::=
{ top.name = "lex";
  top.demand = \s::Decorated Scope with LMGraph -> s.lex; }

inherited attribute var::[Decorated Scope with LMGraph] with ++ occurs on Scope;

production varLabel
top::Label<LMGraph> ::=
{ top.name = "var";
  top.demand = \s::Decorated Scope with LMGraph -> s.var; }

inherited attribute mod::[Decorated Scope with LMGraph] with ++ occurs on Scope;

production modLabel
top::Label<LMGraph> ::=
{ top.name = "mod";
  top.demand = \s::Decorated Scope with LMGraph -> s.mod; }

inherited attribute imp::[Decorated Scope with LMGraph] with ++ occurs on Scope;

production impLabel
top::Label<LMGraph> ::=
{ top.name = "imp";
  top.demand = \s::Decorated Scope with LMGraph -> s.imp; }

--

{- The below datum productions must be defined by the user
 - These are used on the RHS of a mkScope declaration
-}

production datumLex
top::Datum ::=
{}

production datumVar
top::Datum ::= name::String ty::Type
{}

production datumMod
top::Datum ::= name::String
{}

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

{- Predicates written by user
-}

fun varPredicate (Boolean ::= Datum) ::= x::String =
  \d::Datum ->
    case d of
    | datumVar(id, _) -> x == id
    | _ -> false
    end;

fun modPredicate (Boolean ::= Datum) ::= x::String =
  \d::Datum ->
    case d of
    | datumMod(id) -> x == id
    | _ -> false
    end;

--

{- Generated
-}

global blankScope::Decorated Scope with LMGraph =
  decorate scope(error("Demanded datum of blankScope")) with {
    lex = []; var = []; mod = []; imp = [];
  };