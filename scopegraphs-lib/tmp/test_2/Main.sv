grammar test;

imports src;

--------------------------------------------------------------------------------
-- Testing ---------------------------------------------------------------------

fun main IO<Integer> ::= args::[String] = do {

  let sv::LMScope = decorate scopeNoData() with
    { lex = []; var = []; mod = []; imp = []; };

  let s1::LMScope = decorate scopeNoData() with 
    { lex = []; var = [sv]; mod = []; imp = []; };
  
  let s2::LMScope = decorate scopeNoData() with 
    { lex = [s1]; var = []; mod = []; imp = []; };

  let resv::[LMScope] = s2.lmResolve(isName("foo"), varRx());

  print(toString(length(resv))++ "\n");

  return 0;
};

--------------------------------------------------------------------------------
-- Language specific -----------------------------------------------------------


-- Edge attributes:

inherited attribute lex::[LMScope];
inherited attribute var::[LMScope];
inherited attribute mod::[LMScope];
inherited attribute imp::[LMScope];

-- Scopes:

attribute lex, var, mod, imp, lmResolve occurs on Scope;
type LMScope = Decorated Scope with {lex, var, mod, imp};

synthesized attribute lmResolve::([LMScope] ::= Predicate Regex);

aspect production scope
top::Scope ::= datum::Datum
{ top.lmResolve = error("scope.lmResolve should not be demanded"); }

production scopeNoData
top::Scope ::=
{
  top.lmResolve = \p::Predicate r::Regex -> 
    case top.resolvePath(p, r, pathFunEnd(), pathFunCons()) of
    | [] -> error("did not resolve")
    | pathCons(s, _, _)::_ -> [s] -- change
    | pathEnd(s)::_ -> [s]
    end;

  forwards to scope(datumNone());
}

production scopeVar
top::Scope ::= name::String
{ 
  top.lmResolve = \p::Predicate r::Regex -> 
    case top.resolvePath(p, r, pathFunEnd(), pathFunCons()) of
    | [] -> error("did not resolve")
    | pathCons(s, _, _)::_ -> [s] -- change
    | pathEnd(s)::_ -> [s]
    end;

  forwards to scope(datumJust(name));
}

-- Paths:

production pathCons
top::Path ::= s::LMScope l::Label ps::Path
{
  forwards to error("pathCons should not forward");
}

production pathEnd
top::Path ::= s::LMScope
{
  forwards to error("pathEnd should not forward");
}

production pathFunEnd
top::PathFun ::=
{ local f::(Path ::= LMScope) = \s::LMScope -> pathEnd(s);
  forwards to pathFunEndFwd(f); }

production pathFunCons
top::PathFun ::=
{ local f::(Path ::= LMScope Label Path) = \s::LMScope l::Label p::Path -> pathCons(s, l, p);
  forwards to pathFunConsFwd(f); }

-- Labels:

production labelLEX
top::Label ::=
{ top.name = "LEX";
  forwards to label(\s::LMScope -> s.lex); }

production labelVAR
top::Label ::=
{ top.name = "VAR";
  forwards to label(\s::LMScope -> s.var); }

production labelMOD
top::Label ::=
{ top.name = "MOD";
  forwards to label(\s::LMScope -> s.mod); }

production labelIMP
top::Label ::=
{ top.name = "IMP";
  forwards to label(\s::LMScope -> s.imp); }

-- Not required, but convenient Regex productions:

production regexLEX
top::Regex ::=
{ forwards to regexLabel(labelLEX()); }

production regexVAR
top::Regex ::=
{ forwards to regexLabel(labelVAR()); }

production regexMOD
top::Regex ::=
{ forwards to regexLabel(labelMOD()); }

production regexIMP
top::Regex ::=
{ forwards to regexLabel(labelIMP()); }

-- Resolution regexes:

global varRx::Regex = 
  regexCat(
    regexStar(
      regexLEX()
    ),
    regexCat(
      regexMaybe(
        regexIMP()
      ),
      regexVAR()
    )
  );

-- Predicates:

fun isName (Boolean ::= Datum) ::= name::String =
  \d::Datum ->
    case d of
    | datumJust(n) -> n == name
    | _ -> false
    end;
