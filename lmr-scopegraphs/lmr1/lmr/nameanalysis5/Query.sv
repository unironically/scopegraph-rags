grammar lmr1:lmr:nameanalysis5;

------
-- VAR

type PredicateVar = (Boolean ::= Decorated SGVarNode with LMInhs);
fun varPredicate PredicateVar ::= name::String =
  \sv::Decorated SGVarNode with LMInhs -> sv.name == name;

-- LEX* IMP? VAR
-- LEX < VAR, LEX < IMP, IMP < VAR

fun varQuery
SGScope a =>
[Decorated SGVarNode with LMInhs] ::=
  p::PredicateVar
  s::Decorated a with LMInhs =
    queryVarS1(p, s);

-- DFA state 1
fun queryVarS1
SGScope a =>
[Decorated SGVarNode with LMInhs] ::=
  p::PredicateVar
  s::Decorated a with LMInhs =
    -- Follow VAR, move to state 3
    let varRes::[Decorated SGVarNode with LMInhs] = concat(map (queryVarS3(p, _), s.var)) in
    -- Follow IMP, move to state 2
    let impRes::[Decorated SGVarNode with LMInhs] = concat(map (queryVarS2(p, _), s.mod)) in
    -- Follow LEX, move to state 1
    let lexRes::[Decorated SGVarNode with LMInhs] = concat(map (queryVarS1(p, _), s.lex)) in
      if !null(varRes) then varRes
      else if !null(impRes) then impRes
      else lexRes
    end end end;

-- DFA state 2
fun queryVarS2
SGScope a =>
[Decorated SGVarNode with LMInhs] ::=
  p::PredicateVar
  s::Decorated a with LMInhs =
    -- Follow VAR, move to state 3
    concat(map (queryVarS3(p, _), s.var));

-- DFA state 3
fun queryVarS3
[Decorated SGVarNode with LMInhs] ::=
  p::PredicateVar
  sv::Decorated SGVarNode with LMInhs =
    -- Accept if declaration node satisfies predicate p
    if p(sv) then [sv] else [];

------
-- MOD

type PredicateMod = (Boolean ::= Decorated SGModNode with LMInhs);
fun modPredicate PredicateMod ::= name::String =
  \sm::Decorated SGModNode with LMInhs -> sm.name == name;

fun modQuery
SGScope a =>
[Decorated SGModNode with LMInhs] ::=
  p::PredicateMod
  s::Decorated a with LMInhs =
  queryModS1(p, s);

-- DFA state 1
fun queryModS1
SGScope a =>
[Decorated SGModNode with LMInhs] ::=
  p::PredicateMod
  s::Decorated a with LMInhs =
    -- Follow MOD, move to state 3
    let modRes::[Decorated SGModNode with LMInhs] = concat(map (queryModS3(p, _), s.mod)) in
    -- Follow IMP, move to state 2
    let impRes::[Decorated SGModNode with LMInhs] = concat(map (queryModS2(p, _), s.imp)) in
    -- Follow LEX, move to state 1
    let lexRes::[Decorated SGModNode with LMInhs] = concat(map (queryModS1(p, _), s.lex)) in
    if !null(modRes) then modRes
    else if !null(impRes) then impRes
    else lexRes
    end end end;

-- DFA state 2
fun queryModS2
SGScope a =>
[Decorated SGModNode with LMInhs] ::=
  p::PredicateMod
  s::Decorated a with LMInhs =
    -- Follow MOD, move to state 3
    concat(map (queryModS3(p, _), s.mod));

-- DFA state 3
fun queryModS3
[Decorated SGModNode with LMInhs] ::=
  p::PredicateMod
  sm::Decorated SGModNode with LMInhs =
    if p(sm) then [sm] else [];


------
-- DCL

{-

-- Cannot define constraints for type definitions in Silver
-- Have to define the DCL predicate over SGDclNode instead
type PredicateDcl = (Boolean ::= Decorated SGDclNode with LMInhs);
fun dclPredicate PredicateDcl ::= name::String =
  \sd::Decorated SGDclNode with LMInhs -> sd.name == name;

fun dclQuery
SGScope a =>
[Decorated SGDclNode with LMInhs] ::=
  p::PredicateDcl
  s::Decorated a with LMInhs =
  queryDclS1(p, s);

-- DFA state 1
fun queryDclS1
SGScope a =>
[Decorated SGDclNode with LMInhs] ::=
  p::PredicateDcl
  s::Decorated a with LMInhs =
    -- Follow VAR, move to state 3
    let varRes::[Decorated SGDclNode with LMInhs] = concat(map (queryDclS3(p, _), s.var)) in
    -- Follow MOD, move to state 3
    let modRes::[Decorated SGDclNode with LMInhs] = concat(map (queryDclS3(p, _), s.mod)) in
    -- Follow IMP, move to state 2
    let impRes::[Decorated SGDclNode with LMInhs] = concat(map (queryDclS2(p, _), s.imp)) in
    -- Follow LEX, move to state 1
    let lexRes::[Decorated SGDclNode with LMInhs] = concat(map (queryDclS1(p, _), s.lex)) in
    if !null(modRes) || !null(modRes) then varRes ++ modRes
    else if !null(impRes) then impRes
    else lexRes
    end end end end;

-- DFA state 2
fun queryDclS2
SGScope a =>
[Decorated SGDclNode with LMInhs] ::=
  p::PredicateDcl
  s::Decorated a with LMInhs =
    -- Follow VAR, move to state 3
    concat(map (queryDclS3(p, _), s.var)) ++
    -- Follow MOD, move to state 3
    concat(map (queryDclS3(p, _), s.mod));

-- DFA state 3
fun queryDclS3
SGDclTgt a =>
[Decorated SGDclNode with LMInhs] ::=
  p::PredicateDcl
  sm::Decorated a with LMInhs =
    if p(sm.asDcl) then [sm.asDcl] else [];

-}