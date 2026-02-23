grammar lmr3:lmr:nameanalysis_extension2;

imports sg_lib3:src;

--

{- `scope graph LMGraph with {lex, var -> {x::String, ty::Type}, mod -> {x::String}, imp -> as mod};` generates:
 - The below inherited attribute set type alias
 - An inherited attribute for each label
 - A Label production for each label
 - Nonterminals and productions for var/mod
-}

type LMGraph = {lex, var, mod, imp};
type LMGraph_Scope = Decorated Scope with LMGraph;


inherited attribute lex::[Decorated Scope with LMGraph] with ++ occurs on Scope, Scope_var, Scope_mod;

production lexLabel
top::Label<LMGraph> ::=
{ top.name = "lex";
  top.demand = \s::Decorated Scope with LMGraph -> s.lex; }

production datumLex
top::Datum ::=
{}

inherited attribute var::[Decorated Scope with LMGraph] with ++ occurs on Scope, Scope_var, Scope_mod;

production varLabel
top::Label<LMGraph> ::=
{ top.name = "var";
  top.demand = \s::Decorated Scope with LMGraph -> s.var; }

inherited attribute mod::[Decorated Scope with LMGraph] with ++ occurs on Scope, Scope_var, Scope_mod;

production modLabel
top::Label<LMGraph> ::=
{ top.name = "mod";
  top.demand = \s::Decorated Scope with LMGraph -> s.mod; }

inherited attribute imp::[Decorated Scope with LMGraph] with ++ occurs on Scope, Scope_var, Scope_mod;

production impLabel
top::Label<LMGraph> ::=
{ top.name = "imp";
  top.demand = \s::Decorated Scope with LMGraph -> s.imp; }

--

production datumVar
top::Datum ::= x::String ty::Type
{}

production datumMod
top::Datum ::= x::String
{}

fun to_var
Decorated Scope_var with LMGraph ::= s::Decorated Scope with LMGraph =
  case s.datum of
  | datumVar(x, ty) -> decorate var(x, ^ty) with {lex = s.lex; var = s.var; mod = s.mod; imp = s.imp;}
  | _ -> error("Oh no! (to_var)")
  end
;

fun to_mod
Decorated Scope_mod with LMGraph ::= s::Decorated Scope with LMGraph =
  case s.datum of
  | datumMod(x) -> decorate mod(x) with {lex = s.lex; var = s.var; mod = s.mod; imp = s.imp;}
  | _ -> error("Oh no! (to_var)")
  end
;

--

synthesized attribute x::String;
synthesized attribute ty::Type;
synthesized attribute to_scope::Decorated Scope with LMGraph;

nonterminal Scope_var with x, ty, to_scope;

production var
top::Scope_var ::= x::String ty::Type
{
  top.x = x;
  top.ty = ^ty;
  top.to_scope = decorate scope(datumVar(x, ^ty)) with {lex = top.lex; var = top.var; mod = top.mod; imp = top.imp;};
  
}

nonterminal Scope_mod with x, to_scope;

production mod
top::Scope_mod ::= x::String
{
  top.x = x;
  top.to_scope = decorate scope(datumMod(x)) with {lex = top.lex; var = top.var; mod = top.mod; imp = top.imp;};

}



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
