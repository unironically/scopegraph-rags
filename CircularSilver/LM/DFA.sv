grammar LM;


{-
 - DFA for VarRefs.
 -}
global dfaVarRef::DFA = 
  let sink::State = sinkState() in
  let final::State = varRefstate(sink, sink, sink, true) in
  let impState::State = varRefstate(final, sink, sink, false) in
  let start::State = varRefstate(final, impState, start, false) in
    dfa (start)
  end end end end;

{-
 - DFA for qualified VarRefs.
 -}
global dfaVar::DFA = 
  let final::State = varRefstate(sink, sink, sink, true) in
  let start::State = varRefstate(final, sink, sink, false) in
    dfa (start)
  end end;

{-
 - DFA for ModRefs.
 -}
global dfaModRef::DFA = 
  let sink::State = sinkState() in
  let final::State = modRefState(sink, sink, sink, true) in
  let impState::State = modRefState(final, sink, sink, false) in
  let start::State = modRefState(final, impState, start, false) in
    dfa (start)
  end end end end;

{-
 - DFA for qualified ModRefs.
 -}
global dfaMod::DFA = 
  let final::State = modRefState(sink, sink, sink, true) in
  let start::State = modRefState(final, sink, sink, false) in
    dfa (start)
  end end;


synthesized attribute findReachable::([Res] ::= String Either<ModRef, VarRef> [Label] [Res] Scope);


nonterminal DFA with findReachable;

{-
 - DFA.
 - We only need to hold the start state, as each state knows whether it is final, and there should
 - be a path from the start state to any other state in the DFA.
 -}
abstract production dfa
top::DFA ::=
  start::State
{
  top.findReachable = start.findReachable;
}


nonterminal State with findReachable;

abstract production varRefstate
top::State ::=
  varT::State
  impT::State
  lexT::State
  isFinal::Boolean
{
  top.findReachable = 
    \lookup::String
     ref::Either<ModRef, VarRef>
     path::[Label]
     deps::[Res]
     scope::Scope ->

      let varRef::VarRef = ref.fromRight in
    
      let varRes::[Res] = 
        concat(map((varT.findReachable(lookup, ref, labVAR()::path, [], _)), scope.vars)) in

      let impRes::[Res] = 
        concat(map((impT.findReachable(lookup, ref, labIMP()::path, [], _)), scope.imps)) in

      let lexRes::[Res] = 
        concat(map((lexT.findReachable(lookup, ref, labLEX()::path, [], _)), scope.lexs)) in

      let contRes::[Res] = 
        if !null(varRes) then varRes
        else if !null(impRes) then impRes
        else lexRes
      in
        case scope of
        | scopeDatum(d) when isFinal && d.id == lookup ->
            varRes(varRef, scope, path) :: contRes 
        | _ -> contRes
        end

      end end end end end;
}

abstract production modRefState
top::State ::=
  modT::State
  impT::State
  lexT::State
  isFinal::Boolean
{
  top.findReachable = 
    \lookup::String
     ref::Either<ModRef, VarRef>
     path::[Label]
     deps::[Res]
     scope::Scope ->

      let modRef::ModRef = ref.fromLeft in

      let modRes::[Res] = 
        concat(map((modT.findReachable(lookup, ref, labMOD()::path, deps, _)), scope.mods)) in

      let impRes::[Res] = 
        concat(
          map(
            (\r::Res -> impT.findReachable(lookup, ref, labIMP()::path, r::deps, r.resScope)), 
            scope.impsReachable)) in

      let lexRes::[Res] = 
        concat(map((lexT.findReachable(lookup, ref, labLEX()::path, deps, _)), scope.lexs)) in

      let contRes::[Res] = 
        if !null(modRes) then modRes
        else if !null(impRes) then impRes
        else lexRes
      in
        case scope of
        | scopeDatum(d) when isFinal && d.id == lookup -> 
            impRes(modRef, scope, path) :: contRes
        | _ -> contRes
        end
        
      end end end end end end;
}

{-
 - Sink state in a DFA. 
 - Cannot use the current scope in a resolution, and cannot transition.
 -}
abstract production sinkState
top::State ::=
{
  top.findReachable = 
    \lookup::String 
     ref::Either<ModRef, VarRef> 
     path::[Label]
     deps::[Res]
     scope::Scope -> [];
}
