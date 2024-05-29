grammar LM;


{-
 - DFA for VarRefs.
 -}
global dfaVarRef::DFA = 
  let sink::State = sinkState() in
  let final::State = state(sink, sink, sink, sink, true) in
  let impState::State = state(final, sink, sink, sink, false) in
  let start::State = state(final, sink, impState, start) in
    dfa (start)
  end end end end;

{-
 - DFA for qualified VarRefs.
 -}
global dfaVar::DFA = 
  let final::State = state(sink, sink, sink, sink, true) in
  let start::State = state(final, sink, sink, sink) in
    dfa (start)
  end end;

{-
 - DFA for ModRefs.
 -}
global dfaModRef::DFA = 
  let sink::State = sinkState() in
  let final::State = state(sink, sink, sink, sink, true) in
  let impState::State = state(sink, final, sink, sink, false) in
  let start::State = state(sink, final, impState, start) in
    dfa (start)
  end end end end;

{-
 - DFA for qualified ModRefs.
 -}
global dfaMod::DFA = 
  let final::State = state(sink, sink, sink, sink, true) in
  let start::State = state(sink, final, sink, sink) in
    dfa (start)
  end end;


synthesized attribute findVisible::([Res] ::= String Scope Ref [Label] Boolean);


nonterminal DFA with findVisible;

{-
 - DFA.
 - We only need to hold the start state, as each state knows whether it is final, and there should
 - be a path from the start state to any other state in the DFA.
 -}
abstract production dfa
top::DFA ::=
  start::State
{
  top.findVisible = start.findVisible;
}


nonterminal State with findVisible;;

{-
 - Regular (non-sink) state in a DFA.
 - We continue traversal, and also take into account the current scope as a possible resolution
 - if the state is final.
 -}
abstract production state
top::State ::=
  var::State
  mod::State
  imp::State
  lex::State
  isFinal::Boolean
{
  top.findVisible = 
    \lookup::String currentScope::Scope fromRef::Ref currentPath::[Label] resolvingImp::Boolean ->
    
      let varRes::[Res] = if resolvingImp then [] else concat(map((var.findVisible(lookup, _)), currentScope.vars)) in
      let modRes::[Res] = if !resolvingImp then [] else concat(map((mods.findVisible(lookup, _)), currentScope.mods)) in

      let imps::[Scope] = if resolvingImp then map((.resolvedScope), currentScope.impsReachable) else scope.imps in
      let impRes::[Res] = concat(map((imps.findVisible(lookup, _)), imps)) in

      let lexRes::[Res] = concat(map((lexs.findVisible(lookup, _)), currentScope.lexs)) in
      let contRes::[Res] = 
        if !null(varRes) then varRes
        else if !null(modRes) then modRes
        else if !null(impRes) then impRes
        else lexRes 
      in
        case currentScope of
        | scopeDatum(d) -> if d.id != lookup then contRes 
                           else if resolvingImp then impRes(fromRef, currentScope, currentPath) :: contRes
                           else    varRes(fromRef, currentScope, currentPath) :: contRes 
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
  top.findVisible = \lookup::String currentScope::Scope fromRef::Ref currentPath::[Label] resolvingImp::Boolean -> [];
}